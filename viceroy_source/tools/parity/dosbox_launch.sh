#!/usr/bin/env bash
# Persistent headless DOSBox-X session for VICEROY parity capture.
export DISPLAY=:99
pkill -f dosbox-x 2>/dev/null || true
pkill Xvfb 2>/dev/null || true
sleep 1
Xvfb :99 -screen 0 1024x768x24 >/tmp/xvfb.log 2>&1 &
sleep 2
cd /home/user/dosparity
exec dosbox-x -conf viceroy.conf -nomenu >/home/user/dosparity/run.log 2>&1
