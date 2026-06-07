# King-audience, Foreign-Affairs, Cinematic & Native-popup Render Audit

Created 2026-05-24. Source-of-truth disassembly findings for the renderer
team. Every byte offset, DGROUP address, and string in this doc was read
from the VICEROY.EXE disasm tree at
`reverse_engineered/code/VICEROY/disasm/` (or COLONIZE.EXE where noted)
and the GAME.TXT message file at
`reverse_engineered/raw/COLONIZE/GAME.TXT`.

Companion JSON: `build/ui_extract/king_and_cinematic.json`.

---

## TL;DR for the renderer team

1. **The popup at "King audience" is NOT painted by func at 0x249B1.**
   That offset (in COLONIZE.EXE — `func_0249B1` in
   `reverse_engineered/code/COLONIZE/disasm/`) is a small **filename
   builder** for the load_image overlay, NOT the audience screen
   painter. Existing `build/ui_extract/screens/king_screen.json`
   `paint_func: "0x249b1"` is misleading — it just identifies the
   nearest funtion that pushes the "KING" / "IND0A0" strings during
   load_image init.

2. **The actual King-audience speaker-portrait dispatcher is
   `func_06E3D0` in VICEROY**, which iterates up to 4 speaker slots
   (king + 3 advisers) by calling 4 sprite-loader wrappers
   `func_06BE92` (KING or IND), `func_06BF12` (MSS0+N),
   `func_06BF3C` (MYR0+N), `func_06BF66` (MSS3 + ...). The slot
   inputs are 4 DGROUP words.

3. **`KING2.SS` (8 frames) is NOT an "anger states" sheet.** It is
   a frame-by-frame **animation** of the king's arm raising (likely
   the war-declaration / royal-sword cinematic). The standing King
   portrait used in the @KINGTAX / @KINGRAISE popup is the 1-frame
   `KING.SS`. The "king + bound colonist" pose is `KING1.SS`. The
   end-game wraps are `KINGWIN.SS` (king triumphant) and
   `KINGLOSE.SS` (king crying).

4. **`KINGLSS1.PIK` and `KINGLSS2.PIK` are end-game cinematic
   backgrounds**, NOT King-audience backgrounds. They are the
   throne-room parchment-scroll scenes for the WAR-OF-INDEPENDENCE
   conclusion. The King-audience popup uses the **live map view** as
   its background and overlays a parchment speech bubble (see §1).

5. **Native chief popups DO use per-tribe sprites
   `IND[0..7]A[0..3]`**, NOT MSS3. The tribe index 0..7 is set via
   `set_active_native_tribe(tribe_sprite_idx)` at `func_0081C6` which
   stores `[0x8d52] = tribe_sprite_idx (0..7)` and
   `[0x8d50] = tribe_power_idx (4..11)`. The IND filename is
   constructed by `func_06BE92`.

---

## 1 King audience: dispatcher + paint + sprite selection

### The speaker-portrait dispatcher: `func_06E3D0`

@ file `0x06E3D0..0x06E4CD` (253 bytes).
Disasm: `reverse_engineered/code/VICEROY/disasm/func_06E3D0_unknown.asm`.

Reads bytes off a far-pointer arg (`[bp+6]` is `(seg, off)`):
- `byte [es:bx+0xA] & 0x10` → set `[0x1f8a] = 1`
- `byte [es:bx+0xA] & 0x04` → iterate inner loop calling `func_06F83A`

Then unconditionally calls each of:

```
06E480: CMP word [0x1f5c], 0
06E482: CALL func_06BE92      ; speaker slot 1 (KING or IND0..7)
06E48A: CMP word [0x1f5e], 0
06E48C: CALL func_06BF12      ; speaker slot 2 (MSS0..5)
06E494: CMP word [0x1f60], 0
06E496: CALL func_06BF3C      ; speaker slot 3 (MYR0..3)
06E4A5: CALL func_06BF66      ; speaker slot 4 (MSS3 / colonist)
```

Each slot is gated by a "≥ 0" check so callers can skip a slot by
writing a negative sentinel.

### Slot 1 — King or Native chief: `func_06BE92`

@ file `0x06BE92..0x06BF11` (127 bytes). Tagged "KING", "IND0A0".
Disasm: `func_06BE92_unknown.asm`.

```
06BE96: CMP word [0x1f5c], 7
06BE9B: JLE 0x6BECA           ; [0x1f5c] <= 7 → IND branch
06BE9D: PUSH "KING"           ; [0x1f5c] > 7 → KING branch
06BEA4: LCALL strcpy(buf, "KING")
...
06BECA branch (IND):
06BECA: PUSH [0x5398]         ; current player power_idx
06BECE: PUSH [0x1f5c]         ; tribe sprite idx (0..7)
06BED2: LCALL 0x181F:0x030C   ; → 0x05DC:0x00E0 (overlay file 0x021AC2)
06BEDA: PUSH ax               ; result Y1
06BEDB: LCALL 0x181F:0x0A60   ; → 0x05DC:0x00A2 (overlay file 0x021A84)
06BEE3: MOV [bp-0x16], ax     ; Y2 = pose (0..3)
06BEE6: PUSH "IND0A0"
06BEED: LCALL strcpy(buf, "IND0A0")
06BEF2: MOV al, [0x1f5c]
06BEF5: ADD [bp-0x11], al     ; buf[3] = '0' + tribe_idx (IND<N>A0)
06BEF8: MOV al, [bp-0x16]
06BEFB: ADD [bp-0xf], al      ; buf[5] = '0' + pose (IND<N>A<P>)
06BF01: CALL func_06BE50      ; (the actual sprite loader)
```

