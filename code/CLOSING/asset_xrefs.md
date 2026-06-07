# CLOSING.EXE — Asset cross-references (Phase 1)

Provisional inventory of where each `COLONIZE/` filename appears as an immediate string in this executable, plus every byte offset that *looks like* a 16-bit immediate referencing it.

Phase 1 method: filename appears in `strings.json`, and the string's low-16-bit file offset appears as raw bytes anywhere else in the EXE. Phase 2 (annotation) will narrow these to the actual loader instructions and promote each entry from `Loader: TBD` to `Loader: func_<…>`.

**1 of 289 original `COLONIZE/` files** appear by name in this executable.

## `CONFIG.COL`

- Source ext: `.COL`
- Source size: 20 bytes
- Source SHA256: `65855145fba29918…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/COL.md`)

String occurrences in this EXE:

- file 0x00B13F (load_image, NUL-terminated, 10 bytes) — xrefs: (none)
