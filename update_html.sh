#!/bin/bash

# Get the IP address of the host
host_ip=$(hostname -I | awk '{print $1}')

# Directory containing the HTML files
html_directory="/var/www/html"

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

    # Construct new stream URL with the camera number
    new_url="http://${host_ip}/stream${camera_number}.m3u8"

    # Use awk to replace the placeholder with the new URL
    awk -v new_url="$new_url" '/var streamUrl =/ {gsub(/http:\/\/.*\/stream.*\.m3u8/, new_url)} 1' "$html_file" > "$html_file.tmp" && mv "$html_file.tmp" "$html_file"

    echo "HTML file successfully updated: $html_file"
done

# Update the template.html separately with a generic placeholder URL
sed -i "s|REPLACE_WITH_STREAM_URL|http://${host_ip}/streamX.m3u8|" "$html_directory/template.html"

