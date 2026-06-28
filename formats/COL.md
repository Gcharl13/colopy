# .COL — Sound Configuration

Sound device configuration files. Each .COL holds a list of (sound_id,
file_offset_into_COLDIG, size) triples for a specific audio output
device. The game picks one .COL based on the user's sound-device
selection at install time.

**5 .COL files in COLONIZE/**:

| File | Audio device |
|------|--------------|
| `ASOUND.COL` | Adlib (FM synthesis) |
| `GSOUND.COL` | GameBlaster / SoundBlaster |
| `PSOUND.COL` | PC speaker |
| `RSOUND.COL` | Roland MT-32 |
| `CONFIG.COL` | Generic / per-device selection |

---

## Layout

The exact byte layout is TBD (Phase D — find via PUSH "ASOUND.COL"
type sites in startup code). Indication from file sizes (~38KB each
across 5 files = 190KB total) is that each file contains MIDI tracks
or device-specific sequencer commands per sound effect.

For PSOUND.COL the data is likely just frequency/duration pairs.
For ASOUND.COL it's Adlib OPL register sequences. For GSOUND.COL it's
SoundBlaster commands. For RSOUND.COL it's MIDI bytes.

---

## Round-trip

Byte-identity (verified via `tools/verify.py`).

---

## Loader in VICEROY.EXE

The sound-init function reads CONFIG.COL to determine the active device,
then loads the appropriate `?SOUND.COL` into a sound-bank buffer.

Loader function: TBD (Phase D).
