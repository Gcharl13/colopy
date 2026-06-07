# REPORTS.md — complete byte-cited draw-list, all 9 F-key advisor reports

**Surface group:** the F1–F9 advisor report BODIES (F1 Terrain, F2 Religious,
F3 Continental Congress, F4 Labor, F5 Economic, F6 Colony, F7 Naval,
F8 Foreign Affairs, F9 Indian).

**Decoded:** 2026-05-31, straight from `raw/COLONIZE/VICEROY.EXE` via the RTLink
overlay resolver (`reverse_engineered/tools/rtlink/rtlink_decode.py validate` →
ALL PASS). Supersedes the obsolete "BLOCKED overlay 0x191F — PNG-measured only"
caveat in `docs/FIDELITY_CONFORMANCE.md` §"Report screens" and SCREEN_LAYOUTS §4.

**Citation convention (CLAUDE.md prime directive):** every coordinate, sprite
index, string source and color is cited to a VICEROY.EXE file offset (`@asm
0xNNNNN`) or a named data table (`@MISC <field>` in
`extracted/text/LABELS_sections.json`). DGROUP reads cite the DS word offset
(`[DS:0xNNNN]`; DGROUP image base = file 0x1D9A0). Anything not statically
resolvable is tagged `NEEDS VERIFICATION` — never guessed.

---

## 1. Dispatch chain — selector → 9 body offsets

The in-game key handler is a large `switch ([bp+6])` (the keypress code); the
F-key report ladder lives at **@asm 0x023843..0x02390B**. Each F-key compares
`[bp+6]` against an internal report-key code and dispatches `lcall 0x191F:0x3xx`
into overlay page 5 (code base file 0x37340). F3's site is **@asm 0x02386E**.

**Resolution formula (byte-verified; RULINGS commit 199):**
```
target_file_offset = segments[page_id-1].code_offset + (ljmp_seg << 4) + offset_in_segment
page_id            = thunk trailer word @thunk+0x0A   (segment list @file 0x192F0)
```
`ljmp_seg` is the V2-disambiguated JMPF segment from the thunk record (0 for 8 of
the 9; **0x2B1 for F9** — the nonzero-seg case the `typeA_thunk_targets.json` BUG
note warns about; ljmp_seg=0 there yields mid-instruction garbage, so use the
resolver's parsed value).

| F-key | report | key code (`cmp [bp+6]`) | dispatch site | thunk `lcall 0x191F:` | thunk @file | page | ljmp_seg | off_in_seg | **BODY @file** | prologue |
|---|---|---|---|---|---|---|---|---|---|---|
| **F1** | Terrain Information | 0x48 | @asm 0x023849 | 0x41A | 0x1BA0A | 5 | 0x0000 | 0x010A | **0x3744A** | `enter 0x6E` |
| **F2** | Religious Adviser | 0x41 | @asm 0x02385A | 0x40C | 0x1B9FC | 5 | 0x0000 | 0x0618 | **0x37958** | `enter 0x2C` |
| **F3** | Continental Congress | 0x42 | @asm 0x02386E | 0x3FE | 0x1B9EE | 5 | 0x0000 | 0x06D0 | **0x37A10** | `enter 0x6E` |
| **F4** | Labor Adviser | 0x43 | @asm 0x02387F | 0x3F0 | 0x1B9E0 | 5 | 0x0000 | 0x10D8 | **0x38418** | `enter 0x120` |
| **F5** | Economic Adviser | 0x44 | @asm 0x023890 | 0x3E2 | 0x1B9D2 | 5 | 0x0000 | 0x1710 | **0x38A50** | `enter 0x8C` |
| **F6** | Colony Adviser | 0x45 | @asm 0x0238A1 | 0x3D4 | 0x1B9C4 | 5 | 0x0000 | 0x1ED8 | **0x39218** | `enter 0x68` |
| **F7** | Naval Adviser | 0x46 | @asm 0x0238B2 | 0x3C6 | 0x1B9B6 | 5 | 0x0000 | 0x220C | **0x3954C** | `enter 0x6A` |
| **F8** | Foreign Affairs | 0x47 | @asm 0x0238C3 | 0x3B8 | 0x1B9A8 | 5 | 0x0000 | 0x2548 | **0x39888** | `enter 0x72` |
| **F9** | Indian Adviser | 0x49 | @asm 0x0238E2 | 0x3AA | 0x1B99A | 5 | **0x02B1** | 0x0092 | **0x39EE2** | `enter 0x7E` |

All 9 land on clean ENTER prologues. **F9 is gated**: `test [DS:0x5383],0x20; je`
@asm 0x0238D1 — clear bit → `push 1; lcall 0x191F:0x3AA` (body draws, arg=1); set
bit → `lcall 0x181F:0x574` (→0x387E8, a mid-function landing inside F4's
sub-renderer func_038778, a broken-thunk artifact). F9's real body is 0x39EE2.
The `ADVISOR_REPORTS_AUDIT.md` F3=0x025FD0/F7=0x027B0C offsets are likewise broken-
thunk artifacts — **do not cite them.**

**Decode status (2026-05-31 full code re-trace, this pass):** ALL NINE bodies
transcribed END-TO-END from the orphan continuations (the per-function `.asm`
stubs are tiny — F6=70B, F7=52B, F8=28B — the real bodies live in
`orphans_overlay.asm`: F1 0x3744A→0x037957, F3 →0x03807D, F4 →0x038777 + subs,
F6 0x3925E→0x0393F2, F7 0x39580→0x039886, F8 0x398A4→0x039E98, F9 →0x03A1CC+).
Every draw primitive's arg order was verified by decoding the primitive itself
(func_002EE4 gauge, func_0033F2 enqueue, func_003104 flush, func_002BC8 0x100
center, func_002B38 0x13C, func_00DFCC 0x8BC line-fill, func_003E40 0x2BC sprite).
See **PORT FIXES** below. No report hit a genuine wall.

---

## 2. Shared report infrastructure (decode once)

### 2.1 Title + frame setup (every report opens with this)

| Step | code | effect | cite |
|---|---|---|---|
| set active player record | `push [bp+6]; lcall 0x181F:0x582` | func_030550: stores arg→`[DS:0x9E12]`; `arg*0x13C+0x8808` → `[DS:0x84FC]` = ptr to active PowerRecord (stride 0x13C=316, base 0x8808). NOT a draw. | @asm 0x030550 |
| title-bar background | `push <N>; push cs; call 0x39E53` (→`ljmp 0x191F:0xF4A`) | func_037340: loads title template resource **0x11A2**, appends report-number `N` (0x181F:0x182), substitutes player-name quartet `[DS:0x2DA8/2DAA/2DAC/2DAE]` (0x181F:0x44E), draws (0x181F:0x484). | @asm 0x037340 |
| title-bar fill rect | `push <color>; push <h>; push 0x140; push 0; push [DS:<attr>]; lcall 0x181F:0x22` | fill_rect(x=0,w=0x140,h,color); `[DS:<attr>]` = per-report title attr. | @asm 0x02462 |
| band blit | `push dx; push ax; lcall 0x181F:0x100` | func_02BC8 blit composed band. | @asm 0x02BC8 |
| footer rule | `push 0; push 0x140; push 0xC8; lcall 0x181F:0xE2` | func_0DB3A horizontal rule, w=0x140, y=0xC8 (200). | @asm 0x0DB3A |
| OK button | `lcall 0x181F:0x3C0` | func_04A80 OK button (@MISC 46 "OK"). | @asm 0x04A80 |

**Report-number N → title (@MISC report-title field):** N=2→30 'RELIGIOUS ADVISER
REPORT'; N=3→37 'CONTINENTAL CONGRESS ACTIVITIES'; N=4→49 'LABOR ADVISER REPORT';
N=5→50 'ECONOMIC ADVISER REPORT'; N=6/7→51 'COLONY ADVISER REPORT'; N=8→93
'FOREIGN AFFAIRS REPORT'; N=1→ Terrain header (@MISC 79); F7→52 'NAVAL ADVISER
REPORT' (via 0x39E3F→0x191F:0xF12); F9→29 'INDIAN ADVISER REPORT'. (N verified:
F1=1@0x037450, F2=2@0x037967, F3=3@0x037A20, F4=4@0x038429 +5@0x038787,
F5=5@0x038A60 +6@0x038ED8/0x0391C4, F6=7@0x039403, F8=8@0x0398AF.)

### 2.2 Resident draw / text-composition library (`0x181F:` primitives)

RESIDENT calls (JMPF segment = live resident segment, always reachable). Roles
from byte-verified usage + prologue:

