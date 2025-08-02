#!/bin/bash

if ! mountpoint -q "$HOME/nas"; then
  mkdir -p "$HOME/nas"
  sudo mount -t cifs -o credentials=$HOME/.smbcredentials '\\10.1.70.0\share\signage' "$HOME/nas"
fi

rm -rf "$HOME/tmp"
mkdir -p "$HOME/tmp"
cp -r "$HOME/nas" "$HOME/tmp/"

/usr/bin/vlc --fullscreen --image-duration=10 --repeat --no-video-title-show --no-osd --no-audio --extraintf http --http-password=password $HOME/tmp/nas/*