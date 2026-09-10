# DOSBox harness — running the real game headlessly

Boots Colonization under DOSBox on a headless Xvfb display, sends input with
xdotool, and captures frames with DOSBox's own Ctrl-F5 dump (the emulated
320x200 framebuffer — no X compositing, no scaling, no aspect correction, so
output is directly comparable to `port/_shots/*.png`).

    apt-get install -y dosbox xvfb xdotool scrot twm
    python3 -c "import zipfile,os; z=zipfile.ZipFile('col.zip'); \
      [open(os.path.join('game',os.path.basename(m)),'wb').write(z.read(m)) \
       for m in z.namelist() if not m.startswith('__MACOSX') and not m.endswith('/')]"
    WAIT=18 ./boot.sh "VICEROY -g"      # straight to the main menu
    python3 -c "import drive; print(drive.shot('frame'))"

## Two things that will waste your afternoon otherwise

**The game does not start without an emulated Sound Blaster.** `CONFIG.COL`
selects SB at port 0x220 / IRQ 7. With `sbtype=none` the boot path hangs on a
black screen in mode 13h — no error, no exit, forever. `boot.sh` sets
`sbtype=sb16` with `nosound=true` and `SDL_AUDIODRIVER=dummy`, which runs it
silently.

**Mouse clicks need press and release in different emulated frames.** A single
`xdotool click` puts both edges in one tick and the DOS INT 33h polling loop
never observes the button down: motion tracks fine, nothing responds.
`drive.click()` splits them. A window manager must also be running — bare Xvfb
gives SDL no input focus, so `twm` is started by `boot.sh`.

`VICEROY -g` skips `OPENING.EXE`, whose map-pan cinematic runs for minutes.
Escape quits the game rather than skipping the intro.

See `docs/LIVE_UI_CHECK_2026-08-05.md` for what a run of this found.

## The world capture oracle (2026-09-10)

`tools/dos_world_capture.py PREFIX` reads the emulated RAM of the running
DOSBox (the anonymous 33.7 MB mapping that holds the `UNIT\0ORDERS\0ACTIONS`
section-name table; DGROUP's live segment is found by aligning the terrain
plane's Arctic/Sea-Lane border) and files a fresh game's four map planes,
the builder's salt `[0x190]`, the five Customize words, the settlement,
unit, tribe and AIPersonality records.  `tools/dos_world_oracle.py PREFIX`
then asks whether the port builds the SAME world: VICEROY reseeds its LCG
from a 15-bit clock word right before the builder (`srand` @0x075793) and
again at the natives placer (@0x065D2F), so the builder's seed is pinned by
the salt (its first draw) and the natives' seed by a 32768-candidate search
against the settlement records.  Drive to the map with the recipe in
`drive_game.sh` (NEW WORLD: `Return`, the difficulty `Down`s, `Return` x5,
then `space` until the menu-bar signature shows) and capture BEFORE ending a
turn -- braves and the AI's ships move the moment a turn passes.

