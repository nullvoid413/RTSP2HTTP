#!/bin/bash

# Define the output file in the current directory
output_file="serveo_output.txt"
url_file="/var/www/html/current_serveo_url.txt"  # File to store the current Serveo URL

# Get the IP address of the host
host_ip=$(hostname -I | awk '{print $1}')
echo "Host IP: $host_ip"

# Compare with the previous IP and update HTML files if different
if [ -f "$url_file" ]; then
    previous_ip=$(cat "$url_file")
    if [ "$host_ip" != "$previous_ip" ]; then
        sudo ./update_html.sh "$host_ip"
    fi
else
    sudo ./update_html.sh "$host_ip"  # First time setup or IP file not found
fi

# Update the IP file with the current IP
echo "$host_ip" > "$url_file"

# Display the Host IP in a Zenity text entry dialog
zenity --entry --title="Host IP" --text="Host IP:" --entry-text="$host_ip" --width=300 --height=50