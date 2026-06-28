#!/bin/bash
# Interactive driving harness for VICEROY under headless DOSBox (Xvfb + xdotool + scrot).
#
# Companion to tools/runtime_snapshot.py (memory snapshots). This drives the game with
# synthetic keyboard+mouse so you can screenshot any reachable screen and snapshot memory
# at a chosen state. Used 2026-06-25 to visually confirm the byte-documented setup screens
# (docs/screens/) and to runtime-confirm DGROUP findings.
#
# PROVEN INPUT RECIPE (the important part — these specifics matter):
#   * Display: Xvfb :99 -screen 0 1024x768x24 ; DOSBox renders letterboxed, centered.
#   * Keyboard: xdotool key --window <id> Return  (works; e.g. Enter advances menus).
#       !! Escape QUITS Colonization (do not use it to skip cinematics — use Space/click).
#   * Mouse MOTION: use ABSOLUTE coords (xdotool mousemove X Y), NOT --window relative
#       (DOSBox maps absolute screen coords 1:1; window-relative warps land wrong).
#   * Mouse CLICK: an instant `xdotool click 1` is TOO FAST for DOSBox's mouse polling and
#       is dropped. Use windowfocus + mousemove + mousedown + ~0.3s hold + mouseup.
#
# ENV NOTE: in some sandboxes a single long script that backgrounds DOSBox + drives xdotool
# gets killed (exit 144). If so, run the steps as separate short foreground commands (that
# works) — the recipe below is the reference sequence.
#
# Setup once:  Xvfb :99 -screen 0 1024x768x24 &
set -e
export DISPLAY=:99
CONF=${CONF:-db.conf}      # mounts raw/COLONIZE, runs VICEROY.EXE
SDL_AUDIODRIVER=dummy dosbox -conf "$CONF" >dosbox.log 2>&1 &
sleep 14
W=$(xdotool search --class dosbox | tail -1)
key()   { xdotool windowfocus "$W"; xdotool key --window "$W" "$1"; }
click() { xdotool windowfocus "$W"; xdotool mousemove "$1" "$2"; sleep 0.4; \
          xdotool mousedown 1; sleep 0.3; xdotool mouseup 1; }
shot()  { scrot -o "$1"; }

# --- setup flow (New World / England / Explorer), byte-screens confirmed in docs/screens/ ---
shot 01_mainmenu.png;  key Return;        sleep 4   # main menu BEGINMENU -> Start in New World
shot 02_difficulty.png; click 307 350;    sleep 4   # difficulty: "(Click Here When Finished)"
shot 03_nation.png;    click 307 553;     sleep 4   # European power: finished (England default)
shot 04_name.png;      key Return;        sleep 4   # "Please Enter Your Name" -> accept
key Return; sleep 4                                  # nation intro 1
key Return; sleep 4                                  # nation intro 2 (national advantage)
# opening cinematic + arrival: advance with Space/click ONLY (Esc would quit)
for i in $(seq 1 20); do key space; sleep 1; click 512 384; sleep 1; done
shot 99_map.png
echo "done — see *.png; snapshot memory now with tools/runtime_snapshot.py against this dosbox pid"
