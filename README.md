# BatchExtractSubtitles

This works best as a Docker container hosted to provide subtitles & attachments in an automated fashion.

It extracts subtitles & attachments of all **.mkv** files in the folder mounted to /data. They are extracted in a subfolder for each file.

Subtitles are saved as .ass files by default following a template, and attachments keep their original filename.

For each file `FileName.mkv`, its attachments & subtitles will be saved under `FileName/`, and the subtitles will be named `SubtitleName_SubtitleNumber_lang_FileName.OUT_EXT`, with OUT_EXT defaults to ass.

#### Environment variables

- `LANGS` allows to specify the languages to extract. Use their language codes, separated by a space, to extract only these. Defaults to extract all languages. Subtitles without language ('und') are always extracted.

   example : ```LANGS=eng fre```

- `OUT_EXT` defines the ouput extension of the subtitles files. Accepts any subtitle format supported by ffmpeg. Defaults to 'ass'.

   example : ```OUT_EXT=srt```

- `SUBFOLDER` If defined, all subtitles & attachments will be extracted in a subfolder of `SUBFOLDER`.

   example : ```SUBFOLDER=subtitles```. Resulting files will be stored in "SUBFOLDER/videofilename/", instead of only "videofilename/"

#### Usage Examples

##### Extract all subtitles & all attachments

``` {bash}
docker run --rm -it -v /AFolderWithMKVFiles:/data amine1u1/batchextractsubs
```

##### Extract subtitles of specific languages, & all attachments

``` {bash}
docker run --rm -it -v /APathWithMKVFiles:/data -e 'LANGS=eng fre' amine1u1/batchextractsubs
```

##### Extract all subtitles to a specific extension (ffmpeg does any eventual conversion), & all attachments

``` {bash}
docker run --rm -it -v /AFolderWithMKVFiles:/data -e 'OUT_EXT=srt' amine1u1/batchextractsubs
```

Credits & thanks to the ffmpeg developer team.

The code in the repo is subject to the unlicence, and the docker image, containing a compiled ffmpeg static binary, is under GPL.
