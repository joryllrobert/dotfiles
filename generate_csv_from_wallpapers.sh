#!/bin/bash

# Directory containing the files
directory="wallpapers"

# CSV file to write output
csv_file="wallpapers.csv"

# URL base paths
base_url="https://raw.githubusercontent.com/joryllrobert/dotfiles/main/wallpapers/"
thumb_base_url="${base_url}thumbnails/"

# Header for CSV file
echo "name,author,url,thumbUrl" > "$csv_file"

# Loop through each file in the directory
for file in "$directory"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file" .png)
        url="${base_url}$filename.png"
        thumb_url="${thumb_base_url}thumbnail_$filename.png"
        echo "$filename, ,$url,$thumb_url" >> "$csv_file"
    fi
done

echo "CSV file generated: $csv_file"


