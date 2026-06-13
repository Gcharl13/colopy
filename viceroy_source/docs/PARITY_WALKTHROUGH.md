# Running the DOSBox parity capture on your machine — full walkthrough

This is the user-machine half of Phase 7 (the pixel-identical frame matrix and
the live-playthrough determinism compare). The headless half is already green
here (`tools/cert7.py`); this completes the cross-proof against the original
running in DOSBox. Everything below is copy-pasteable.

> **Copyright note:** VICEROY.EXE + the COLONIZE data + your DOSBox captures are
> never committed (gitignored). You supply your own legally-owned game files.

---

## 0. Prerequisites (one-time install)

You need: a C toolchain, CMake ≥3.16, Python 3, DOSBox-X, and (optional, for a
live modern window) SDL2 + ImageMagick.

**Linux (Debian/Ubuntu):**
```bash
sudo apt update
sudo apt install -y build-essential cmake python3 dosbox-x libsdl2-dev imagemagick
```

**macOS (Homebrew):**
```bash
brew install cmake python3 dosbox-x sdl2 imagemagick
```

**Windows:** install DOSBox-X (dosbox-x.com), Python 3, and either WSL2 (then
follow the Linux steps) or MSYS2/MinGW for the build. The DOSBox steps are
identical; use the DOSBox-X GUI for screenshots (Ctrl+F5).

---

## 1. Get the repo and point at your game files

```bash
git clone <this repo>            # or: git checkout claude/beautiful-maxwell-EUu9I
cd colopy/viceroy_source

# Tell the build where your COLONIZE install lives (the dir with
# NAMES.TXT, GAME.TXT, VICEROY.EXE, COLONY00.SAV ...):
export VICEROY_DATA=/path/to/COLONIZE
```

---

## 2. Build the modern binary

```bash
mkdir -p build_modern && cd build_modern
cmake .. && cmake --build . -j4
cd ..
# -> build_modern/viceroy_modern
```
If SDL2 was found you get a **live window** (with F12 screenshot); otherwise the
build is headless and dumps PPM frames — both work for parity.

---

## 3. Sanity check (the headless gates, on your machine)

```bash
VICEROY_DATA=$VICEROY_DATA python3 tools/cert7.py
VICEROY_DATA=$VICEROY_DATA ./build_modern/viceroy_modern --g6
```
Expect `PHASE 7 HEADLESS GATES: ALL PASS` (incl. `10/10 byte-identical` save
cross-parity) and `G6 PASS: boot -> intro -> title -> load -> play`.

---

## 4. Save & determinism parity (7.2 / 7.3) — easiest, fully real

This needs no screenshots — it compares **save bytes**, which is the strongest
parity signal.

**4a. Round-trip your real saves (already byte-exact here):**
```bash
for s in "$VICEROY_DATA"/COLONY*.SAV; do
  ./build_modern/viceroy_modern --roundtrip="$s"
  python3 tools/savediff.py "$s" "$s.rt" && echo "OK $(basename "$s")"
  rm -f "$s.rt"
done
```
`savediff` exit 0 = the modern build read the original's save and re-emitted it
bit-for-bit. (`--allow tools/save_allowlist.json` is optional; omit it to require
exact identity.)

**4b. Determinism:** two same-seed soaks must be byte-identical:
```bash
./build_modern/viceroy_modern --smoke=500 --seed=12345 > A.txt
./build_modern/viceroy_modern --smoke=500 --seed=12345 > B.txt
cmp A.txt B.txt && echo "deterministic"
```

---

## 5. DOSBox setup (for the pixel + live-playthrough half)

A deterministic config ships in `tools/parity/viceroy.conf`. Point it at your
data and a captures dir:

```bash
mkdir -p ~/dosparity/capture
cat > ~/dosparity/viceroy.conf <<EOF
[sdl]
output=surface
[dosbox]
machine=vgaonly
captures=$HOME/dosparity/capture
[cpu]
cycles=fixed 3000
core=normal
[render]
aspect=false
[autoexec]
mount c $VICEROY_DATA
c:
viceroy.exe
EOF
```
`machine=vgaonly` + `cycles=fixed 3000` make DOSBox deterministic frame-for-frame.