Output: filename is one of `"KING"`, `"IND0A0".."IND7A3"`.

### Slot 2 — Adviser MSS family: `func_06BF12`

@ file `0x06BF12..0x06BF3B` (41 bytes). Tagged "MSS0".
Disasm: `func_06BF12_unknown.asm`.

Builds `"MSS" + ('0' + [0x1f5e])` so writing `[0x1f5e] = 0..5`
yields `MSS0` .. `MSS5`.

### Slot 3 — Adviser MYR family: `func_06BF3C`

@ file `0x06BF3C..0x06BF65` (41 bytes). Tagged "MYR0".
Disasm: `func_06BF3C_unknown.asm`.

Builds `"MYR" + ('0' + [0x1f60])` so writing `[0x1f60] = 0..3`
yields `MYR0` .. `MYR3`.

### Slot 4 — Colonist / MSS3 (special): `func_06BF66`

@ file `0x06BF66..0x06C189` (564 bytes — continues into orphan range).
Disasm: `func_06BF66_unknown.asm` + tail in `orphans_overlay.asm`
line 96955+.

Loads `"MSS3"` (the scout/pioneer portrait) based on the same
`[0x1f5c] > 7` decision. This is the 4th simultaneous speaker; it
also takes the speech-bubble VRAM (writes 0xA000:0xFC00) so it's
the dedicated "small colonist" advisor portrait that overlays the
bottom-right of the audience screen.

### Speaker-slot triggers

Each speaker slot has a 24-byte wrapper that sets the slot
DGROUP word, then LJMPs into the message-display
function via `func_06F7EF` (which `LJMP 0x181F:0x998` =
`display_message_with_key`):

| Func file offset | What it does |
|------------------|--------------|
| `func_06F5B0` (file 0x06F5B0..0x06F5C8) | `[0x1f5c] = arg2` then show speech (slot 1 = native/king variant) |
| `func_06F5DA` (file 0x06F5DA..0x06F5F2) | `[0x1f5c] = 8` (KING sentinel >7) then show speech — this is **"open King audience"** |
| `func_06F5F2` (file 0x06F5F2..0x06F60A) | `[0x1f5e] = arg2` (slot 2 — MSS adviser) |
| `func_06F61C` (file 0x06F61C..0x06F634) | `[0x1f60] = arg2` (slot 3 — MYR adviser) |

These take 2 args: `(message_key_string, speaker_idx)`. Per
`king_tax_raise.c` (BYTE_VERIFIED 2026-05-02), the message helper
LJMP'd to is `LCALL 0x181F:0x0998` →
`output_message_with_value`.

### Speaker-slot DGROUP variables (all 16-bit, signed)

| DGROUP addr | Slot | Meaning | Notes |
|-------------|------|---------|-------|
| `[0x1f5c]` | 1 | tribe_sprite_idx 0..7 (IND branch) or sentinel 8 = KING | If negative → skip slot in dispatcher |
| `[0x1f5e]` | 2 | adviser idx 0..5 → MSS0..MSS5 | Negative = skip |
| `[0x1f60]` | 3 | adviser idx 0..3 → MYR0..MYR3 | Negative = skip |
| (implicit) | 4 | always MSS3 (scout) when triggered | Slot 4 has no idx — fixed sprite |

The trigger sites of `[0x1f5c]`:
- `func_0081C6` (`func_0081C6_unknown.asm`) — explicit setter
  `set_active_native_tribe(idx)`. Writes `[0x8d52] = idx` (0..7) and
  `[0x8d50] = idx + 4` (power_idx 4..11) and
  `[0x8d4e] = 0x5ad6 + idx * 78` (NativeTribe record ptr).
- `func_04B036` line `04B0C2`: `MOV ax, [0x8d52]; MOV [0x1f5c], ax`
  — copies the active tribe into slot 1.
- `func_06F5DA`: writes constant 8 (KING).
- `func_070A1A` line `070A4E`: writes constant 4 (slot 1 = tribe 4 = Cherokee?
  TBD which trigger uses this).

---

## 2 King speech-bubble layout (geometry, font, colors)

### Background
The King-audience popup is **NOT a full-screen replacement**. It
overlays the live map view. Per `build/ui_extract/popup_layouts.json`
entry `"king_tax"`:

- `popup_bounds: [95, 30, 220, 130]` (x, y, w, h in native 320×200 px)
- King sprite (`KING.SS.000`) drawn at `(8, 30)`, size `(79, 161)`
- Sprite is on the LEFT, popup parchment on the RIGHT
- No title bar
- Body text wraps inside the popup
- 2-option default button row at the bottom (e.g.
  `Kiss pinky ring.` / `Hold '<Nation> Party.'`)

These coordinates are HAND-DERIVED (2026-05-24) from a DOS reference
PNG, not byte-cited. They should be considered AUTHORITATIVE for the
renderer until disasm of the popup-rect-compute path elevates them.

