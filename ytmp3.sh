#!/bin/sh

yt-dlp \
    --cookies-from-browser firefox \
    --js-runtimes node \
    --remote-components ejs:github \
    -x \
    --audio-format mp3 \
    --embed-thumbnail \
    --add-metadata \
    -o "%(title)s.%(ext)s" \
    "$@"
