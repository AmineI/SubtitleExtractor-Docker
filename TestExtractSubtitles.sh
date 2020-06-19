#!/bin/bash
set -e

if ffmpeg -hide_banner -formats | grep ass; then
    echo -e "\e[32m ✔ - ASS Subtitle format available\e[0m"
else
    echo -e "\e[31m ❌ - ASS Subtitle format unavailable\e[0m" >&2 && exit 1
fi

mkdir -p "/test_tmp" && cd "/test_tmp"
apk add --no-cache wget

wget -q -O test_video.mkv "https://mkvtoolnix.download/samples/vsshort-vorbis-subs.mkv"

SUBEXT="ass" /docker-entrypoint.sh

cd test_video
if ls | grep '.ass'; then
    echo -e "\e[32m ✔ - Extracted ASS subtitles found in the expected folder\e[0m"
else
    echo -e "\e[31m ❌ - ASS subtitles unavailable\e[0m" >&2 && exit 2
fi

cd ..

rm -rf test_video

SUBEXT="srt" /docker-entrypoint.sh

cd test_video
if ls | grep '.srt'; then
    echo -e "\e[32m ✔ - Extracted SRT subtitles found in the expected folder\e[0m"
else
    echo -e "\e[31m ❌ - SRT subtitles unavailable \e[0m" >&2 && exit 3
fi

echo -e "\e[32m ✔✔✔ - All tests successful\e[0m"