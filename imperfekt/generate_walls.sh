#!/bin/bash

# Directory containing the images
input_dir="wallpapers"
# Directory to save the thumbnails
output_dir="wallpapers/thumbnails"

# Create the output directory if it doesn't exist
rm -rf "$output_dir"
mkdir -p "$output_dir"

# Function to process each image file
process_image() {
    local file="$1"
    local filename=$(basename "$file")
    # Generate the thumbnail and save it to the output directory
    magick "$file" -resize 300x300^ -gravity center -extent 300x300 "$output_dir/thumbnail_$filename"
    echo "Creating thumbnail for $file"
}

# Process PNG files
for file in "$input_dir"/*.png; do
    if [ -f "$file" ]; then
        process_image "$file"
    fi
done

# Process JPG files
for file in "$input_dir"/*.jpg; do
    if [ -f "$file" ]; then
        process_image "$file"
    fi
done

echo "Thumbnails generated in $output_dir"

for file in "$input_dir"/*.jpg; do
  # Get the base name of the file (without directory and extension)
  base_name=$(basename "$file" .jpg)

  # Define the temporary output file path
  temp_file="$input_dir/$base_name-temp.jpg"

  # Convert jpg to jpg with specified quality
  magick "$file" -quality 75 "$temp_file"

  # Replace the original file with the processed file
  mv "$temp_file" "$file"

  echo "Replaced $file with $temp_file"
done

# Directory containing the files
directory="wallpapers"

# CSV file to write output
csv_file="wallpapers.csv"

# URL base paths
base_url="https://raw.githubusercontent.com/joryllrobert/dotfiles/main/imperfekt/wallpapers/"
thumb_base_url="${base_url}thumbnails/"

# Header for CSV file
echo "name,author,url,thumbUrl" > "$csv_file"

# Function to process each image file
process_image() {
    local file="$1"
    local extension="$2"

    # Extract filename without extension
    basename=$(basename "$file" "$extension")

    # Extract name and author from the filename
    name=$(echo "$basename" | cut -d '-' -f 1 | sed 's/_/ /g')
    author=$(echo "$basename" | cut -d '-' -f 2 | sed 's/_/ /g')

    # Construct URLs
    url="${base_url}$basename$extension"
    thumb_url="${thumb_base_url}thumbnail_$basename$extension"

    # Write to CSV file
    echo "$name,$author,$url,$thumb_url" >> "$csv_file"
}

# Process PNG files
for file in "$directory"/*.png; do
    if [ -f "$file" ]; then
        process_image "$file" ".png"
    fi
done

# Process JPG files
for file in "$directory"/*.jpg; do
    if [ -f "$file" ]; then
        process_image "$file" ".jpg"
    fi
done

echo "CSV file generated: $csv_file"

echo "Generating JSON file..."

# Output JSON file
json_file="wallpapers.json"

# Check if the CSV file exists
if [ ! -f "$csv_file" ]; then
  echo "Error: CSV file '$csv_file' not found."
  exit 1
fi

# Initialize JSON array
echo "[" > "$json_file"

# Read CSV file, skip header, and process each line
tail -n +2 "$csv_file" | while IFS=',' read -r col1 col2 col3 col4 _; do
  # Construct JSON object
  json_object=$(cat <<EOF
  {
    "name": "$col1",
    "author": "$col2",
    "url": "$col3",
    "thumbUrl": "$col4"
  }
EOF
)
  # Append JSON object to JSON file
  echo "$json_object," >> "$json_file"
done

# Remove the trailing comma from the last line
sed -i '$ s/,$//' "$json_file"

# Close JSON array
echo "]" >> "$json_file"

echo "Conversion completed. Output JSON file: $json_file"


