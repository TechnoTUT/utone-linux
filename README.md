# ndi-receiver-live
このリポジトリは、[ndi-receiver](https://github.com/TechnoTUT/ndi-receiver)を実行するDebian Live環境を管理します。
## 使い方
[Release](https://github.com/TechnoTUT/ndi-receiver-live/releases)からイメージをダウンロードし、DVDまたはUSBメモリに書き込みます。  
USBメモリに書き込む場合は、[Rufus](https://rufus.ie/)等のツールを使用します。  

完成したDVDまたはUSBメモリをPCに挿入し、電源を投入するとLive環境が起動します。
`systemctl --user start ndi-receiver.service` を実行すると、PC "Yummy" からのNDI信号を受信します。

## 接続先の変更方法
ホームディレクトリの `ndi-recv-start.sh` を編集し、サービスを起動します。
```bash
vim ~/ndi-recv-start.sh
systemctl --user start ndi-receiver.service
```

## ビルド方法
Debian環境で`live-build`をインストールします。
```bash
sudo apt install live-build
```
このリポジトリをクローンし、`work/config`内を編集します。
```bash
git clone https://github.com/TechnoTUT/ndi-receiver-live.git
cd ndi-receiver-live/work
```
isoイメージをビルドします。
```bash
lb config --distribution 'bookworm' --archive-areas 'main non-free non-free-firmware contrib' --bootappend-live 'boot=live components keyboard-layouts=jp splash'
sudo lb build
```
ビルドが完了すると、`live-image-amd64.hybrid.iso`が生成されます。  
ビルドをやり直す場合は、`sudo lb clean`を実行してから再度ビルドを行います。