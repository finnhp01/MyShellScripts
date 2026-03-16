# Mix your audio tracks, leaving video the same, I think.

for f in "$@"; do
    # get the directory and filename without extension
    dir="$(dirname "$f")"
    name="$(basename "$f" | sed 's/\.[^.]*$//')"
    
    # set the output file name
    output="$dir/${name}_mixed.mp4"
    
    # mix the two audio tracks and keep video, One day I'll fully understand this part
    ffmpeg -i "$f" -filter_complex "[0:a:0][0:a:1]amix=inputs=2:normalize=1[aout]" -map 0:v -map "[aout]" -c:v copy "$output"
done
