#!/bin/bash

# Define the output file in the current directory
output_file="serveo_output.txt"
url_file="/opt/lampp/htdocs/current_serveo_url.txt"  # File to store the current Serveo URL

# Start Serveo SSH tunnel in the background and redirect output to the output file
sudo ssh -tt -R 80:localhost:80 serveo.net > "$output_file" 2>&1 &
ssh_pid=$!

# Timeout for checking the Serveo URL
timeout=30

# Initialize a variable to store the Serveo URL
serveo_url=""

# Function to extract and print Serveo URL
get_serveo_url() {
    local url_pattern="https?://\S+\.serveo\.net"
    local found_url
    found_url=$(grep -oP "$url_pattern" "$output_file" | head -1)
    if [ -n "$found_url" ]; then
        serveo_url="$found_url"
        echo "Serveo URL: $serveo_url"
        return 0
    else
        return 1
    fi
}

# Loop to check the output file for the Serveo URL
while [ $timeout -gt 0 ]; do
    if get_serveo_url; then
        > "$output_file"
        break
    fi
    sleep 1
    ((timeout--))
done

# If URL not found in specified time, kill SSH process
if [ -z "$serveo_url" ]; then
    echo "Serveo URL not found within the expected time."
    sudo kill $ssh_pid
    exit 1
fi

# Compare with the previous URL and update HTML files if different
if [ -f "$url_file" ]; then
    previous_url=$(cat "$url_file")
    if [ "$serveo_url" != "$previous_url" ]; then
        sudo ./update_html.sh "$serveo_url"
    fi
else
    sudo ./update_html.sh "$serveo_url"  # First time setup or URL file not found
fi

# Update the URL file with the current URL
echo "$serveo_url" > "$url_file"

# Display the Serveo URL in a Zenity text entry dialog
zenity --entry --title="Serveo URL" --text="Serveo URL:" --entry-text="$serveo_url" --width=300 --height=50

# Cleanup: Optionally remove the output file
rm "$output_file"
