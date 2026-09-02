#!/usr/bin/env python3
"""Drive the real Colonization under DOSBox headlessly and capture screens.

Xvfb gives us a display and xdotool sends input, but frames are grabbed with
DOSBox's own Ctrl-F5 screenshot, which dumps the *emulated* 320x200 framebuffer
straight to PNG -- no X compositing, no scaling, no aspect correction. That is
exactly the geometry port/_shots/*.png use, so the two are directly comparable.

Note: the game will not start without an emulated Sound Blaster. CONFIG.COL
selects SB at port 0x220 / IRQ 7, and with sbtype=none the opening hangs on a
black screen forever. `nosound=true` + SDL_AUDIODRIVER=dummy keeps it silent
without removing the card.
"""
import os
import shutil
import subprocess
import time
from pathlib import Path

SB = Path(__file__).resolve().parent
CAP = SB / "cap"
SHOTS = SB / "shots"
DISPLAY = ":77"
ENV = {**os.environ, "DISPLAY": DISPLAY}


def sh(cmd):
    return subprocess.run(cmd, shell=True, capture_output=True, text=True, env=ENV)


def wid():
    out = sh("xdotool search --name 'DOSBox'").stdout.split()
    return out[0] if out else None


def program():
    """The DOS program DOSBox says is running (from the window title)."""
    t = sh(f"xdotool getwindowname {wid()}").stdout
    return t.split("Program:")[-1].strip() if "Program:" in t else "?"


def key(k, times=1, delay=0.4):
    w = wid()
    for _ in range(times):
        sh(f"xdotool key --window {w} --clearmodifiers {k}")
        time.sleep(delay)


def typ(text, delay=0.06):
    sh(f"xdotool type --window {wid()} --delay {int(delay*1000)} -- '{text}'")


def click(x, y, delay=0.6):
    """Click at logical 320x200 coordinates."""
    g = sh(f"xdotool getwindowgeometry --shell {wid()}").stdout
    d = dict(l.split("=", 1) for l in g.strip().splitlines() if "=" in l)
    wx, wy = int(d["X"]), int(d["Y"])
    ww, wh = int(d["WIDTH"]), int(d["HEIGHT"])
    sx, sy = wx + int(x * ww / 320), wy + int(y * wh / 200)
    sh(f"xdotool mousemove {sx} {sy}")
    time.sleep(0.3)
    # Press and release must straddle several emulated frames -- a single
    # xdotool `click` puts both edges in one tick and the DOS INT 33h polling
    # loop never observes the button down.
    sh("xdotool mousedown 1")
    time.sleep(0.35)
    sh("xdotool mouseup 1")
    time.sleep(delay)


def park(delay=0.5):
    """Park the emulated pointer in the game's bottom-right corner.

    With autolock=false DOSBox maps the X pointer's position INSIDE its
    window onto the 320x200 mode-13h surface and stops updating once the
    pointer leaves it, so the last in-window position is where the DOS
    arrow stays. Moving to the window's last pixel puts the arrow's hotspot
    at (319,199): the 16x16 arrow hangs off the right and bottom edges and
    at most its tip is visible. Every census baseline before 2026-09-02 was
    taken with the pointer at its boot position (158..172, 98..116) -- ~82
    px of arrow on every screen, the ledger's C4.19 floor. Call before
    shot(); a MOVE is not a click, and the game has no hover effects on
    the screens the census captures.
    """
    g = sh(f"xdotool getwindowgeometry --shell {wid()}").stdout
    d = dict(l.split("=", 1) for l in g.strip().splitlines() if "=" in l)
    wx, wy = int(d["X"]), int(d["Y"])
    ww, wh = int(d["WIDTH"]), int(d["HEIGHT"])
    sh(f"xdotool mousemove {wx + ww - 1} {wy + wh - 1}")
    time.sleep(delay)


def unpark(delay=0.5):
    """Return the pointer to the window centre -- the boot position every
    pre-2026-09-02 capture was taken at. Only the SHOT wants the pointer
    parked: with it left in the corner the map's Escape -> "Exit to DOS?"
    -> Escape round-trip that capture() uses to re-enter every screen
    stopped cancelling the dialog (the 2026-09-02 first pass filed the
    dialog as F5 and the DOS prompt as COLONY), so the key sequences run
    with the pointer where they were always driven."""
    g = sh(f"xdotool getwindowgeometry --shell {wid()}").stdout
    d = dict(l.split("=", 1) for l in g.strip().splitlines() if "=" in l)
    wx, wy = int(d["X"]), int(d["Y"])
    ww, wh = int(d["WIDTH"]), int(d["HEIGHT"])
    sh(f"xdotool mousemove {wx + ww // 2} {wy + wh // 2}")
    time.sleep(delay)


def _existing():
    return set(CAP.glob("*.png"))


def shot(name, settle=0.8):
    """Ctrl-F5 the emulated framebuffer and file it under shots/<name>.png."""
    SHOTS.mkdir(exist_ok=True)
    time.sleep(settle)
    before = _existing()
    key("ctrl+F5", delay=0.1)
    for _ in range(30):
        time.sleep(0.2)
        new = _existing() - before
        if new:
            src = new.pop()
            dst = SHOTS / f"{name}.png"
            shutil.move(str(src), dst)
            return dst
    return None


def wait(s):
    time.sleep(s)
