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
systemctl --user start ndi-rx.service
```
This will start receiving NDI signals from the PC "Yummy".  
これにより、PC "Yummy" からのNDI信号を受信します。  

To change the connection destination, edit the `ndi-rx-start.sh` in your home directory and start the service:  
接続先を変更するには、ホームディレクトリの `ndi-rx-start.sh` を編集し、サービスを起動します: 

```bash
vim ~/ndi-rx-start.sh
systemctl --user start ndi-rx.service
```

### Transmit NDI - NDI送信
To transmit NDI signals from a capture board, run the following command:  
キャプチャーボードからNDI信号を送信するには、以下のコマンドを実行します:  
```bash
systemctl --user start ndi-tx.service
```
Transmits NDI signals as `<HOSTNAME> (TX)`.  
NDI信号を `<HOSTNAME> (TX)` として送信します。

If you want to change arguments such as the transmission name, resolution, or frame rate, edit `ndi-tx-start.sh` in the home directory and start the service. List of arguments can be checked with `/opt/utone-ndi-utils/tx.py --help`.   
送信名や解像度、フレームレートなどの引数を変更したい場合は、ホームディレクトリの `ndi-tx-start.sh` を編集し、サービスを起動します。引数の一覧は、`/opt/utone-ndi-utils/tx.py --help`で確認できます。  
```bash
vim ~/ndi-tx-start.sh
systemctl --user start ndi-tx.service
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
Install `live-build` in a Debian environment:  
Debian環境で`live-build`をインストールします。
```bash
sudo apt install live-build
```
To build the ISO image, you need to clone this repository and edit the files in `work/config`. Make sure to clone with the `--recursive` option.  
このリポジトリをクローンし、`work/config`内を編集します。`--recursive`オプションを付けてクローンしてください。
```bash
git clone https://github.com/TechnoTUT/utone-linux.git --recursive
cd utone-linux/work
```
Build the ISO image with the following command:  
isoイメージをビルドします。
```bash
lb config --distribution 'bookworm' --archive-areas 'main non-free non-free-firmware contrib' --bootappend-live 'boot=live components splash persistence' --image-name 'technotut-utone-live'
sudo lb build
```
Successful execution will create a directory named `technotut-utone-live-amd64.hybrid.iso` in the `work` directory.  
Retry the build with `sudo lb clean`.  
ビルドが完了すると、`technotut-utone-live-amd64.hybrid.iso`が生成されます。  
ビルドをやり直す場合は、`sudo lb clean`を実行します。
