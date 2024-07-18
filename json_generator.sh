#!/bin/bash

# Input CSV file (replace with your actual CSV file path)
csv_file="wallpapers.csv"

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
