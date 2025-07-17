# ndi-receiver-live
このリポジトリは、[ndi-receiver](https://github.com/TechnoTUT/ndi-receiver)を自動実行するDebian Live環境を管理します。
## 使い方
[Release](https://github.com/TechnoTUT/ndi-receiver-live/releases)からイメージをダウンロードし、DVDまたはUSBメモリに書き込みます。  
USBメモリに書き込む場合は、[Rufus](https://rufus.ie/)等のツールを使用します。  

完成したDVDまたはUSBメモリをPCに挿入し、電源を投入すると自動でLive環境が起動し PC "Yummy" からのNDI信号を受信します。

## 接続先の変更方法
sshログインを行います。ユーザ名は `user`、パスワードは `live` です。
ホームディレクトリの `ndi-recv-start.sh` を編集し、サービスを再起動します。
```bash
vim ~/ndi-recv-start.sh
systemctl --user restart ndi-receiver.service
```

## デフォルトの接続先の変更方法
Debian環境で`live-build`をインストールします。
```bash
sudo apt install live-build
```
このリポジトリをクローンし、`work/config/includes.chroot_after_packages/etc/skel/ndi-recv-start.sh`の引数 `-s`を編集します。
```bash
git clone https://github.com/TechnoTUT/ndi-receiver-live.git
cd ndi-receiver-live/work
vim config/includes.chroot_after_packages/etc/skel/ndi-recv-start.sh
```
isoイメージをビルドします。
```bash
lb config --distribution 'bookworm' --archive-areas 'main non-free non-free-firmware contrib' --bootappend-live 'boot=live components keyboard-layouts=jp splash'
sudo lb build
```
ビルドが完了すると、`live-image-amd64.hybrid.iso`が生成されます。  
ビルドをやり直す場合は、`sudo lb clean`を実行してから再度ビルドを行います。