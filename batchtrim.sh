#!/usr/bin/env bash

START_TRIM="5"
END_TRIM="15.0"

toSeconds() {
    awk -F: 'NF==3 { print ($1 * 3600) + ($2 * 60) + $3 }
            NF==2 { print ($1 * 60) + $2 }
            NF==1 { print 0 + $1 }' <<<"$1"
}

getFileRuntime() {
    ffprobe -i "$1" -show_entries format=duration -v quiet -of csv="p=0"
}

for FILE in /drobo/The\ Middle/*.mp4
do
    [[ -e "$FILE" ]] || break
    FILE_RUNTIME=$(getFileRuntime "$FILE")
    FILE_NAME="${FILE%%.*}"
    FILE_EXT="${FILE##*.}"
    OUT_FILE="${FILE_NAME}_trimmed.${FILE_EXT}"

    ffmpeg -i "$FILE" -ss "$START_TRIM" -to "$(bc <<< "$FILE_RUNTIME"-"$END_TRIM")" \
                -c:v copy -c:a copy "$OUT_FILE"
done