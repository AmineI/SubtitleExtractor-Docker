# Subtitle Extractor

This works best as a Docker container hosted to provide subtitles & attachments in an automated fashion. 

It extracts subtitles & attachments of all **.mkv** files in the volume mounted to /data. They are extracted in a subfolder for each file.

Subtitles are saved as .ass files by default following a template, and attachments keep their original filename.

The Docker image size is kept very small by using multi-stage build to compile minimal FFMPEG binaries from source. 

#### Environment variables 

- `LANGS` allows to specify the languages to extract. Use their language codes, separated by a space, to extract only these. Defaults to extract all languages. Subtitles without language ('und') are always extracted.

   example : ```LANGS=eng fre```

- `SUBEXT` defines the ouput extension of the subtitles files. Accepts any subtitle format supported by ffmpeg. Defaults to 'ass' by default. 

   example : ```SUBEXT=srt```


#### Usage Examples :

##### Extract all subtitles & all attachments
```
docker run --rm -it -v /AFolderWithMKVFiles:/data amine1u1/batchextractsubs
```


##### Extract subtitles of specific languages, & all attachments 
```
docker run --rm -it -v /APathWithMKVFiles:/data -e 'LANGS=eng fre' amine1u1/batchextractsubs
```

##### Extract all subtitles to a specific extension (ffmpeg does any eventual conversion), & all attachments
```
docker run --rm -it -v /AFolderWithMKVFiles:/data -e 'SUBEXT=srt' amine1u1/batchextractsubs
```

Credits & thanks to the ffmpeg developer team.

The code in the repo is subject to the unlicence, and the docker image, containing a compiled ffmpeg static binary, is under GPL.