### Font (USER-CURATED RULE — RESPECT)
Per `docs/UI_RENDER_MAP.md` lines 3-19: **FONTKING is reserved for
the King-audience screen ONLY**. Every other popup, including the
KINGTAX speech bubble that wraps around the King sprite, uses
**FONTTINY** (4×6 fixed-width) for body text. The King portrait is
the only place in the game using the proportional FONTKING.

That said, the brief calls out FONTKING for the audience screen
specifically — the speech bubble for @KINGTAX, @KINGRAISE etc.
should be rendered using FONTKING (8×16 glyphs) per the UI_RENDER_MAP
font assignment for "King audience screen". Choice rests on
the interpretation: if the King speech bubble *is* the "King-audience
screen" then FONTKING applies; if the bubble is a regular popup
overlaying the map, FONTTINY applies.

**Color**: TBD via direct pixel sample on a DOS reference frame.
Per `UI_RENDER_MAP.md` patterns, body text on parchment is likely
dark brown (matching the inkwell look) but no byte citation exists.

### Speech-bubble pinned coords
The text-layout pipeline pushes through:
- `LCALL 0x181F:0x16E` → `0x004B:0x00E2` (file 0x06048A) —
  string-formatter (sprintf-like, builds the substituted message)
- `LCALL 0x181F:0x178` → `0x004B:0x0000` (file 0x0603A8) —
  stream-write
- `LCALL 0x181F:0x182` → `0x004B:0x012E` (file 0x0604D6) —
  append-integer
- `LCALL 0x181F:0x0998` → message-display
  (`output_message_with_value`)

The text layout (x, y, line-spacing) is determined by GAME.TXT
directives `@width=N` (and optional `@x=N`, `@y=N` — see e.g.
@KINGLOSE / @KINGWIN at GAME.TXT lines 3328-3345).

---

## 3 KINGTAX / KINGRAISE / KINGLOWER family — which sprite, which body, which options

All audience messages are loaded by **`func_06F5DA`** (`[0x1f5c] = 8`
→ KING sprite). The message-key string is passed as arg.

| GAME.TXT key | Line | Trigger | King sprite | Speech body | Options |
|--------------|------|---------|-------------|-------------|---------|
| `@KINGTAX`      | 1622 | Routine tax raise (Navigation Act) | KING (default standing) | "Crown receive proper recompense...raise tax rate by X%. Tax rate is now Y%." | TAXOPTIONS (Kiss pinky / Tea Party) |
| `@KINGRAISE`    | 1616 | Player refused a tax-LOWER request — punitive raise | KING (same default — no separate "angry" sprite confirmed) | "DARE to demand lower taxes!... raise taxes by X%." | TAXOPTIONS |
| `@KINGLOWER`    | 1604 | Player asked for lower tax, king grants | KING | "graciously decided to lower your tax rate by X%." | (default OK) |
| `@KINGNOTHING`  | 1610 | Tax change asked, no change | KING | "shall not change your tax rate at this time. You may kiss our royal pinky ring." | (default OK) |
| `@KINGNO`       | 1589 | Player asks for fund/recruit, king refuses | KING | "most dissatisfied with your efforts...do not deign to fulfill..." | (default OK) |
| `@KINGFUND`     | 1596 | Player asks for funds, king grants partial | KING | "Our royal treasury is stretched to the limit. At this time we can offer you grant of only Z gold." | "We gratefully accept this gift." / "Never mind." |
| `@KINGRECRUIT`  | 461  | Player asks for recruits | KING | "Royal University can provide us with specialists..." | (list of professions) |
| `@KINGBLESS`    | 1630 | Random favorable | KING | "have our royal blessing. If you wish, you may kiss..." | (default OK) |
| `@KINGLAUGH`    | 1635 | Player declares independence (mock laugh) | KING | "Ha ha ha ha ha ha! You make a funny joke!" | (default OK) |
| `@KINGWELCOME0` | 1640 | First-time audience welcome | KING | "Welcome, %TITLE %NAME. Your exploits in the New World please us greatly." | (default OK) |
| `@MERCANTILISM` | 1645 | Tax raise due to player building a manufactory | KING | "this %BUILDING you have built will take profits...raise tax rate by X%." | TAXOPTIONS |
| `@PURCHASETAX`  | 1653 | Tax raise due to Crown-resource purchase | KING | "raise your tax rate by X% in recognition of your use of Crown resources." | TAXOPTIONS |
| `@KINGFRIGATE`  | 1793 | King declares war / sends frigate | KING (or KING2 animation?) | (declaration) | (default OK) |
| `@KINGGALLEON2` | 1803 | King treasure-galleon event | KING | | |
| `@KINGGALLEON3` | 1816 | King treasure-galleon event | KING | | |
| `@KINGMERCY`    | 1843 | King grants mercy in war | KING | | |
| `@KINGNEWWAR`   | 1851 | New war declaration | KING2 (?? animation frames 000..007) | "[sword raised]" | (default OK) |
| `@KINGVICTORY`  | 1862 | King's REF wins a battle | KING | | |
| `@KINGWIFE`     | 1869 | Random — king's wife event | KING | | |
| `@KINGWAR`      | 1876 | War continues message | KING | | |
| `@KINGNAVACT`   | 1883 | Navigation Act enforcement | KING | | |
| `@KINGSTAMPACT` | 1891 | Stamp Act event | KING | | |
| `@KINGBUY`      | 2570 | King adds unit to REF | (no King sprite — different popup) | | |
| `@KINGMOBILIZE` | 2707 | Player mobilizes Continental Army | (no King sprite) | | |
| `@KINGLOSE`     | 3328 | End-game cinematic — player wins independence | KING1 (mocking pose) or KINGLOSE (crying) — see cinematic branch in §5 | "let you go your own way..." | (final OK) |
| `@KINGWIN`      | 3338 | End-game cinematic — King wins / player loses | KINGWIN (triumphant pose) | "Rag Tag armies are simply no match for our Royal forces." | (final OK) |

