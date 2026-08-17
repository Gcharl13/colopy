# tools/audio — the audio milestone's capture + pack pipeline

Everything here is **empirical-capture tier** (`notes/rulings/RULINGS.md`
2026-08-16): measured from the real game's `?SOUND.COL` driver running under
DOSBox, never byte-cited. Design doc: `docs/AUDIO_PORT.md`.

## Pipeline

    bin/reconstitute.py                      # col.zip -> raw/COLONIZE/
    (once) unzip col.zip into tools/dosbox_harness/game/   # harness README
    apt-get install -y dosbox xvfb xdotool twm

    python3 capture_audio.py --set sfx       # ids 0x40..0x5F  (~15 min)
    python3 capture_audio.py --set tunes     # 0x20..0x3B,0x3E,0x3F (~1.5 h)
    python3 capture_audio.py --set fanfares  # 0x8020.. best-effort
    python3 trim_masters.py                  # -> captures/masters/ + manifest
    python3 ../gen_audio_pack.py             # -> cport/pak/COLAUDIO.PAK + header

`captures/` is git-ignored (regenerable); the committed artifacts are this
directory's manifests, which make the regeneration auditable.

`map_coldig.py` (chunked cross-correlation of the SFX captures against
COLDIG.BIN) is **no longer part of the pipeline**: the SFX id→slice map now
comes from `data_extracted/coldig_index.json`, decoded straight out of the
sound drivers by `tools/decode_coldig.py`. Its output
`data_extracted/data/coldig_slices.json` is kept as a record of the capture
work but is read by nothing — it disagreed with the drivers on every shared
id. See `docs/AUDIO_PORT.md` and `formats/BIN.md`.

## How the capture works (measured live 2026-08-17)

- `boot.sh` gained an opt-in `AUDIO=1` block: `nosound=false`, `rate=44100`,
  SDL audio still on the dummy driver. DOSBox's Ctrl-F6 mixer WAV capture
  records fine in that state (verified: OPL music present in a 12 s probe).
- Session prep: main menu → LOAD Game → slot 0 (`COLONY00.SAV`) → GAME >
  Sound Options → **Background Music OFF** (rotation scheduler stays quiet;
  Event Music stays ON, which is the gate Sound-Test tunes pass — spec
  §options_dialogs) → cheat menu on with **Alt+W, Alt+I, Alt+N**.
- Per id: CHEAT (click 192,3) → Sound Test (click 240,88) → DEBUG `@SOUND`
  "Play what sound #?" → decimal id → Enter.
- The driver **queues** a play request while something is sounding (observed:
  a tune waited out a long piece), so the capture loop waits for
  silence-after-signal (3 s hold, polling the growing WAV's raw tail) before
  moving on — one id per file.
- Menu geometry constants live at the top of `capture_audio.py`; verify with
  `drive.shot()` against `docs/screens/live_2026-08-05/` if the layout ever
  looks different.

## Files

| file | role |
|---|---|
| `capture_audio.py` | boot/prepare + per-id Sound-Test capture loop |
| `map_coldig.py` | cross-correlate SFX captures against `COLDIG.BIN` → slice table |
| `trim_masters.py` | tune/fanfare captures → trimmed 22050 mono masters |
| `ima_adpcm.py` | the pack's music codec (self-contained 1024-sample blocks); `python3 ima_adpcm.py` self-tests |
| `verify_pack.py` | objective pack report: slice bit-identity + per-render SNR vs master (12 dB regression floor) |
| `captures_manifest.json` | per-id capture log (duration, first-signal, provenance) |
| `masters_manifest.json` | per-master trim log |

## Honesty notes

- SFX **payloads** in the pack are verbatim `COLDIG.BIN` slices (sha256-
  checked against the slice table); only the id→slice mapping is empirical.
- Tune renders are DOSBox's OPL emulation of the real driver — authentic
  hardware family, but an emulator render, and tune lengths/loop behaviour
  are capture-derived.
- Which driver letter the stock `CONFIG.COL` selects is not byte-decoded;
  the capture manifest records the observed stack (OPL music + DSP samples
  under `sbtype=sb16`). See `formats/COL.md` §"What is still sealed".