**Launch it (with a real display — the easy path):**
```bash
dosbox-x -conf ~/dosparity/viceroy.conf
```
VICEROY boots through OPENING.EXE → the title `@BEGINMENU`. **Screenshot key in
DOSBox-X is `Ctrl+F5`** (writes a PNG into the `captures` dir).

> **Headless (no monitor)?** Use the shipped rig: `tools/parity/dosbox_launch.sh`
> runs `Xvfb :99` + dosbox-x. Navigate blind with `xdotool key --window <id>
> Down Return ...` and grab frames with `import -window root frame.png`. This is
> exactly what the in-container rig does (see `docs/DOSBOX_PARITY.md`).

---

## 6. Pixel parity (7.1) — frame by frame

For each checkpoint screen, capture the **same** view in both builds, then diff.

**6a. Modern frames (320×200 PPM):**
```bash
# title + nations + the colony/map screen frames (headless dump):
VICEROY_DATA=$VICEROY_DATA ./build_modern/viceroy_modern   # writes viceroy_title.ppm, viceroy_nations.ppm, viceroy_map.ppm ...
# intro keyframes {0,50,200,400,600,891}:
VICEROY_DATA=$VICEROY_DATA ./build_modern/viceroy_modern --introrender   # writes /tmp/intro_*.ppm
# with an SDL window, press F12 at any screen -> viceroy_shot<N>.ppm
```

**6b. DOSBox frames:** boot into DOSBox, navigate to the matching screen
(title / nations / a loaded COLONY save / Europe / a report), press **Ctrl+F5**.
The PNG lands in `~/dosparity/capture/`.

**6c. Diff each pair:**
```bash
python3 tools/pixdiff.py viceroy_title.ppm  ~/dosparity/capture/viceroy_000.png
```
`pixdiff` reports IDENTICAL or writes a `*.diff.ppm` highlighting differing
pixels. Target: `pixdiff == 0` on the ~25 checkpoint frames (title, nations,
difficulty, map, colony×3, Europe×2, each report, Congress, naval adviser, Hall
of Fame, king audience, combat dialog, LCR dialog, save/load).

> Palette note: the modern PPM is already RGB via your `VICEROY.PAL`; DOSBox VGA
> mode-13h is 320×200. `pixdiff` decodes both — if a frame differs only by the
> DOSBox border, crop to the 320×200 play area.

---

## 7. The combat / interactive cross-check (the 10 gated stubs)

The 10 interactive `func_` stubs (`docs/g4_interactive_floor.json`) only fire on
player actions. Use save-bytes to spec + verify them:

```bash
# In DOSBox: load a war-era COLONY save, move an attacker onto a defender,
# save pre- and post-combat .SAV into $VICEROY_DATA.
# Modern: replay the same combat from the pre-combat save, then:
python3 tools/savediff.py post_dosbox.SAV post_modern.SAV.rt
```
A clean diff certifies the consequence path; any diff IS the byte-spec for the
remaining interactive entry (the recipe in `docs/DOSBOX_PARITY.md` §"Combat-
economy parity"). Repeat for: a native raid, an LCR pop, a king demand, an FF
election, a war declaration — that walks the full interactive floor.

---

## 8. Final green sheet

```bash
VICEROY_DATA=$VICEROY_DATA python3 tools/cert7.py     # headless gates -> docs/PHASE7_STATUS.md
# plus your pixdiff==0 set (step 6) and savediff==0 set (steps 4,7)
```
When the headless gates are PASS, every checkpoint `pixdiff == 0`, and the
playthrough `savediff == 0`, Phase 7 is fully certified end-to-end against the
original.

---

## Quick reference

| task | command |
|---|---|
| build | `cd build_modern && cmake .. && cmake --build . -j4` |
| headless gates | `python3 tools/cert7.py` |
| boot→play self-test | `./build_modern/viceroy_modern --g6` |
| save round-trip | `./build_modern/viceroy_modern --roundtrip=GAME.SAV` |
| save diff | `python3 tools/savediff.py A.SAV B.SAV` |
| modern frames | `./build_modern/viceroy_modern` / `--introrender` / F12 |
| pixel diff | `python3 tools/pixdiff.py modern.ppm dosbox.png` |
| DOSBox | `dosbox-x -conf ~/dosparity/viceroy.conf` (screenshot: Ctrl+F5) |
| DOSBox headless | `tools/parity/dosbox_launch.sh` + xdotool + `import -window root` |
