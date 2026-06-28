# On-Disk File Formats — Index

> **Layer 2 — Data Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.

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

## 4. Resolution notes (closed)

1. **Per-format confidence tiers vary — by design, not a gap.** Each `formats/*.md` carries
   its own per-field tier (B/A/R); this index does not re-assert a single global tier. Read each
   format's own spec for the byte-level confidence of any field. **Resolved (policy):** the
   per-spec tier IS the authority; every field is tiered in its own sheet.
2. **`viceroy_source/formats/` vs `formats/` divergence — resolved by the truth hierarchy.** On
   any conflict the primary (`formats/`) + the raw bytes win (`notes/TRUTH_HIERARCHY.md`,
   Remove-bad-data). The `viceroy_source/` notes are secondary pointers only (CLAUDE.md path
   convention); they never override a byte-cited primary. **Resolved (policy).**
3. **RTLINK overlay segment→file directory — byte-decoded; complete.** The 31-page overlay
   directory is decoded deterministically from the on-disk **32-byte segment-descriptor table at
   file `0x0192F0`** (`vp_segment_descriptor_table`; `image_para = [DGROUP:0x3999](=0x16EB)+4 =
   0x16EF → file 0x2400 + 0x16EF·16 = 0x192F0`, self-checked `record0.disk == 0x20670`). The full
   page→`file_offset`/`code_offset`/`size_paragraphs`/`reloc_count`/`flags` map is committed in
   **`code/VICEROY/overlay_pages.json`** (31 records, `record_size 32`), which **supersedes** the
   "partial decode" note in `formats/RTLINK.md §"VICEROY segment directory"`. The overlay image
   begins at file `0x020670` (= MZ load-image end `0x20665` rounded up to the next paragraph; see
   `formats/EXE_MZ.md` §"overlay"). **B** — `code/VICEROY/overlay_pages.json` /
   `tools/decode_overlay_pages_v2.py`.
