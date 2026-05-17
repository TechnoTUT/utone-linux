#!/bin/bash

if ! mountpoint -q "$HOME/nas"; then
  mkdir -p "$HOME/nas"
  sudo mount -t cifs -o credentials=$HOME/.smbcredentials '\\192.168.1.100\share\signage' "$HOME/nas"
fi

rm -rf "$HOME/tmp"
mkdir -p "$HOME/tmp"
cp -r "$HOME/nas" "$HOME/tmp/"

/usr/bin/vlc --fullscreen --image-duration=10 --repeat --no-video-title-show --no-osd --no-audio --extraintf http --http-password=password $HOME/tmp/nas/*