# VICEROY.EXE — Asset cross-references (Phase 1)

Provisional inventory of where each `COLONIZE/` filename appears as an immediate string in this executable, plus every byte offset that *looks like* a 16-bit immediate referencing it.

Phase 1 method: filename appears in `strings.json`, and the string's low-16-bit file offset appears as raw bytes anywhere else in the EXE. Phase 2 (annotation) will narrow these to the actual loader instructions and promote each entry from `Loader: TBD` to `Loader: func_<…>`.

**7 of 289 original `COLONIZE/` files** appear by name in this executable.

## `AMER2.MP`

- Source ext: `.MP`
- Source size: 12,534 bytes
- Source SHA256: `ea928f06e70564be…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/MP.md`)

String occurrences in this EXE:

- file 0x01FB06 (load_image, NUL-terminated, 8 bytes) — xrefs: 0x011A62, 0x01A0CC, 0x034E93

## `AMERICA.MOV`

- Source ext: `.MOV`
- Source size: 572 bytes
- Source SHA256: `a5c5777d6435b931…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/MOV.md`)

String occurrences in this EXE:

- file 0x01F7F0 (load_image, NUL-terminated, 11 bytes) — xrefs: 0x004973, 0x0049EB, 0x010501, 0x018567, 0x02D443, 0x03D2E8, 0x0414AE, 0x064E88
- file 0x01F7FF (load_image, NUL-terminated, 11 bytes) — xrefs: 0x0192DD, 0x019E1C, 0x038C86, 0x038D67, 0x049284, 0x049357, 0x049DBF, 0x04F133, … (+6 more)
- file 0x01F811 (load_image, NUL-terminated, 11 bytes) — xrefs: 0x016857

## `CONFIG.COL`

- Source ext: `.COL`
- Source size: 20 bytes
- Source SHA256: `65855145fba29918…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/COL.md`)

String occurrences in this EXE:

- file 0x01F9F9 (load_image, NUL-terminated, 10 bytes) — xrefs: (none)

## `CYCLE.DAT`

- Source ext: `.DAT`
- Source size: 34 bytes
- Source SHA256: `97d2506bcbab011e…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/DAT.md`)

String occurrences in this EXE:

- file 0x01FF99 (load_image, NUL-terminated, 9 bytes) — xrefs: 0x0645AE

## `TRIBE.TXT`

- Source ext: `.TXT`
- Source size: 813 bytes
- Source SHA256: `348df01bbeeb00e1…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/TXT.md`)

String occurrences in this EXE:

- file 0x01F835 (load_image, NUL-terminated, 9 bytes) — xrefs: (none)

## `VICEROY.EXE`

- Source ext: `.EXE`
- Source size: 494,910 bytes
- Source SHA256: `a17ed64c27671e5e…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/EXE.md`)

String occurrences in this EXE:

- file 0x019951 (load_image, NUL-terminated, 11 bytes) — xrefs: (none)

## `VICEROY.PAL`

- Source ext: `.PAL`
- Source size: 1,024 bytes
- Source SHA256: `8ea9b23a1c8510da…`
- Loader: TBD (pending Phase 2 annotation)
- Format spec: TBD (`formats/PAL.md`)

String occurrences in this EXE:

- file 0x01FD1D (load_image, NUL-terminated, 11 bytes) — xrefs: 0x0178BC, 0x02D9B9
