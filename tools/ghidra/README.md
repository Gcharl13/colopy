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

## 3. Parse the record types — in detail

This is the step that pays for itself: it turns `byte ptr [bx+0x1f]` into
`colony->population` and `[bx+0x2a]` into `power->gold` across the whole
decompiler view.

### 3.1 Parse

`File > Parse C Source…` opens the **Parse C Source** dialog.

**Start with the Parse Configuration dropdown at the top — do not just add
our header to whatever profile is loaded.** That dropdown selects a saved
*profile*: a bundle of source files plus parse options. Ghidra ships prefabs
(`clib`, the `VisualStudio*` ones, …) and one of them is normally preselected,
carrying dozens of system headers and a long list of `-D` defines. Adding
`viceroy_types.h` to that and hitting parse gives you three problems at once:

- a slow parse that pulls in the whole CRT/Win32 header set;
- a wall of errors, because those headers reference paths that exist on the
  machine the profile was authored for, not necessarily yours;
- **type pollution** — thousands of unrelated Windows/CRT types land in the
  program's Data Type Manager alongside the five you wanted.

So build a clean profile instead:

1. **Clear** the configuration (the dialog has Clear / Save / Save As /
   Delete buttons next to the dropdown) so the source list and options are
   empty.
2. **Source files** — `+`, add `tools/ghidra/viceroy_types.h`, nothing else.
   It is deliberately self-contained: no `#include`, no macros, no compiler
   builtins, so it needs no companions.
3. **Parse Options** — leave **empty**. No `-I` (nothing to include) and no
   `-D` (no conditionals in the header). An empty list here is correct, not
   lazy.
4. **Program Architecture** — the current 16-bit VICEROY program. **This is
   the setting that decides whether the structs come out right** (see 3.3),
   and it matters most for *Parse to File*, where there is no current program
   to inherit from.
5. **Save As** a profile named e.g. `viceroy`. You will re-parse every time
   the header is regenerated (each new field identified), and this makes that
   two clicks.
6. **Parse to Program**. ("Parse to File…" writes a reusable `.gdt` archive
   instead — useful to share the types across projects, but Parse to Program
   is the direct route, and re-parsing later updates the types in place:
   anything you already applied picks up the new fields because the type name
   is unchanged.)

Saved profiles live as `.prf` files in the `parserprofiles` folder of your
Ghidra user-settings directory (alongside `tools`, `preferences`, …); the
exact path is version-stamped. *Their internal format is not documented
here — I have not verified it, so create profiles through the dialog rather
than by hand-writing a file.*

Success looks like a quiet dialog and five new entries under
`Data Type Manager > <your program> > /viceroy_types.h`. Warnings about
unrecognised tokens mean it fell back mid-file — check the messages, because
a partial parse silently gives you partial structs.

### 3.2 Apply

Two ways, and for this binary the **second** is the one that pays:

**Retype a pointer.** In the decompiler, right-click the variable →
`Retype Variable` (Ctrl-L) → `ColonyRecord *`. Good for locals that clearly
hold a record pointer.

**Apply arrays at the table bases — do this one.** The engine keeps its
records in fixed DGROUP tables and indexes them by `slot * stride`, so typing
the *table* propagates everywhere at once. In the Listing, go to the table
address, then `Data > Choose Data Type` (hotkey `T`) and enter e.g.
`ColonyRecord[18]`:

| Table | DGROUP | in the script's DGROUP block | Count comes from |
|---|---|---|---|
| `ColonyRecord[]` | `0x5D46` | `0x205D46` | `g_colony_count` `[0x539E]` |
| `UnitRecord[]` | `0x3144` | `0x203144` | `g_unit_count` `[0x539C]` |
| `PowerRecord[4]` | `0x8808` | `0x208808` | fixed 4 |
| `NativeSettlement[]` | `0x54EC` | `0x2054EC` | `g_settlement_count` `[0x539A]` |
| `AIPersonality[4]` | `0x540E` | `0x20540E` | fixed 4 |

(These tables live in BSS, past the end of the file image, which is why the
script creates the synthetic `DGROUP` block at `0x200000` — the second column
is where to apply them.)

Then retype the current-record pointers so the decompiler links the two:
`g_current_colony_ptr` `[0x8542]` → `ColonyRecord *`,
`g_current_power_ptr` `[0x84FC]` → `PowerRecord *`,
`g_active_settlement_ptr` `[0x8D4A]` → `NativeSettlement *`.

### 3.3 The one real trap: `long` is 4 bytes here, 8 on your desktop

`s32` is `typedef signed long`. Under Ghidra's **16-bit x86** compiler spec —
and in the 1994 build — `long` is 4 bytes. Under an LP64 spec it is 8, which
would silently shift every field after the first `s32` and quietly corrupt
the layout. `ColonyRecord` would come out 210 bytes instead of 202 and
`rebel_divisor` would land at `+0xCA` instead of `+0xC6`.

So: **parse against the 16-bit program**, and sanity-check one struct
afterwards — `ColonyRecord` must be **0xCA (202)** bytes in the Data Type
Manager. If it is 210, the architecture was wrong. (This is also why the
generator verifies the layout arithmetically in Python rather than by
compiling the header on the host: a host `sizeof()` check reports false
failures for exactly this reason.)

### 3.4 What is actually mapped

The structs are honest about coverage — unmapped spans are `_pad_XX`, never
invented field names:

| Record | Stride | Named |
|---|---|---|
| `ColonyRecord` | 0xCA | 89% |
| `UnitRecord` | 0x1C | 89% |
| `PowerRecord` | 0x13C | 93% |
| `NativeSettlement` | 0x12 | 83% |
| `AIPersonality` | 0x34 | 5% |

If you identify what a `_pad` span holds, that is a real finding — add it to
`RECORDS` in `export_ghidra_symbols.py`, regenerate, and it flows into the
header, the module map and the port's save decode together.

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