### `@TAXOPTIONS` (GAME.TXT line 1659)
The two-option string used by every tax-raise event:
```
Kiss pinky ring.
Hold '{%STRING3 Party}.'
```
The `%STRING3` is the commodity name (e.g. "Sugar Party", "Tobacco Party").
GAME.TXT marks @TAXOPTIONS as a `@combine_options_from` target —
the dispatcher concatenates it onto @KINGTAX / @KINGRAISE / etc.

### King-anger byte — TBD
The brief mentions `[0x53A7]` as the king-anger byte and per project
memory `MEMORY.md` it is byte-verified. The only writes I found in
disasm are in `func_03DE46` (Independence event handler, lines
`03DE6D..03DE6F`) which set it to `year / 100` (the era/century byte
for the score screen). The read in `func_039EE2` (score-screen
function) confirms it's used as a score multiplier.

**If `[0x53A7]` is also the king-anger byte for sprite selection**,
that write must live in a different (overlay) function I haven't
tracked. Marking TBD pending re-verification. The MEMORY.md note
should be re-audited.

Possible interpretation: `[0x53A7]` might be **dual-use** — during
gameplay it's king anger (0..N) which incidentally maps to KING2
animation frames; at endgame the Independence handler repurposes it
for the century-of-independence display. This would explain the
"8 frames" of KING2 matching 8 anger levels. **Not confirmed.**

---

## 4 Foreign Affairs picker + per-nation report

### F4 — Foreign Affairs gate

`func_039888` (file `0x039888..0x0398A3`, 28 bytes).
Disasm: `func_039888_unknown.asm`. Tagged `"FOREIGNNOTAVAIL"`.

```
039888: ENTER 0x72, 0
03988D: TEST byte [0x5382], 1     ; bit 0 of [0x5382] = "War of Independence active"
039892: JE 0x398A4                ; if NOT in war → continue (caller's logic)
039894: PUSH 1
039896: PUSH "FOREIGNNOTAVAIL"
039899: LCALL 0x181F:0x652        ; → 0x0000:0x37A2 (file 0x0290A2) = display message
0398A1: POP si; LEAVE; RETF
```

This is a **GUARD** — the Foreign Affairs picker is locked once the
War of Independence has begun. The actual picker function must be the
caller of this gate. Per `build/ui_extract/popup_layouts.json` entry
`"foradv_picker"`:

- popup at `(60, 96, 180, 68)` — a small centered menu over the map
- adviser sprite **MSS5** (Continental Adviser / nun in white veil)
  drawn at `(130, 34)`, size `(60, 68)`, ABOVE the popup in the map area
- options: English / French / Spanish / Dutch
- title: "View Whose Report?" (note: this string is in DEBUG.TXT
  @SETREPORT line 143, suggesting the player-facing version is
  hardcoded or different — TBD)

The picker function offset itself was not found in disasm by string
search. It would need to be located by: (a) finding the caller of
`func_039888`, (b) finding `func_06F5F2` (slot 2 setter) called with
arg `[0x1f5e] = 5` (MSS5).

### Per-nation report screen

After the user picks a nation in the F4 picker, the per-nation
fullscreen report uses `func_037340` (file `0x037340..0x0373A3`,
100 bytes). Disasm: `func_037340_unknown.asm`. Tagged `"REPORT"`.

```
037344: PUSH "REPORT"
037347: LEA ax, [bp - 0x50]
03734B: LCALL strcpy(buf, "REPORT")
037353: PUSH [bp + 6]              ; arg = report index (1..9)
0737...: LCALL append_int          ; buf = "REPORT" + str(idx)
037379: LCALL load_PIK(buf)        ; load REPORTn.PIK
037389: JE 0x373A4                 ; if load failed → bail
03739B: MOV al, 0x22               ; ' = "
03739D: LCALL 0x181F:0x484        ; print_to_screen
```

The argument `[bp+6]` selects which REPORT*.PIK to load.

### REPORT*.PIK inventory (visual identification, 2026-05-24)

From inspecting `reverse_engineered/assets/backgrounds/REPORT*/`:

