# COL Format — Sound Driver / Config Table

## File inventory
5 .COL files in COLONIZE/:
- `ASOUND.COL` — AdLib (Sound Blaster FM) driver config
- `GSOUND.COL` — General MIDI driver config
- `PSOUND.COL` — PC speaker driver config
- `RSOUND.COL` — Roland MT-32 driver config
- `CONFIG.COL` (20 bytes) — runtime config (graphics mode, sound choice, etc.)

## Format (ASOUND.COL / GSOUND.COL / PSOUND.COL / RSOUND.COL)

Sound-driver descriptor. Maps logical sound IDs to driver-specific
output (FM register settings for AdLib, MIDI program numbers for GM,
beeper duty cycles for PC speaker, MT-32 timbre IDs for Roland).

The exact format varies per driver. Each is selected at game start
based on the user's sound config (CONFIG.COL).

## Format (CONFIG.COL)

20 bytes. Stores user runtime preferences:
- Graphics mode flag (mode 13h vs others)
- Sound driver selection (which of A/G/P/R)
- Audio cue level (none / minimal / full)
- Music on/off
- (more flags TBD)

## Loader

DOS-side: read at game startup. The CONFIG.COL contents are stored
in DGROUP globals that drive runtime behaviour. The selected driver
COL is loaded by the sound init code.

## Citations

- @asm_file  TBD (sound-init in overlay; config-load in load_image)
              of "AdLib/Sound Blaster via ASOUND.COL/GSOUND.COL/...")
- @rule      The four sound drivers are mutually exclusive at runtime;
             only ONE COL is consulted per session.
