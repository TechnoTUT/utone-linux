# utone-linux

English | [日本語](README.ja.md)

This repository provides a Debian Live environment to easily run edge devices for the on-campus DJ event "The Utopia Tone". It includes [moip-toolkit](https://github.com/TechnoTUT/moip-toolkit) (NDI receive/transmit and digital signage) and [booth-display](https://github.com/TechnoTUT/booth-display) (booth display controller).  

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

`ndi-rx.service` uses the `kmsdrm` video driver by default, which bypasses the desktop compositor and renders directly to the display for the lowest latency. To use the desktop compositor instead, remove `--video-driver kmsdrm` from the `ExecStart` line. To run it manually with kmsdrm:  
```bash
uv run /opt/moip-toolkit/main.py rx -s "<NDI Source Name>" --video-driver kmsdrm
```
- No desktop session may be running on that display (console / TTY state). `sudo systemctl set-default multi-user.target` makes the machine boot without a GUI.
- Add the user to the `video` and `input` groups: `sudo usermod -aG video,input $USER`
- Output is always fullscreen.

### Transmit NDI
To transmit NDI signals from a capture board, run the following command:  
```bash
ntx
```
Transmits NDI signals as `<HOSTNAME> (TX)`.  

If you want to change arguments such as the transmission name, resolution, or frame rate, edit `.config/systemd/user/ndi-tx.service` in the home directory and enable the service. List of arguments can be checked with `ntx --help`.   
```bash
vim ~/.config/systemd/user/ndi-tx.service
systemctl --user enable --now ndi-tx.service
```
The default hostname is `debian`. To change the hostname, use the command `sudo hostnamectl set-hostname <new hostname>`.  

### Signage
Signage is provided by moip-toolkit. Start the Web UI service, then upload an image from your browser to show it fullscreen on the connected display:  
```bash
systemctl --user enable --now ndi-web.service
```
Open `http://<IP address>:8000/` in a browser (the IP address is shown at login). To keep the setting after reboot, use persistent storage.  

You can also show an image directly from the command line:  
```bash
/opt/moip-toolkit/.venv/bin/python /opt/moip-toolkit/main.py signage -i /path/to/image.png --fullscreen
```
If `-i` is omitted, the most recent image uploaded via the Web UI is shown. On a console without a GUI (TTY), add `--framebuffer` to draw directly to the Linux framebuffer (root privileges may be required).  
See the [moip-toolkit README](https://github.com/TechnoTUT/moip-toolkit) for details.

### Booth display
The [booth-display](https://github.com/TechnoTUT/booth-display) controller streams test patterns, video files or NDI sources to the tiled booth displays. Start it with:  
```bash
bth
```
To start it automatically, enable the service:  
```bash
systemctl --user enable --now booth.service
```
Open `http://<IP address>:8080/` in a browser to use the Web GUI. Display addresses and crop positions are set in `/opt/booth-display/config.yaml`.  

NDI input uses the NDI runtime (`libndi.so.6`) from the official NDI SDK for Linux. The ISO build downloads the SDK, accepts its license and installs the runtime to `/usr/local/lib`.  
See the [booth-display README](https://github.com/TechnoTUT/booth-display) for details.

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
