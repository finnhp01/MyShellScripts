# Reduce significally the ammount of pixels your video will have in a different file 

# Check if a file was provided
if [ -z "$1" ]; then
  echo "Usage: reduce <file.mp4> [crf 18-50]"
  exit 1
fi

input="$1"

# Check if the file exists
if [ ! -f "$input" ]; then
  echo "Error: File '$input' does not exist."
  exit 1
fi

# Asks for CRF
if [ -z "$2" ]; then
  read -p "Enter desired quality (CRF 18-50, lower = better quality, default 28): " crf
  crf="${crf:-28}"   # Default is 28
else
  crf="$2"
fi

# Validate CRF input, somehow, I'm sure there's a shorter way to do this
if ! [[ "$crf" =~ ^[0-9]+$ ]] || [ "$crf" -lt 18 ] || [ "$crf" -gt 50 ]; then
  echo "Invalid CRF value. Please enter a number between 18 and 50."
  exit 1
fi

# Extract directory, filename without extension, and extension. why not
dir="$(dirname "$input")"
filename="$(basename "$input")"
name="${filename%.*}"
ext="${filename##*.}"

# Output file. Here there's the part you might wanna change to edit the final name the file will have
output="$dir/${name}_small.$ext"

# Get file size in KiB. Unecessary, can cut it if you want
size_kib=$(du -k "$input" | cut -f1)

# Decide settings based on size, ffmpeg stuff I don't understand much, yet.
if [ "$size_kib" -lt 1024 ]; then
  echo "Detected very small file (~${size_kib} KiB). Using audio copy and slow preset."
  ffmpeg -i "$input" -vcodec libx264 -crf "$crf" -preset slow -acodec copy "$output"
else
  ffmpeg -i "$input" -vcodec libx264 -crf "$crf" -preset fast -acodec aac -b:a 128k "$output"
fi

echo "Output saved to $output with CRF=$crf"cho "Output saved to $output with CRF=$crf"
