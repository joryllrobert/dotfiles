#!/bin/bash

# Directory containing the PNG images
input_dir="wallpapers"
# Directory to save the thumbnails
output_dir="wallpapers/thumbnails"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop through all PNG files in the input directory
for file in "$input_dir"/*.png; do
    # Extract the filename without the directory
    filename=$(basename "$file")
    # Generate the thumbnail and save it to the output directory
    convert "$file" -resize 300x300^ -gravity center -extent 300x300 "$output_dir/thumbnail_$filename"
done

echo "Thumbnails generated in $output_dir"
