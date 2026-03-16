#!/bin/bash
yt-dlp -f "bv*+ba/b" --merge-output-format mp4 \
-o "%(title)s.%(ext)s" \
"$@"
