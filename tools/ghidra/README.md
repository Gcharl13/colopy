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

---

## 0. The whole procedure, in order

Start from nothing. Every step is checkable — if a step's "you should see"
does not appear, stop there rather than continuing, because everything after
it depends on it.

Sections 1–3 below are the reference detail for these steps; you only need
them if a step misbehaves.

### Part 1 — on the machine with the repo

**1.** Get the current scripts and the binary:

```
cd <repo>
git pull
python3 bin/reconstitute.py           # writes raw/COLONIZE/VICEROY.EXE
python3 tools/ghidra/export_ghidra_symbols.py
```

*You should see* `-> tools/ghidra/viceroy_ghidra_symbols.py` and
`-> tools/ghidra/viceroy_types.h`, and `raw/COLONIZE/VICEROY.EXE` should be
**494,910 bytes** (`0x78D3E`) and `reconstitute.py` should print `sha256 OK`
for it. Ignore `VICEROY_flat.exe` — the address model in this repo is offsets
into `VICEROY.EXE`.

**2.** Copy three files to the Ghidra machine:

| From | To |
|---|---|
| `raw/COLONIZE/VICEROY.EXE` | anywhere |
| `tools/ghidra/viceroy_ghidra_symbols.py` | `%USERPROFILE%\ghidra_scripts\` |
| `tools/ghidra/viceroy_types.h` | anywhere |

Overwrite any older copies. If you renamed the script previously, delete the
old name so you cannot run a stale one by accident.

### Part 2 — import (do this in a NEW project, not the old one)

**3.** `File > New Project` → non-shared → name it whatever.

Starting clean is the point of "start over": a database that has been through
earlier runs of this script carries a half-built `DGROUP` block and stale
labels, and diagnosing that costs more than a fresh import.

**4.** `File > Import File` → pick `VICEROY.EXE`. In the import dialog:

- **Format:** `Raw Binary` — *not* the auto-detected MS-DOS Executable
- **Language:** click `...` → filter `real mode` → **`x86:LE:16:Real Mode`**, any compiler
- **Options… > Base Address:** `0`

*Why:* an MS-DOS Executable import maps only the load image
(`0x2400..0x22A65`) and drops all 31 overlay pages — colony, Europe, combat
and boot screens included. Raw binary at base 0 also makes **Ghidra address ==
file offset**, which is what every citation in this repo uses. Detail in §1.

**5.** Double-click the imported file to open it in the CodeBrowser. When it
offers to analyze, click **Yes** and accept the defaults. Wait for the
progress bar at the bottom right to finish — a few minutes.

*You should see* a Listing full of `FUN_xxxxxxxx` names.

### Part 3 — types and symbols

**6.** *(nothing to do — the script defines the record types itself.)*

`File > Parse C Source` on `viceroy_types.h` is **no longer required**. The
script builds the five structs directly in the Data Type Manager, which also
sidesteps the C parser's data organisation (`long` is 4 bytes in the 16-bit
program and 8 on your desktop — §3.3). The header stays in the repo as
documentation and for other tools. §3.1 covers the manual route if you want it.

**7.** `Window > Script Manager` → **Refresh** (the two-arrows icon) → find
`viceroy_ghidra_symbols.py` → select it → click the green **▶**.

If it is not listed: **Manage Script Directories** (bulleted-list icon, top
right) → **+** → add your `ghidra_scripts` folder.

**8.** `Window > Console - Scripting`, scroll to the bottom. *You should see*:

```
viceroy_ghidra_symbols  BUILD <12 hex>      <- must match the generator's
functions created  : ...
functions named    : 1250
DGROUP block created at 8000:0000 (0x80000), 64 KB
DGROUP permissions set to rw-
DGROUP initialised half copied: 20677 bytes from file 0x1D9A0
DS set to 0x8000 over N block(s) - globals should now decompile by name
record types defined: AIPersonality, ColonyRecord, NativeSettlement, ...
   ColonyRecord[]     8000:5d46  [16 x 0xCA]
   ...
record tables applied: 5/5
   g_current_colony_ptr     8000:8542  as ColonyRecord * (near, 2 bytes)
   ...
