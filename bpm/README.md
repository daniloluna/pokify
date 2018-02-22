# IBM Business Process Manager (BPM)
*Version:* 8.5.7

#### Requirements
* Packer 1.0.4 or newer
* VirtualBox 5.2.6 or newer
* BPM images
  * BPM_Std_V857_Linux_x86_1_of_3.tar
  * BPM_Std_V857_Linux_x86_2_of_3.tar
  * BPM_Std_V857_Linux_x86_3_of_3.tar

### Instructions
1. Download the required BPM images into the */files* folder
2. In a terminal, go to the *pokify/bpm* folder and type `bash run.sh`
3. Wait for the installation to finish (+- 1h on SSD). The image will be generated in the *builds* folder

Once the image is generated, it will be used as the base image for other *poks*

### Installing
1. On VirtuaBox go to *File -> Import Appliance*
2. Select the generated image
3. Import the image
4. Start the VM (Tip: use a HostOnly adapter, otherwise you will have to map all network ports manually)
5. Login as root and get the current IP (`ip addr`)

#### Credentials
* User: **admin**
* Password: **pokify**

#### URLs:
* https://<IP>:9443/ProcessAdmin
* https://<IP>:9443/ProcessCenter
* https://<IP>:9043/ibm/console
