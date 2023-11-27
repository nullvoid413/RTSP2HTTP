#!/bin/bash
    sed -i "s|var streamUrl = '.*';|var streamUrl = 'REPLACE_WITH_STREAM_URL';|" "/opt/lampp/htdocs/template.html"

# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null
}

# Function to handle cleanup actions
cleanup() {
    # Restore the placeholder value in template.html
    sed -i "s|var streamUrl = '.*';|var streamUrl = 'REPLACE_WITH_STREAM_URL';|" "/opt/lampp/htdocs/template.html"

    # Stop services (you can add your service stopping logic here)
    sudo /opt/lampp/htdocs/stop_services.sh

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

# Check for XAMPP
if [ -d "/opt/lampp" ] && [ -x "/opt/lampp/lampp" ]; then
    echo "XAMPP is installed."
else
    echo "XAMPP is not installed. Please install XAMPP before running this script."
    cleanup
fi

# If all dependencies are satisfied, continue with the script

# Start XAMPP's Apache Server and log its output
echo "Starting XAMPP's Apache Server..."
sudo /opt/lampp/lampp startapache > /opt/lampp/htdocs/apache_start.log 2>&1

# Check if Apache started successfully
if grep -q 'error' /opt/lampp/htdocs/apache_start.log; then
    echo "Error starting Apache."
    cleanup
else
    echo "Apache started successfully."
fi

# Give it a moment to ensure Apache starts
sleep 10

# Run ffmpeg in the background and log its output
echo "Starting ffmpeg..."
sudo /opt/lampp/htdocs/run_ffmpeg.sh > /opt/lampp/htdocs/ffmpeg.log 2>&1 &

# Run Serveo in the background and log its output
echo "Starting Serveo..."
sudo /opt/lampp/htdocs/start_serveo.sh > /opt/lampp/htdocs/serveo.log 2>&1 &

# Ask the user if they want to stop services
echo "Services are running. Do you want to stop them? (y/n): "
read stop_answer
if [ "$stop_answer" = "y" ]; then
    cleanup
fi
