# RTSP2HTTP
This project is intended to convert RTSP streams to HTTP.






## Installation

Install requirements to use RTSP2HTTP:

XAMPP (make sure the installation goes to /opt/lampp/):

https://www.apachefriends.org/index.html

(Guide for installation):

https://smarttech101.com/how-to-install-and-manage-xampp-in-linux/


FFMPEG:
```bash
sudo apt-get update && sudo apt-get install -y ffmpeg
```

SSH:
```bash
sudo apt-get update && sudo apt-get install -y ssh
```

    
## Setup

1. Repository Files Preparation:

*Ensure all the necessary files from the repository are located in the /opt/lampp/htdocs/ directory. This is crucial for the proper functioning of the project.*

```bash
sudo git clone --branch beta-1 https://github.com/nullvoid413/RTSP2HTTP /opt/lampp/htdocs/
```

2. Set Executable Permissions:

*Open your terminal and run the following command to grant executable permissions to all files in the /opt/lampp/htdocs/ directory:*
```bash
sudo chmod +x /opt/lampp/htdocs/*
```

3. Navigate to Project Directory:

*Change your current working directory to the project folder by executing:*
```bash
cd /opt/lampp/htdocs
```

4. Configure Camera Streams:

*Input the RTSP link for each of your cameras. Remember, each line in this file corresponds to one camera. To configure multiple cameras, simply add more lines with their respective RTSP links.*
```bash
   Edit the stream_config.conf file that you downloaded from this Repo which is located in /opt/lampp/htdocs/ directory. 
```

5. Initiate Streaming Process:

*Start the streaming process by running the start_streaming.sh script. Execute this command:*
```bash
sudo ./start_streaming.sh
```

6. Project Loading:
*Please allow some time for the project to initialize and load correctly. This might take a few moments depending on your system specifications and the number of camera streams.*

Additional Notes:

*Ensure that your system meets all the necessary prerequisites for running the project.
For any troubleshooting or additional configurations, refer to the project's documentation or contact support.
By following these steps, you should be able to successfully set up and enjoy the Camera Streaming.
For further assistance or inquiries, please do not hesitate to reach out.*