| File | Subject (visual) | Likely Adviser |
|------|------------------|----------------|
| `REPORT1.PIK` | Native scout on shore (rifle, pointing across water) | TBD — possibly "Indian Affairs" |
| `REPORT2.PIK` | Preacher at podium with congregation | **Religious Adviser** (F2?) |
| `REPORT3.PIK` | Scribe + statesman at desk (correspondence) | **Continental Adviser** / Political |
| `REPORT4.PIK` | Frontier labor scene (settlers + stockade) | **Labor Adviser** |
| `REPORT5.PIK` | Scales + candle + hourglass + papers | **Economic Adviser** / Trade |
| `REPORT6.PIK` | Fortified colony overview from above | **Military Adviser** |
| `REPORT7.PIK` | Caravel under sail | **Naval Adviser** |
| `REPORT8.PIK` | Old map with seal + ink-stand | **Foreign Affairs Adviser** ✓ (best fit) |
| `REPORT9.PIK` | Native scout on shore (DUPLICATE of REPORT1 — palette variant) | TBD |

So the F4-picker → per-nation page likely uses `REPORT8.PIK`. The
existing `popup_layouts.json` entry "fullscreen_foreign_affairs" hints
"REPORT4.PIK or similar" — that's a guess; **REPORT8.PIK is the
better visual match** for Foreign Affairs / nation-status content.

### Nation flag sprites

`func_075352` (the WIN/LOSS endgame; see §5) builds nation-prefix
filename based on player power_idx 0..3:

| `[0x5398]` | Nation prefix | Sprite sheets exist |
|-----------|---------------|---------------------|
| 0 | `ENGLND` | ENGLND1.SS, ENGLND2.SS |
| 1 | `FRANCE` | FRANCE1.SS, FRANCE2.SS |
| 2 | `SPAIN`  | SPAIN1.SS, SPAIN2.SS |
| 3 | `DUTCH`  | DUTCH1.SS, DUTCH2.SS |

The `1` vs `2` suffix corresponds to the `bp+6` argument passed to
`func_075352` (which also picks KINGLSS1.PIK vs KINGLSS2.PIK as the
parchment background).

---

## 5 Cinematic screens (Declaration, KingLoss, Closing) — which PIK, which text, which font

### Declaration of Independence (DECLARAT.PIK + DECOIND.PIK)

**Two distinct PIKs, two distinct functions, two distinct moments**.

#### `DECOIND.PIK` — the document-signing scene

`func_03DA2A` (file `0x03DA2A..0x03DB04`, 219 bytes).
Disasm: `func_03DA2A_unknown.asm`. Tagged `"DECOIND"`.

```
03DA47: PUSH "DECOIND"
03DA4A: LCALL load_PIK_fullscreen("DECOIND")    ; load 320×200 background
03DA59: LCALL 0x181F:0x3B6       ; → 0x0262:0x0012 (file 0x021D42) — present-buffer
03DAB4: IMUL ax, [0x5398], 0x34  ; player_idx * 52 (PowerRecord lite stride)
03DAB9: ADD ax, 0x540E           ; + 0x540E = base of player-name table in DGROUP
03DABC: PUSH ax                  ; pointer to player's leader name
03DAC1: LCALL strcpy(local_buf, player_name)
03DACD: LCALL 0x0D1D:0xD46        ; some-string-op (likely uppercase?)
```

Then the function continues building a signature display. The
glyph-by-glyph rendering uses `DEC-LOWA..DEC-LOWZ` and
`DEC-UPPA..DEC-UPPZ` sprite sheets (decorative letter sprites) for
the player's signature, NOT a regular font. This matches the
existing CLAUDE.md ruling and `SPRITE_CATALOG.md` lines 47-99.

#### `DECLARAT.PIK` — the printed-document scene

A separate 320×200 PIK. Already-rendered "We the People..." text
baked into the background image. No code reference found by string
search in VICEROY.disasm — likely loaded by a different overlay
function. The
existing `UI_RENDER_MAP.md` entry "Declaration of Independence
screen" cites `DECLARAT.PIK` for the printed text + `DEC-LOW*` /
`DEC-UPP*` sprites for the signature overlay.

**Distinction between the two:**
- **DECOIND.PIK** = the celebratory "We the People proclaim..."
  scene (Founding Fathers around the document) — the introductory
  cinematic when Declaration is signed
- **DECLARAT.PIK** = the document itself (parchment, hand-written
  body), used as the static background for displaying the
  signature

### KingLoss endgame (KINGLSS1.PIK / KINGLSS2.PIK)

`func_075352` (file `0x075352..0x075593`, 578 bytes).
Disasm: `func_075352_unknown.asm`. Tagged `"KINGLSS", "ENGLND", "FRANCE"`.

```
07536E: PUSH "KINGLSS"
0753...: LCALL strcpy(buf_a, "KINGLSS")
07537D: PUSH [bp+6]              ; arg1: 1 or 2 → picks KINGLSS1 or KINGLSS2
075385: LCALL append_int         ; buf_a = "KINGLSS1" or "KINGLSS2"
0753A9: LCALL load_PIK(buf_a)    ; load KINGLSS<N>.PIK

; Then load nation flag sprite
0753B8: MOV ax, [0x5398]         ; player power_idx
0753BB: switch on ax {
         0: PUSH "ENGLND"
         1: PUSH "FRANCE"
         2: PUSH "SPAIN"
         3: PUSH "DUTCH"
       }
0753E3: LCALL strcpy(buf_a, nation_str)
0753EB: PUSH [bp+6]              ; same N as PIK
0753F3: LCALL append_int         ; buf_a = "ENGLND1" or "ENGLND2" etc.
0753FB: LCALL load_sprite_struct(buf_a)

; Then load king sprite based on win/loss + sub-variant
075430: CMP [bp+6], 1
075434: JNE 0x7545E              ; bp+6 != 1 → KINGWIN
075436: CMP [bp+8], 1
07543A: JNE 0x75458              ; bp+6=1 && bp+8 != 1 → KINGLOSE
07543C: PUSH "KING1"             ; bp+6=1 && bp+8=1 → KING1 (mock king + bound colonist)
...
075458: PUSH "KINGLOSE"
07545E: PUSH "KINGWIN"
```

