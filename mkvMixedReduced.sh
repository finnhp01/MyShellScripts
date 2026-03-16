# This script will transform your mkv to a mixed track audio and smaller video 


if [ -z "$1" ]; then
  echo "Usage: mkvMixedReduced <video.mkv> [crf]"
  exit 1
fi

input="$1"

# Check if the file exists
if [ ! -f "$input" ]; then
  echo "Error: File '$input' does not exist."
  exit 1
fi


# Asks for the CRF
if [ -z "$2" ]; then
  read -p "Enter desired quality (CRF 18-50, lower = better quality, default 28): " crf
  crf="${crf:-28}"
else
  crf="$2"
fi

# Validate CRF input, if someone knows how to optimize this part tell me
if ! [[ "$crf" =~ ^[0-9]+$ ]] || [ "$crf" -lt 18 ] || [ "$crf" -gt 50 ]; then
  echo "Invalid CRF value. Please enter a number between 18 and 50."
  exit 1
fi

dir="$(dirname "$input")"
filename="$(basename "$input")"
name="${filename%.*}"


# Again this is the only part you might wanna change on this script.
output="$dir/${name}_ReduMixed.mp4"

ffmpeg -i "$input" \
-filter_complex "[0:a:0][0:a:1]amix=inputs=2:normalize=1[aout]" \
-map 0:v -map "[aout]" \
-c:v libx264 -crf "$crf" -preset fast \
-c:a aac -b:a 128k \
"$output"

echo "Saved: $output"
