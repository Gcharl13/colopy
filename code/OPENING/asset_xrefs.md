# OPENING.EXE — Asset cross-references (Phase 1)

Provisional inventory of where each `COLONIZE/` filename appears as an immediate string in this executable, plus every byte offset that *looks like* a 16-bit immediate referencing it.

Phase 1 method: filename appears in `strings.json`, and the string's low-16-bit file offset appears as raw bytes anywhere else in the EXE. Phase 2 (annotation) will narrow these to the actual loader instructions and promote each entry from `Loader: TBD` to `Loader: func_<…>`.

**4 of 289 original `COLONIZE/` files** appear by name in this executable.

## `CONFIG.COL`

- Source ext: `.COL`
- Source size: 20 bytes
- Source SHA256: `65855145fba29918…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/COL.md`)

String occurrences in this EXE:

- file 0x00C2D5 (load_image, NUL-terminated, 10 bytes) — xrefs: (none)

## `MEMORY.TXT`

- Source ext: `.TXT`
- Source size: 152 bytes
- Source SHA256: `b40fce9252ead0fb…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/TXT.md`)

String occurrences in this EXE:

- file 0x00C2A1 (load_image, NUL-terminated, 10 bytes) — xrefs: 0x001F1D

## `MEMORY2.TXT`

- Source ext: `.TXT`
- Source size: 540 bytes
- Source SHA256: `ef0fe3a53aa711f6…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/TXT.md`)

String occurrences in this EXE:

- file 0x00C2C6 (load_image, NUL-terminated, 11 bytes) — xrefs: (none)

## `PATH.DAT`

- Source ext: `.DAT`
- Source size: 6,459 bytes
- Source SHA256: `5b3a22a9add668e5…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/DAT.md`)

String occurrences in this EXE:

- file 0x00BFE8 (load_image, NUL-terminated, 8 bytes) — xrefs: 0x0016D8