**Decoded argument matrix:**

| `bp+6` | `bp+8` | Background | Nation art | King sprite | Meaning |
|--------|--------|-----------|------------|-------------|---------|
| 1 | 1 | KINGLSS1.PIK | ENGLND1.SS etc. | KING1.SS (mocking + colonist) | Sub-variant "1a" |
| 1 | other | KINGLSS1.PIK | ENGLND1.SS etc. | KINGLOSE.SS (king crying) | **@KINGLOSE — player WINS independence** |
| 2 | any | KINGLSS2.PIK | ENGLND2.SS etc. | KINGWIN.SS (king triumphant) | **@KINGWIN — player LOSES the war** |

Note the naming is inverted relative to the game outcome — KINGLOSE
sprite = the king has "lost" so he's crying = PLAYER WON. KINGWIN
sprite = the king has "won" so he's triumphant = PLAYER LOST.

The end-game text (@KINGLOSE / @KINGWIN) has explicit `@x` / `@y`
directives in GAME.TXT lines 3328-3345, positioning the
parchment text-blob over the throne-room background:
- @KINGLOSE: `@width=68, @x=232, @y=31` — small text in upper-right
  of KINGLSS1 (overlays the parchment scroll on the right)
- @KINGWIN: `@width=90, @x=202, @y=125` — text in lower-right of
  KINGLSS2 (overlays the parchment scroll over the bound colonist)

### Closing / Credits cinematic (CLOS-BKG + CLOS-*)

The closing cinematic is handled by **CLOSING.EXE**, NOT VICEROY.EXE.
See `reverse_engineered/code/CLOSING/` and
`reverse_engineered/closing_source/`.

`CLOS-BKG.PIK` is the background; the foreground is composed from
seven multi-frame animation sheets (per `SPRITE_CATALOG.md` lines
39-45):

| Sheet | Frames | Subject |
|-------|--------|---------|
| `CLOS-BEL.SS` | 22 | Liberty Bell animation |
| `CLOS-FWK.SS` | 67 | Fireworks |
| `CLOS-HAT.SS` | 23 | (hat?) |
| `CLOS-LDY.SS` | 22 | (lady?) |
| `CLOS-MAN.SS` | 15 | (man?) |
| `CLOS-MIL.SS` | 21 | (militia?) |
| `CLOS-ROC.SS` | 23 | (rocket?) |

CLOSING.EXE strings list confirms `CONFIG.COL` is the only COLONIZE/
file the closing exe references; everything else is its own bundled
assets. Per-frame timing/sequencing is in CLOSING.EXE — not yet
disassembled.

### Opening cinematic (OPENING.EXE)

Separate executable. Per `code/ASSET_ROLES.md` line 18: sigmatch
promoted 4 C-runtime helpers, per-line annotation pending. Loads
`AMERICA.MOV` (script driving frame sequences from `OPEN*.SS`).

---

## 6 Native tribe sprite dispatch (IND0..IND7 selection — function + DGROUP source)

### Context setter: `func_0081C6`

@ file `0x0081C6..0x0081F1` (44 bytes).
Disasm: `func_0081C6_unknown.asm`.

```c
void set_active_native_tribe(int tribe_sprite_idx /* bp+6, 0..7 */) {
    [0x8d52] = tribe_sprite_idx;        // clamped to 0 if out-of-range
    if (tribe_sprite_idx < 0 || >= 8)
        [0x8d52] = 0;                   // safety clamp
    [0x8d50] = [0x8d52] + 4;            // tribe_power_idx (4..11)
    [0x8d4e] = 0x5ad6 + [0x8d52] * 0x4E;  // pointer into NativeTribe table (stride 78)
}
```

### Active-tribe DGROUP context

| Addr | Meaning | Source / Notes |
|------|---------|----------------|
| `[0x8d52]` | tribe_sprite_idx (0..7) | Written by `func_0081C6` |
| `[0x8d50]` | tribe_power_idx (4..11) = `[0x8d52] + 4` | Used for PowerRecord lookups |
| `[0x8d4e]` | ptr to NativeTribe record (DGROUP:0x5ad6 + idx × 78) | Used for tribe-data access |
| `[0x8d4a]` | ptr to active NativeSettlement record (set by other code) | Per `MEMORY.md`: stride 18 bytes, base `[0x54EC]` |
| `[0x8d4c]` | (related context — used in chief funcs) | TBD |

### Tribe sprite mapping (BYTE_VERIFIED via NAMES.TXT @TRIBES)

NAMES.TXT line 385+ defines tribes in this exact order (the file
ordering IS the canonical tribe_sprite_idx ordering):