| `0x181F:` | resident @file | role |
|---|---|---|
| 0x16E | 0x02992 | strcat: append string [arg0] to buffer [arg1] |
| 0x178 | 0x028B0 | text-buffer op (ctrl 0x50) |
| 0x182 | 0x029DE | append number (base 10) |
| 0x10A | 0x02912 | text-buffer op (ctrl 0x5C) |
| 0x114 | 0x02AC6 | measure/justify (F1 right-align) |
| 0x11E | 0x02922 | text-buffer op (ctrl 0x5E) |
| 0x128 | 0x02932 | text-buffer op (ctrl 0x60) |
| 0x1BE | 0x028F2 | draw/flush composed buffer (left) |
| 0x13C | 0x02B38 | draw text at (x,y) color (push color;y;x;ss;&buf) |
| 0x100 | 0x02BC8 | draw text in box / blit band |
| 0x22  | 0x02462 | fill_rect |
| 0xE2  | 0x0DB3A | horizontal rule full-width |
| 0x222 | 0x033F2 | **ENQUEUE** (sprite=ax→[0x2CF4], value=dx→[0x2CCE], color=bx→[0x2CE2]) at row counter [0x2CE0]++ — NO draw; builds a row accumulator. **VERIFIED arg order (func_0033F2): ax=sprite index, dx=value (count), bx=color** (skip-if value==0). |
| 0x22C | 0x03104 | **FLUSH the row** (func_003104): walk the queue [0x2CE0], read each sprite [bx+0x2CF4]&0xFFF, measure its width via sheet `[0x83E]` (es:[bx+idx*12+0x3E]), lay out left-to-right + blit each — a **ROW OF SPRITES** (value copies of each sprite), not a filled rect. **Call sig: stack push 4; reg ax=X-col, dx=Y-row, bx=span (=0x12C in F3)**; `[DS:0x70]=1` set around the call toggles draw mode. |
| 0x236 | 0x02EE4 | **segment-sprite gauge** (func_002EE4, `RETF 0xc` = 6 stack words). LOOP tiling a sprite across the span (filled vs empty segments), blit via `LCALL 0xC36:0xA` (→ runtime blit, file=seg*0x10+off+0x2400). Sheet base = `[0x83E]/[0x840]` (NOT [0x2DA8]; the blit pushes `[0x840]`,`[0x83E]`). **Stack args (cdecl): [bp+6]=mode(1), [bp+8], [bp+0xa], [bp+0xc]=span, [bp+0xe]=Y-baseline, [bp+0x10]=X-start (advancing coord → dx in blit @0x2FB7 `add [bp+0x10],ax`). Register args: ax=FILLED-segment sprite index → [bp-0x20], dx=value-hi, bx=value-lo.** EMPTY-segment sprite is **hardcoded 0x38** (`mov ax,0x38` @0x02FA5). — NOT a filled bar, NOT a "color".|
| 0x2BC | 0x03E40 | **ship/colony status SPRITE** (func_003E40, JMPF 0x012B:0x01BA → file 0x3E64; NOT 0x0386A). Reads a table record (ax*0x12+`[0x54EE]`), owner color `[bx+0x84C]`, blits a condition sprite (`si` clamped ≤3, +0xB) via `LCALL 0xC56:0x4`. Used by F7 Cargo (ship hull/cargo icon) and F6 colony (production icon). A SPRITE, not a filled bar. |
| 0x218 | 0x033EA | newline / row cursor reset ([DS:0x2CE0]=0) |
| 0x254 | 0x0E76A | **blit one sprite** (func_00E76A; JMPF 0x0C36:0x000A). Call sig (F1/F7): `push [0x840]; push [0x83E]` (sheet hi/lo), `push X`; reg `ax=sprite idx`, `bx=[0x2DA8]`, `dx=Y`. F1 terrain row sprite=`[bp-0x54]+0x72`; F7 cargo-good sprites in the cargo column loop. A single sprite blit, not a "label+value row". |
| 0x484 | 0x0DCD4 | draw composited title string |
| 0x44E | 0x76B9E | string-substitution/format engine |
| 0x65E | 0x0817E | per-player lookup (FF/intervention) |
| 0x768 | 0x062B4 | unit/ship name by (type,level) |
| 0x7B4 | 0x0BC10 | has-Founding-Father(idx) → 0/1 |
| 0x7BE | 0x08D26 | unit/colony name resolve |
| 0x302 | 0x05BFA | ship destination/route classify |
| 0x9A4 | (Type-B) | numeric/percent format |
| 0xA1A | 0x080C8 | terrain-name lookup (F1) |
| 0xA4C | 0x081F2 | terrain-count tally (F1) |
| 0xBE6 | 0x0B2A2 | cargo-slot count for unit (F7) |
| 0xC68 | 0x0B2F0 | cargo-good id for unit slot (F7) |
| 0xC54 | (resident) | colony-name-at-index (F3) |
| 0x652 | 0x6F5F2 | "report not available" message ([DS:0x87C]) |

Overlay-resident report helpers: `0x191F:0xF4A`@0x37340 title composer;
`0xF66`@0x3C282 FF/leader lookup; `0xF74`@0x3BB4A scroll/"more" pager;
`0xF82` (page5) draw unit/ship status icon from UnitRecord; `0xF12/0xF20/0xF3C`@
0x393F4 F7 title/footer trampolines.

- **`0x191F:0x8BC` (thunk @0x1BEAC) = func_00DFCC, a HORIZONTAL COLOR-RUN /
  LINE-FILL — NOT a "bordered value cell" and NOT a box.** The thunk JMPFs to
  fixed runtime seg `0x0BBC:0x000C` (load-image paragraph; runtime 0xBBCC +
  0x2400 = file 0xDFCC). func_00DFCC clamps bx,dx into [0,[bp+8])×[bp+0xa],
  then computes `di = [bp-2]*[bp-8] + [bp-0xc] + [bp-4]` in segment `es=[bp-6]`
  and runs `MOV es:[di],al; INC di; LOOPNE` over `cx = clamped_hi - clamped_lo
  + 1` bytes with `al=[bp+6]` = the **fill color** (RETF 0xa). So F4/F5/F6/F8
  use `0x8BC` (color in `dx`=0x137/0x13F) to draw **horizontal separator/header
  lines**, not framed cells. (F6's `0x8BC` @0x039372 is a DIFFERENT thunk →
  0x0427:0x0D38, a production-quantity helper, not the line-fill.)
- **F4 matrix frame = `0x2C6`(@0x3CB2-region)/`0x24A` line-rectangle.** These
  draw a rectangular outline via repeated `LCALL 0xB9E:0xA` edge calls (4 edges,
  corners DEC/INC by 2) using the nation quartet `[0x2DA8..0x2DAE]`. This is the
  Labor-matrix container outline — a line-drawn box, parameterised by the matrix
  dims; F2/F3/F7 do NOT draw such a frame.

### 2.3 Font & color
- Body font = FONTTINY: `les bx,[DS:0x89E]; mov al,es:[bx]` = char height, drives
  row pitch (`+2`/`shr 1` recurs every body). [V @asm 0x037BD1, 0x06FEB6]