record pointers typed: 3/3
thunk stubs labelled : 773
call sites annotated : NNNN  (EOL comment names the real callee)
signatures applied   : 357  (arg counts from caller stack cleanup)
```

**Any line starting `!!` is a real failure — read it, do not continue.** The
script reports rather than swallowing errors, so the message says what to do.

### Part 4 — check it worked

**9.** Click in the Listing, press **G**, type `53b14`, Enter. This is the
smallest function in the binary that uses the current-colony pointer:

```
053B17  8b1e4285   mov bx, word ptr [0x8542]
053B1B  80671c7f   and byte ptr [bx + 0x1c], 0x7f
```

The Decompiler should now name the global:

```c
*(byte *)(g_current_colony_ptr + 0x1c) &= 0x7f;      /* what you want */
*(byte *)(*(int *)0x8542 + 0x1c) &= 0x7f;            /* DS did not take */
```

If you get the second form, right-click in the Decompiler →
**Decompiler > Refresh** first. Still a bare `0x8542` after that means step 8's
`DS set to` line did not appear — go back and read the console.

**10.** Check the arrays landed: **G** → `2eb1c`. The disassembly is
`imul bx,[bp+6],0xca` / `mov al,[bx+0x5d65]`, and `0x5d65` should now show as
`ColonyRecord[?].population` (`0x5D46 + 0x1F`). Full worked example in §3.2.3.

That is the whole procedure. Everything that used to be manual after the
script — parsing the header, `G`+`T` at five table bases, `Ctrl-L` on three
pointers — the script now does. §3 remains as the explanation of *what* it
did and how to redo any part by hand.

### Two things worth knowing about, once it runs

**Cross-page calls now name their callee.** Every inter-module call in
VICEROY goes `lcall <thunkseg>:<off>` into a stub in the load-image thunk
table, which calls the RTLink runtime, which pages the overlay in and jumps
on. Statically that chain is opaque — the callee is an anonymous `FUN_`.
The script decodes the far-call operand from the instruction bytes and puts
the answer in an EOL comment:

```
9a 22 07 1f 18    CALLF 0x181f:0x722    ; -> region_of  (file 0x05E90, via type-B thunk)
```

773 of the 1020 thunks resolve. Two byte-verified paths: type-B stubs carry
`seg:off` in the LJMP directly (`target = 0x2400 + seg*16 + off`); type-A
stubs have the segment patched at load time, and their 4 trailer bytes carry
the overlay **page id** (`target = page.code_offset + ljmp_off`). A
resolution is accepted only when it lands **exactly on a known function
start** — an off-by-one in either formula would scatter results across
mid-function addresses instead of hitting boundaries. The 247 that miss get
no comment rather than a guess.

**Function arity comes from the callers.** 16-bit cdecl makes the caller
clean the stack, so `add sp, N` after a call proves the callee took N/2 words
— evidence in the instruction stream, not an inference from the prologue, and
corroborated across every call site. 357 functions get a signature this way;
counts are accepted only when **all** observed callers agree.

Two honest limits. Argument *types* are not evidenced, so every parameter is
laid down as a plain 2-byte word named `param_N` — the stack slot is real,
the meaning is not. And absence of `add sp` is **not** read as zero arguments:
compilers defer and coalesce cleanup, so silence is unknown.

Validated against the seven thunk signatures transcribed by hand in
`viceroy_source/src/native/page0B_native_raid.c` — 7/7 agree
(`region_of(x,y)`=2, `village_select(idx)`=1, `alarm_bump(amt,power,tribe)`=3, …).

### What the script does NOT decide for you

- **Element counts are display choices**, not facts: the real counts are
  runtime values (zero in a static dump). `ColonyRecord[16]`, `UnitRecord[64]`
  etc. are generous placeholders. The decompiler resolves `base + i*stride`
  from the *element type*, so the length does not affect correctness.
- **Unmapped bytes stay `undefined1`.** ColonyRecord is 89% mapped,
  AIPersonality 5%. Gaps are gaps — the script never invents a field name to
  fill one.
- **110 candidate function names are comments only.** They come from partial
  fingerprint matches against MAPEDIT and are labelled
  `CANDIDATE (unconfirmed...)` in the plate comment, never applied as names.
  See §3 on name tiers before trusting one.

---

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
- **build one contiguous 64 KB `DGROUP` block** at `0x80000`, copy the
  initialised half in from the file image (0x1D9A0, 0x50C5 bytes), and
  **label all ~140 globals** inside it;
- **set the `DS` register to `0x8000`** across every other block — see §2.1,
  this is the step that makes globals decompile by name;
- **bookmark the 31 overlay page boundaries** (Bookmarks window, type
  `RTLink`).

### 2.1 Why `DS` has to be set — the thing that blocks everything else

Real mode has no flat addressing. The instruction is

```
053B17  8b1e4285   mov bx, word ptr [0x8542]
```

and `0x8542` is an offset *from whatever DS holds*, which the bytes do not
record. With DS unknown, Ghidra cannot turn that displacement into a
reference, so the decompiler emits a naked constant:

```c
*(byte *)(*(int *)0x8542 + 0x1c) = *(byte *)(*(int *)0x8542 + 0x1c) & 0x7f;
```

There is no variable to retype here and no label in sight — and this is how
**every** global in the program looks until DS is set. Once the script points
DS at the DGROUP block, the same line resolves against
`g_current_colony_ptr`, and the §3.2 type work becomes possible.

This also forced a layout change (2026-08-08): DGROUP used to be labelled in
two places — initialised globals at their file addresses, BSS globals in the
synthetic block — and **no single DS value could reach both**. It is now one
window with the file bytes copied in.

### 2.2 Why DGROUP must be WRITABLE

`createInitializedBlock` makes a **read-only** block by default, and a
read-only block is a promise to the decompiler that those bytes never change.
It takes that promise seriously: it constant-folds every read. BSS is
zero-filled, so `if (g_some_flag)` folds to *false* and the whole guarded
body is **deleted from the decompilation**.

The symptom is unmistakable — a 274-byte function collapses to a few lines
alongside `WARNING: Read-only address (ram,0x000xxxxx) is written`:

```c
undefined2 __cdecl16far colony_econ_02CFD0(...)
{
  _OPT_MODE_1F5E = 0xffff;
  UNK_8000_0337 = 0;
                    /* WARNING: Read-only address (ram,0x00081f5e) is written */
  return 0;
}
```

The script now sets `rw-` on the block and prints `DGROUP permissions set to
rw-`. To check or fix by hand: `Window > Memory Map`, tick the **W** column on
the `DGROUP` row.

> **If you ran an earlier version of this script**, delete the old block
> first: `Window > Memory Map`, select `DGROUP`, click the red **X**. The old
> one is uninitialised, and the script will reuse it and warn rather than
> silently give you a DGROUP whose initialised half reads as zeros.

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

### 3.2 Apply the types

#### 3.2.0 Step by step, first time through

Purely mechanical. Do these in order; do not skip the console check in step A6.

**A. Re-run the script (once — earlier runs are broken, see §3.2.1).**

1. In a terminal: `cd /home/user/colopy && git pull`
2. In Ghidra, open VICEROY.EXE in the CodeBrowser (the window with the
   Listing on the left and the Decompiler on the right).
3. `Window > Script Manager`.
4. If `viceroy_ghidra_symbols.py` is not in the list: click the
   **Manage Script Directories** button (top-right of the Script Manager
   toolbar, the bulleted-list icon), press **+**, add
   `/home/user/colopy/tools/ghidra`, then **OK**. Use the filter box at the
   bottom of the Script Manager to find the script.
5. Select the script and click the green **▶ Run** button.
6. `Window > Console - Scripting`, scroll to the bottom. You must see one of:
   - `DGROUP block created at 8000:0000 (0x80000)`
   - `DGROUP block already present at 8000:0000`

   If instead you see `!! COULD NOT CREATE THE DGROUP BLOCK`, stop — nothing
   below will work, and the console lists what it tried.
7. Below that is the `APPLY RECORD ARRAYS HERE` table. Leave the console open;
   you will copy addresses out of it.

**B. Apply one array (start with ColonyRecord only).**

1. Click inside the **Listing** window so it has keyboard focus.
2. Press **G** (Go To). Type `8000:5d46`. Enter.
3. You land on a line of undefined bytes labelled `g_colony_table`.
4. Press **T** (`Data > Choose Data Type`).
5. Type `ColonyRecord[16]` in the box. Enter.
6. The Listing now shows an array; click the **▸** in the left margin to
   expand it and you should see `map_x`, `map_y`, `owner`, … by name.

   If Ghidra refuses with a conflict: select the range, press **C**
   (Clear Code Bytes), then redo steps 4–5.

Repeat for the other four rows of the table in §3.2.1 once this one works.

**C. Retype a pointer (the bigger readability win).**

1. Click in the Listing, press **G**, type `2cfd0`, Enter.
2. The Decompiler pane on the right shows the function. If it shows nothing,
   press **F** (Create Function) first.
3. In the decompiled C, find the line that reads the global — it looks like
   `uVar1 = g_current_colony_ptr;` or
   `puVar1 = (undefined *)DAT_80008542;`
4. Click the variable name on the **left** of the `=`.
5. Press **Ctrl-L** (`Retype Variable`; or right-click > Retype Variable).
   Type `ColonyRecord *`. Enter.
6. Every `*(byte *)(puVar1 + 0x1f)` in that function turns into
   `puVar1->population`.
7. Optional: with the variable still selected, press **L** (Rename Variable)
   and type `colony`.

Cross-check what you get against
`viceroy_source/src/colony/page03_colony_turn.c` — same function, transcribed
by hand.

---

The engine reaches a record in **two different ways**, and they need two
different fixes. Recognising which one you are looking at is most of the
skill here.

```
PATTERN A — through the current-record pointer
    mov  bx, [0x8542]        ; g_current_colony_ptr
    mov  al, [bx+0x1f]       ; -> population
  fix: retype the POINTER  (§3.2.2)

