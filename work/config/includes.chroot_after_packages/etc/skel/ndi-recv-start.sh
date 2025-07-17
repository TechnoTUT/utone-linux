#!/bin/bash
# venv activation
source /opt/ndi-receiver/venv/bin/activate
exec python3 /opt/ndi-receiver/recv_sdl2.py -s "Yummy (PROD)" --fullscreen