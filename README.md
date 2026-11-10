# utone-linux

English | [日本語](README.ja.md)

This repository provides a Debian Live environment to easily run edge devices for the on-campus DJ event "The Utopia Tone". It includes [utone-ndi-utils](https://github.com/TechnoTUT/utone-ndi-utils) and an automatic signage system.  

## How to use
Download the image from [Releases](https://github.com/TechnoTUT/utone-linux/releases) and write it to a DVD or USB drive. To write to a USB drive, use a tool like [Rufus](https://rufus.ie/).  
If you want to keep settings after reboot, specify the size of the persistent storage in Rufus settings. 1GB is sufficient for most cases. If you plan to use NDI transmission or signage, setting up persistent storage is recommended.  

Insert the completed DVD or USB drive into your PC and power it on to boot into the Live environment.  

### Receive NDI
To receive NDI signals, run the following command:  
```bash
nrx
```

To change the connection destination, edit the `.config/systemd/user/ndi-rx.service` in your home directory and enable the service:  

```bash
vim ~/.config/systemd/user/ndi-rx.service
systemctl --user enable --now ndi-rx.service
```

### Transmit NDI
To transmit NDI signals from a capture board, run the following command:  
```bash
ntx
```
Transmits NDI signals as `<HOSTNAME> (TX)`.  

If you want to change arguments such as the transmission name, resolution, or frame rate, edit `.config/systemd/user/ndi-tx.service` in the home directory and enable the service. List of arguments can be checked with `uv run /opt/utone-ndi-utils/tx.py --help`.   
```bash
vim ~/.config/systemd/user/ndi-tx.service
systemctl --user enable --now ndi-tx.service
```
The default hostname is `debian`. To change the hostname, use the command `sudo hostnamectl set-hostname <new hostname>`.  

### Signage
After booting, you will need to configure Wi-Fi and enter NAS credentials.  
```bash
sudo nmtui
vim .smbcredentials
```
To change the NAS IP address, edit `kiosk-start.sh` in your home directory:  
```bash
vim kiosk-start.sh
```
To start the signage, run the `kiosk-start.sh` script in your home directory:  
```bash
./kiosk-start.sh
```
To enable automatic startup, add the following line to your `.bashrc` file:  
```bash
exec ~/kiosk-start.sh
```
To append this line in one command, you can run:  
```bash
echo "exec ~/kiosk-start.sh" >> ~/.bashrc
```

## How to build
### Using Dev Container (Recommended)
You can easily build the ISO using VS Code and Dev Containers (Docker/Podman required).  

1. Open this repository in VS Code.
2. Click "Reopen in Container" when prompted (or via Command Palette `Ctrl+Shift+P` -> `Dev Containers: Reopen in Container`).
3. In the terminal inside the container, run:
   ```bash
   make build
   ```
   To clean build artifacts:
   ```bash
   make clean
   ```

### Using Debian / WSL2
To build the ISO image, you need a Debian environment. If you are using Windows, you can easily set up a Debian environment using WSL2.    
```pwsh
wsl --update
wsl --list --online
wsl --install -d Debian
```

Install `live-build` and `make` in a Debian environment:  
```bash
sudo apt update
sudo apt install live-build make
```
To build the ISO image, clone this repository with the `--recursive` option:  
```bash
git clone https://github.com/TechnoTUT/utone-linux.git --recursive
cd utone-linux
```
Build the ISO image with `make`:  
```bash
make build
```
Successful execution will create `utone-linux-amd64.hybrid.iso` in the `work` directory.  
To clean up build artifacts, run `make clean`:  
```bash
make clean
```
