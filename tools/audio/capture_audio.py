#!/usr/bin/env python3
"""Per-id audio capture from the real game — the audio milestone's render step.

Boots `VICEROY -g` under the DOSBox harness with AUDIO=1 (un-muted emulated
SB16, 44100 Hz WAV capture), loads COLONY00.SAV, sets Sound Options to
Background Music OFF / Event Music ON / Sound Effects ON (so the rotation
scheduler stays quiet but the Sound Test's gated play passes), enables the
cheat menu (Alt+W, Alt+I, Alt+N), then for each requested id:

    CHEAT > Sound Test > "Play what sound #?" > <decimal id> > Enter

with DOSBox's Ctrl-F6 WAV capture running. The capture ends when the mixer
output has been silent for SILENCE_HOLD seconds after signal was seen (the
driver queues rather than preempts, so waiting for silence keeps one id per
file), or at a per-class cap. Output: captures/<class>_<hexid>.wav plus a
running captures_manifest.json.

Provenance: everything this produces is **empirical capture** tier (RULINGS
2026-08-16) — the real `?SOUND.COL` driver selected by the stock CONFIG.COL,
running under DOSBox 0.74's SB16/OPL emulation. Nothing here is byte-cited.

Usage (from tools/audio/):
    python3 capture_audio.py --set sfx          # ids 0x40..0x5F
    python3 capture_audio.py --set tunes        # 0x20..0x3B, 0x3E, 0x3F
    python3 capture_audio.py --set fanfares     # 0x8020..0x8027, 0x8024 family
    python3 capture_audio.py --ids 0x54 0x20    # explicit list
    --no-boot reuses an already-prepared session (skips boot+setup),
    --resume skips ids whose .wav already exists.
"""
import argparse
import json
import os
import struct
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
HARNESS = HERE.parent / "dosbox_harness"
sys.path.insert(0, str(HARNESS))
import drive  # noqa: E402

CAPTURES = HERE / "captures"
MANIFEST = HERE / "captures_manifest.json"

WAV_HDR = 44          # DOSBox writes a plain 44-byte canonical header
BYTES_PER_SEC = 44100 * 2 * 2   # stereo s16 @ 44100
SILENT_PEAK = 60      # |s16| below this = silence (observed floor: 0..6)
SIGNAL_PEAK = 300     # first sample block above this = "the id is sounding"
SILENCE_HOLD = 3.0    # seconds of silence after signal = capture done
NO_SIGNAL_GIVEUP = 15.0

# Menu geometry (320x200 logical coords, measured live 2026-08-17;
# see shots a04..a16 methodology in tools/audio/README.md)
CHEAT_MENU_XY = (192, 3)
SOUND_TEST_XY = (240, 88)
SOUNDOPT_BG_ROW_XY = (110, 97)


def sh(cmd, **kw):
    return subprocess.run(cmd, shell=True, text=True, capture_output=True, **kw)


def tail_peak(wav: Path, seconds: float = 0.6) -> int:
    """Peak |sample| of the last `seconds` of a *growing* DOSBox WAV.

    The header's size fields are stale while recording, so read raw PCM from
    the file tail directly (data starts at byte 44, s16le stereo)."""
    size = wav.stat().st_size
    want = int(BYTES_PER_SEC * seconds)
    start = max(WAV_HDR, size - want)
    start += (start - WAV_HDR) % 2  # keep sample alignment
    with open(wav, "rb") as f:
        f.seek(start)
        raw = f.read()
    n = len(raw) // 2
    if n == 0:
        return 0
    samples = struct.unpack(f"<{n}h", raw[: n * 2])
    return max(abs(s) for s in samples)


def new_capture(before: set) -> Path | None:
    for _ in range(20):
        time.sleep(0.15)
        new = set((HARNESS / "cap").glob("*.wav")) - before
        if new:
            return new.pop()
    return None


def boot_and_prepare():
    """Fresh DOSBox to the map view with the capture sound-switch state."""
    print("[boot] DOSBox + VICEROY -g (AUDIO=1) ...")
    env = {**os.environ, "AUDIO": "1", "WAIT": "20"}
    subprocess.run([str(HARNESS / "boot.sh"), "VICEROY -g"], env=env, check=True)
    # main menu -> LOAD Game -> slot 0 -> dismiss "Loaded ... successfully."
    drive.key("Down", times=3, delay=0.5)
    drive.key("Return", delay=2.0)
    drive.key("Return", delay=2.5)
    drive.key("Return", delay=3.0)
    # GAME > Sound Options: Background Music OFF (row click toggles), OK.
    drive.key("alt+g", delay=1.0)
    drive.key("Down", times=2, delay=0.4)
    drive.key("Return", delay=1.5)
    drive.click(*SOUNDOPT_BG_ROW_XY, delay=1.0)
    drive.key("Return", delay=1.2)   # closes dialog; any-off sends driver stop
    # cheat menu on
    drive.key("alt+w", delay=0.4)
    drive.key("alt+i", delay=0.4)
    drive.key("alt+n", delay=0.8)
    shot = drive.shot("capture_session_ready")
    print(f"[boot] session ready (verify CHEAT in menu bar: {shot})")


