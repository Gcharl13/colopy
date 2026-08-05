#!/bin/bash
# boot.sh "<dos command>" -- restart Xvfb+DOSBox and run one DOS command line.
SB="$(cd "$(dirname "$0")" && pwd)"
CMD="${1:-}"
DISP=:77

pkill -f "dosbox -conf $SB/dosbox.conf" 2>/dev/null
pkill -f "Xvfb $DISP" 2>/dev/null
pkill -f "twm -f" 2>/dev/null
sleep 1

cat > "$SB/dosbox.conf" <<EOF
[sdl]
fullscreen=false
output=surface
windowresolution=original
autolock=false
[render]
aspect=false
scaler=none
[cpu]
core=dynamic
cycles=${CYCLES:-60000}
[mixer]
nosound=true
rate=22050
[sblaster]
sbtype=sb16
sbbase=220
irq=7
dma=1
[gus]
gus=false
[speaker]
pcspeaker=false
[dosbox]
machine=vga
captures=$SB/cap
memsize=16
[autoexec]
mount c $SB/game
c:
cls
$CMD
EOF

export DISPLAY=$DISP
Xvfb $DISP -screen 0 1280x1024x24 -nolisten tcp >/dev/null 2>&1 &
sleep 2
twm -f "$SB/twmrc" >/dev/null 2>&1 &
sleep 1
SDL_AUDIODRIVER=dummy SDL_VIDEODRIVER=x11 dosbox -conf "$SB/dosbox.conf" >"$SB/dosbox.log" 2>&1 &
sleep "${WAIT:-10}"
echo "booted: $CMD"
