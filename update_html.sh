#!/bin/bash

# The Serveo domain passed from the start_serveo.sh script
serveo_domain=$1

# Directory containing the HTML files
html_directory="/opt/lampp/htdocs"

# Loop through each generated HTML file in the directory (excluding template.html)
for html_file in "$html_directory"/camera*.html; do
    # Check if HTML file exists
    if [ ! -f "$html_file" ]; then
        echo "Skipping, not a file: $html_file"
        continue
    fi

    # Check if the file is "template.html" and skip it
    if [ "$(basename "$html_file")" = "template.html" ]; then
        echo "Skipping, it's template.html: $html_file"
        continue
    fi

    # Extract the camera number from the filename (assuming format camera[number].html)
    camera_number=$(echo "$html_file" | grep -oP 'camera\K[0-9]+')

    # Construct new Serveo stream URL with the camera number
    new_url="${serveo_domain}/stream${camera_number}.m3u8"

    # Use sed to replace the placeholder with the new Serveo URL
    sed -i "s|REPLACE_WITH_STREAM_URL|${new_url}|" "$html_file"

    echo "HTML file successfully updated: $html_file"
done

# Update the template.html separately with a generic placeholder URL
sed -i "s|REPLACE_WITH_STREAM_URL|${serveo_domain}/streamX.m3u8|" "$html_directory/template.html"
