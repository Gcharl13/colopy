# On-Disk File Formats — Index

> **Layer 2 — Data Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.

**Canonical primary:** the per-format specs in `formats/` (committed) and `viceroy_source/formats/` (decode-notes, secondary pointer). This stub is a one-line index pointing to each format's own spec; read those for byte layouts.

## 1. Summary

The original *Colonization* data directory uses a handful of MicroProse/MADS container formats plus the DOS executable. Each on-disk file type has its own spec under `formats/`; several have parallel decode-notes under `viceroy_source/formats/` (secondary — pointers only). Per CLAUDE.md hard rule 5 (amended 2026-06-22), `TERRAIN.SS` is the base-ground sheet (composited under PHYS0 overlays); only `BDARK.SS` is an orphan sprite sheet that must never be loaded.

## 2. Contents

| Ext / type | One-line description | Primary spec |
|------------|----------------------|--------------|
| `.MP` | Map file — terrain grid, sea-lane column, auto-forest encoding | `formats/MP_FORMAT.md` (+ `viceroy_source/formats/MP.md`) |
| `.SS` | MADS sprite sheet (frames; PHYS0.SS terrain, ICONS, units) | `formats/SS.md` (+ `viceroy_source/formats/SS.md`) |
| `.PAL` | VGA palette file | `formats/PAL.md` (+ `viceroy_source/formats/PAL.md`) |
| `.PIK` | MADS packed 320×200 background image | `formats/PIK.md` (+ `viceroy_source/formats/PIK.md`) |
| `.FF` | MADS bitmap font | `formats/FF.md` (+ `viceroy_source/formats/FF.md`) |
| `.COL` | Sound configuration | `formats/COL.md` (+ `viceroy_source/formats/COL.md`) |
| `.MOV` | MicroProse cinematic script | `formats/MOV.md` (+ `viceroy_source/formats/MOV.md`) |
| `.BIN` | Audio sample bank | `formats/BIN.md` (+ `viceroy_source/formats/BIN.md`) |
| `.DAT` | Misc binary data | `formats/DAT.md` (+ `viceroy_source/formats/DAT.md`) |
| `.TXT` | Section-based text data (`@KEY`) — NAMES/GAME/LABELS/PEDIA/MENU | `formats/TXT.md` (+ `viceroy_source/formats/TXT.md`) |
| EXE / MZ | DOS MZ executable header (VICEROY.EXE) | `formats/EXE_MZ.md` |
| RTLINK | Pocket Soft RTLink Plus overlay scheme | `formats/RTLINK.md` |
| `.GIF` | (extraction-side image format) | `formats/GIF.md` (+ `viceroy_source/formats/GIF.md`) |
| MADSPACK | (MADS pack container — decode-note only) | `viceroy_source/formats/MADSPACK.md` |
| `.PCX` | (decode-note only) | `viceroy_source/formats/PCX.md` |

## 3. Evidence

- `formats/*.md` — committed per-format specs (titles confirmed 2026-06-18). **B/A** (per each spec's own tier).
- `viceroy_source/formats/*.md` — parallel decode-notes; **SECONDARY**, pointers only.
- CLAUDE.md hard rules 2/4/5 — `.MP` sea-lane & terrain, `.SS` orphan sheets / skip indices 0,16,100.

## 4. Open questions (TBD)

1. Per-format confidence tiers vary — see each spec; not all byte-verified.
2. `viceroy_source/formats/` notes may diverge from `formats/`; on conflict primary (`formats/`) + bytes win (Remove-bad-data).
3. RTLINK overlay segment map vs `formats/EXE_MZ.md` linkage — completeness TBD.
