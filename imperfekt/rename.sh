#!/bin/bash

# Directory containing files to be renamed
DIRECTORY="./wallpapers"

# Check if names.txt exists
if [[ ! -f "names.txt" ]]; then
  echo "names.txt file not found!"
  exit 1
fi

# Read names from names.txt
while IFS= read -r new_name; do
  # Replace spaces with underscores in the new name
  sanitized_name="${new_name// /_}"
  
  # Get the first file in the directory
  original_file=$(find "$DIRECTORY" -type f | head -n 1)

  # Check if there are files to rename
  if [[ -z "$original_file" ]]; then
    echo "No files left to rename in the directory."
    break
  fi

  # Extract the file extension
  extension="${original_file##*.}"
  
  # Construct the new filename with the correct extension
  new_file_path="$DIRECTORY/$sanitized_name.$extension"

  # Rename the file
  mv "$original_file" "$new_file_path"
  echo "Renamed '$original_file' to '$new_file_path'"

done < "names.txt"
