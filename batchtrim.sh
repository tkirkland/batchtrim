#!/usr/bin/env bash

START_TRIM="5"
END_TRIM="15"

getFileRuntime() {
    i=$(ffprobe -i "$1" -show_entries format=duration -v quiet -of csv="p=0")
    return "${i}"
}

for FILE in /drobo/mid/*.mp4; do
    [[ -e "$FILE" ]] || break
    FILE_RUNTIME=$(getFileRuntime "$FILE")
    FILE_NAME="${FILE%%.*}"
    FILE_EXT="${FILE##*.}"
    OUT_FILE="${FILE_NAME}_trimmed.${FILE_EXT}"
    echo  $FILE_RUNTIME
    #ffmpeg -i "$FILE" -ss "$START_TRIM" -to $((FILE_RUNTIME - END_TRIM)) -c:v copy -c:a copy "$OUT_FILE"
done
