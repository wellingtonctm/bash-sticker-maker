#!/bin/bash

input_gif="input.gif"
output_webm="output_sticker.webm"
desired_fps=30
max_side_length=512
max_duration=2.8
max_file_size_kb=256

# Get input GIF dimensions and duration
gif_width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=nw=1:nk=1 "$input_gif")
gif_height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=nw=1:nk=1 "$input_gif")
gif_duration=$(ffprobe -v error -select_streams v:0 -show_entries format=duration -of default=nw=1:nk=1 "$input_gif")

# Calculate output dimensions while maintaining aspect ratio
if [ "$gif_width" -ge "$gif_height" ]; then
    scale="scale=-1:$max_side_length"
else
    scale="scale=$max_side_length:-1"
fi

# Check if the duration exceeds the limit
if (( $(bc <<< "$gif_duration > $max_duration") )); then
    # Calculate required speedup factor to fit within the duration
    speedup_factor=$(bc -l <<< "$max_duration / $gif_duration")
    
    echo "$speedup_factor"
    
    # Encode the WebM video with the calculated speedup
    ffmpeg -i "$input_gif" -vf "$scale,setpts=${speedup_factor}*PTS" -c:v libvpx-vp9 -an -f webm "$output_webm"
else
    # Encode the WebM video without any speedup
    ffmpeg -i "$input_gif" -vf "$scale" -c:v libvpx-vp9 -an -f webm "$output_webm"
fi

gif_duration=$(ffprobe -v error -select_streams v:0 -show_entries format=duration -of default=nw=1:nk=1 "$output_webm")
echo -e "\nduration: ${gif_duration}\n"

# Calculate output file size
output_file_size_kb=$(du -k "$output_webm" | cut -f1)

# Loop the video and re-encode if needed to meet file size constraint
while [ "$output_file_size_kb" -gt "$max_file_size_kb" ]; do
    desired_fps=$((desired_fps - 1))
    
    ffmpeg -i "$input_gif" -vf "$scale" -c:v libvpx-vp9 -r "$desired_fps" -an -f webm "$output_webm"
    output_file_size_kb=$(du -k "$output_webm" | cut -f1)
done

echo "Sticker created: $output_webm"
echo "Final FPS: $desired_fps"
echo "Output file size: $output_file_size_kb KB"

