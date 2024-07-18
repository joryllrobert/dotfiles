#!/bin/bash

# Check if output directory exists, create it if not
output_dir="thumbnails"
mkdir -p "$output_dir"

# Loop through all JPEG and PNG files in the current directory
for file in *.jpg *.jpeg *.png; do
    if [ -f "$file" ]; then
        # Generate thumbnail filename with prefix and extension
        thumbnail_name="thumbnail_$(basename "$file")"

        # Create the thumbnail
        convert "$file" -resize 300x300^ -gravity center -extent 300x300 "$output_dir/$thumbnail_name"

        echo "Created thumbnail: $output_dir/$thumbnail_name"
    fi
done

echo "Thumbnails creation complete."