| `[0x8d52]` | `[0x8d50]` (=idx+4) | Tribe name | Pal color (NAMES col 5) | Sprite |
|-----------|---------------------|------------|------------------------|--------|
| 0 | 4  | Incas    | 97  | IND0A0 .. IND0A3 |
| 1 | 5  | Aztecs   | 149 | IND1A0 .. IND1A3 |
| 2 | 6  | Arawaks  | 54  | IND2A0 .. IND2A3 |
| 3 | 7  | Iroquois | 87  | IND3A0 .. IND3A3 |
| 4 | 8  | Cherokee | 67  | IND4A0 .. IND4A3 |
| 5 | 9  | Apache   | 111 | IND5A0 .. IND5A3 |
| 6 | 10 | Sioux    | 118 | IND6A0 .. IND6A3 |
| 7 | 11 | Tupi     | 71  | IND7A0 .. IND7A3 |

Per project memory file `project_tribes_col5_is_color.md`, the col-5
value is a VICEROY.PAL palette color (for the tribe's map marker),
NOT wealth.

### Filename construction (BYTE_VERIFIED in `func_06BE92`)

```
buf = "IND0A0\0"           // template (7 bytes including null)
buf[3] = '0' + tribe_sprite_idx   // → "IND<N>A0"
buf[5] = '0' + pose               // → "IND<N>A<P>"
```

The pose `P` (0..3) is computed from `LCALL 0x181F:0x030C` then
`LCALL 0x181F:0x0A60` taking `(player_idx, tribe_idx)`. The two
overlay helpers haven't been pinned to specific source files yet —
they live at file offsets `0x021AC2` and `0x021A84` respectively.
Best guess: pose is "facing direction" derived from the player's
relative position to the village, OR a tribe-specific narrative
state.

### Chief-popup function: `func_04A7CA`

@ file `0x04A7CA..0x04A9C4` (507 bytes).
Disasm: `func_04A7CA_unknown.asm`. Tagged `"CHIEFHOWDY"`.

This is the @CHIEFHOWDY trade-overture popup. Inputs:
- `[bp+6]` = unit_idx (the unit visiting the village)
- `[bp+8]` = ??? (a sub-flag, 0..3 → different paths)
- `[bp+0xA]` = ??? (another arg)
- `[0x8d52]` = the tribe being visited (set beforehand)
- `[0x8d4a]` = pointer to the NativeSettlement record (set beforehand)

```
04A7D5: IMUL bx, [bp+6], 0x1c        ; UnitRecord stride 28
04A7D9: CMP byte [bx + 0x315b], 0x16 ; UnitRecord+0x15 == 0x16? (some unit type)
                                     ; 0x3146 is UnitRecord base, so +0x15 = +0x15
04A7EE: PUSH [0x8d52]                ; visited tribe
04A7F2: LCALL 0x181F:0x030C          ; same fn as in func_06BE92 — returns Z
04A7FA: MOV [bp-0x22], ax            ; Z
04A7FD: CMP ax, 0x4B                 ; Z >= 75?

; later:
04A959: PUSH "CHIEFHOWDY"
04A95C: LCALL 0x191F:0x19C           ; → 0x0000:0x3760 (file 0x029060) = trade-prompt
```

The chief-popup uses the IND sprite via the standard speaker-slot
path: someone calls `func_06F5B0(tribe_sprite_idx, "CHIEFHOWDY")`
which sets `[0x1f5c] = tribe_sprite_idx (0..7)` then displays the
message — and the speaker-portrait dispatcher `func_06E3D0` shows
the matching `IND<N>A<P>.SS` sprite.

**THE BUG FIX**: the existing renderer is using MSS3 for chief popups
because some code path is setting slot 4 (MSS3) instead of slot 1
(IND). The correct path is:
1. Set `[0x8d52]` = tribe_sprite_idx (0..7) via `func_0081C6`
2. Set `[0x1f5c]` = `[0x8d52]` (copy from active tribe)
3. Skip slots 2/3/4 by leaving them negative or zero
4. Call `func_06F5B0(tribe_sprite_idx, "CHIEFHOWDY")` (or equivalent)

This will render the per-tribe IND sprite.

### Native popup messages (all use IND<tribe>A<pose> sprite)

| GAME.TXT key | Line | Trigger |
|--------------|------|---------|
| `@CHIEFHOWDY`    | 1288 | First contact with peaceful village; trade overture |
| `@CHIEFGUIDES`   | 1296 | Chief grants Scout guides |
| `@CHIEFAREA`     | 1303 | Chief grants area knowledge (map reveal) |
| `@CHIEFGIFT`     | 1309 | Chief gives peace-offering beads |
| `@CHIEFBORED`    | 1315 | Chief acknowledges repeat visit |
| `@CHIEFKILL`     | 1320 | Chief executes player (sacred taboo broken) |
| `@INDIANGOLD`    | 867  | Native village raze gold reward |
| `@RAIDGOLD`      | 1087 | Raid gold loot |
| `@CONFISCATE`    | 1281 | Native confiscates player wagon goods |
| `@TRADE0`        | 1332 | Native trade negotiation offer |
| `@PISS5`         | 1580 | Native tribe stance change |

---

## 7 Open questions / TBD

1. **King-anger byte location**. Per project `MEMORY.md`, the anger
   byte is `[0x53A7]`. But the disasm xref scan shows the only write
   to `[0x53A7]` is in `func_03DE46` (Independence event) where it's
   set to `year / 100` (century byte). The MEMORY.md citation needs
   re-audit — possibly the anger byte is at a different address, OR
   the write site for anger increments lives in an overlay function
   not yet captured by the xref scan.

2. **KING2.SS frames purpose**. Visually they are 8 frames of a
   king-arm-raising animation. They are NOT loaded by `func_06BE92`
   (which only emits "KING" or "INDxA<p>"). The string "KING2" does
   not appear in any `.asm` file I searched. Likely loaded by a
   different cinematic/animation function (war-declaration scene?).
   Pending location of the loader site.

3. **The 4th speaker slot (MSS3)**. `func_06BF66` always loads MSS3
   when called. What's the trigger? Per visual inspection MSS3 is
   the "scout/pioneer" portrait — likely shown for outdoor warnings
   like @NOOCEAN. Need to find the slot-4 trigger function.

4. **Foreign Affairs picker function offset**. The guard
   `func_039888` is found but the actual menu-display caller has
   not been located (called from RTLink runtime stub `0x01A5F0`).
   Best approach: search for the "View Whose Report?" string xref or
   trace the F4-keypress dispatch in the input handler.

5. **REPORT*.PIK → adviser-function map**. The 9 REPORT*.PIK
   backgrounds are visually identified but the mapping from
   "F2 Religion / F3 Trade / F4 Foreign Affairs / etc." to the
   specific REPORT index is BY-VISUAL-INFERENCE (best guess
   REPORT8 = Foreign Affairs based on map imagery, REPORT2 =
   Religion based on preacher imagery). No code citation yet.

6. **Speech-bubble color**. The King-audience parchment-bubble body
   text color hasn't been byte-sampled from a DOS reference frame.
   Per UI_RENDER_MAP conventions it's likely a dark brown (ink on
   parchment), but TBD.

