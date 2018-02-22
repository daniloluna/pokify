# CentOs Base image
*Version:* CentOS-7-x86_64-Minimal-1708

#### Requirements
* Packer 1.0.4 or newer
* VirtualBox 5.2.6 or newer

### Instructions
1. Download the required ISO image (see *isos* readme)
2. In a terminal console, go to the *pokify/baseCentos7_64* folder and type `bash run.sh`
3. Wait for the installation to finish. The image will be generated in the *builds* folder

Once the image is generated, it will be used as the base image for other *poks*

### Installing
1. On VirtuaBox go to *File -> Import Appliance*
2. Select the generated image
3. Import

#### Credentials
* User: **root**
* Password: **pokify**