- Title fill color **0x90**. Gauge/strip span width **0x12C (300px)**.
- **`0x61` is a TEXT COLOR, not a sprite.** It is the `[bp+0xe]` color arg of
  `0x13C`/`0x100` for: F3 FF-grid names (push 0x61 @0x037FF7 → 0x13C color),
  F4 occupation counts (@0x038675), F7 Ship-name (@0x039656/0x039660 → 0x13C),
  F7 Location box (@0x0396AC → 0x100), F7 Destination box (@0x03977F → 0x100).
  The earlier "selectable-row icon sprite 0x61" claim is **WRONG** — there is no
  0x61 sprite blit in F1/F3/F7. (F1's row icon is data-driven `[bp-0x54]+0x72`
  via 0x254; F7's Ship status icon is `0x191F:0xF82` reading the UnitRecord.)
- Row text colors actually seen: F3 session/FF rows **0x92** (@0x037BB8,
  @0x037DF3), F4 occupation label **0x92** / count **0x61**, F6 colony name
  **0x92** (@0x039335), F7 cells **0x61**, F8 strength rows **0x91**
  (@0x039973), F8/F4 column-band line-fill color **0x13F**/**0x137** (`dx` arg
  of `0x8BC`). F2 immigrant text **0xF** (@0x0379D9). F9 rows **0x92**.

---

## 3. F3 — Continental Congress (func_037A10) — VALIDATION REFERENCE

Frame `enter 0x6E`; ends `retf` @asm 0x03807D. Title N=3 → @MISC 37. Independent
re-trace reproduces RULINGS commit 199 exactly.

**DATA INPUTS:** active PowerRecord `[DS:0x84FC]`; REF slots `[DS:0x53DA/53DC/53E0/
53DE]` + group `+0x53E2/E4/E6/E8`; rebel% `[DS:0x53D0]`; bells `[DS:0x53D4]`;
nation quartet `[DS:0x2DA8..0x2DAE]`; FF name table base `DS:0x9632` (`[bx*6-0x69AE]`);
FF-ownership 0x181F:0x7B4; intervention list via `[DS:0x8542]+0x1F`, `[DS:0x539C/
539E]`, UnitRecord (base 0x3144 stride 0x1C).

| # | op | coords / value | source/color | cite |
|---|---|---|---|---|
| 1 | set active record | report id = 3 | →`[DS:0x84FC]` | @asm 0x037A18 |
| 2 | title bar bg | N=3 → @MISC 37 | tpl 0x11A2 | @asm 0x037A23 |
| 3 | title fill rect | x=0,y=0x90,w=0x140,h=5 | color 0x90, attr `[DS:0x2E04]` | @asm 0x037A37 |
| 4 | session line | @MISC 112 "Next Continental Congress Session" + bells-to-go; value 0x191F:0xF66 | str `[DS:0x2E9A]`/`[DS:0x2E9C]` strcat 0x16E | @asm 0x037A5E–0x037B0B |
| 5 | bell gauge — **TILED SEGMENT SPRITES** via 0x236, NOT a filled bar | X=`[bp-0x56]`(=4, pushed first @0x037BCE), Y=`[bp-0x5a]`(running row, pushed @0x037BE2), span **0x12C**; **FILLED-segment sprite = ax=0x3F (@0x037BEC)**, **EMPTY-segment sprite = 0x38 (hardcoded in func_002EE4)**; value dx:bx=clamp(bells,[DS:0x84FC]+0xC) | 0x181F:0x236 | @asm 0x037BCE–0x037BF5 |
| 6 | sentiment line | label `[DS:0x2E44]` + rebel% `[DS:0x53D0]` | 0x182 | @asm 0x037C40–0x037D03 |
| 7 | rebel/tory strip — **ROW OF SPRITES** (enqueue 0x222 ×2 → flush 0x22C), NOT a filled bar | enqueue **rebel sprite ax=0x7C** value=`[bp-0x64]` (@0x037D43), **tory sprite ax=0x7D** value=`[bp-0x6C]` (@0x037D50), color bx=0; flush at X=`[bp-0x56]`, Y=`[bp-0x5a]`, span bx=0x12C (@0x037D5D-0x037D68). **0x7C/0x7D are SPRITE indices, not colors.** | 0x181F:0x222 ×2 + 0x22C | @asm 0x037D43–0x037D6D |
| 8 | REF row | enqueue 4× `0x222` then flush `0x22C`: **icon=ax (DGROUP runtime cell)** + count=dx: `[DS:0x5286]`/`[DS:0x53DA]`, `[DS:0x52A2]`/`[DS:0x53DC]`, `[DS:0x52CC]`/`[DS:0x53E0]`, `[DS:0x532E]`/`[DS:0x53DE]`; `[DS:0x70]=1` around flush; flush X=`[bp-0x56]` Y=`[bp-0x5a]` span 0x12C; label `[DS:0x2E64]` @MISC 85. (The `[DS:0x52xx]` cells hold the runtime sprite ids — values **NEEDS VERIFICATION**, not statically knowable.) | 0x181F:0x222 ×4 + 0x22C w=0x12C | @asm 0x037E1C–0x037E6D |
| 9 | 2nd force row | enqueue 4× + flush: icons `[DS:0x52B0]/0x5294/0x52CC/0x532E` + counts `[DS:0x53E2/E4/E8/E6]`; label `[DS:0x2E98]`/`[DS:0x2E6C]` | 0x222 ×4 + 0x22C | @asm 0x037EFE–0x037F4F |
| 10 | "Founding Fathers" hdr | @MISC 89, str `[DS:0x2E6C]` | strcat | @asm 0x037F6D |
| 11 | **FF grid** | idx 0..0x18 (`cmp 0x19`); has-FF (0x181F:0x7B4) → name `[DS:0x9632+idx*6]` drawn via **0x13C in COLOR 0x61** (push 0x61 @0x037FF7; there is **NO separate 0x61 sprite**) at x=`[bp-0x68]`, y=`[bp-0x6a]`; cols start 4 (`[bp-0x56]=4`@0x037A49) **step 0x4E** (`add [bp-0x68],0x4E`@0x03800C) → **{4,82,160,238}**, 4/row (`cmp [bp-0x52],4`), Y-step font+2 | 0x13C color 0x61 | @asm 0x037FC6–0x03803C |
| 12 | footer rule | y=0xC8, w=0x140 | 0x181F:0xE2 | @asm 0x038056 |
| 13 | OK button | shared | 0x181F:0x3C0 | @asm 0x03805B |
| 14 | overflow pager | @MISC 105 "+ More +" | 0x191F:0xF74 | @asm 0x038073 |

**VALIDATION RESULT: PASS (with corrections logged 2026-05-31 code re-trace)** —
title, session line, gauge span 0x12C, rebel% `[DS:0x53D0]`, REF row
`[DS:0x53DA/DC/DE/E0]`, FF grid {4,82,160,238} step 0x4E limit 0x19, footer rule
y=0xC8 (@0x038056), OK button 0x3C0 (@0x03805B), "+More+" pager 0x191F:0xF74
(@0x038073) all reproduce. **Corrections vs the earlier table:** (a) the bell
gauge "color 0x39" was a misread — there is no color; the FILLED-segment sprite
is **0x3F** and the EMPTY-segment sprite is **0x38**; (b) rebel/tory "colors
0x7C/0x7D" are **SPRITE indices** (rows of count-copies), not colors; (c) FF-grid
"sprite 0x61" is the **text color** of the 0x13C name draw, not an icon sprite;
(d) the 0x236 gauge X is `[bp-0x56]`=4 and Y is the running cursor (the advancing
coord in func_002EE4 is `[bp+0x10]`=X — the earlier "x≈0x19" had X/Y swapped).

---

## 4. F1 — Terrain Information (func_3744A)

Frame `enter 0x6E`; ends `retf` @asm 0x037957. Title N=1. Terrain encyclopedia
grid: per terrain type, name + this-nation unit/colony counts, right-aligned nums.

**DATA INPUTS:** terrain record `[DS:0x8D4E]` (+3 flag 0x80 page mode, +2 idx,
+7 row count); terrain palette/icon `[bx+0x848]`; terrain-name table base
`DS:0x962E` (`[bx*6-0x69CE]`); colony table (`[DS:0x539A]` count, ColonyRecord
stride 0x12 @ `DS:0x54EE`); UnitRecord (base 0x3144 stride 0x1C, type+0x3147&0xF,
level+0x3146); limits `[DS:0x539A/539C]`.

| # | op | coords / value | source/color | cite |
|---|---|---|---|---|
| 1 | title bar bg | N=1 | tpl 0x11A2 | @asm 0x037450 |
| 2 | title fill rect | x=0,y=0x90,w=0x140,h=5 | color 0x90, attr `[DS:0x2DF4]` | @asm 0x037463 |
| 3 | per-terrain loop | y=0xA (`[bp-0x5A]`), x=0x19 (`[bp-0x5C]`); idx `[bp-2]` < rows `[DS:0x8D4E]+7` | — | @asm 0x037479–0x03748B |
| 4 | terrain name | `[DS:0x962E+idx*6]`; idx 0xA → icon 0xC | strcat 0x16E; flush 0x1BE | @asm 0x037489–0x0374C2 |
| 5 | move-cost columns | when `[DS:0x8D4E]+3 & 0x80`: "Move Cost" `[DS:0x2EBE]` @MISC 186 + 4 corner draws | sprite `[bp-0x6E]`, color 0; 0x13C | @asm 0x0374CF–0x03760B |
| 6 | right-align value | x = `0x136 − measure` (0x181F:0x114; sub 0x136; neg) | — | @asm 0x0375AF–0x0375BC |
| 7 | row advance | y += 0x1E then += font+2 | — | @asm 0x037613–0x037627 |
| 8 | colony tally | ColonyRecord stride 0x12 @ `[DS:0x54EE]`, terrain byte==`[bp-2]`; 0x181F:0xA4C | `[DS:0x539A]` | @asm 0x037638–0x03766B |
| 9 | unit tally | UnitRecord stride 0x1C, type `[+0x3147]&0xF`==`[bp+6]`, level `[+0x3146]`==0x14 | `[DS:0x539C]` | @asm 0x037680–end |
| 10 | column captions | `[DS:0x2DF0]`, `[DS:0x2DF2]`, `[DS:0x2E14]` | @MISC | @asm 0x037758, 0x03775E, 0x037802 |
| 11 | **terrain icon row** | `0x181F:0x254` blit-sprite: sheet `[0x83E]/[0x840]`, **sprite = `[bp-0x54]+0x72` (terrain-derived, NOT a literal/0x61)**, x=`[bp-0x6C]`, y=`[bp-0x68]`; x+=3, y+=0x14 per | 0x254 | @asm 0x0378FA–0x037917 |
| 12 | footer | rule y=0xC8 w=0x140 (0x181F:0xE2 @0x03794A), OK 0x3C0 (@0x03794F) | 0xE2+0x3C0 | @asm 0x03794A, 0x03794F |

**Status:** FULLY traced end-to-end (retf @0x037957). Numeric column x is data-
driven (0x181F:0x114 right-justify; `sub 0x136; neg`) → `[layout]`, no static
literal. Terrain row icon is `[bp-0x54]+0x72` via 0x254 (sheet [0x83E]) — **there
is no 0x61 marker sprite in F1**. Footer rule y=0xC8, OK 0x3C0.

---

## 5. F2 — Religious Adviser (func_37958) — FULLY DECODED

Frame `enter 0x2C`; ends `retf` @asm 0x037A0F. Title N=2 → @MISC 30.

**DATA INPUTS:** active PowerRecord `[DS:0x84FC]`; **crosses** PowerRecord
**+0x2E (lo)/+0x30 (hi)**; gate `[DS:0x5383]&0x20`; template **0x11A9**.

| # | op | coords / value | source/color | cite |
|---|---|---|---|---|
| 1 | set active record | id=2 | `[DS:0x84FC]` | @asm 0x03795C |
| 2 | title bar bg | N=2 | @MISC 30 | @asm 0x037967 |
| 3 | title fill rect | x=0,y=0x90,w=0x140,h=5 | color 0x90, attr `[DS:0x2DF6]` | @asm 0x03797A |
| 4 | band blit | — | 0x181F:0x100 | @asm 0x037988 |
| 5 | **Crosses gauge** (0x236, sprite-strip) | X=**0xA** ([bp+0x10], pushed 1st @0x037996), Y=**0x19** ([bp+0xe], pushed 2nd @0x03799D), span **0x12C**; **FILLED-segment sprite ax=0x39** (@0x0379B1), **EMPTY-segment sprite 0x38** (hardcoded); value dx:bx=`[DS:0x84FC]+0x30`(hi)/`+0x2E`(lo). **0x39 is the FILLED SPRITE INDEX, not a color.** | 0x181F:0x236 | @asm 0x037990–0x0379B4 |
| 6 | "next immigrant" text | gated `[DS:0x5383]&0x20`: format tpl 0x11A9 (lcall 0xD1D:0xB48), draw x=0xA y=0x19 color 0xF (push order color/y/x verified) | 0x181F:0x13C | @asm 0x0379B9–0x0379E9 |
| 7 | footer rule | y=0xC8, w=0x140 | 0x181F:0xE2 | @asm 0x037A04 |
| 8 | OK button | shared | 0x181F:0x3C0 | @asm 0x037A09 |

**Status:** FULLY DECODED (all 8 ops).

---

## 6. F7 — Naval Adviser (func_3954C) — FULLY DECODED (4-col ruled table)

Frame `enter 0x6A`; ends `retf` @asm 0x039886. Title via 0x39E3F→0x191F:0xF12 →
@MISC 52. Column headers @MISC **61 'Ship'/62 'Cargo'/63 'Location'/64 'Destination'**.

**Geometry (byte-verified):** row pitch **0x14 (20px)** (`add [bp-0x58],0x14`
@0x039796); first row **y=0x2A (42)** (`[bp-0x58]=0x2A`@0x039560); **7 ships/page**
(`cmp [bp-0x64],7`@0x03979D); base x=2 (`[bp-0x56]=2`@0x03955B). Per-row Y baseline
`[bp-0x6a]` = row_y+3 (Ship/Cargo) or row_y+6 (other cols).

**Column X (byte-verified) + ALIGNMENT — the key correction:**
| col | x (from base=2) | technique | align | color | cite |
|---|---|---|---|---|---|
| **Ship type name** | `[bp-0x66]`=base+0x18=**26** when class∈0xD–0x12 (ship); else +0x56→**112** | **0x13C** (explicit x,y) | **LEFT** | **0x61** | @asm 0x039636–0x039676 |
| **Cargo** | x=`[bp-0x6a]` (≈base), advances +0xC/icon | **0x254** sprite-blit loop (cargo-good sprites) + **0x2BC** ship-condition sprite | sprite row | — | @asm 0x039574–0x039608, 0x0395C3 |
| **Location** | box_x=base+0xA0=**162**, **box_w=0x50 (80)** | **0x100** (text-in-box) | **CENTERED** in [162..242] | **0x61** | @asm 0x0396AC–0x0396C4 |
| **Destination** | box_x=base+0xF0=**242**, **box_w=0x4C (76)** | **0x100** (text-in-box) | **CENTERED** in [242..318] | **0x61** | @asm 0x03977F–0x039793 |

So **Location and Destination are CENTERED (0x100)**; the **Ship type name is LEFT
(0x13C)**; **Cargo is a row of SPRITES** (0x254 cargo-good blits + a 0x2BC condition
sprite), not text and not a filled bar. Column HEADERS (@MISC 61–64) are drawn by
the title-setup path (`0x39E3F`), centered per column.

**Ship status icon** (left of the name): **`0x191F:0xF82`** (@0x0396A2 and a 2nd at
@0x039709) reads the UnitRecord and draws the unit's OWN sprite — there is **no
"marker 0x61"** (0x61 is the text color). Cargo good id via `0x181F:0xC68`
(@0x0395F5), slot count via `0x181F:0xBE6` (@0x0395E4); empty-cargo sprite **0x17**
(`mov ax,0x17`@0x039605), full-stack sprite **0x27** (`mov ax,0x27`@0x0395A8).

**RULES — the second key correction:** F7 draws **exactly ONE `0xE2` horizontal
rule per page, at y=0xC8 (200) = the FOOTER** (page1 @0x0397BB, page2 @0x03987A).
**No header rule, no per-row rule, no inter-column rules.** The "4-col ruled table"
framing was misleading: the columns are separated only by their X positions +
center-boxing, not by drawn rules. OK button `0x3C0` @0x0397C0 (page1) /@0x03987F
(page2). Per-row text color is **0x61** (not 0x92).

**DATA INPUTS:** UnitRecord base 0x3144 stride 0x1C; owner `[+0x3144]`, sub
`[+0x3145]`, type `[+0x3147]&0xF`==`[bp+6]`, class `[+0x3146]` (0xD..0x12=ships),
cargo count `[+0x3150]`, name `[DS:0x5230+cls*0xE]`; location `[+0x314C]`
(3/0xB/2=at-sea → coords `[+0x314D/E]`); route 0x181F:0x302; high-seas/Europe
`[DS:0x5426+p*0x34]`; colony count `[DS:0x539C]`.

Two passes: pass1 ships on map/in colonies (7 rows/page → footer → page2 re-init
@0x0397CF, `[bp-0x52]=1`), pass2 ships at-sea/Europe (class split @0x0397F2/
0x039801; re-enters the cargo/condition path @0x039574).

**Status:** FULLY DECODED — 4 cols with VERIFIED alignment (Loc/Dest centered via
0x100, Ship left via 0x13C, Cargo = sprite row), pitch 0x14, 7-row paging, single
footer rule y=0xC8, OK 0x3C0, both passes.

---

## 7. F4 — Labor Adviser (func_38418)

Frame `enter 0x120`; primary `retf` @asm 0x038777; sub-pages **func_038778**
(`enter 6`, N=5) and **func_038890** (`enter 0x66`). Title N=4 → @MISC 49.
Multi-column colonist/occupation matrix.

**DATA INPUTS:** active PowerRecord `[DS:0x84FC]`; colony table `[DS:0x539C/5398]`;
nation quartet `[DS:0x2DA8..0x2DAE]`; cell engine 0x191F:0x8BC; title attrs
`[DS:0x2E1C]` (N=4), `[DS:0x2E1E]`/`[DS:0x2F58]` (N=5).

| # | op | coords / value | source/color | cite |
|---|---|---|---|---|
| 1 | set active record | id=4 | `[DS:0x84FC]` | @asm 0x038421 |
| 2 | title bar bg | N=4 | @MISC 49 | @asm 0x03842C |
| 3 | title fill ×2 | x=0,w=0x140 | attrs `[DS:0x2E1C]`, `[DS:0x2E2A]` | @asm 0x03843C, 0x038467 |
| 4 | sub-page hdr (038778) | N=5; `[DS:0x2E1E]` + `[DS:0x2F58]` | @MISC | @asm 0x03879A, 0x0387C5 |
| 4b | occupation rows (main body) | per occupation 0..0x1c: NAME `[bx*8-0x715C]` via **0x13C color 0x92** (x=`[bp-0x11c]+1`); COUNT via 0x182 then **0x13C color 0x61** (x=label_x+0x27); a colonist BAR via **0x2C6/0x24A** (line-rectangle, see §2.2) | strcat+0x13C | @asm 0x0385F4–0x038687 |
| 5 | column-header HORIZONTAL LINE | **0x191F:0x8BC = LINE-FILL** (color `dx=0x137`), x=`shl bx,3; add 0x2A`, 18-wide loop (`cmp 0x12`) — a horizontal separator line, **NOT a bordered cell** | color 0x137 | @asm 0x03887D–0x03888C |
| 6 | gold/summary value | `[DS:0x8542+si+0x9A]` formatted (0xD1D:0x8FA), color 0x61/0x92/0xE by magnitude (@0x03891E/0x038929/0x038990) | 0x16E+0x13C | @asm 0x0388FA–0x03899F |
| 7 | summary string | `[DS:0x2E2C]` | strcat | @asm 0x038980 |
| 8 | footer | rule y=0xC8 (0x386EE), OK 0x3C0 (0x386F3), click-hit-scan 0x3CA for selectable colony cells | 0xE2+0x3C0 | @asm 0x0386EE–0x038731 |

**Status:** main occupation-row body (label 0x13C/0x92 + count 0x13C/0x61 + 0x2C6/
0x24A bar) + sub-page line-fill header + gold summary traced; footer rule y=0xC8 +
OK 0x3C0 + click scan verified. **The "value cells" are NOT bordered boxes** — F4
draws text rows + a line-rectangle matrix frame (0x2C6/0x24A) + horizontal header
lines (0x8BC line-fill). Per-occupation count = structural (UnitRecord tally).

---

## 8. F5 — Economic Adviser (func_38A50)

Frame `enter 0x8C`; primary `retf` @asm 0x038ED2; sub-pages **func_038ED4**
(`enter 2`, N=6), **func_038F2C** (`enter 0x66`), **func_0391C0** (`enter 2`,
N=6). Title N=5 → @MISC 50. Multi-page trade/production report.

**DATA INPUTS:** active PowerRecord `[DS:0x84FC]`; quartet `[DS:0x2DA8..0x2DAE]`;
title attrs `[DS:0x2E1E]` (N=5), `[DS:0x2E20]` (N=6), `[DS:0x2F56/2F50/2F52/2F5C/
2F4E/2F5A]`; section `[DS:0x2E2E/2E30/2E2C]`; cells 0x191F:0x8BC.

| # | op | coords / value | source/color | cite |
|---|---|---|---|---|
| 1 | set active record | id=5 | `[DS:0x84FC]` | @asm 0x038A58 |
| 2 | title bar bg | N=5 | @MISC 50 | @asm 0x038A63 |
| 3 | title fill ×2 | w=0x140 | attrs `[DS:0x2E1E]`, `[DS:0x2F56]` | @asm 0x038A73, 0x038A9E |
| 4 | column header HORIZONTAL LINES | quartet, **0x191F:0x8BC = LINE-FILL** (separator lines, NOT bordered cells) | — | @asm 0x038AB4–0x038BCD |
| 5 | section labels | `[DS:0x2E2E]`, `[DS:0x2E30]`, `[DS:0x2F50]`, `[DS:0x2F52]` via 0x13C | @MISC | @asm 0x038AD8–0x038B7B |
| 6 | per-good value text + line | text via 0x13C; row separators via **0x191F:0x8BC line-fill** | production/price/net | @asm 0x038C22, 0x038CF2 |
| 7 | sub-page 2 (038ED4/038F2C) | N=6; `[DS:0x2E20]`+`[DS:0x2F5C]`; `[DS:0x2F4E]` | @MISC | @asm 0x038EEB–0x038F66 |
| 8 | sub-page 3 (0391C0) | N=6; `[DS:0x2E20]`+`[DS:0x2F5A]` | @MISC | @asm 0x0391D7–0x039206 |

**Status:** title/frame/header + column engine + 3 sub-page entries traced; per-
good value = structural.

---

## 9. F6 — Colony Adviser (func_39218)

Frame `enter 0x68`; primary `retf` @asm 0x0393F2; sub-page **func_0393F4**
(`enter 0x58`, N=7). Title N=7 → @MISC 51. Per-colony summary table.

**DATA INPUTS:** active PowerRecord `[DS:0x84FC]`; colony table (`[DS:0x539C]`
count, ColonyRecord stride 0xCA @ base 0x5D60); quartet `[DS:0x2DA8..0x2DAE]`;
title attr `[DS:0x2E22]`; section `[DS:0x2E34/2E36/2E38/2E3A]`.

| # | op | coords / value | source/color | cite |
|---|---|---|---|---|
| 1 | title bar bg | N=7 | @MISC 51 | @asm 0x03921F, 0x0393FB/0x039406 |
| 2 | title fill rect | w=0x140 | attr `[DS:0x2E22]` | @asm 0x039416 |
| 3 | per-colony rows (9/page) | per colony: building/condition SPRITE via **0x2BC** (@0x039297, advancing x by `[bp-0x58]`); colony icon via **0x2A8** (@0x039330, x=`[bp-0x5a]`); colony NAME via **0x13C color 0x92** (@0x03934D, x=`[bp-0x5a]+0x17`, y=`[bp-0x5e]+7`); production-rate SPRITE-strip via **0x35C**→**0x2BC** | mixed | @asm 0x039288–0x0393B8 |
| 4 | row geometry | base x=2 (`[bp-0x5a]=2`@0x039227), base y=0x14=20 (`[bp-0x5e]=0x14`), row pitch **+0x11 (17px)** (@0x0392A4), 9 rows/page (`cmp [bp-0x68],9`@0x0392AB); paginated by `[DS:0x539E]` | — | @asm 0x039227–0x0392F1 |
| 5 | footer | rule y=0xC8 (0x392C9/0x393E0), OK 0x3C0 (0x392CE/0x393E5) | 0xE2+0x3C0 | @asm 0x0392C9–0x0393E5 |

**Status:** per-colony rows = **colony condition sprite (0x2BC) + colony icon
(0x2A8) + name (0x13C color 0x92) + production sprite-strip (0x35C→0x2BC)**, row
pitch 0x11, 9/page, two-page footer. **NOT a grid of bordered cells.** Note F6's
`0x8BC` @0x039372 is a production-quantity helper (thunk → 0x0427:0x0D38), NOT the
F4/F8 line-fill. Per-colony field values = structural (ColonyRecord).

---

## 10. F8 — Foreign Affairs (func_39888)

Frame `enter 0x72`; gated @asm 0x039892 `test [DS:0x5382],1; je 0x398A4`.
**Polarity (byte-verified):** bit0 **CLEAR → JE taken → body draws** at 0x0398A4;
bit0 **SET → falls through → "FOREIGNNOTAVAIL"** message (`push 1; push 0x11B6;
lcall 0x181F:0x652`) then return @0x0398A3. (So the not-available message fires when
`[DS:0x5382]&1` is SET — the earlier "==0 → not available" was inverted.) Real body
@0x0398A4. Title N=8 → @MISC 93. Per-rival diplomacy/strength table (4 powers).

**DATA INPUTS:** gate `[DS:0x5382]&1`; active PowerRecord `[DS:0x84FC]`; per-power
PowerRecord (stride 0x13C @ 0x8808); quartet `[DS:0x2DA8..0x2DAE]`; rival flag
`[DS:0x53A2]`; FF 0x181F:0x7B4; title attr `[DS:0x2E74]`; strength labels
`[DS:0x2E78/2E7C/2E7A/2E7E/2E80/2E82]`, war/peace `[DS:0x2E66/2E68/2E76]`,
recognition `[DS:0x2F38/2F36]`.

| # | op | coords / value | source/color | cite |
|---|---|---|---|---|
| 0 | gate / not-available | `test [DS:0x5382],1; je 0x398A4`: bit **CLEAR → body draws** (jump); bit **SET → "FOREIGNNOTAVAIL"** (@0x11B6) + return. (The earlier "==0 → not available" was INVERTED.) | 0x181F:0x652 | @asm 0x039892–0x0398A3 |
| 1 | set active record | id=8 | `[DS:0x84FC]` | @asm 0x0398A7 |
| 2 | title bar bg | N=8 | @MISC 93 | @asm 0x0398B2 |
| 3 | title fill rect + 0x100 band | x=0,y=0x90,w=0x140,h=2 | color 0x90, attr `[DS:0x2E74]` | @asm 0x0398C2–0x0398D0 |
| 4 | per-power column HORIZONTAL LINES | 4 powers (`cmp 4`), x=idx·0x2D+0xD−3, sprite 0x77; each = **0x191F:0x8BC = LINE-FILL color dx=0x13F** (a header underline, **NOT a bordered cell**) | line-fill 0x13F | @asm 0x0398DD–0x039917 |
| 5 | contact guard | 0x181F:0x7B4 + `[DS:0x53A2]` | — | @asm 0x039922–0x039939 |
| 6 | strength rows | label @MISC 95 Colonies `[DS:0x2E78]` / 96 Population `[DS:0x2E7C]` / 97 Avg Colony `[DS:0x2E7A]` / 98 Military `[DS:0x2E7E]` / 99 Naval `[DS:0x2E80]` / 100 Merchant `[DS:0x2E82]` via **0x13C color 0x91** at x=`[bp-0x5a]`=2; per-power VALUES via **0x13C color 0x91 (LEFT-aligned, explicit x)** at x=`[bp-0x5e]`=0xD / 0x50(80) / 0xA0(160) (/0xF0 4th) | strcat + 0x13C color 0x91 | @asm 0x039940–0x039ADA |
| 7 | war/peace + recognition | @MISC 101 War `[DS:0x2E66]`/102 Peace `[DS:0x2E68]`; `[DS:0x2E76]`; recognition `[DS:0x2F38/2F36]` | strcat | @asm 0x039C65–0x039DDF |
| 8 | footer rows | quartet ×2 | 0x191F:0x8BC | @asm 0x039E60, 0x039E7F |

**Status:** title/gate/header/strength band traced; 6 categories + war/peace +
recognition mapped to @MISC 95–102; per-power values = structural.

---

## 11. F9 — Indian Adviser (func_39EE2) — FULLY DECODED (structure)

Frame `enter 0x7E` (multi-page). Reached via gated dispatch (§1). Title → @MISC 29.
Arg `[bp+6]` = page/mode. Paginated tribe list with per-tribe relations.

**DATA INPUTS:** native-relation **`[DS:0x53A7]` (×0x64) + `[DS:0x53A8]`** →
`[bp-0x6A]`; player loop `[DS:0x5398]`, per-player PowerRecord (0x13C @ 0x8808,
flag `&4`); year `[DS:0x538A]`; NativeSettlement base **DS:0x54EC** (stride 18:
+0x00 x, +0x01 y, +0x02 owner, +0x04 pop, +0x05 mission flag); tribe palette per
@TRIBES col-5; mission strings `[DS:0x2E9E/2EB6/2DE0/2EA0/2EC6/2EA2/2EA4/2EA8/
2EAC/2ED6/2ED8]`; quartet `[DS:0x2DA8..0x2DAE]`.

| # | op | coords / value | source/color | cite |
|---|---|---|---|---|
| 1 | native-relation scalar | `[DS:0x53A8] + 0x64·[DS:0x53A7]` | — | @asm 0x039EE6 |
| 2 | player-presence count | players<4, PowerRecord flag&4 | `[DS:0x5398]` | @asm 0x039F1C–0x039F3A |
| 3 | title fill ×2 | w=0x140 | attrs `[DS:0x2E9E]`, `[DS:0x2EB6]` | @asm 0x039F61, 0x039F90 |
| 4 | header strings | `[DS:0x2DE0]`, year `[DS:0x538A]` | @MISC; 0x100 | @asm 0x039FFF, 0x03A061 |
| 5 | paginator | `call 0x39E98`: `[DS:0x2D0E]` x+=8 wrap 0x124, `[DS:0x2D10]` y | — | @asm 0x03A107, 0x03A1CA |
| 6 | sub-title band | re-0x181F:0x582 + `[DS:0x2EA0/2EC6]` | @MISC | @asm 0x03A22D, 0x03A358, 0x03A3D1 |
| 7 | per-tribe rows | labels `[DS:0x2E30/2EA4/2E44/2E48/2ED6/2EA2/2EA8/2ED8/2EAC]`; year; NativeSettlement fields | strcat + 0x13C/0x100 color 0x92 | @asm 0x03A412–0x03A8F5 |
| 8 | footer rows | quartet ×2 | 0x191F:0x8BC | @asm 0x03A93D, 0x03A961 |

**Status:** FULLY DECODED structurally — entry (0x39EE2 via ljmp_seg=0x2B1),
native-relation inputs, presence loop, two title bands, paginator (func_039E98),
per-tribe band traced. Per-tribe strings are @MISC fields selected by settlement
data.

---

## PORT FIXES (code-transcribed)

Audit of `colonize_sdl/render/screens.py` against the byte-verified bodies above
(read-only — no port edit was made). The prior pass fabricated a generic frame +
filled bars + left-aligned/guessed chrome. Every fix below cites the body offset
that disproves the current port code. **READ-ONLY: this section is the spec for a
later port edit; nothing in `colonize_sdl/` was changed.**

### Cross-cutting fabrications to STRIP (all three renderers)

1. **The whole 12-cell grid in `_render_report`** (lines ~1077-1097: the
   `for n in range(12)` walk with `REPORT_4COL_*`/`REPORT_3COL_*` and
   `cx=col*76+10 / col*105+23`). **No report body draws a 12-cell grid.** Those
   constants come from `SCREEN_LAYOUTS §4 func_06FF94`, which is **not** any
   F-key body (F1=0x3744A, F2=0x37958, … are vertical-stack / row layouts). STRIP
   the grid entirely; each report is its own row/column stack (see per-report
   below). [disproof: §3 F1 row loop @0x037479; §4 F4 row loop @0x0385F4; etc.]
2. **`PANEL_STRIP_ICON = 0x3F` blitted behind each cell** (line 1091
   `self._blit_icon(surf, self.PANEL_STRIP_ICON, cx, cy)`). 0x3F is **not** a
   cell-background sprite anywhere. (It collides with F3's gauge FILLED-segment
   sprite 0x3F — but that's tiled as a GAUGE across span 0x12C, not a per-cell
   panel.) STRIP. [disproof: no body blits 0x3F as a backdrop; §3 F3 gauge
   @0x037BEC uses 0x3F as a 0x236 fill-tile]
3. **Header rule at y=16 (`REPORT_HEADER_RULE_Y`)** (line 1065-1067). No body
   draws a header rule. The only rule a body draws is the **FOOTER rule at
   y=0xC8=200** via `0x181F:0xE2`. STRIP the header rule. [disproof: F1 @0x03794A,
   F2 @0x037A04, F3 @0x038056, F7 @0x0397BB all rule at y=0xC8; none at y=16]
4. **Footer rule at y=183 (`REPORT_FOOTER_RULE_Y=183`)** — bodies rule at
   **y=0xC8=200**, not 183. FIX the constant to 200 (0xC8). [disproof: every body
   `push 0xC8` before `0x181F:0xE2`]
5. **Invented title strip + colors** (`(0,0,0)` strip, `yellow/green/cream`).
   Bodies draw a title **fill-rect of color 0x90 + per-report attr** then a
   composited title band via `0x191F:0xF4A`; body text is FONTTINY. Keep FONTTINY;
   the flat black strip + invented RGBs are placeholders (acceptable only until a
   title sprite is extracted, but they are NOT byte-cited chrome). [§2.1]
6. **OK button** — every body calls `0x181F:0x3C0` (func_04A80) to draw the real
   OK widget. The generic path draws no OK button; `_render_report_congress`
   hand-draws an orange rect + red border + text (lines 1424-1427). That box +
   its colors are invented; the real call is the shared 0x3C0 primitive. Replace
   the hand-drawn box with the 0x3C0 widget (or its extracted sprite). [§2.1]

### `_render_report` generic path — corrected technique

There is **no single generic report layout.** Each of F1/F2/F4/F5/F6/F8/F9 has a
distinct body. The port should branch each (like it already does for F3/F7), not
funnel them through a grid. Minimum correct skeleton shared by all:
title fill-rect (color 0x90) → body rows/columns (per report) → **footer rule
y=200 (0xE2)** → **OK button (0x3C0)**. The subtitle "(F#) Press ESC" at y=190 is
a port affordance, not in the body — keep it out of the byte-cited region or mark
it clearly as a port-only hint.

- **F1 (terrain):** per-terrain ROWS (y starts 0xA, x 0x19; +0x1E+font per row);
  terrain NAME left + numeric columns **right-justified** (x=0x136−textW via
  `0x114`); a terrain ICON per row via `0x254` (sprite=`terrain+0x72`, sheet
  [0x83E]). No grid. [§4]
- **F2 (religious):** ONE crosses gauge — **sprite-strip (0x236)** at X=0xA Y=0x19
  span 0x12C, FILLED sprite **0x39** / EMPTY sprite **0x38**, sheet [0x2DA8];
  optional "next immigrant" text at x=0xA y=0x19 color 0xF. [§5]
- **F4 (labor):** occupation ROWS — label `0x13C` color **0x92** + count `0x13C`
  color **0x61** + a colonist bar via `0x2C6`/`0x24A` (line-rectangle). A matrix
  frame outline via `0x2C6`/`0x24A` (4 `0xB9E` edges) — NOT bordered cells. [§7]
- **F5/F6/F8:** column header **lines** via `0x8BC` (HORIZONTAL LINE-FILL color
  0x137/0x13F) — **NOT bordered cells/panels**; text rows via `0x13C`. F6 colony
  rows = condition sprite (0x2BC) + colony icon (0x2A8) + name (0x13C/0x92) +
  production sprite-strip; pitch 0x11, 9/page. F8 strength rows left-aligned
  color **0x91** at x=2 (labels) / 0xD,0x50,0xA0,0xF0 (per-power values); gate
  shows "FOREIGNNOTAVAIL" when `[0x5382]&1` is SET. [§8/§9/§10]

### `_render_report_naval` (F7) — corrected strip list

Current code (lines 1104-1158) draws all 4 columns **left-aligned as text** and
**cargo as a string**, with the footer rule at y=183. Byte-verified body
(func_3954C, §6) requires:

| element | current (WRONG) | corrected (byte-verified) | cite |
|---|---|---|---|
| Ship type name | `font_tiny.render` x=2 | **0x13C LEFT** at x=**26** (base+0x18, ship class 0xD–0x12; else +0x56→112), color **0x61** | @0x039636 |
| Ship status icon | (missing) | **0x191F:0xF82** (unit's own sprite) left of name | @0x0396A2 |
| Cargo | `cargo_desc` text @88 | **ROW OF SPRITES**: cargo-good sprites via `0x254` (id=0xC68, count=0xBE6) + ship-condition sprite via `0x2BC`; empty=sprite 0x17, full-stack=sprite 0x27 | @0x039574 |
| Location | text @162 left | **0x100 CENTERED** in box [x=162, w=80] color 0x61 | @0x0396AC |
| Destination | text @242 left | **0x100 CENTERED** in box [x=242, w=76] color 0x61 | @0x03977F |
| headers @MISC 61–64 | left @y=22 | centered per column (title path) | (title) |
| rules | footer @y=**183** | **ONE footer rule @y=200 (0xC8)**; NO header/row/column rules | @0x0397BB |
| OK button | (missing) | **0x3C0** @bottom | @0x0397C0 |
| row geometry | y=42+i*20, ≤7 | CORRECT (first y=0x2A, pitch 0x14, 7/page) | @0x039560/0x039796/0x03979D |

**Key F7 finding:** Location + Destination are **CENTERED via 0x100** (the task's
premise confirmed); Ship name is **LEFT via 0x13C**; Cargo is a **sprite row**
(not text, not a bar). Only ONE rule (footer y=200).

### `_render_report_congress` (F3) — corrected strip list

Current code (lines 1255-1427) draws the gauge and sentiment as **filled rects**
and the REF row as **4 fixed columns with guessed ICONS 125/126/9/127**, plus a
hand-drawn OK box. Byte-verified body (func_037A10, §3) requires:

| element | current (WRONG) | corrected (byte-verified) | cite |
|---|---|---|---|
| bell gauge | `draw.rect` black bar + grey ticks (lines 1328-1333) | **sprite-strip `0x236`**: FILLED sprite **0x3F**, EMPTY sprite **0x38**, sheet [0x2DA8], span 0x12C, X=4 (=`[bp-0x56]`), Y=running row | @0x037BCE-0x037BF5 |
| rebel/tory bar | `draw.rect(CC_SENT_REBEL,…)` (line 1360) | **row of sprites** (enqueue `0x222`×2 → flush `0x22C`): rebel sprite **0x7C** ×rebel-count + tory sprite **0x7D** ×tory-count, span 0x12C at x=4 | @0x037D43-0x037D68 |
| REF row | 4 cols x=4/100/190/280, ICONS **125/126/9/127** (lines 1380-1396) | enqueue `0x222`×4 → flush `0x22C` (sprite ROW, span 0x12C at x=4); icon ids come from DGROUP cells **`[0x5286]/[0x52A2]/[0x52CC]/[0x532E]`** (runtime; **NEEDS VERIFICATION** for numeric values — the port's 125/126/9/127 are unverified guesses) | @0x037E1C-0x037E6D |
| FF grid color | `CC_BODY_INK` | name text color **0x61** (not body-yellow); cols {4,82,160,238} step 0x4E, 25 slots, Y-step font+2 — this part is otherwise correct | @0x037FF7 |
| gauge/bar fill colors | invented `CC_GAUGE_*`/`CC_SENT_REBEL` RGBs | there are NO fill colors — these are tiled SPRITES; the RGBs are fabrications | §2.2 |
| OK button | hand-drawn orange rect + red border (lines 1424-1427) | shared **0x3C0** widget | @0x03805B |

**Key F3 finding:** the gauge, rebel/tory bar, and REF row are all **rows of tiled
sprites**, never filled rects. Pinned gauge sprite indices: **filled 0x3F / empty
0x38** (F3 bells); rebel **0x7C** / tory **0x7D**; F2 crosses filled **0x39** /
empty **0x38**. REF/2nd-force icon sprite ids are **runtime DGROUP cells**
(`[0x52xx]`) → NEEDS VERIFICATION of the numeric values (not statically resolvable;
requires the report-label/icon loader, still unidentified — see §13).

---

## 12. DATA INPUTS — consolidated DGROUP map

| DS offset | meaning | used by |
|---|---|---|
| 0x84FC | ptr to active PowerRecord (id·0x13C+0x8808) | all |
| 0x9E12 | active report-player index | all |
| 0x8808 | PowerRecord table base (stride 0x13C) | all |
| 0x3144 | UnitRecord base (stride 0x1C); +0x02 type, +0x03 owner | F1,F4,F7 |
| 0x5D60 | ColonyRecord base (stride 0xCA) | F6 |
| 0x54EE | ColonyRecord terrain/loc array (stride 0x12) | F1 |
| 0x54EC | NativeSettlement table (stride 18) | F9 |
| 0x539A | colony count | F1 |
| 0x539C | unit/colony count | F1,F6,F7,F9 |
| 0x5398 | player count | F9 |
| 0x539E | secondary count | F3 |
| 0x53D0 | rebel sentiment % | F3 |
| 0x53D4 | bells this turn | F3 |
| 0x53DA/DC/DE/E0 | REF army slots | F3 |
| 0x53E2/E4/E6/E8 | intervention/2nd-force slots | F3 |
| 0x5286/52A2/52CC/532E | REF unit icon ids | F3 |
| 0x53A7/53A8 | native-relation / king-anger bytes | F9 |
| 0x5382 | flags: bit0 diplomacy contact (F8 gate), bit1 (F3) | F3,F8 |
| 0x5383 | flags: bit5 (0x20) natives discovered | F2,F3,F9,selector |
| 0x53A2 | rival-met flag | F7,F8 |
| 0x8542 | colony struct ptr (+0x1F count, +0x1A owner) | F3 |
| 0x8D4E | terrain-data record (+2 idx, +3 flag 0x80, +7 rows) | F1 |
| 0x962E | terrain-name table (stride 6) | F1 |
| 0x9632 | Founding-Father name table (stride 6) | F3 |
| 0x5230 | ship-class name table (stride 0xE) | F7 |
| 0x5426 | high-seas/Europe location names (stride 0x34) | F7 |
| 0x538A | current year | F9 |
| 0x2DA8/2DAA/2DAC/2DAE | active nation name quartet (8-byte %s arg) | all |
| 0x2D0E/2D10 | paginator x/y cursor | F9, title composer |
| 0x89E | FONTTINY descriptor (FAR ptr; +0 char height) | all |
| 0x2DE0..0x2F5C | label-pointer slots (runtime-filled from @MISC) | all |
| resource 0x11A2 | report-title template | all titles |
| resource 0x11A9 | religious "next immigrant" template | F2 |
| resource 0x11B6 | "report not available" | F8 |
| resource 0x11C6 | title sub-template (0x39E70) | titles |

**Label-pointer slots vs @MISC:** `[DS:0x2Dxx..0x2Fxx]` are runtime pointers
filled in bulk at game-text load. No per-slot `mov` exists (table-driven), so
slot→field is by semantic content + contiguity, string given from @MISC. Report
TITLES are unambiguous (resource 0x11A2 index N → @MISC 29/30/37/49/50/51/52/93).
**Loader correction (2026-05-31):** the bulk loader is NOT `func_0749E0` — that
function was decoded (`docs/NAMES_LOADER.md`) and only loads the NAMES.TXT *name*
tables (OTHER_NAMES→DS:0x2DB0, RESOURCE, COUNTRY→byte[0x848], NATIONALITY,
COLONYNAME→PowerRecord, LEADERNAME→AIPersonality); it reaches DS:0x2DB0 and
stops, never touching the report-label region (DS:0x2DE0+). The actual
report-label loader is a separate LABELS.TXT-style section loader, still
unidentified (`func_06AF1C`, the only "MISC"-string referencer, is a message
renderer, not the loader).

---

## 13. NEEDS VERIFICATION

1. **Exact @MISC field index per `[DS:0x2Dxx..0x2Fxx]` slot** — bound by semantic
   match + contiguity, not a static `mov`. To pin numerically: identify + trace
   the report-label loader and record store order. **NOTE (2026-05-31):** the
   prior guess `func_0749E0` was DISPROVED (it's the NAMES.TXT name-table loader,
   stops at DS:0x2DB0 — see `docs/NAMES_LOADER.md`); the real loader is a separate
   LABELS.TXT section loader, not yet found. Titles + F3/F7 column/REF labels
   unambiguous; some F4/F5/F6/F8 section labels best-effort until the loader is
   pinned.
2. **0x191F:0x8BC role** — RESOLVED: it is func_00DFCC, a **horizontal color-run
   / line-fill** (`MOV es:[di],al; LOOPNE` over cx pixels with color=al), NOT a
   "bordered value cell." F4/F5/F6/F8 use it for header/row separator LINES (color
   0x137/0x13F). The per-row numeric VALUES are separate `0x13C` text draws; the
   exact UnitRecord/ColonyRecord field per value is computed in each sub-renderer's
   tally loop (F1 pattern) — structural.
3. **F1 numeric column x** — right-justified via 0x181F:0x114 (`sub 0x136; neg`),
   so data-driven `[layout]`, not a static literal (no fabricated coord).
4. **F9 per-tribe row y / paginator constants beyond `[DS:0x2D0E]` wrap 0x124,
   step 8** — row band data-driven by NativeSettlement; row y laid out by func_039E98.
5. **Runtime sprite-id cells for the F3 REF / 2nd-force icon rows**
   (`[DS:0x5286]/0x52A2/0x52CC/0x532E` and `0x52B0/0x5294/...`) — the rows ARE
   sprite rows (0x222 enqueue + 0x22C flush, byte-verified), but the numeric icon
   **indices** are read from these DGROUP cells at runtime and are not statically
   resolvable here (same loader gap as #1). The port's hardcoded 125/126/9/127 are
   UNVERIFIED — pin via the icon-id loader or a runtime dump. (The GAUGE/STRIP
   tile sprites that ARE static literals are pinned: F2 crosses fill **0x39**,
   F3 bells fill **0x3F**, both empty **0x38**; rebel **0x7C**, tory **0x7D**;
   F7 empty-cargo **0x17**, full-stack **0x27**.)
6. **0x236 gauge X/Y arg slots** — RESOLVED by reading func_002EE4: the advancing
   coordinate is `[bp+0x10]` (=X, `add [bp+0x10],ax` per segment @0x02FB7) blitted
   as dx; `[bp+0xe]` is the constant Y baseline. This corrects the earlier F2/F3
   gauge entries that had X/Y swapped. The blit's exact runtime sheet→file mapping
   (`LCALL 0xC36:0xA`) is via the load-image base (file = seg·0x10+off+0x2400);
   not needed for the transcription conclusion.

None are overlay-resolution failures — every body offset and draw primitive is
statically resolved. The above are data-binding refinements (item 5 is the only
fabrication-risk literal the port must not invent).

---

# PORT WIRING SPEC — report-screen sprite-strip gauges (2026-05-31)

The bell gauge / crosses gauge / rebel-tory strip are **sprite strips**, not bars
(confirmed). This section captures everything needed to wire them in the port,
plus the ONE unresolved blocker that currently prevents a faithful render.

## A. CRITICAL: port ICONS extraction is off-by-one vs VICEROY numbering

`port_png_index = VICEROY_runtime_index − 1` **globally**. `COLONIZE/ICONS.SS`
holds 131 sprites dumped 0-based to `extracted/assets/sprites/ICONS/ICONS.SS.000..130.png`
(`tools/mpskit/ss.py`); VICEROY's runtime sprite index (the `ax` in the
`ax*12+0x3E` sheet lookup) is 1-based relative to that dump. Proven from
`NAMES.TXT @UNIT` col-1: Galleon 8→png7, Wagon 9→png8, Artillery 10→png9,
Man-O-War 128→png127, Soldier 103→png102 — every name matches its art only under
−1. CLAUDE.md's unit/ship indices (100-105/127 etc.) are ALREADY `@UNIT−1` = port
indices, so the renderer's existing unit/ship use is correct; **new** sprite uses
(like these gauges) must apply −1. Verified by the sprite-cataloger; recorded in
`SPRITE_CATALOG.md`.

## B. Gauge segment sprites → PORT png index

| Role | VICEROY idx (asm, ground truth) | PORT png | depiction |
|------|------|------|------|
| bell-gauge FILLED   | 0x3F (63) `037BEC B8 3F 00` | **62** | silver Liberty Bell (10×12) |
| crosses-gauge FILLED| 0x39 (57) `0379B1 B8 39 00` | **56** | cross (7×12) |
| EMPTY segment (all) | 0x38 (56) `02FA5 B8 38 00`  | **55** | red "X" (8×12) — SEE BLOCKER |
| rebel row sprite    | 0x7C (124)                  | **123**| colonial flag (13×11) |
| tory  row sprite    | 0x7D (125)                  | **124**| gold crown (13×11) |

## C. Geometry + mechanics (byte-decoded)

- **F3 bell-gauge call** `@0x037BCE–0x037BF5`: X=`[bp-0x56]`=**4**, Y=`[bp-0x5a]`
  (running row, advanced by `FONTTINY_height+2` just before), span=**0x12C=300**,
  mode=**1**, filled sprite ax=0x3F, value dx:bx=`[bp-0x54]:[bp-0x66]`
  (= clamp(bells, need)).
- **func_2d74** (geometry helper, `RETF 0xe`): reads the FILLED sprite's width at
  `[0x83E]:idx*12+0x3E`; if mode&2 width+=2; computes a sub-pixel per-segment
  advance + a shift so the scaled span fits in `span−width`; **CENTERS** the strip
  (`leftover = span − usedW; X_out += leftover>>1` @0x2E3C). Returns the advance.
- **func_002EE4** (tiler, `RETF 0xc`): loops `count` segments; at each it blits the
  FILLED sprite, then (past the filled threshold) overlays the EMPTY sprite 0x38;
  advances X by func_2d74's pitch (`add [bp+0x10],ax` @0x2FB7). Dense sub-pixel
  pitch ⇒ the gauge looks like a packed centered row of small segments, not a few
  spaced icons.
- **rebel/tory + REF rows** use a different primitive (0x222 enqueue ×N → 0x22C
  flush / func_003104): a row of N sprite copies measured by width and laid
  left-to-right (centered). Exact per-row count/pitch semantics NOT yet pinned.

## D. RENDER MODE — RESOLVED: segments are drawn as BLACK silhouettes

The gauge does NOT blit the sprite's own colours. Pixel-sampling
`reference/dos/CC_continental_dos_reference.png`:
  - FILLED span (left ~76%, matching value ~30→76%): **23-24% black (0,0,0)**,
    ~1-4% red. The bell sprite (png62) is silver and the empty sprite (png55) is
    red — yet the rendered ticks are BLACK. ⇒ the gauge blit (`LCALL 0xC36:0xA`,
    `bx=0x2da8` param) is a **silhouette/mask mode** that recolours each segment
    black, independent of the sprite's pixels.
  - UNFILLED remainder (right ~24%): parchment/sepia background, **not red** — the
    empty 0x38 segments are barely-visible dark ticks, NOT bright red X's.
  - Palette bug #56 is RULED OUT here: the sprite-cataloger confirmed png55's red
    is correct per `VICEROY.PAL` (idx 112). The black comes from the blit MODE.

**⇒ NO red-box risk, and the port's CURRENT F3 gauge is already faithful:**
`_render_report_congress` draws a black filled span (`CC_GAUGE_DARK=0,0,0`) with
grey/black 1-px tick texture + sepia unfilled remainder over the byte-cited
300-px span — i.e. exactly the DOS black-silhouette-tick appearance. At 320×200
the sub-pixel sprite-strip renders AS this black tick bar; the literal bell/flag/
crown shapes are sub-pixel and recoloured, so they are not individually visible.
**No renderer change is required** (and none was made — altering a correct gauge
would risk a regression). The sprite/index/geometry facts above are retained for
any FUTURE literal-sprite use (e.g. a higher-res target), where the −1 mapping and
silhouette mode both apply. The rebel/tory bar (port: dark-blue figure-run + flag)
is faithful for the same reason. Remaining nicety (LOW priority): port the exact
func_2d74 sub-pixel pitch so the tick spacing matches segment-for-segment.
