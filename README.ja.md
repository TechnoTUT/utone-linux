# utone-linux

[English](README.md) | 日本語

このリポジトリは、学内DJイベント "The Utopia Tone" のエッジデバイスを容易に動作させるためのDebian Live環境を提供します。[moip-toolkit](https://github.com/TechnoTUT/moip-toolkit)(NDI送受信とデジタルサイネージ)を含みます。  

## 使い方
[Releases](https://github.com/TechnoTUT/utone-linux/releases)からイメージをダウンロードし、DVDまたはUSBメモリに書き込みます。USBメモリに書き込む場合は、[Rufus](https://rufus.ie/)等のツールを使用します。  
再起動しても設定が保持されるようにするには、Rufusの設定で保存領域のサイズを指定します。1GB程度で十分です。NDI送信やサイネージの設定を行う場合には、保存領域の設定を推奨します。

完成したDVDまたはUSBメモリをPCに挿入し、電源を投入するとLive環境が起動します。

### NDI受信
NDI信号を受信するには、以下のコマンドを実行します:  
```bash
nrx
```

接続先を設定して自動起動を有効にするには、ホームディレクトリの `.config/systemd/user/ndi-rx.service` を編集します: 

```bash
vim ~/.config/systemd/user/ndi-rx.service
systemctl --user enable --now ndi-rx.service
```

`ndi-rx.service` は初期設定で `kmsdrm` ビデオドライバを使用し、デスクトップのコンポジタを経由せずにディスプレイへ直接出力して遅延を最小にします。デスクトップのコンポジタを使う場合は、`ExecStart` から `--video-driver kmsdrm` を削除します。手動でkmsdrmを使って実行するには:  
```bash
uv run /opt/moip-toolkit/main.py rx -s "<NDIソース名>" --video-driver kmsdrm
```
- 対象のディスプレイでデスクトップセッションが動作していない必要があります(コンソール / TTY の状態)。`sudo systemctl set-default multi-user.target` でGUIなしで起動するようになります。
- ユーザーを `video` と `input` グループに追加します: `sudo usermod -aG video,input $USER`
- 出力は常に全画面になります。

### NDI送信
キャプチャーボードからNDI信号を送信するには、以下のコマンドを実行します:  
```bash
ntx
```
NDI信号を `<HOSTNAME> (TX)` として送信します。

送信名や解像度、フレームレートなどの引数を変更し自動起動を有効にする場合は、ホームディレクトリの `.config/systemd/user/ndi-tx.service` を編集し、サービスを起動します。引数の一覧は、`ntx --help`で確認できます。  
```bash
vim ~/.config/systemd/user/ndi-tx.service
systemctl --user enable --now ndi-tx.service
```
初期設定のホスト名は `debian` です。ホスト名を変更するには、`sudo hostnamectl set-hostname <新しいホスト名>` と入力します。

### サイネージ
サイネージ機能は moip-toolkit が提供します。Web UIのサービスを起動し、ブラウザから画像をアップロードすると、接続されたディスプレイに全画面で表示されます。  
```bash
systemctl --user enable --now ndi-web.service
```
ブラウザで `http://<IPアドレス>:8000/` を開きます(IPアドレスはログイン時に表示されます)。再起動後も設定を保持するには、保存領域を使用します。  

コマンドラインから直接画像を表示することもできます。  
```bash
/opt/moip-toolkit/.venv/bin/python /opt/moip-toolkit/main.py signage -i /path/to/image.png --fullscreen
```
`-i` を省略すると、Web UIから最後にアップロードした画像が表示されます。GUIのないコンソール(TTY)では、`--framebuffer` を付けるとLinuxフレームバッファに直接描画します(root権限が必要な場合があります)。  
詳細は [moip-toolkit の README](https://github.com/TechnoTUT/moip-toolkit) を参照してください。

## ビルド方法
### Dev Containerを使用する場合 (推奨)
VS Code と Dev Containers 拡張機能を使用することで、ホスト環境を汚さずにビルド環境を構築できます（Docker または Podman が必要です）。

1. VS Code でこのリポジトリを開きます。
2. ポップアップまたはコマンドパレットからコンテナ内で再度開きます。
3. コンテナ内ターミナルで以下を実行します:
   ```bash
   make build
   ```
   クリーンアップする場合:
   ```bash
   make clean
   ```

### 通常のDebian / WSL2環境を使用する場合
ビルドにはDebian環境が必要です。Windowsを使用している場合は、WSL2を利用することで簡単にDebian環境を構築できます。  
```pwsh
wsl --update
wsl --list --online
wsl --install -d Debian
```

Debian環境で`live-build`と`make`をインストールします。
```bash
sudo apt update
sudo apt install live-build make
```
このリポジトリを`--recursive`オプションを付けてクローンします。
```bash
git clone https://github.com/TechnoTUT/utone-linux.git --recursive
cd utone-linux
```
`make` を使って ISO イメージをビルドします。
```bash
make build
```
ビルドが完了すると、`work` ディレクトリ内に `utone-linux-amd64.hybrid.iso` が生成されます。  
ビルドをやり直す場合やクリーンアップを行う場合は、`make clean` を実行します。
```bash
make clean
```
