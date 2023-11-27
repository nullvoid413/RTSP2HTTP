# RTSP2HTTP
This project is intended to convert RTSP streams to HTTP.






## Installation

Install requirements to use RTSP2HTTP:

```bash
XAMPP (make sure the installation goes to /opt/lampp/):
https://www.apachefriends.org/index.html

FFMPEG:
sudo apt-get update && sudo apt-get install -y ffmpeg

SSH:
sudo apt-get update && sudo apt-get install -y ssh
```
    
## Deployment

Follow these steps to configure and run RTSP2HTTP in your environment:


```bash
1. Repository Files Preparation:
   Ensure all the necessary files from the repository are located in the /opt/lampp/htdocs/ directory. This is crucial for the proper functioning of the project:

cd /opt/lampp/htdocs
git clone --branch beta-1 https://github.com/nullvoid413/RTSP2HTTP

2. Set Executable Permissions:
   Open your terminal and run the following command to grant executable permissions to all files in the /opt/lampp/htdocs/ directory:

sudo chmod +x /opt/lampp/htdocs/*

3. Navigate to Project Directory:
   Change your current working directory to the project folder by executing:

cd /opt/lampp/htdocs

4. Configure Camera Streams:
   Edit the stream_config.conf file located in the directory. Input the RTSP link for each of your cameras. Remember, each line in this file corresponds to one camera. To configure multiple cameras, simply add more lines with their respective RTSP links.

5. Initiate Streaming Process:
   Start the streaming process by running the start_streaming.sh script. Execute this command:

sudo ./start_streaming.sh


6. Project Loading:
   Please allow some time for the project to initialize and load correctly. This might take a few moments depending on your system specifications and the number of camera streams.

Access the Streaming Interface:
Once the project is fully loaded, a URL will be provided. Copy this URL and paste it into your preferred web browser to access the streaming interface and view your camera feeds.

Additional Notes:
Ensure that your system meets all the necessary prerequisites for running the project.
For any troubleshooting or additional configurations, refer to the project's documentation or contact support.
By following these steps, you should be able to successfully set up and enjoy the Camera Streaming.
For further assistance or inquiries, please do not hesitate to reach out.






```

