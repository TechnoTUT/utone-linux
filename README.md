# utone-linux
このリポジトリは、[utone-ndi-utils](https://github.com/TechnoTUT/utone-ndi-utils)を実行するDebian Live環境を管理します。

## 使い方
[Release](https://github.com/TechnoTUT/utone-linux/releases)からイメージをダウンロードし、DVDまたはUSBメモリに書き込みます。  
USBメモリに書き込む場合は、[Rufus](https://rufus.ie/)等のツールを使用します。  

完成したDVDまたはUSBメモリをPCに挿入し、電源を投入するとLive環境が起動します。

### NDI受信
`systemctl --user start ndi-rx.service` を実行すると、PC "Yummy" からのNDI信号を受信します。

接続先を変更するには、ホームディレクトリの `ndi-rx-start.sh` を編集し、サービスを起動します。
```bash
vim ~/ndi-rx-start.sh
systemctl --user start ndi-rx.service
```

### NDI送信
`systemctl --user start ndi-tx.service` を実行すると、キャプチャーボードからの映像をNDI信号として送信します。
引数を変更する場合は、ホームディレクトリの `ndi-tx-start.sh` を編集し、サービスを起動します。
```bash
vim ~/ndi-tx-start.sh
systemctl --user start ndi-tx.service
```

### サイネージ
起動後、wi-fiの設定、NASの資格情報の入力を行います。  
```bash
sudo nmtui
vim .smbcredentials
```
NASのIPアドレスを変更するには、ホームディレクトリの `kiosk-start.sh` を編集します。
```bash
vim kiosk-start.sh
```
サイネージを起動するには、ホームディレクトリの `kiosk-start.sh` を実行します。
```bash
./kiosk-start.sh
```
自動起動を設定するには、`.bashrc` に以下の行を追加します。
```bash
exec ~/kiosk-start.sh
```
ワンライナーで追記するには、`echo "exec ~/kiosk-start.sh" >> ~/.bashrc` を実行します。

## ビルド方法
Debian環境で`live-build`をインストールします。
```bash
sudo apt install live-build
```
このリポジトリをクローンし、`work/config`内を編集します。
```bash
git clone https://github.com/TechnoTUT/utone-linux.git
cd utone-linux/work
```
isoイメージをビルドします。
```bash
lb config --distribution 'bookworm' --archive-areas 'main non-free non-free-firmware contrib' --bootappend-live 'boot=live components splash persistence' --image-name 'technotut-utone-live'
sudo lb build
```
ビルドが完了すると、`technotut-utone-live-amd64.hybrid.iso`が生成されます。  
ビルドをやり直す場合は、`sudo lb clean`を実行してから再度ビルドを行います。