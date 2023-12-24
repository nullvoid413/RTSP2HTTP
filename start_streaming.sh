#!/bin/bash
    sed -i "s|var streamUrl = '.*';|var streamUrl = 'REPLACE_WITH_STREAM_URL';|" "/var/www/html/template.html"

# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null
}

# Function to handle cleanup actions
cleanup() {
    # Restore the placeholder value in template.html
    sed -i "s|var streamUrl = '.*';|var streamUrl = 'REPLACE_WITH_STREAM_URL';|" "/var/www/html/template.html"

    # Delete all files except the ones listed
    find /var/www/html -type f | grep -vE '(start_streaming\.sh|run_ffmpeg\.sh|start_serveo\.sh|stop_services\.sh|stream_config\.conf|template\.html|update_html\.sh)' | xargs rm

    # Stop services (you can add your service stopping logic here)
    sudo /var/www/html/stop_services.sh

    exit 0
}

# Trap signals and call the cleanup function when any of these signals are received
trap 'cleanup' SIGINT SIGTERM SIGHUP

# Check for ffmpeg
if command_exists ffmpeg; then
    echo "ffmpeg is installed."
else
    echo "ffmpeg is not installed. Installing ffmpeg..."
    sudo apt-get update && sudo apt-get install -y ffmpeg
fi

# Check for ssh
if command_exists ssh; then
    echo "ssh is installed."
else
    echo "ssh is not installed. Installing ssh..."
    sudo apt-get update && sudo apt-get install -y ssh
fi

if systemctl is-active --quiet apache2; then
    echo "Apache2 is running."
else
    echo "Apache2 is not running. Attempting to start Apache2..."
    sudo systemctl start apache2
    if [ $? -eq 0 ]; then
        echo "Apache2 started successfully."
    else
        echo "Failed to start Apache2. Please check the installation or try starting it manually."
        exit 1
    fi
fi


# If all dependencies are satisfied, continue with the script

# Run ffmpeg in the background and log its output
echo "Starting ffmpeg..."
sudo /var/www/html/run_ffmpeg.sh > /var/www/html/ffmpeg.log 2>&1 &

# Run Serveo in the background and log its output
echo "Starting Serveo..."
sudo /var/www/html/start_serveo.sh > /var/www/html/serveo.log 2>&1 &

sleep 10
serveo_url=$(cat /var/www/html/current_serveo_url.txt)
echo "Serveo URL: $serveo_url"

# Ask the user if they want to stop services
echo "Services are running. Do you want to stop them? (y/n): "
read stop_answer
if [ "$stop_answer" = "y" ]; then
    cleanup
fi
