#!/bin/bash

max_fps=30
max_duration=3
max_size_px=512
max_size=256
crf=30

while [[ $1 != "" ]]; do
	case $1 in
		-i | --input)
			shift
			input="$1"
		;;
		-o | --output)
			shift
			output="$1"
		;;
		--max-fps)
			shift
			max_fps="$1"
		;;
		--max-duration)
			shift
			max_duration="$1"
		;;
		--max-size-px)
			shift
			max_size_px="$1"
		;;
		--max-output-size)
			shift
			max_size="$1"
		;;
		-h | --help)
			echo "-i | --input [PATH] - Path to the input file"
			echo "-o | --output [PATH] - Path to the output file"
			echo "-h | --help - This help message"
		;;
		*)
			echo "Opção inválida: $1"
            exit 1
		;;
	esac
	
	shift
done

if [[ ! -f "$input" ]]; then
	echo "Invalid input file"
	exit 1
fi

if [[ -z "$output" ]]; then
	echo "Invalid output file"
	exit 1
fi

input_width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=nw=1:nk=1 "$input")
input_height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=nw=1:nk=1 "$input")
input_duration=$(ffprobe -v error -select_streams v:0 -show_entries format=duration -of default=nw=1:nk=1 "$input")

if [ "$input_width" -ge "$input_height" ]; then
    scale="$max_size_px:-1:force_original_aspect_ratio=decrease"
    padding="$max_size_px:ih:(ow-iw)/2:(oh-ih)/2:color=black@0.0"
else
    scale="-1:$max_size_px:force_original_aspect_ratio=decrease"
    padding="i:$max_size_px:(ow-iw)/2:(oh-ih)/2:color=black@0.0"
fi

if (( $(bc <<< "$input_duration > $max_duration") )); then
    speedup_factor=$(bc -l <<< "scale=2; $max_duration / $input_duration")
else
	speedup_factor=1
fi

output_size=$((max_size + 1))

while [ "$output_size" -gt "$max_size" ]; do
    ffmpeg -i "$input" -c:v libvpx-vp9 -r "$max_fps" -crf "$((crf+=2))" -an -y -f webm \
    	-vf "scale=$scale,setpts=${speedup_factor}*PTS" "$output" &> /dev/null
	output_size=$(du -k "$output" | cut -f1)
done

output_width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=nw=1:nk=1 "$output")
output_height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=nw=1:nk=1 "$output")
output_duration=$(ffprobe -v error -select_streams v:0 -show_entries format=duration -of default=nw=1:nk=1 "$output")
output_fps=$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 "$output")

