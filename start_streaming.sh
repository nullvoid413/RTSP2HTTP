#!/bin/bash

# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null
}

# Function to handle cleanup actions
cleanup() {
    # Stop services (you can add your service stopping logic here)
    sudo /var/www/html/stop_services.sh

    # Restore the template.html with the placeholder URL
    sed -i "s|http://${host_ip}/stream[0-9]*\.m3u8|REPLACE_WITH_STREAM_URL|" /var/www/html/template.html

    exit 0
}

# Trap signals and call the cleanup function when any of these signals are received
trap 'cleanup' SIGINT SIGTERM SIGHUP

# If all dependencies are satisfied, continue with the script

# Give it a moment to ensure Apache starts
sleep 10

# Start ffmpeg in the background and log its output
echo "Starting ffmpeg..."
sudo /var/www/html/run_ffmpeg.sh > /var/www/html/ffmpeg.log 2>&1 &

# Wait for a moment to allow ffmpeg processes to start
sleep 5

# Check for the existence of .m3u8 files and wait until they are created
while ! ls /var/www/html/*.m3u8 1> /dev/null 2>&1; do
    sleep 2
done

# Run the update_html.sh script to update HTML files with correct URLs
bash /var/www/html/update_html.sh

# Get the IP address of the host
host_ip=$(hostname -I | awk '{print $1}')
echo "Host IP: $host_ip"

# Ask the user if they want to stop services
echo "Services are running. Do you want to stop them? (y/n): "
read stop_answer
if [ "$stop_answer" = "y" ]; then
    cleanup
fi

