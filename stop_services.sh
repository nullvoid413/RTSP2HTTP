#!/bin/bash

# Function to check if a service is running
is_service_running() {
    pgrep -f "$1" > /dev/null
    return $?
}

# Function to stop a service
stop_service() {
    pkill -f "$1"
}

# Initialize variable to store names of running services
running_services=""

# Check if ffmpeg is running
is_service_running "ffmpeg"
if [ $? -eq 0 ]; then
    running_services+="ffmpeg "
fi

# Check if XAMPP's Apache is running
is_service_running "lampp"
if [ $? -eq 0 ]; then
    running_services+="lampp "
fi

# Check if SSH is running
is_service_running "ssh"
if [ $? -eq 0 ]; then
    running_services+="ssh "
fi

# Check if any services are running
if [ ! -z "$running_services" ]; then
    echo "The following services are running: $running_services"
    echo "Do you want to stop these services? (y/n): "
    read stop_all_answer
    if [ "$stop_all_answer" = "y" ]; then
        # Stop each running service
        for service in $running_services; do
            stop_service "$service"
            echo "$service stopped."
        done

        # Ask if the user wants to start streaming again
        echo "Do you want to start streaming again? (y/n): "
        read start_streaming_answer
        if [ "$start_streaming_answer" = "y" ]; then
            sudo ./start_streaming.sh
        fi
    fi
else
    echo "No services are currently running."
fi

echo "Service stopping process completed."