PATTERN B — table base + slot*stride, base folded into the displacement
    imul bx, [bp+6], 0xca    ; slot * sizeof(ColonyRecord)
    mov  al, [bx+0x5d65]     ; 0x5D46 + 0x1F  -> population
  fix: apply the ARRAY at the table base  (§3.2.1)
```

#### 3.2.1 Apply record arrays at the table bases

In the Listing, `G` (Go To) → the address, then `T`
(`Data > Choose Data Type`) → type e.g. `ColonyRecord[16]`.

**Addresses in this program are SEGMENTED** (`segment:offset`) — confirmed on
a real import: Go To `2cfd0` lands on a line displayed as `2000:cfd0`
(0x2000×16 + 0xCFD0 = file 0x2CFD0). Go To accepts the flat hex and
normalises it, so you can type either form.

Because the DGROUP block is placed at `0x80000`, which is segment-aligned,
the mapping is one-to-one with no arithmetic:

> **Ghidra `8000:XXXX` == DGROUP offset `0xXXXX`.**

Every DGROUP address in this repo's docs is therefore reachable by typing
`8000:` in front of it:

| Apply this type | at Go To |
|---|---|
| `ColonyRecord[16]` | `8000:5d46` |
| `UnitRecord[64]` | `8000:3144` |
| `PowerRecord[4]` | `8000:8808` |
| `NativeSettlement[32]` | `8000:54ec` |
| `AIPersonality[4]` | `8000:540e` |

and the record pointers to retype live at `8000:8542`
(`g_current_colony_ptr`), `8000:84fc` (`g_current_power_ptr`),
`8000:8d4a` (`g_active_settlement_ptr`).

The script also prints all of this at the end of its run, in whatever form
your program actually uses:

```
DGROUP block created at 8000:0000 (0x80000)
================================================================
APPLY RECORD ARRAYS HERE  (Listing: G to go, then T to set type)
================================================================
  ColonyRecord[]     DS:0x5D46  ->  8000:5d46     [g_colony_count, stride 0xCA]
  UnitRecord[]       DS:0x3144  ->  8000:3144     [g_unit_count, stride 0x1C]
  PowerRecord[]      DS:0x8808  ->  8000:8808     [fixed 4, stride 0x13C]
  ...
