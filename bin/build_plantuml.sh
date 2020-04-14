#!/usr/bin/env bash

FILE="$1"

if [[ ! -d "img" ]]; then
    mkdir -p "img"
fi


FILE_BASE="${FILE%.*}"
plantuml -o img "$FILE" && open "img/$FILE_BASE.png"
