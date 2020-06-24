#!/bin/bash
set -e

extractSubsAndAttachments() {
    file="${1}"
    basename="${1%.*}"
    : ${OUT_EXT:="ass"} #Sets the default value if not specified
    originaldir=$(pwd)

    if [[ ! -z $SUBFOLDER ]]; then
        mkdir -p $SUBFOLDER
        cd $SUBFOLDER
    fi

    mkdir -p "$basename"
    cd "$basename"

    subsmappings=$(ffprobe -loglevel error -select_streams s -show_entries stream=index,codec_name:stream_tags=language,title -of csv=p=0 "${originaldir}/${file}")
    #Results formatted as : 2,eng,title

    #IFS is the command delimiter - https://bash.cyberciti.biz/guide/$IFS
    #We back it up before changing it to a ',' as used in the mappings
    OLDIFS=$IFS
    IFS=,

    (while read idx codec lang title; do
        if [[ "$codec" == *pgs* ]]; then
            echo "codec $codec, forcing output format."
            EXT="mks"
            forceArgument=("-f" "-c" "copy")
        else
            forceArgument=()
            EXT=$OUT_EXT
        fi
        if [ -z "$lang" ]; then
            lang="und"
            #When the subtitle language isn't present in the file, we note it as undefined and extract it regardless of the parameters
        else
            if [[ ! -z "$LANGS" ]] && [[ "$LANGS" != *$lang* ]]; then
                #If subtitles language restrictions were provided, we check that the subtitles lang is one of them before proceeding
                echo "Skipping ${lang} subtitle #${idx}"
                continue
            fi
        fi

        echo "Extracting ${lang} subtitle #${idx} named '$title' to .${OUT_EXT}, from ${file}"
        formattedTitle="${title//[^[:alnum:] -]/}" #We format the track title to avoid issues using it in a filename.
        ffmpeg -y -nostdin -hide_banner -loglevel error -i \
        "${originaldir}/${file}" "${forceArgument[@]}" -map 0:"$idx" "${formattedTitle}_${idx}_${lang}_${basename}.${EXT}"
        # The -y option replaces existing files.

    done <<<"${subsmappings}")

    echo "Dumping attachments from $file"
    ffmpeg -nostdin -hide_banner -loglevel quiet -dump_attachment:t "" -i "${originaldir}/${file}" || true #"One or more attachments could not be extracted."
    # Despite successful extraction, the error "At least one output file must be specified" seems to always appear.
    # The "|| true" part allows us to continue the script regardless.

    #Restore previous values
    IFS=$OLDIFS
    cd $originaldir
}
for f in *.mkv; do
    extractSubsAndAttachments "$f"
done
echo "Finished."
