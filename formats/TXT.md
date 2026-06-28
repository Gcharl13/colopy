# .TXT — Section-Based Text Data

Plain-ASCII text files using a section-table format. Used for game
data tables (NAMES.TXT), localization (LABELS.TXT), encyclopedia
(PEDIA.TXT), and various screen captions.

**18 .TXT files in COLONIZE/**:

| File | Role |
|------|------|
| `NAMES.TXT` | **Authoritative game-data dictionary** — terrain/unit/FF/tribe names. Read by `func_0749E0` (BYTE_VERIFIED 40-section list). |
| `LABELS.TXT` | UI labels |
| `GAME.TXT` | Game messages |
| `COLONY.TXT` | Colony screen text |
| `MAPEDIT.TXT` | Map editor labels |
| `MAPMENU.TXT` | Map editor menu strings |
| `MENU.TXT` | Main game menu strings |
| `MEMORY.TXT`, `MEMORY2.TXT` | Memory diagnostics |
| `PEDIA.TXT` | Colonization Encyclopedia |
| `TRIBE.TXT` | Per-tribe descriptions |
| `WOODCUT.TXT` | Woodcut sequence captions |
| `OPENING.TXT` | Opening cinematic captions |
| `CLOSING.TXT` | Closing cinematic captions |
| `README.TXT` | Standard readme |
| `AUTOEXEC.TXT` | Sample autoexec.bat lines |
| `DEBUG.TXT` | Debug message strings |
| `CONFIG.TXT` | Config menu text |

---

## Layout

```
$SECTION_NAME
key1=value1
key2=value2
...

$ANOTHER_SECTION
...
```

Section markers begin with `$`. Lines within a section are tab- or
newline-separated key/value pairs. The exact field schema per section
is determined by the consumer code in VICEROY.

For NAMES.TXT, the 40 sections are listed in
[`viceroy_source/FUNCTION_INVENTORY.md`](../viceroy_source/FUNCTION_INVENTORY.md)
under func_0749E0.

---

## Round-trip

Plain ASCII — byte-identity round-trip is trivial.
`tools/verify.py` already verifies all .TXT files.

---

## Loader in VICEROY.EXE

`func_0749E0` (the **scenario loader**) opens NAMES.TXT and reads each
section by name into DGROUP tables. Other .TXT files are read on
demand by their respective screen handlers.

Loader function: BYTE_VERIFIED via string analysis (see
viceroy_source/FUNCTION_INVENTORY.md).
