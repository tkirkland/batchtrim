#!/usr/bin/env bash

START_TRIM="10"
END_TRIM="25"

getFileRuntime() {
    ffprobe -i "$1" -show_entries format=duration -v quiet -of csv="p=0"
    return
}

for FILE in /drobo/S01/*e22*.mp4; do
    [[ -e "$FILE" ]] || break
    FILE_RUNTIME=$(printf "%.0f" "$(getFileRuntime "$FILE")")
    FILE_NAME="${FILE%%.*}"
    FILE_EXT="${FILE##*.}"
    OUT_FILE="${FILE_NAME}_trimmed.${FILE_EXT}"
    echo "$FILE_RUNTIME"
    ffmpeg -i "$FILE" -ss "$START_TRIM" -to $((FILE_RUNTIME - END_TRIM)) \
        -c:v copy -c:a copy "$OUT_FILE"
done