```

Copy the right-hand column verbatim — it is authoritative if the block ever
lands somewhere other than `0x80000` (the script falls back if that address
is unavailable).

These tables are BSS — past the end of the file image — so the script creates
a synthetic `DGROUP` block for them. It is placed at **`0x80000`**: just past
the ~495 KB file and inside the 1 MB real-mode range. (An earlier version
used `0x200000`, which is *outside* x86 real-mode address space entirely, so
block creation failed and none of these addresses existed. If your run
predates that fix, re-run the script.) If the block cannot be created the
script now says so loudly and lists what it tried, rather than failing
quietly.

**On the element count:** it is a display convenience, not a correctness
requirement. The counts are runtime values (zero in a static dump), and the
decompiler resolves `base + i*stride` from the *element type*, not the array
length. Pick something generous — `[16]` for colonies, `[64]` for units — or
apply a single `ColonyRecord` if you only want the field names. The block is
64 KB, so nothing here overflows it.

If Ghidra refuses with a conflict, the region already has data defined:
select the range and `C` (Clear Code Bytes), then re-apply.

#### 3.2.2 Retype the record pointers

**This only works after DS is set (§2.1).** Until then the pointer load is a
bare constant with no variable attached to it, and there is nothing to
retype — that is the symptom, not a mistake on your part.

Best done **in the decompiler window, on the local**, rather than on the
global. Open a function that loads the pointer, click the variable that
receives it, `Ctrl-L` (`Retype Variable`), enter `ColonyRecord *`. The
decompiler immediately rewrites every `*(byte *)(pcVar1 + 0x1f)` in that
function as `colony->population`.

If the load still decompiles inline (`*(int *)0x8542` with no local), press
`Ctrl-L` on the **global** at `8000:8542` instead and read the pointer-size
caveat below.

The four current-record globals:

| Global | DGROUP | Type as |
|---|---|---|
| `g_current_colony_ptr` | `0x8542` | `ColonyRecord *` |
| `g_current_power_ptr` | `0x84FC` | `PowerRecord *` |
| `g_active_settlement_ptr` | `0x8D4A` | `NativeSettlement *` |
| `g_active_tribe_data_ptr` | `0x8D4E` | (TribeData, not yet mapped) |

The script prints the resolved address for the first three under
`RECORD POINTERS to retype:` — again, copy rather than compute.

**16-bit pointer caveat.** These hold 2-byte *near* offsets into DGROUP. If
your program's compiler spec makes a `ColonyRecord *` 4 bytes (far), typing
the global that way will consume two bytes too many and mislabel whatever
follows. Check the size Ghidra reports; if it is 4, leave the global as `u16`
and do the retyping on decompiler locals instead — that is where the
readability win is anyway, and Ghidra handles the local's pointer semantics
correctly regardless.

#### 3.2.3 Two worked examples to check it took

Both are verified against `code/VICEROY/disasm_overlay_reseg/` — the exact
instruction bytes are quoted, so if your decompiler disagrees the types have
not landed.

> **Correction (2026-08-08):** an earlier revision of this file named
> `0x02CFD0` as the Pattern A example. That is wrong — `func_02CFD0` is a
> **dialog routine** (page 0x03; open/add-widget/run-modal/close through the
> `0x181F`/`0x191F` thunks) and never touches `[0x8542]`. The real Pattern A
> sites were found by grepping the disassembly for `word ptr [0x8542]`.

**`0x053B14` — Pattern A, the smallest one in the binary (18 bytes).**
Page 0x0E. Its whole body is:

```
053B17  8b1e4285   mov bx, word ptr [0x8542]     ; g_current_colony_ptr
053B1B  80671c7f   and byte ptr [bx + 0x1c], 0x7f ; clear bit 7 of colony_flags
053B1F  8a4606     mov al, byte ptr [bp + 6]
053B22  041f       add al, 0x1f
```

Retype the local that receives `[0x8542]` as `ColonyRecord *` and the
decompiler should turn `*(byte *)(x + 0x1c) & 0x7f` into
`colony->colony_flags & 0x7f`. One field, no ambiguity.

**`0x053820` — Pattern A, the map_x/map_y version.** Page 0x0E, 531 bytes.
Opens `mov bx,[0x8542]` / `mov al,[bx]` / `mov cl,[bx+1]` — i.e.
`colony->map_x`, `colony->map_y` — then passes them to `0x181F:0x722`
(`region_of`). Bigger, but it shows several fields resolving at once
(`[bx+0x1a]` becomes `owner_power`).

**`0x02EB1C` — Pattern B.** Forty-two bytes, and the clearest test in the
binary: `imul bx,[bp+6],0xca` then `mov al,[bx+0x5d65]` and a store to
`[bx+p+0x5e00]`. With `ColonyRecord[]` applied at `8000:5d46` those two
displacements resolve as `+0x1F` (`population`) and `+0xBA`
(`population_on_map`) — i.e. the function is "record what power *p* sees of
colony *ci*'s population and fortification". If your decompiler now says
something equivalent, the types are landing correctly.

Note that Ghidra will not always fold Pattern B into clean `[]` syntax,
because the assembler pre-added the field offset into the displacement
(`0x5D65` *is* `0x5D46 + 0x1F`). Seeing the arithmetic resolve to the right
field offsets is the win; perfectly idiomatic C is not always reachable.

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
