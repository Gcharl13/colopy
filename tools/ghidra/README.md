# Ghidra import for VICEROY.EXE

Feeds everything this project knows into Ghidra so the listing shows real
names instead of `FUN_0002d658` / `DAT_00008542`.

Regenerate both artifacts any time (they stay in sync with the repo's JSON):

```
python3 tools/ghidra/export_ghidra_symbols.py
```

| File | What it is |
|---|---|
| `viceroy_ghidra_symbols.py` | self-contained Ghidra script — drop in `ghidra_scripts/`, run from the Script Manager |
| `viceroy_types.h` | the five record layouts — `File > Parse C Source` |

## 1. Load the binary the RIGHT way

**Import as `Raw Binary`, language `x86:LE:16:Real Mode`, base address `0`.**

This matters. VICEROY is an RTLink/Plus overlay binary: the MZ load image is
only file `0x2400..0x22A65`, and the **31 overlay pages live past it**, at
`0x20EE0..0x78D40`. A normal *MS-DOS Executable* import maps just the load
image — about a quarter of the code, and none of the colony, Europe, combat
or boot screens, which are all in overlays.

With a raw-binary load at base 0, **Ghidra address == file offset**, which is
the addressing every artifact in this repo uses.

(If you already imported it as MZ, set `MZ_LOAD = True` at the top of the
script; it will then apply `addr = file_offset - 0x2400` and silently skip
everything outside the mapped image.)

## 2. Run the script — either Python provider works

The script is written for **both** of Ghidra's Python runtimes; you do not
need to pick one:

| Runtime | Notes |
|---|---|
| **PyGhidra** (CPython 3) | bundled and the default since Ghidra 11.3 — nothing to install |
| **Jython 2.7** | the older provider, an installable extension; still fine |

It only uses stdlib `json` plus the injected flat API (`toAddr`,
`createFunction`, `setPlateComment`, `createLabel`, `createBookmark`), and
the one Java type it needs — `SourceType` — is imported explicitly:

```python
from ghidra.program.model.symbol import SourceType
```

That explicit import matters. A bare `ghidra.program.model.symbol.SourceType`
reference resolves under *neither* provider (it is a `NameError` in CPython
and in Jython alike); if it is also wrapped in a bare `except: pass`, every
rename fails silently and you are left wondering why the auto-analysed
functions kept their `FUN_` names. The script now reports rename failures and
unmapped-address skips in its output instead of swallowing them.

No f-strings, no Python-3-only syntax — verified mechanically.

Script Manager → `viceroy_ghidra_symbols.py`. It will:

- **name 1,250 functions**, creating any Ghidra hasn't found;
- **plate-comment each one** with its module, overlay page, byte size, file
  offset, and the GAME.TXT message keys it emits (that last line is often the
  fastest way to recognise what a function does);
- **label ~140 DGROUP globals** — the 64 that are initialised data get
  labelled in place; the BSS half gets a synthetic `DGROUP` block at
  `0x200000` so the names exist somewhere;
- **bookmark the 31 overlay page boundaries** (Bookmarks window, type
  `RTLink`).

Then `File > Parse C Source` → `viceroy_types.h` and retype the record
pointers — e.g. `g_current_colony_ptr` → `ColonyRecord *`. That single step
turns most of the colony code from `byte ptr [bx+0x1f]` into
`colony->population`.

## 3. What the name tiers mean — read this before trusting a name

The plate comment on every function ends with a tier tag:

| Tag | Meaning | Trust |
|---|---|---|
| `REAL NAME (MAPEDIT CodeView match)` | the whole MAPEDIT function matched instruction-for-instruction; this is its actual 1994 name | **high** — byte evidence |
| `role name (analysis)` | named from what the code demonstrably does | medium — a description, not the original name |
| `module-derived placeholder` | `<module>_<offset>`; only the module is claimed | low — a slot, not a claim |

**Unconfirmed candidates are deliberately NOT applied as names.** 110
functions have a *partial* fingerprint match to a named MAPEDIT function.
The matcher's own documentation calls those leads — most are shared compiler
prologues, not shared functions. Applying them would launder a guess into a
fact, so instead each appears in the plate comment as:

```
CANDIDATE (unconfirmed, partial fingerprint match - verify before adopting): _minimax
```

If you verify one in Ghidra (compare the bodies, check the call sites), that's
a real finding worth feeding back into
`data_extracted/viceroy_named_from_mapedit.json` — and it upgrades that
function to tier B everywhere downstream.

## Counts at last generation

- 1,250 functions — 89 confirmed CodeView names, 143 role names,
  1,018 module-derived placeholders, 110 unconfirmed candidates in comments
- 140 DGROUP globals (64 in-file, 76 BSS)
- 31 overlay pages
- 5 record layouts: `ColonyRecord` 0xCA, `UnitRecord` 0x1C,
  `PowerRecord` 0x13C, `NativeSettlement` 0x12, `AIPersonality` 0x34

## Address model (verified, not assumed)

```
MZ header        0x2400   (576 paragraphs, from the MZ header itself)
load image       0x2400 .. 0x22A65
DGROUP in file   0x1D9A0  (verified: DS:0x2166 -> "AMER2.MP", 7/7 string probes)
overlay pages    0x20EE0 .. 0x78D40   (31 RTLink pages, tools/rtlink/viceroy_rtlink_map.json)
DGROUP global    file = 0x1D9A0 + ds_offset      (BSS half is past the image)
thunk stub       file = seg*16 + off + 0x2400    (verified against 0x181F:0x9E6)
```

## Feeding findings back

Renames you make in Ghidra are worth returning to the repo — the module map,
the C reconstruction and the port all read from the same JSON. The cheapest
loop: note the offset + the name + how you verified it, and it can be folded
into `code/VICEROY/functions.json` (role names) or the CodeView match file
(confirmed names), after which regenerating this script carries it back into
Ghidra.
