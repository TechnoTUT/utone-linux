# utone-linux
This repository provides a Debian Live environment to easily run edge devices for the on-campus DJ event "The Utopia Tone". It includes [utone-ndi-utils](https://github.com/TechnoTUT/utone-ndi-utils) and an automatic signage system.  
このリポジトリは、学内DJイベント "The Utopia Tone" のエッジデバイスを容易に動作させるためのDebian Live環境を提供します。[utone-ndi-utils](https://github.com/TechnoTUT/utone-ndi-utils)や、自動サイネージシステムを含みます。  

## How to use - 使い方
Download the image from [Releases](https://github.com/TechnoTUT/utone-linux/releases) and write it to a DVD or USB drive. To write to a USB drive, use a tool like [Rufus](https://rufus.ie/).  
If you want to keep settings after reboot, specify the size of the persistent storage in Rufus settings. 1GB is sufficient for most cases. If you plan to use NDI transmission or signage, setting up persistent storage is recommended.  
[Releases](https://github.com/TechnoTUT/utone-linux/releases)からイメージをダウンロードし、DVDまたはUSBメモリに書き込みます。USBメモリに書き込む場合は、[Rufus](https://rufus.ie/)等のツールを使用します。  
再起動しても設定が保持されるようにするには、Rufusの設定で保存領域のサイズを指定します。1GB程度で十分です。NDI送信やサイネージの設定を行う場合には、保存領域の設定を推奨します。

Insert the completed DVD or USB drive into your PC and power it on to boot into the Live environment.  
完成したDVDまたはUSBメモリをPCに挿入し、電源を投入するとLive環境が起動します。

### Receive NDI - NDI受信
To receive NDI signals, run the following command:  
NDI信号を受信するには、以下のコマンドを実行します:  
```bash
nrx
```

To change the connection destination, edit the `.config/systemd/user/ndi-rx.service` in your home directory and enable the service:  
接続先を設定して自動起動を有効にするには、ホームディレクトリの `.config/systemd/user/ndi-rx.service` を編集します: 

```bash
vim ~/.config/systemd/user/ndi-rx.service
systemctl --user enable --now ndi-rx.service
```

### Transmit NDI - NDI送信
To transmit NDI signals from a capture board, run the following command:  
キャプチャーボードからNDI信号を送信するには、以下のコマンドを実行します:  
```bash
ntx
```
Transmits NDI signals as `<HOSTNAME> (TX)`.  
NDI信号を `<HOSTNAME> (TX)` として送信します。

If you want to change arguments such as the transmission name, resolution, or frame rate, edit `.config/systemd/user/ndi-tx.service` in the home directory and enable the service. List of arguments can be checked with `uv run /opt/utone-ndi-utils/tx.py --help`.   
送信名や解像度、フレームレートなどの引数を変更し自動起動を有効にする場合は、ホームディレクトリの `.config/systemd/user/ndi-tx.service` を編集し、サービスを起動します。引数の一覧は、`uv run /opt/utone-ndi-utils/tx.py --help`で確認できます。  
```bash
vim ~/.config/systemd/user/ndi-tx.service
systemctl --user enable --now ndi-tx.service
```
The default hostname is `debian`. To change the hostname, use the command `sudo hostnamectl set-hostname <new hostname>`.  
初期設定のホスト名は `debian` です。ホスト名を変更するには、`sudo hostnamectl set-hostname <新しいホスト名>` と入力します。

### Signage - サイネージ
After booting, you will need to configure Wi-Fi and enter NAS credentials.  
起動後、Wi-Fiの設定とNASの資格情報の入力が必要です。  
```bash
sudo nmtui
vim .smbcredentials
```
To change the NAS IP address, edit `kiosk-start.sh` in your home directory:  
NASのIPアドレスを変更するには、ホームディレクトリの `kiosk-start.sh` を編集します。
```bash
vim kiosk-start.sh
```
To start the signage, run the `kiosk-start.sh` script in your home directory:  
サイネージを起動するには、ホームディレクトリの `kiosk-start.sh` を実行します。
```bash
./kiosk-start.sh
```
To enable automatic startup, add the following line to your `.bashrc` file:  
自動起動を設定するには、`.bashrc` に以下の行を追加します。
```bash
exec ~/kiosk-start.sh
```
To append this line in one command, you can run:  
ワンライナーで追記するには、以下のコマンドを実行します。
```bash
echo "exec ~/kiosk-start.sh" >> ~/.bashrc
```

## How to build - ビルド方法
### Using Dev Container (Recommended) - Dev Containerを使用する場合 (推奨)
You can easily build the ISO using VS Code and Dev Containers (Docker/Podman required).  
VS Code と Dev Containers 拡張機能を使用することで、ホスト環境を汚さずにビルド環境を構築できます（Docker または Podman が必要です）。

1. Open this repository in VS Code. / VS Code でこのリポジトリを開きます。
2. Click "Reopen in Container" when prompted (or via Command Palette `Ctrl+Shift+P` -> `Dev Containers: Reopen in Container`). / ポップアップまたはコマンドパレットからコンテナ内で再度開きます。
3. In the terminal inside the container, run: / コンテナ内ターミナルで以下を実行します:
   ```bash
   make build
   ```
   To clean build artifacts: / クリーンアップする場合:
   ```bash
   make clean
   ```

### Using Debian / WSL2 - 通常のDebian / WSL2環境を使用する場合
To build the ISO image, you need a Debian environment. If you are using Windows, you can easily set up a Debian environment using WSL2.    
ビルドにはDebian環境が必要です。Windowsを使用している場合は、WSL2を利用することで簡単にDebian環境を構築できます。  
```pwsh
wsl --update
wsl --list --online
wsl --install -d Debian
```

Install `live-build` and `make` in a Debian environment:  
Debian環境で`live-build`と`make`をインストールします。
```bash
sudo apt update
sudo apt install live-build make
```
To build the ISO image, clone this repository with the `--recursive` option:  
このリポジトリを`--recursive`オプションを付けてクローンします。
```bash
git clone https://github.com/TechnoTUT/utone-linux.git --recursive
cd utone-linux
```
Build the ISO image with `make`:  
`make` を使って ISO イメージをビルドします。
```bash
make build
```
Successful execution will create `utone-linux-amd64.hybrid.iso` in the `work` directory.  
To clean up build artifacts, run `make clean`:  
ビルドが完了すると、`work` ディレクトリ内に `utone-linux-amd64.hybrid.iso` が生成されます。  
ビルドをやり直す場合やクリーンアップを行う場合は、`make clean` を実行します。
```bash
make clean
```