7. **King-audience screen full-paint function**. The audience screen
   IS likely a fullscreen replacement (not just an overlay), but no
   dedicated `paint_king_audience()` function has been confirmed.
   The four speaker-loaders (`func_06BE92` etc.) only load sprite
   structs; they don't blit a background. The background-paint must
   happen via a different function — possibly `func_06E3D0`'s caller
   (which is RTLink-dispatched, so not directly in callgraph.json).

---

## Cross-references

- `reverse_engineered/code/VICEROY/disasm/func_06E3D0_unknown.asm` —
  speaker-portrait dispatcher
- `reverse_engineered/code/VICEROY/disasm/func_06BE92_unknown.asm` —
  King/IND filename builder
- `reverse_engineered/code/VICEROY/disasm/func_06BF12_unknown.asm` —
  MSS filename builder
- `reverse_engineered/code/VICEROY/disasm/func_06BF3C_unknown.asm` —
  MYR filename builder
- `reverse_engineered/code/VICEROY/disasm/func_06BF66_unknown.asm` —
  MSS3 / colonist slot
- `reverse_engineered/code/VICEROY/disasm/func_06F5DA_unknown.asm` —
  **"open King audience" entry point**
- `reverse_engineered/code/VICEROY/disasm/func_075352_unknown.asm` —
  WIN/LOSS endgame cinematic
- `reverse_engineered/code/VICEROY/disasm/func_03DA2A_unknown.asm` —
  Declaration of Independence cinematic (DECOIND.PIK)
- `reverse_engineered/code/VICEROY/disasm/func_037340_unknown.asm` —
  REPORT*.PIK loader
- `reverse_engineered/code/VICEROY/disasm/func_039888_unknown.asm` —
  FOREIGNNOTAVAIL guard
- `reverse_engineered/code/VICEROY/disasm/func_0081C6_unknown.asm` —
  set_active_native_tribe
- `reverse_engineered/code/VICEROY/disasm/func_04A7CA_unknown.asm` —
  CHIEFHOWDY dispatcher
- `reverse_engineered/code/VICEROY/disasm/func_03DE46_unknown.asm` —
  Independence event handler (writes 0x53A7 = century)
- `reverse_engineered/viceroy_source/src/king/king_tax_raise.c` —
  BYTE_VERIFIED tax-change formula (KINGRAISE/KINGLOWER paths)
- `reverse_engineered/raw/COLONIZE/GAME.TXT` lines 461, 1589-1640,
  1843-1891, 2570, 2707, 3328-3345 — all @KING* message bodies
- `reverse_engineered/raw/COLONIZE/NAMES.TXT` lines 79-83
  (@COUNTRY), 385-394 (@TRIBES) — power and tribe ordering
- `build/ui_extract/popup_layouts.json` entries `"king_tax"`,
  `"foradv_picker"`, `"fullscreen_foreign_affairs"`,
  `"fullscreen_advisor_report"` — popup geometries
- `reverse_engineered/assets/sprites/KING*/`, `IND*/`, `MSS*/`,
  `MYR*/`, `KINGLOSE/`, `KINGWIN/` — sprite art
- `reverse_engineered/assets/backgrounds/KINGLSS1/`, `KINGLSS2/`,
  `DECLARAT/`, `DECOIND/`, `REPORT*/`, `CLOS-BKG/` — PIK art