def capture_one(sound_id: int, max_secs: float, name: str) -> dict:
    """Open Sound Test, play `sound_id`, record until silent-after-signal."""
    drive.click(*CHEAT_MENU_XY, delay=0.9)
    drive.click(*SOUND_TEST_XY, delay=1.1)
    before = set((HARNESS / "cap").glob("*.wav"))
    drive.key("ctrl+F6", delay=0.3)
    wav = new_capture(before)
    if wav is None:
        drive.key("ctrl+F6", delay=0.3)  # try to leave a clean toggle state
        return {"id": sound_id, "error": "no capture file appeared"}
    drive.key("BackSpace", times=6, delay=0.12)
    drive.typ(str(sound_id))
    drive.key("Return", delay=0.4)

    t0 = time.time()
    saw_signal = False
    first_signal = None
    silent_since = None
    while True:
        time.sleep(0.5)
        t = time.time() - t0
        peak = tail_peak(wav)
        if not saw_signal:
            if peak >= SIGNAL_PEAK:
                saw_signal, first_signal = True, t
            elif t > NO_SIGNAL_GIVEUP:
                break
        else:
            if peak < SILENT_PEAK:
                silent_since = silent_since or time.time()
                if time.time() - silent_since >= SILENCE_HOLD:
                    break
            else:
                silent_since = None
        if t > max_secs:
            break
    drive.key("ctrl+F6", delay=0.4)
    time.sleep(0.4)

    dst = CAPTURES / f"{name}.wav"
    dst.parent.mkdir(exist_ok=True)
    wav.rename(dst)
    dur = (dst.stat().st_size - WAV_HDR) / BYTES_PER_SEC
    entry = {
        "id": sound_id,
        "file": dst.name,
        "duration_s": round(dur, 2),
        "signal": saw_signal,
        "first_signal_s": round(first_signal, 2) if first_signal else None,
        "provenance": "empirical capture: stock CONFIG.COL driver under "
                      "DOSBox 0.74 sb16 (OPL+DSP), Sound Test cheat, "
                      "44100 Hz WAV mixer capture",
    }
    print(f"[cap] id 0x{sound_id:X} -> {dst.name}  {dur:.1f}s  "
          f"signal={'yes @%.1fs' % first_signal if saw_signal else 'NO'}")
    return entry


SETS = {
    "sfx": ([*range(0x40, 0x60)], 45.0, "sfx"),
    "tunes": ([*range(0x20, 0x3C), 0x3E, 0x3F], 240.0, "tune"),
    "fanfares": ([0x8020, 0x8021, 0x8022, 0x8023, 0x8024, 0x8025, 0x8026,
                  0x8027], 45.0, "fanfare"),
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--set", choices=SETS, dest="which")
    ap.add_argument("--ids", nargs="*", type=lambda s: int(s, 0))
    ap.add_argument("--max-secs", type=float)
    ap.add_argument("--no-boot", action="store_true")
    ap.add_argument("--resume", action="store_true")
    args = ap.parse_args()

    if args.which:
        ids, max_secs, prefix = SETS[args.which]
    elif args.ids:
        ids, max_secs, prefix = args.ids, args.max_secs or 240.0, "id"
    else:
        ap.error("need --set or --ids")
    if args.max_secs:
        max_secs = args.max_secs

    if not args.no_boot:
        boot_and_prepare()

    manifest = json.loads(MANIFEST.read_text()) if MANIFEST.exists() else {}
    no_signal_streak = 0
    for sound_id in ids:
        name = f"{prefix}_{sound_id:x}"
        if args.resume and (CAPTURES / f"{name}.wav").exists():
            print(f"[skip] {name}.wav exists")
            continue
        entry = capture_one(sound_id, max_secs, name)
        manifest[f"0x{sound_id:X}"] = entry
        MANIFEST.write_text(json.dumps(manifest, indent=1, sort_keys=True))
        if entry.get("signal"):
            no_signal_streak = 0
        else:
            no_signal_streak += 1
            if no_signal_streak >= 4:
                drive.shot(f"capture_stuck_0x{sound_id:x}")
                print("[abort] 4 consecutive silent ids -- automation "
                      "probably lost the menu; screenshot saved")
                sys.exit(2)
    print("[done]", len(ids), "ids attempted")


if __name__ == "__main__":
    main()
