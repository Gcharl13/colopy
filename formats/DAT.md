# .DAT — Misc Binary Data

Three .DAT files used for various game data:

| File | Size | Role |
|------|------|------|
| `CYCLE.DAT` | TBD | Color-cycling animation table (water shimmer, lava glow, etc.) |
| `PATH.DAT` | TBD | Pathfinding precomputed data |
| `INSTALL.DAT` | TBD | Installer manifest (used by INSTALL.EXE) |

---

## CYCLE.DAT — palette cycle table OR animation script (TBD)

**Size**: 34 bytes — far smaller than a typical cycle table.

**Observed bytes** (file 0x00..0x21):
```
01 00 08 3D 78 23 74 10 3D 05 00 75 03 E9 13 01
3D 07 00 74 1A E9 0B 01 FF 76 0A 57 56 9A 00 00
2A 2D
```

These bytes decode plausibly as x86 16-bit code (CMP AX, val; JE; JNE;
JMP; PUSH; LCALL 0x2D2A:0x0000), suggesting CYCLE.DAT is a **tiny code
patch / animation script** rather than a pure data table. It may be
loaded into a specific memory location and JMP'd to during the
animation tick, OR interpreted by a tiny VM in the cycle-tick function.

**Status**: Format TBD. Phase CV1 will be reframed as "find the
function that reads CYCLE.DAT and trace what it does with these bytes."

The cycle-tick function in VICEROY.EXE (TBD — Phase D) is found via
either (a) writes to VGA I/O port 0x3C9 in a timer-driven function,
or (b) the call-site that PUSHes "CYCLE.DAT" string.

---

## PATH.DAT — pathfinding waypoints (BYTE_VERIFIED format)

**Size**: 6,459 bytes. **Plain ASCII text**.

**Observed format**: comma-separated (x, y) coordinate pairs separated
by `\r\n`, e.g.:
```
868, 89
867, 89
866, 89
865, 89
...
```

Likely a precomputed sea-route or trade-route waypoint list (the
European-trade-route segment AMER2 → Europe?). The exact role is
TBD until the loader is annotated.

---

## INSTALL.DAT — installer manifest (BYTE_VERIFIED format hint)

**Size**: 14,153 bytes. **Binary with embedded filenames**.

First bytes: `87 15 64 46 87 19 23 0A 05 05 C0 05` then ASCII
`config.col` followed by zero-padding. This is a list of installer
file records: each record has a small fixed-size header (size, flags,
maybe checksum) followed by a null-padded filename.

Used by INSTALL.EXE only.

---

## Round-trip

Byte-identity (already verified via `tools/verify.py`).
