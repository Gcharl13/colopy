# Input & Controls — mouse, keyboard, and per-screen bindings

> **Status: byte-traced 2026-06-25, partially independently re-verified.** This is the
> first consolidated input spec. The mouse `int 0x33` wrapper table and the keyboard
> `kbhit`/`getch` anchors were re-disassembled by hand and confirmed (see ledger).
>
> **Offset convention (important):** all `0xNNNN` code offsets in THIS file are **raw FILE
> offsets into `raw/COLONIZE/VICEROY.EXE`** (the byte at that position in the file), e.g.
> file `0xC9C5` = `int 0x33`. They are NOT DGROUP-relative logical addresses. Confirmed:
> `0xC9C2 mov ax,1 / 0xC9C5 int 0x33` (show cursor), `0xCCC7 mov ax,4 / 0xCCCA int 0x33`
> (set pos), `0xCD2B mov ax,3 / 0xCD2E int 0x33` (get pos). Globals like `0x7E8` are
> DGROUP offsets. An automated verifier that assumed `file = 0x2400 + addr` produced
> spurious mismatches on these; those are noted as **[convention]** in the ledger and are
> NOT real errors.
>
> **Corrections folded in from adversarial review:**
> - The two seed call sites `0x109E2` / `0x5A9F0` are **NOT** `int 0x33` — they are a
>   `CD 33` byte pair inside an unrelated instruction and inside an overlay far-pointer
>   data table, respectively (false positives; verified).
> - The mouse **left/right button discriminator** at `0x7E4` is **RESOLVED (2026-06-25)**:
>   it is `!(buttons & 1)`, not `(bl&1)`. Byte-exact at `0xD1A2-0xD1AE`
>   (`mov al,bl / and ax,1 / cmp ax,1 / sbb ax,ax / neg ax / mov [0x7E4],ax`):
>   `[0x7E4]=0` on a **left** click (bit0 set), `=1` on a **right** click (bit0 clear),
>   written only on a fresh press down-edge (gated by `or dx,dx / je` @`0xD198`). The
>   earlier `(bl&1)` claim was inverted; see the `func @0xD106` table below.
> - Menu-accelerator rows (`@ORDERS`/`@REPORTS`/`@CUP` etc.) are **string-table sourced**
>   (`data_extracted/text/*.json`, committed decoded data), not EXE-offset claims; the
>   key→action *labels* are byte-true from those tables, the *dispatch sites* are cited
>   separately where traced.
> - A few "enters screen X via chain Y" caller-chains were over-stated; treat multi-hop
>   call chains as indicative unless each hop carries its own offset.


## Mouse Input (int 0x33 driver, software cursor, click hit-testing)

All mouse handling lives in one resident module at file `0xC980–0xCF00` (RTLink
segment `0xA58`; module offset 0 = file `0xC980`, so `file_off = 0xC980 + module_off`).
Every `int 0x33` in `VICEROY.EXE` is inside this module — **8 real sites**, plus **2
false positives** (see below). The module wraps the Microsoft mouse driver, but when
running in VGA mode 13h it **suppresses the driver cursor and emulates everything in
software** via an installed event handler.

### 1. The 8 `int 0x33` wrappers (each AX byte-decoded)

| File off | AX | CX | DX | Driver fn | Enclosing module fn (file / module_off) | Purpose |
|---|---|---|---|---|---|---|
| `0xC9C5` | `1` | – | – | Show cursor | `show_cursor` @`0xC98D` / `0x00D` | Inc nesting counter `0xA899`, show |
| `0xCA05` | `2` | – | – | Hide cursor | `hide_cursor` @`0xC9D4` / `0x054` | Dec counter, hide |
| `0xCA67` | `0` | – | – | Reset / detect | `mouse_init` @`0xCA0C` / `0x08C` | Returns AX=0xFFFF if present |
| `0xCA7A` | `0x0F` | `8` | `0x18` | Set mickey/pixel ratio | `mouse_init` @`0xCA0C` | 8 mickeys/8px horiz, 0x18 vert |
| `0xCA83` | `3` | – | – | Get position+buttons | `mouse_init` @`0xCA0C` | In a `loopne` settle loop |
| `0xCB4B` | `0x14` | `1` | `0x207` | Swap interrupt subroutine | `mouse_init` @`0xCA0C` | ES:DX=`CS:0x207`, mask=1 → installs SW handler `evt_handler_A` |
| `0xCCCA` | `4` | (x*2) | (y) | Set cursor position | `move_to` @`0xCC8F` / `0x30F` | Warp cursor (only if real driver active) |
| `0xCD2E` | `3` | – | – | Get position+buttons | `get_pos` @`0xCD0B` / `0x38B` | Public poll entry; returns buttons in AX |

Notes, all byte-verified:
- **AX=0 detect** is gated by a DOS check first: `mouse_init` does `AX=0x3533;
  int 0x21` (`0xCA4D`) to fetch the int 0x33 vector, then rejects a null vector
  (`0xCA52` `or ax,bx`) or an `0xCF`/IRET stub (`0xCA5E` `cmp al,0xCF`). Only then
  `xor ax,ax; int 0x33` (`0xCA65`). Result stored to `0x83ac` ("real driver
  present", `0xCA9C`).
- **AX=0x14** (not 0x0C) is how the SW cursor handler is installed: `ES=CS`,
  `DX=0x207` (= module_off `0x207` = `evt_handler_A` @`0xCB87`), `CX=1` call mask.
  This is only executed when SW-emulation flag `0x92F8 != 0` (`0xCB37`), i.e. mode 13h.
  **The installed-handler behavior is therefore runtime-routed through the driver — see
  §4; the handler code itself is fully resolved at `0xCB87`/`0xCBEC`.**
- **AX=0x0F** sets mouse-to-pixel sensitivity; the per-axis SW scale used internally
  is the shift count `0x598`/`0x599` (set to 3 for most modes, `0xCAF1`).
- There is **no AX=7/8 (set X/Y range)** call anywhere; clipping is done in software
  (`cursor_clip` @`0xCE0C`).

### 2. How button state + cursor x/y reach the game

Public entry `get_pos(&x,&y)` @`0xCD0B` (module_off `0x38B`):
- If real driver active (`0x83ac != 0`), `AX=3; int 0x33` (`0xCD2E`) then `scale_pos`
  @`0xCCEB` shifts CX/DX right by the mickey-scale `0x598`.
- If SW-emulation (`0x92F8 != 0`), it instead reads the cached cursor `0x92FC`/`0x92FE`
  (kept current by the event handler) and forces buttons BX=0.
- Returns: `*x = CX` (`0xCD40`), `*y = DX` (`0xCD45`), and **AX = buttons** —
  `pop ax; or ax,[0x92fa]` (`0xCD47`). `0x92FA` is a button OR-mask, init'd to 0
  (`0xCAB5`) and not otherwise written in this module (reserved → effectively 0 here).

Callers wrap `get_pos` and latch the state into a block of input globals. The central
poll/edge-detector is `func @0xD106`:

| Global | Set at | Meaning |
|---|---|---|
| `0x7E8` | `0xD16C` arg | mouse X (current) |
| `0x7EA` | arg | mouse Y (current) |
| `0x7E6` | `0xD122` | raw buttons (AX from get_pos) |
| `0x7EE` | `0xD160` | previous buttons |
| `0x7F4` | `0xD140`/`0xD148` | "button just released" edge |
| `0x7F2` | `0xD19C`/`0xD168` | press latch |
| `0x7EC` | `0xD194` | down edge (this poll) |
| `0x7E4` | `0xD1AE` | which button (left vs right), written **only on a fresh press down-edge** (block gated by `or dx,dx / je 0xd1b1` @`0xD198`). **RESOLVED 2026-06-25:** value = `!(buttons & 1)` i.e. `[0x7E4]=0` when the **left** button bit is set (left click), `=1` otherwise (**right** click). Byte-exact: `0xD1A2 8A C3 mov al,bl` (bl = low byte of raw buttons latched from `[0x7E6]` @`0xD131`) → `0xD1A4 25 01 00 and ax,1` (isolate left-button bit0) → `0xD1A7 3D 01 00 cmp ax,1` → `0xD1AA 1B C0 sbb ax,ax` (AX=0xFFFF if left bit clear, 0 if set) → `0xD1AC F7 D8 neg ax` (AX=1 if left clear, 0 if left set) → `0xD1AE A3 E4 07 mov [0x7E4],ax`. So the prior `(bl & 1)` claim was inverted: the stored value is the **complement** of bit0 (a right-button flag). Sole writer (`A3 E4 07` appears exactly once); all readers test `[0x7E4]==0` vs nonzero (e.g. `cmp word [0x7e4],0` @`0x2438A`,`0x29C91`,`0x6ECBC`,`0x2A038`). |
| `0x7F0` | `0xD188`/`0xD18E` | "state changed since last poll" |
| `0x7F6` | `0xD1BB`/`0xD1C2` | any-button-currently-down |
| `0x7F8`/`0x7FA` | `0xD10C`/`0xD112` | X/Y snapshot at poll start (for movement test) |

Other `get_pos` callers: `0x2515`, `0x4DC9`, `0x5A58`, `0xD0EF`, `0xD11B`. `mouse_init`
is called once from `0x560B` as `init(0, 0x13)` (the `0x13` = VGA mode 13h, stored to
`0x9308` and driving the SW-emulation branch).

### 3. Cursor rendering — software sprite, not driver cursor

In mode 13h the hardware/driver cursor is never shown; the game blits a **16×16
software cursor** keyed on color `0xFF` (transparency):
- `cb_show_draw`/`blit_setup` @`0xCDD6` computes clip rectangle (`cursor_clip`
  @`0xCE0C`, via `lcall 0xD1C:0`), saves the background, then draws the cursor sprite.
- `cb_hide_draw` @`0xCDAD` restores the saved background.
- Core blit `0xCE98`: `rep movsb` rows, width=`AL`, src stride `BX=0x10`, dst stride
  `DX=0x140` (=320, screen width), `0x10` rows (`dec ah` loop).
- Transparency: `0xCEC0` `cmp al,0xFF` → skip pixel (read-through to background buffer
  at `0xFB00`).
- Save buffer seg/off in `0x586`/`0x588`; sprite source at `0xFA00`+`[0x5A8]`;
  cursor hotspot/clip in `0x5A0`/`0x5A2`/`0x5A4`/`0x5A6`.

The SW event handler keeps the on-screen cursor synced: `evt_handler_A` @`0xCB87` (the
AX=0x14-installed callback) switches to a private stack (`0x6CE`/`0x6D0`/`0x6D2` guard),
applies the mickey shift (`shr ax, [0x598]`), updates cached pos `0x92FC`/`0x92FE`
(`0xCBE2`), and calls the hide/show-draw callbacks. `enable_flag` @`0xCC4E` and
`handler_dispatch` @`0xCC60` arm/disarm redraw.

| Global | Meaning |
|---|---|
| `0xA899` | cursor show/hide nesting counter (signed; `0xFF` = hidden baseline, set `0xCA9F`) |
| `0x92F8` | SW-emulation flag (`0xFFFF` if mode==0x13 else 0; `0xCACB`/`0xCAD6`) |
| `0x83AC` | real driver present flag |
| `0x92FC`/`0x92FE` | cached cursor x/y (handler-maintained) |
| `0x598`/`0x599` | per-axis mickey→pixel shift |
| `0x590`/`0x592` | cursor hotspot (set by `set_bounds` @`0xCB59`, masks args `&0xF`) |

#### 3a. Amendment 2026-09-02 — the cursor image and its hotspot (screens track)

`CURSOR.SS` (2 frames, 17×17, a mandatory boot asset — exit code 0x17 @0x076153) is installed
by `func_00D9E0(sheet, frame)` @0x00D9E0 (`0x191F:0x468`): a 17×17 scratch surface (@0xD9E7)
filled with 0xFF (`mov al,0xff; lcall 0xb8d,4` @0xDA0E — the SW cursor's transparency key),
the frame blitted into it (`lcall 0xc36,0xa` @0xDA2C), then the **hotspot read off marker
pixels**: the last row whose column-16 pixel is opaque (`di` walks column 16 in steps of 0x11
@0xDA36..0xDA5A) and the last column of row 16 that is opaque (`[bp+si-0x22]` @0xDA51) —
both frames carry a single marker (index 9) at (16,0) and (0,16), so the **hotspot is (0,0)**.
The pair is stored at `[0x262C]/[0x262E]` (@0xDAB2..0xDAB7), passed to `0xA58:0x1D9`
(@0xDAC6), and the 16×16 top-left is copied to the mouse image `[0x9300]` (`bx=0x10` @0xDAEF,
`0xB8F:6` @0xDAF2) — the marker row/column never shows. Frame 1 (disk 0) is the arrow;
frame 2 (disk 1, the arrow with a box) is installed by the map-view pointer handler
`func_024342` when the button is held and `now − press_latch > 0x14` ticks of the 60.8766 Hz
clock (@0x243A3..0x243C3, latch `[0x2D0A:0x2D0C]` @0x2436E, flag `[0xB94]`), and the arrow
restored by `push 1` @0x24338. **B** (RULINGS 2026-09-02g). The P4 shell draws it so.

### 4. Click hit-testing — distributed, no central region table

The two seed "call sites" `0x109E2` and `0x5A9F0` are **FALSE POSITIVES**, not int 0x33:
- `0x109E2`: bytes `...EB CD 33 C0 AA...` — the `CD 33` is the tail of a `jmp` operand
  / a `stosb` in a string-escape parser (`0x109E0` `stosb; jmp 0x109B0`). Not an opcode.
- `0x5A9F0`: bytes `9E 32 00 00 CD 33 00 00` sit in an RTLink overlay far-pointer **data
  table** (region disassembles as garbage), not executable code.

So there is **no int 0x33-based hit-test**, and no single rectangle table. Hit-testing
is done by each UI screen reading the input globals (`0x7E8`/`0x7EA` x/y, `0x7E6`
buttons, edge flags `0x7EC`/`0x7F4`/`0x7F2`, `0x7E4` left/right) and comparing against
its own coordinates. The poll routine `0xD106` does motion detection (`cmp [0x7F8],ax`
at `0xD16F`) and edge detection but **dispatches nothing itself** — it only publishes
state. **Which screen owns the hit-test for a given click is per-game runtime state
(the active UI mode in BSS), but the per-screen region comparisons are NOT open — each
screen's rect set is byte-enumerated below: the Colony screen via `func @0x299A0`
(10 rects, §Colony screen) and the Europe screen via `func @0x3200A`/`@0x032034`
(8 rects, §Europe screen), both testing the input globals (`0x7E8`/`0x7EA` x/y,
`0x7E6` buttons, edges `0x7EC`/`0x7F4`/`0x7F2`, `0x7E4` left/right) through point-in-rect
`func_004B16 @0x4B16` (thunk `0x181F:0x3CA`); the minimap rect via `func_066CD6 @0x66CF4`.
Which of these owns a click is selected at runtime by the active-mode global, not a static
central table.**

### Summary of the public mouse API (segment `0xA58`)

| module_off | file | Name | Signature |
|---|---|---|---|
| `0x00D` | `0xC98D` | `show_cursor` | inc nesting, show |
| `0x054` | `0xC9D4` | `hide_cursor` | dec nesting, hide |
| `0x08C` | `0xCA0C` | `mouse_init` | `(retptr, video_mode)` → present flag |
| `0x1D9` | `0xCB59` | `set_hotspot` | `(x,y)` masked `&0xF` |
| `0x207` | `0xCB87` | `evt_handler_A` | driver callback (AX=0x14 installed) |
| `0x26C` | `0xCBEC` | `evt_handler_B` | secondary callback |
| `0x2CE` | `0xCC4E` | `enable_redraw` | re-arm SW cursor |
| `0x2E0` | `0xCC60` | `handler_dispatch` | run deferred redraw |
| `0x30F` | `0xCC8F` | `move_to` | `(x,y)` warp (AX=4) |
| `0x38B` | `0xCD0B` | `get_pos` | `(&x,&y)` → buttons in AX (AX=3) |

## Keyboard Input

MicroProse Colonization (DOS, VICEROY.EXE) drives **all** keyboard input through
BIOS **INT 16h polling**. There is **no custom INT 09h keyboard ISR** — the game
never installs a vector-9 handler (no `setvect`, no `getvect`, no IVT poke; see
§2). Every keystroke enters through two 13–15-byte C-runtime primitives —
`kbhit()` @0xD272 and `getch()` @0xD286 — which are wrapped by a small family of
resident "wait / poll / drain" helpers. Those helpers are invoked from overlay
UI code via the RTLink thunk table, and the returned key code is dispatched
**table-driven**, not by an inline `cmp` cascade (§3).

> Offset convention (per task): resident `file_off = 0x2400 + seg*16 + off`.
> All offsets below are **file offsets** into `raw/COLONIZE/VICEROY.EXE` unless a
> `seg:off` form is given.

### 1. Low-level read pipeline

| Function | File off | Mechanism | Returns (AX) |
|---|---|---|---|
| `kbhit` | `0xD272` | `MOV AH,1; INT 16h` (BIOS "Check Key") | `0` if no key pending (`JNE`→`XOR AX,AX`); else the buffered key unchanged (`AH`=scan, `AL`=ASCII) |
| `getch` | `0xD286` | `MOV AH,0; INT 16h` (BIOS "Get Key", blocking) | If `AL!=0`: ordinary ASCII → `XOR AH,AH` (AX=ASCII only). If `AL==0`: extended key → AX preserved (`AH`=scan code) |
| `wait_for_keypress` | `0x4A5C` | loop: refresh `LCALL 0x29F:0xF6` → `kbhit` (`LCALL 0xAE7:0x02`); on hit `getch` (`LCALL 0xAE7:0x16`); exit when key≠0 | AX = key from `getch` |
| `wait_keyOrClick` (was "0x4A80") | `0x4A80` | per-iteration: timer `LCALL 0xC0C:6`, cursor/UI ticks (`0xACB:0x30`,`0x29F:0xF6`,`0xACB:0x56`,`0xACB:0x11A`), then `kbhit`/`getch`; also samples a **mouse-click region** (`[0x826]`, coords vs `[0x7F4]`) so a click can satisfy the wait | AX = `getch` value in `DI`, or 0 (mouse) |
| `drain_keyboard_buffer` | `0x4AFA` | loop `kbhit`; if AX=0 exit, else `getch` (discard), repeat | — |

**AX key encoding (the model the whole game uses).** A keystroke is a 16-bit
value: `AL` = ASCII character, `AH` = BIOS scan code. `getch` @0xD286 normalizes
it: for an **ordinary printable key** it zeroes `AH` so the caller sees a clean
ASCII byte in `AL` (`32 E4 XOR AH,AH` at 0xD291); for an **extended key**
(arrows, function keys, keypad — BIOS delivers `AL=0`) it leaves `AH` intact so
the scan code survives (`0A C0 OR AL,AL` / `74 05 JE` at 0xD28D–0xD28F). Thus
callers distinguish "letter command" from "arrow/Fn command" purely by whether
`AH`/the high byte is non-zero. `kbhit` returns the **raw** BIOS value
(un-normalized) so it can be used as a boolean.

`wait_for_keypress` (0x4A5C) and `drain_keyboard_buffer` (0x4AFA) bracket the
buffer the classic DOS way: block-until-key for "press any key" prompts; flush
stale keystrokes after long operations so buffered input can't auto-advance the
next dialog.

### 2. INT 09h ISR — there is none

The seed's "int 0x09 appears 2×" is a **disassembly artifact**, confirmed by
byte inspection:

| Hit | Verdict |
|---|---|
| `0x22773` (`CD 09`) | **operand of `PUSH 0x09CD`** — the preceding byte is `0x68` (PUSH imm16) at 0x22772. Part of a `push 3 / push 0x09CD / lcall 0x181F:0x652` string-print sequence, not an opcode. |
| `0x36B6C` (`CD 09`) | sits inside a zero-filled data/table region (surrounded by `00 00` → `add [bx+si],al`), not executable code. |

Searches for the install/teardown of vector 9 return **nothing**: no `MOV
AX,2509h` / `MOV AX,0925h` (setvect), no `MOV AX,3509h` (getvect), no `MOV
AL,9 … INT 21h`, and no direct IVT poke to offsets `0x24`/`0x26` (`es:[9*4]`).
The third `INT 16h` "hit" at `0x5ABEC` is likewise data (zero-padded table), not
code. **Conclusion: keyboard handling is 100% BIOS INT 16h polling; the BIOS's
own INT 09h ISR fills the buffer, the game never replaces it, and there is no
game-side ctrl/shift-state ISR.**

> **CORRECTED 2026-08-07** (see `notes/rulings/RULINGS.md`): the earlier claim
> here that shift state "would come from `INT 16h AH=02h` — but no such call
> exists, so the game relies solely on the cooked AX" was **over-broad**. It is
> true of `INT 16h AH=02h` specifically, but the game DOES read live shift
> state another way: `func_004A22 @0x04A22` reads the **BIOS Data Area flag
> byte directly** (`0040:0017 & 3`) and passes it as the last argument to every
> cargo-transfer routine (`@0x2AF3E`, `@0x2BA0B`, `@0x2AE2C`, `@0x33AA0`,
> `@0x3367E`, `@0x334D1`, `@0x33516`) — that is the **shift-drag = partial
> amount** modifier for the drag-and-drop paths. Keyboard *keystrokes* remain
> cooked-AX only.

### 3. In-game key dispatch

The wait helpers have **no static (resident) callers** — they are reached only
from overlay UI code through the RTLink thunk table. The thunk records are
`LCALL 0x110D:0xD91` (loader stub) + `LJMP <seg>:<off>` (target); callers invoke
them as `LCALL <window>:<thunk_off>` (window 0x181F → thunk file
0x1A5F0–0x1B5EF):

| Helper | Caller-visible thunk | # overlay callers | Caller cluster |
|---|---|---|---|
| `wait_keyOrClick` @0x4A80 | `LCALL 0x181F:0x3C0` (record @file 0x1A9B0) | 34 | 0x21xxx, 0x37xxx–0x39xxx (main UI) |
| `idle_poll` @0x4D1E | `LCALL 0x181F:0x3AC` (record @file 0x1A99C) | 34 | 0x63xxx–0x65xxx (map interaction) |
| `drain` @0x4AFA | `LCALL 0x181F:0xEC` (record @file 0x1A6DC) | 5 + resident `LCALL 0x262:0xDA` @0x253D,0x57E5 | — |

**Dispatch is table-driven, not a `cmp` cascade.** Scanning the 80 bytes after
every `wait_keyOrClick` call yields almost no inline key comparisons — the
returned AX is used as an **index into per-key lookup tables**, e.g. at the
list/scroll handler `func @0x22E50`:

```
0x22E56  LCALL 0x181F:0x3C0      ; AX = wait_keyOrClick()  (key code)
0x22E5B  MOV   BX,AX
0x22E60  TEST  byte [BX+0x27ED],2 ; per-key flag table (bit1 = "fold case")
0x22E67  LEA   AX,[BX-0x20]       ; if set, subtract 0x20 (lower→UPPER ASCII)
0x22E6D  CMP   word [BP-4],0x48   ; 0x48 = BIOS up-arrow scan → page-scroll up
```

The key code indexes a **normalization/flag table at DS:0x27ED** (bit 2 = ASCII
case-fold, `-0x20`) and the action then dispatches through tables at
`[BX-0x6840]` and `[BX+0x2F7B]` (see the colony building-select handler
`func @0x2C692` below). Because the action targets are computed from those tables
at runtime, the **complete map-command → action map is runtime-composed** (mechanism byte-cited; the
per-key flag table `DS:0x27ED` and the action-code tables `DS:0x97C0` (command codes `0xAD..0xC0`,
snapshot-read) / `DS:0x2F7B` are indexed at dispatch — see "Unresolved" for the exact sites). **B (mechanism + table values) / runtime (the live key→action composition).**

**Byte-provable bindings.** The few keys compared by literal are:

| Key (AX) | Meaning | Site | Action (byte-cited) |
|---|---|---|---|
| `0x0D` | Enter / Return | `0x2C69F` (`CMP AX,0xD`) | select building slot `0x10` in colony build menu (`MOV [BP-0x14],0x10`) |
| `0x48` | up-arrow (BIOS scan 0x48) | `0x22E6D` (`CMP [BP-4],0x48`) | list/page scroll up (`MOV [BP-2],2` then scroll calls `0x191F:0x2A4/0x296/0x288`) |
| `0x12D` | internal "abort/cancel" key | `0x4D9A` (`CMP SI,0x12D`) in `idle_poll` | sets abort flag `byte [0x828]=1` → triggers cleanup `LCALL 0x181F:0x3D4` + `LCALL 0xD1D:0x30D` |
| `0x110` | internal "abort/cancel" key | `0x4DA0` (`CMP SI,0x110`) in `idle_poll` | same abort path (`[0x828]=1`) |

`idle_poll` @0x4D1E is the **interruptible idle/animation waiter**: it samples a
timer (`LCALL 0xC0C:6`), accumulates elapsed ticks in `[0x90/0x92]`/`[0x8C]`,
on a keypress reads `getch`→SI, immediately `drain`s, sets "input seen"
`[0x8A]=1`, checks the two abort codes, and also polls the mouse
(`LCALL 0xA58:0x38B`). It does **not** return the key to its caller (only the
`[0x8A]` flag) — so the 34 map-region callers use it for "wait, but let the user
break out," with the actual command read happening via `wait_keyOrClick`.

**Corroboration (function only, HIGH-trust per CLAUDE.md, not exact codes).**
`data_extracted/text/` confirms the control *vocabulary*: GAME.TXT — "sail to the
west ({left arrow})", "move the ship normally with the arrow keys", "the port of
your choice by pressing the '{G}' key"; MAPMENU.TXT lists "Mouse Commands /
Keyboard Commands" help; MAPEDIT.TXT "KEYBOARD COMMANDS … The {arrow} keys move
the cursor … The {space} or {enter} key paints". These match the scan-code
evidence (0x48=up-arrow, 0x0D=Enter) but the EXE bytes remain authoritative for
the numeric codes.

### Runtime-driven dispatch (exact site named)

| Item | Blocker | Exact site to trace |
|---|---|---|
| Full map-command keymap (every letter/Fn → action) | dispatch indexes runtime LUTs, no literal cascade | per-key flag table `DS:0x27ED`; action tables `[BX-0x6840]` (`func @0x2C71C/0x2C72F`) and `[BX+0x2F7B]` (`func @0x2C6FF`); fold rule `-0x20` @0x22E67 |
| Meaning of internal codes `0x110`/`0x12D` | values are pre-normalized game key codes, not raw BIOS AX | producer of `SI` in `idle_poll` @0x4D89 (raw `getch`) — needs the overlay normalizer that maps scan→`0x1xx`; the type-A thunk `LCALL 0x181F:0xC0E` (overlay-resolved input wrapper) is the likely site |
| `wait_keyOrClick` mouse-region gating globals | live UI state | `[0x826]`, `[0x7F4]`, click coords from `LCALL 0xACB:0x11A` @0x4AC6 |
| `wait_for_keypress` @0x4A5C callers | 0 static callers (called via computed far ptr) | sole data far-pointer to it is at file `0x47886` (`01B8:0ADC`) — overlay function-pointer table entry |

## Per-Screen Control Bindings (hotkeys, accelerators, click regions)

> **Consolidated from:** `spec/ui/*.md` (menus, map_view, colony_screen, europe_screen,
> context_dialogs, popups, advisor_reports), `docs/MENUS_VICEROY_DECODE.md`,
> `docs/GAME_MANUAL.md`, `data_extracted/text/{MENU,NAMES}_sections.json`, and a fresh
> disassembly pass of `raw/COLONIZE/VICEROY.EXE` for the dispatch ladders.
>
> **Trust tiers per CLAUDE.md:**
> - **B (byte)** — traced to a `func@0xNNNNN` immediate/`cmp` in the EXE, or to a verified
>   string-table accelerator key (`MENU`/`NAMES` `@`-section, which derives from `.TXT`).
> - **M (manual)** — `docs/GAME_MANUAL.md` prose only. HIGH trust for the *function* of a
>   binding, but the exact key→engine-id wiring is **not** statically pinned in a per-key
>   `cmp` (it is routed data-driven through the menu accelerators — see "Dispatch model").
> - **per-game state / overlay-resident** — value is computed at runtime or the dispatch lives in an overlay-resident caller; in every such case below the exact source global + producing/consuming func site is named (nothing is left un-cited).

### Dispatch model (how a key reaches an action) — B

The in-game command dispatcher is **`func_0235D6` @0x0235D6** (`enter 0x1e,0` =
`c8 1e 00 00`), reached via thunk **`0x181F:0x0F78`** (`9a 78 0f 1f 18`). It is a large
`switch ([bp+6])` where **`[bp+6]` is a normalized command/keypress id** (`mov ax,[bp+6];
cmp ax,0x1a` @0x235E2; `dec ax` ladder for ids 1..26; an out-of-range branch at @0x23DC8
`cmp ax,0x300` / `cmp ax,0x5c` / `cmp ax,0x31`; ENTER handled at `cmp ax,0xd` @0x23B8D).

- **F-key reports** are the only keys with an explicit per-key `cmp` ladder in this function
  (`func_0235D6`, region @0x023843–0x02390B). They compare BIOS-extended scancode-style ids
  in `[bp+6]` (see the REPORTS / F-keys table). **B.**
- **Menu-letter accelerators** (the `A`/`W`/`F`/`S`/`B`/`L`/`U`/… map commands, and the
  EUROPE `R`/`P`/`T`/`L`/`U`) are **NOT** decoded by a static per-letter `cmp` here. They are
  resolved by the menu/accelerator front-end from the **`game menu` data section** (built by
  `func_072090` @0x072090: opens section `"game"`/`"menu"` @0x0720BE, string literals at file
  `0x1FA38`/`0x1FA3D` = `67 61 6d 65 00 6d 65 6e 75`), whose rows carry the `~`-marked
  accelerator letters (below). The per-row→engine-command-id binding is **data-driven**, so
  the *accelerator letter* is **B** (string table) but the *handler each one invokes* is
  **runtime-dispatched (per-row id binding via `func_0235D6`)** — blocker: the binding lives in the `game menu` section, not a
  static per-row `cmp` — it is the runtime `game menu` ordinal → `func_0235D6` screen-router dispatch (no static per-row table; mechanism byte-cited in `menus.md` §15.5). **B (accelerator letter + dispatch mechanism) / runtime (per-row handler binding).** (`docs/MENUS_VICEROY_DECODE.md` §7.3.)

The `~` glyph in a `MENU`/`NAMES` section marks the **underlined accelerator letter** the
game draws and the key it binds (`GAME_MANUAL.md` lines 440–443: "a highlighted letter that
corresponds to the key"; menu pulldown is `Alt`+letter, line 40).

> **RUNTIME-CONFIRMED 2026-06-25 (live memory + screenshot).** Drove the game to an active
> unit and opened the ORDERS pulldown (`docs/screens/08_orders_menu.png`), then snapshotted
> DOS RAM (`tools/runtime_snapshot.py`). The live menu is built as a linked list of nodes
> (the `func_06C850` 0x18-byte node: two far-pointer links + the row label + a u8 row-index +
> a flag byte), and **each node carries the `~`-marked `MENU.TXT @ORDERS` label verbatim** —
> e.g. in RAM at DGROUP-region seg `0x668c`: `~Activate unit`, `~Wait for next unit`,
> `~Fortify`, `~Sentry`, `~Build Colony`, `Join Colony (~B)`, `Build ~Road`,
> `Begin ~Trade Route`, `No Orders (~s~p~a~c~e~ bar)`, `Disband Unit (~s~h~i~f~t~-~D)`. This
> proves the in-game accelerator key-match is driven by the `~` markers parsed from the live
> `MENU.TXT @ORDERS` rows (NOT the `NAMES @ORDERS`→`0x54de` table, which is the on-map
> status-letter glyph per `unit_orders.md §2.4`). The full `MENU.TXT @ORDERS` accelerator set:
> `A`ctivate / `W`ait / `F`ortify / `S`entry / `B`uild Colony / Join Colony `B` / Clear Forest
> `P` / Plow Fields `P` / Build `R`oad / `L`oad / `U`nload / `P`illage / `G`o to Port /
> `G`o to Place / Begin `T`rade Route / `R`eturn to Europe / No Orders = **spacebar** /
> Dump Cargo `O`verboard / Disband Unit = **shift-D**. This RESOLVED the one input item that had
> previously been flagged as needing a runtime trace (no longer open — closed by the live capture above).

---

### Main map view — top menu bar (pulldowns)

Click a title to open its dropdown; `Alt`+underlined-letter opens it from the keyboard
(`GAME_MANUAL.md` L40). Titles built by `func_072090`; dropdown opened/run/hit-tested by
`func_06E3D0` @0x06E3D0; row highlight = 1-px hollow outline `0x181F:0xCE` (RULING
2026-05-31). Per-title click-x origins are **R** (C-recon only) — blocker: bar-title draw is
overlay-resident (`MENUS_VICEROY_DECODE.md` §7.2, open item 1).

**Gesture model (B):** the pulldown is a HELD interaction — it lives only while the button
is down (`func_06E3D0` @0x6ECCF), re-hit-tests the rows on each poll where the moved flag
is set (@0x6E5B1, rects @0x6E5BB–0x6E667), and **commits the highlighted row on the RELEASE
edge** (@0x6EC70). So the native gesture is press-on-title → drag to the row → release.
(Port note 2026-08-08: the HTML port drives all three edges — press opens, held move tracks
rows and slides across bar titles, release commits — and additionally keeps the menu open
after a no-move release on the title so a plain click leaves a browsable pulldown; that
click-click mode is the port's own web convenience, not engine behaviour.)

| Key / region | Action | Tier | Citation |
|---|---|---|---|
| Click `~GAME` / Alt-G | open Game pulldown | B (title) / R (x) | `MENU @GAME` `~GAME`; `func_06E3D0` @0x06E3D0 |
| Click `~VIEW` / Alt-V | open View pulldown | B / R (x) | `MENU @VIEW` `~VIEW` |
| Click `~ORDERS` / Alt-O | open Orders pulldown | B / R (x) | `MENU @ORDERS` `~ORDERS` |
| Click `~REPORTS` / Alt-R | open Reports pulldown | B / R (x) | `MENU @REPORTS` `~REPORTS` |
| Click `~TRADE` / Alt-T | open Trade pulldown | B / R (x) | `MENU @TRADE` `~TRADE` |
| Click `~CHEAT` (`@CUP`) | open Cheat pulldown | B / R (x) | `MENU @CUP` `~CHEAT` |
| Click `~COLONIZOPEDIA` (`@PEDIA`) | open Colonizopedia pulldown | B / R (x) | `MENU @PEDIA` `~COLONIZOPEDIA` |

---

### Main map view — map commands (active unit / cursor)

The single-letter accelerators below come from `MENU @ORDERS`/`@VIEW` (`~`-marked) and are
corroborated verbatim by `GAME_MANUAL.md` "Map Commands" (L63–103). Accelerator letter = **B**
(string table); the handler-id wiring per row is **runtime data-driven** — the `~`-accelerator parsed from each `MENU @ORDERS`/`@VIEW` node is matched against the typed key in the menu engine (`func_06E3D0 @0x06E3D0`), the matched row-index selecting the command; per-game menu-node state, not a static per-row `cmp` (see Dispatch model).

| Key | Action | Tier | Citation |
|---|---|---|---|
| Arrow Keys | Move active unit / move cursor | M | `GAME_MANUAL.md` L67 |
| `A` | Activate unit | B (accel) / M | `MENU @ORDERS` `~Activate unit`; `GAME_MANUAL.md` L69 |
| `W` | Wait for next unit | B (accel) / M | `MENU @ORDERS` `~Wait for next unit`; `GAME_MANUAL.md` L71 |
| `Spacebar` | No orders this turn (skip) | B (accel) / M | `MENU @ORDERS` `No Orders (~s~p~a~c~e~ bar)`; `GAME_MANUAL.md` L76 |
| `F` | Fortify active unit | B (accel) / M | `MENU @ORDERS` `~Fortify`; `GAME_MANUAL.md` L78 |
| `S` | Sentry active unit | B (accel) / M | `MENU @ORDERS` `~Sentry`; `GAME_MANUAL.md` L81 |
| `B` | Build colony / Join colony with active unit | B (accel) / M | `MENU @ORDERS` `~Build Colony` / `Join Colony (~B)`; `GAME_MANUAL.md` L83/L85 |
| `P` | Clear forest / Plow field (Pioneer) | B (accel) / M | `MENU @ORDERS` `Clear Forest (~P)` / `Plow Fields (~P)`; `GAME_MANUAL.md` L88/L92 |
| `R` | Build Road (Pioneer) | B (accel) / M | `MENU @ORDERS` `Build ~Road`; `GAME_MANUAL.md` L96 |
| `G` | Go to named place / port | B (accel) / M | `MENU @ORDERS` `~Go to Port`/`~Go to Place`; `GAME_MANUAL.md` L100 |
| `O` | Dump cargo overboard (ship) | B (accel) / M | `MENU @ORDERS` `Dump Cargo ~Overboard`; `GAME_MANUAL.md` L102 |
| `L` | Load most valuable cargo (ship/wagon) | B (accel) / M | `MENU @ORDERS` `~Load Cargo`; `GAME_MANUAL.md` L67/L69 |
| `U` | Unload most valuable cargo (ship/wagon) | B (accel) / M | `MENU @ORDERS` `~Unload Cargo`; `GAME_MANUAL.md` L73 |
| `T` | Begin trade route | B (accel) / M | `MENU @ORDERS` `Begin ~Trade Route` |
| `Shift-D` | Disband (delete) active unit | B (accel) / M | `MENU @ORDERS` `Disband Unit (~s~h~i~f~t~-~D)`; `GAME_MANUAL.md` L77 |
| `E` | Return to / go to Europe screen | B (accel) / M | `MENU @ORDERS` `~Return to Europe`; `GAME_MANUAL.md` L84 |
| `V` | Put display in View mode | B (accel) / M | `MENU @VIEW` `~View Pieces`; `GAME_MANUAL.md` L80 |
| `M` | Put display in Move mode | B (accel) / M | `MENU @VIEW` `~Move Pieces`; `GAME_MANUAL.md` L82 |
| `H` | Show Hidden terrain | B (accel) / M | `MENU @VIEW` `Show ~Hidden Terrain`; `GAME_MANUAL.md` L91 |
| `Z` | Zoom in | B (accel) / M | `MENU @VIEW` `Zoom In#   ~Z`; `GAME_MANUAL.md` L86 |
| `X` | Zoom out | B (accel) / M | `MENU @VIEW` `Zoom Out   ~X`; `GAME_MANUAL.md` L89 |
| `C` | Center view on cursor / active unit | B (accel) / M | `MENU @VIEW` `~Center View`; `GAME_MANUAL.md` L93–95 |
| `F1` | Get terrain information (Terrain report) | B | dispatch `cmp [bp+6],0x48` @0x023843 → `0x191F:0x41A` (`advisor_reports.md` §3); `GAME_MANUAL.md` L97 |
| `ESC` | Exit game (to confirm/quit) | M | `GAME_MANUAL.md` L99 |

> Note: `MENU @ORDERS` also lists `~Pillage` and `~Activate unit`; the manual omits Pillage.
> The "Zoom Level 120×96/60×48/30×24/15×12" rows in `@VIEW` have **no** `~` accelerator
> (mouse/menu only). `~European Status` (`@VIEW`) and `Find Colony` likewise: `~European
> Status` binds the `E`-underline only within View, `Find Colony` has no accelerator.

---

### Main map view — click regions

| Region | Action | Tier | Citation |
|---|---|---|---|
| Click own colony tile | open Colony screen | B | `map_view.md §entry`; entry chain `func_L187 → set_active_colony (file 0x82DC) → 0x191F:0x1DE` (`COLONY_RENDER_CHAIN.md` §2) |
| Click foreign colony tile | sidebar trade view | A | `map_view.md` (overlay-measured) |
| Right-click anything | info popup for that object | M | `GAME_MANUAL.md` L433–435 |
| Minimap panel (241,8,79,41) | recenter / overview | B (rect) | `func_066CD6_minimap_panel` panel box `(0xF1,8,0x4F,0x29)` @0x66CF4 |
| Click-and-hold / drag | scroll-direction cursor | M | `GAME_MANUAL.md` L422–423 |

---

### Reports / advisor screens (F1–F10) — B (dispatch ladder)

Reached from the REPORTS pulldown or the F-key hotkeys. Each F-key is an explicit
`cmp [bp+6], <code>` in `func_0235D6` @0x023843–0x02390B (byte-verified this pass). The id in
`[bp+6]` is the BIOS-extended scancode-style code. Body offsets per `advisor_reports.md §3`.

| Key | Report | `[bp+6]` code | Dispatch site | Thunk | Body @file | Tier |
|---|---|---|---|---|---|---|
| F1 | Terrain Information | 0x48 | @0x023843 | 0x191F:0x41A | 0x3744A | B |
| F2 | Religious Adviser | 0x41 | @0x023854 | 0x191F:0x40C | 0x37958 | B |
| F3 | Continental Congress | 0x42 | @0x023865 | 0x191F:0x3FE | 0x37A10 | B |
| F4 | Labor Adviser | 0x43 | @0x023876 | 0x191F:0x3F0 | 0x38418 | B |
| F5 | Economic Adviser | 0x44 | @0x023887 | 0x191F:0x3E2 | 0x38A50 | B |
| F6 | Colony Adviser | 0x45 | @0x023898 | 0x191F:0x3D4 | 0x39218 | B |
| F7 | Naval Adviser | 0x46 | @0x0238A9 | 0x191F:0x3C6 | 0x3954C | B |
| F8 | Foreign Affairs | 0x47 | @0x0238BA | 0x191F:0x3B8 | 0x39888 | B |
| F9 | Indian Adviser | 0x49 | @0x0238CB | 0x191F:0x3AA (gated) | 0x39EE2 | B |
| F10 | Colonization Score | — (score path) | not in ladder | `func_03A9C0` | 0x3A9C0 | B |

- **F9 is gated:** `test byte [0x5383], 0x20` @0x0238D1 (`f6 06 83 53 20`); if the bit is set
  the dispatch diverts to `0x181F:0x574` @0x0238D8 (a broken-thunk landing — do not draw).
  Only when the bit is clear does F9 reach `push 1; lcall 0x191F:0x3AA` @0x0238E2. **B.**
- The dropdown row text for these is `MENU @REPORTS` (`~F~1 Terrain Information` … `~F~1~0
  Colonization Score`), matching the manual F-key list (`GAME_MANUAL.md` L52–61). **B.**

---

### Cheat menu (`@CUP` / "CHEAT") — B (accelerators)

Row text + accelerators from `MENU @CUP`. These are debug/cheat function keys; the per-row
handler binding is **runtime data-driven** — the `~`-accelerator parsed from each `MENU @CUP` row is matched in the menu engine (`func_06E3D0 @0x06E3D0`), the matched row-index selecting the cheat function; per-game menu-node state, not a static per-row `cmp` (see Dispatch model).

| Accelerator | Action | Tier | Citation |
|---|---|---|---|
| F01 | Create Unit | B (accel) | `MENU @CUP` `~F~0~1 Create Unit` |
| F02 | Debug Info Flags | B (accel) | `MENU @CUP` `~F~0~2 Debug Info Flags` |
| F04 | Reveal Map | B (accel) | `MENU @CUP` `~F~0~4 Reveal Map` |
| F05 | Set Human Player | B (accel) | `MENU @CUP` `~F~0~5 Set Human Player` |
| F06 | Kill Indians | B (accel) | `MENU @CUP` `~F~0~6 Kill Indians` |
| F07 | Advance Revolution Status | B (accel) | `MENU @CUP` `~F~0~7 Advance Revolution Status` |
| F08 | Show Strategy | B (accel) | `MENU @CUP` `~F~0~8 Show Strategy` |
| F09 | Show Colony Sites | B (accel) | `MENU @CUP` `~F~0~9 Show Colony Sites` |
| F010 | Test Routine | B (accel) | `MENU @CUP` `~F~0~1~0 Test Routine` |
| (none) | Sound Test / Memory Check | B (text only) | `MENU @CUP` (no `~` marker) |

---

### Colony screen

Entry: clicking an own colony (`func_L187 → entry stub @0x025EC8 → mov bx,0x2C; lcall
0x181F:0x772`). Key commands from `GAME_MANUAL.md` L114–134 (manual-sourced); the colony key
handler is not a static per-letter `cmp` (the keys drive the Multi-function display widget).

| Key | Action | Tier | Citation |
|---|---|---|---|
| `Tab` | Move highlight view→view | M | `GAME_MANUAL.md` L116 |
| Arrow Keys | Move highlight within a view | M | `GAME_MANUAL.md` L118 |
| `Enter` | Open Jobs menu for colonist/unit | M | `GAME_MANUAL.md` L119 |
| `L` | Load most valuable cargo | M | `GAME_MANUAL.md` L120 |
| `=` | Load all of selected cargo | M | `GAME_MANUAL.md` L121 |
| `+` (Shift-=) | Load some of selected cargo | M | `GAME_MANUAL.md` L122/L146 |
| `U` | Unload cargo from ship | M | `GAME_MANUAL.md` L123 |
| `-` | Unload all of selected cargo | M | `GAME_MANUAL.md` L124 |
| `_` (Shift--) | Unload some of selected cargo | M | `GAME_MANUAL.md` L125 |
| `M` | Toggle views in Multi-function display | M | `GAME_MANUAL.md` L126 |
| `1` | Show Production view | M | `GAME_MANUAL.md` L127 |
| `2` | Show Units view | M | `GAME_MANUAL.md` L128 |
| `3` | Show Construction view | M | `GAME_MANUAL.md` L129 |
| `N` | Toggle production Numbers on/off | M | `GAME_MANUAL.md` L130 |
| `C` | Open Construction menu | M | `GAME_MANUAL.md` L131 |
| `B` | Buy current construction project | M | `GAME_MANUAL.md` L132 |
| `F1` | Get info about selected item | M | `GAME_MANUAL.md` L133 |
| `ESC` | Exit and return to Map | M | `GAME_MANUAL.md` L134 |

**Click regions** — byte-cited from the colony-screen hit-test routine **`func @0x299A0`**
(`enter 2,0`; default region id `0x14`), which tests these rects against the mouse globals
via point-in-rect `0x181F:0x3CA` (`func_004B16` @0x4B16; see §4). Each row is
`push h; push w; push y; push x; lcall 0x181F:0x3CA; or ax,ax; je next; mov [bp-2],<id>`. The
rects match the `colony_screen.md` paint rects 1:1 (RESOLVED 2026-06-25).

| Rect (x,y,w,h) | Region-id | Region / action | Tier | Citation |
|---|---|---|---|---|
| (0,0,320,7) | 0xA | top title bar | B | `func @0x299A0` `@0x29AA9` |
| (0,8,199,120) | 2 | main scene / work-area left | B | `@0x29A11` |
| (200,8,120,120) | 1 | field-production / right scene panel | B | `@0x299A9` |
| (0,130,120,48) | 0 | colonist plaza row (`func_0270D0`) | B | `@0x299F1` |
| (121,130,84,48) | 8 | surrounding-tile minimap (`func_027DB2`) | B | `@0x29A8D` |
| (211,130,91,48) | 4 | SoL / cargo / message panel (`func_02814C`) | B | `@0x29A70` |
| (303,132,17,45) | 3 | nation flag panel (`func_028540`) | B | `@0x29A32` |
| (0,179,305,21) | 5 | 16-commodity stockpile strip (`func_0281D6`) | B | `@0x29A52` |
| (305,179,15,21) | 9 | warehouse / gold readout (heap string `[0x2F5E]`, NOT gold) | B | `@0x299D2`; draw `@0x0283F1` |
| (anywhere else) | 0x14 | no region (default) | B | `@0x299A4 mov [bp-2],0x14` |

> The `AX` return of `func @0x299A0` is the **region-id** built in `[bp-2]` (the 0/1/2/3/4/5/8/9/0xA/0x14
> table above; default `0x14` @0x299A4) — fully decoded. The downstream id→action `switch` lives in
> the overlay-resident caller (reached via RTLink thunk; no static far-call to `0x299A0` exists in the
> resident image, scan-confirmed), so the action targets per id are **overlay-resident** and would need
> an overlay-page trace of that caller to tabulate (see Open blockers).

---

### Europe screen

Key commands from `GAME_MANUAL.md` L159–184 (manual-sourced; the `R`/`P`/`T` recruit/purchase/
train accelerators correspond to the painted `@EUROLABEL` rows in `europe_screen.md §1`). The
"Exit = `x`/ESC" is byte-corroborated: `@EUROLABEL` 4th token `"x"` drives the generic screen
close (`europe_screen.md §4`, RESOLVED 2026-06-23).

| Key | Action | Tier | Citation |
|---|---|---|---|
| `Tab` | Move highlight area→area | M | `GAME_MANUAL.md` L168 |
| Arrow Keys | Move highlight within a view | M | `GAME_MANUAL.md` L169 |
| `Enter` | Open dock options (colonist) / harbor options (ship) | M | `GAME_MANUAL.md` L170–171 |
| `L` | Buy full load of selected cargo | M | `GAME_MANUAL.md` L172 |
| `=` | Buy full load of selected cargo | M | `GAME_MANUAL.md` L173 |
| `+` | Buy some of selected cargo | M | `GAME_MANUAL.md` L174 |
| `U` | Sell cargo from ship | M | `GAME_MANUAL.md` L175 |
| `-` | Sell all of selected cargo | M | `GAME_MANUAL.md` L176 |
| `_` | Sell some of selected cargo | M | `GAME_MANUAL.md` L177 |
| `R` or `1` | Open recruit menu | M | `GAME_MANUAL.md` L178 |
| `P` or `2` | Open purchase menu | M | `GAME_MANUAL.md` L180 |
| `T` or `3` | Open train menu | M | `GAME_MANUAL.md` L181 |
| `F1` | Get info about selected item | M | `GAME_MANUAL.md` L182 |
| `ESC` or `E` | Exit and return to map | B (`x`/ESC) / M (`E`) | `@EUROLABEL` `"x"` token (`europe_screen.md §4`); `GAME_MANUAL.md` L183 |

**Click hit-test rects** — byte-cited from the Europe hit-test routine **`func @0x3200A`**
(`enter 2,0`; default region id `0xF`), point-in-rect `0x181F:0x3CA` (= `func_004B16` @0x4B16;
see §4), `europe_screen.md §4`. **Note (corrected 2026-06-25):** the function ENTRY is `0x3200A`,
not `0x032034` — `0x032034` is the body of the *second* rect block (the id-5 recruit pool). Each
row is `push h; push w; push y; push x; lcall 0x181F:0x3CA`:

| Rect (x,y,w,h) | Click-id | Action | Tier | Citation |
|---|---|---|---|---|
| (281,89,37,32) | 5 | Recruit/Purchase/Train pool | B | `@0x032034` (`europe_screen.md §4`) |
| (143,118,81,60) | 1 | Dock A (ships) | B | `@0x032034` |
| (72,118,70,51) | 2 | "Bound For" panel | B | `@0x032034` |
| (1,118,70,51) | 3 | "Loading" panel | B | `@0x032034` |
| (224,120,96,59) | 4 | "Expected" panel | B | `@0x032034` |
| (0,179,305,21) | 0 | Market price row (buy/sell cell; sell handler @0x32914) | B | `@0x032034`; `europe_screen.md §6` |
| (305,179,15,21) | 0xB | Stockpile/gold readout zone | B | `@0x3200E-0x3201A` (`push 0x15; push 0x0F; push 0xB3; push 0x131` — x = **0x131 = 305**; CORRECTED 2026-08-07: this row previously read 306 with the citation `@0x032034`, which is the id-**5** block, not id 0xB) |
| (Exit) | — | leave Europe | B (clickable) / B (paint mechanism) / A (pixel) | click-rect = region 0xB `@0x3200E-0x3201A` (x=305; the old `@0x032034` cite was the id-5 block); paint = framework chrome from the generic screen-view runner `func_077D5E` (region load_image), reached via `0x181F:0x772` (screen-view id 0x2B) — NOT a Europe-page draw, so the Europe composer paints no Exit button (RESOLVED 2026-06-27, `europe_screen.md` §0 lines 15-19). On-screen position white "Exit" `(306,179)` + red "E" `(308,187)`, measured from live capture `docs/screens/10_europe_screen.png` (A) |

---

### Boot / main menu — B

Runner `BEGINMENU` via `func_06F594` (`lea bx,[0x2345]; lcall 0x181F:0x3FE` @0x075C60,
`8d 1e 45 23 9a fe 03 1f 18`), returns 1-based index; `dec ax` selection ladder @0x075C6D
selects the branch (`MENUS_VICEROY_DECODE.md` §3).

| Key / region | Action | Tier | Citation |
|---|---|---|---|
| Arrow keys | move highlight bar | B | `menus.md §3` (nav keys) |
| `Enter` (13) | select highlighted item | B | `menus.md §3` |
| `Esc` (27) | cancel / exit | B | `menus.md §3` |
| `Space` (32) | (advance) | B | `menus.md §3` |
| Digit / first-letter | jump to item (hotkey) | B | `menus.md §3` |
| Item 1 "Start … NEW WORLD" | exit branch `jmp 0x75F8D` | B | `dec ax` ladder @0x075C6D–0x075C70 |
| Item 2 "Start … AMERICA" / LOAD | `jmp 0x75DEA` | B | @0x075C75 |
| Item 3 "CUSTOMIZE" | setup loop @0x75C86 | B | @0x075C75 (`jle`) |
| Item 4 "LOAD Game" | new-game `jmp 0x75EB0` → begin_game | B | @0x075C7E (`jne`) |
| Item 5 default | exit `jmp 0x75F8D` | B | @0x075C83 |

> The exact item-text→branch *wording* follows `@BEGINMENU` option order; branch **targets**
> are byte-verified, the per-line→branch binding follows option order (`MENUS_VICEROY_DECODE.md`
> §3.1). Difficulty/Nation pickers are mouse-grid + same nav keys (`menus.md §7`).

---

### Modal dialogs / popups (shared engine) — B

All event popups, the unit-orders/ship-orders menu, trade-route setup, and native-village
actions run through the shared centered-dialog engine: BUILD parser `func_06F0F4` @0x06F0F4
(`@`-key check `cmp byte [bx],0x40` @0x06F193); RUN + hit-test `func_06E3D0` @0x06E3D0; modal
wait `0x181F:0x3C0` (`func_004A80`, draws nothing). Row highlight = `0x181F:0xCE` 1-px hollow
outline.

| Key / region | Action | Tier | Citation |
|---|---|---|---|
| Arrow keys | move highlighted row | B | `func_06E3D0` (`context_dialogs.md §3`) |
| `Enter` / OK row click | confirm selection | B | wait loop `0x181F:0x3C0` (`popups.md §2`); `GAME_MANUAL.md` L584 |
| `Spacebar` / Enter / click | dismiss message popup | M | `GAME_MANUAL.md` L584 |
| Click a row | select that option | B | hit-test `func_06E3D0`; row outline `0x181F:0xCE` |

**Unit / ship orders menu** — option text from `GAME @UNITOPTIONS`/`@SHIPOPTIONS`/
`@EUROPESHIPOPTIONS`/`@ARMOPTIONS` (`context_dialogs.md §4`, `directives={}` bare lists).
**B (lists).** The order short-code/status table is `NAMES @ORDERS`
(`No Orders,-` / `Sentry,S` / `Trade Route,T` / `Go To,G` / `Live In Village,L` / `Fortify,F` /
`Build Colony,B` / `Clear/Plow,P` / `Build Road,R`) — label + single-letter code columns,
**B** (`NAMES_sections.json @ORDERS`).

**Native-village action menu** — `NAMES @ACTIONS` (10 lines: Trade With Village … Cancel
Action), per-row show/enable gating `func_04B308` (`enter 0xba`). **B (list + gating).**

---

### Open blockers (carried)

1. **Map/Europe/colony letter-key → handler-id binding** is data-driven through the `game
   menu` section, not a static per-key `cmp` — accelerator letters are **B**, the handler each
   invokes is bound at **runtime by the menu engine** — the `~`-accelerator parsed from each `game menu` node (built `func_06C850`) is matched against the typed key inside `func_06E3D0 @0x06E3D0`, the matched row-index selecting the command; per-game menu-node state, not a static per-key `cmp` (`MENUS_VICEROY_DECODE.md` §7.3).
2. **Top-bar per-title click-x origins** — **R** (C-recon); bar-title draw is overlay-resident
   (open item 1).
3. **Europe Exit-button paint origin** — RESOLVED 2026-06-27: the Exit glyph is **framework
   chrome from the screen-view runner** (`0x181F:0x772 → file 0x077D5E`, EXIT.SS), not a
   europe-page draw; rendered as white "Exit" `(306,179)` + red "E" accelerator `(308,187)`
   (`europe_screen.md` §1/L57). The click-rect is `@0x032034`.
4. **Colony-screen Multi-function key handler** — all colony letter/number keys are
   **manual-sourced (M)**; no per-key `cmp` located in the static export.

---

## Appendix: independent-verification ledger

Each load-bearing byte assertion was checked by an independent adversarial agent. `[convention]` marks a spurious mismatch caused by the file-vs-logical offset confusion (the underlying content is correct — see front-matter). `[content]` marks a genuine dispute that was folded into the text above (struck, or downgraded to a named runtime/data-driven source).

### input_mouse — 22/29 independently confirmed

| ✓ | claim | cite | note |
|---|-------|------|------|
| ⚠️ | All mouse handling is in a resident module at file 0xC980-0xCF00, RTLink segment 0xA58 (module_off 0 = file 0xC980) | thunks_resolved.json formula file_off=0x2400+seg*16+off; seg | [convention] Core identification VERIFIED, but the stated byte RANGE is wrong on its upper bound. Confirmed independently from raw/COLONIZE/VICEROY.EXE (capstone CS_MODE_16): (1) base formula file_off=0x2400+seg*16+off is correct — MZ heade |
| ✅ | There are exactly 8 real int 0x33 sites: 0xC9C5,0xCA05,0xCA67,0xCA7A,0xCA83,0xCB4B,0xCCCA,0xCD2E | regex CD 33 over VICEROY.EXE | Independently confirmed via capstone CS_MODE_16. All 10 raw "CD 33" byte matches exist at exactly the offsets in the evidence (0xc9c5,0xca05,0xca67,0xca7a,0xca83,0xcb4b,0xccca,0xcd2e,0x109e2,0x5a9f0). A single contiguous disassembly of the  |
| ⚠️ | 0xC9C5 is AX=1 show cursor | func_006... show_cursor @0xC98D; 0xC9C2 mov ax,1; 0xC9C5 int | [convention] FALSE on every point. File offset for resident 0xC9C5 = 0x2400+0xC9C5 = 0xEDC5. Disassembling (CS_MODE_16) from the function start 0xC98D yields honest instruction boundaries. CLAIM "0xC9C2 mov ax,1": actual bytes at file 0xEDC |
| ✅ | 0xCA05 is AX=2 hide cursor | hide_cursor @0xC9D4; 0xCA02 mov ax,2; 0xCA05 int 0x33 | Independently re-disassembled VICEROY.EXE (capstone CS_MODE_16) at the cited file offsets. hide_cursor @0xC9D4 disassembles cleanly and the cited bytes match exactly: 00ca02 b8 02 00 = mov ax,2; 00ca05 cd 33 = int 0x33; 00ca07 fe 0e 99 a8 = |
| ✅ | 0xCA67 is AX=0 reset/detect inside mouse_init, gated by DOS int21 AH=0x35 vector check | mouse_init @0xCA0C | All six evidence lines decode exactly as claimed (cited values are RAW FILE offsets, not the 0x2400+seg*16+off resident formula given in the harness instructions — that formula yields an unrelated RLE-decode loop here; the bytes only match  |
| ✅ | 0xCA7A is AX=0x0F set mickey/pixel ratio with CX=8, DX=0x18 | mouse_init @0xCA0C | Independently re-disassembled VICEROY.EXE with capstone CS_MODE_16. At file offsets matching the evidence labels, the bytes decode EXACTLY as claimed: 0xca71 b80f00 = mov ax,0xf; 0xca74 b90800 = mov cx,8; 0xca77 ba1800 = mov dx,0x18; 0xca7a |
| ✅ | 0xCA83 is AX=3 get position+buttons in a settle loop | mouse_init @0xCA0C | Independently re-disassembled raw/COLONIZE/VICEROY.EXE with capstone CS_MODE_16. At file offset 0xca80 bytes b8 03 00 = `mov ax,3`; at 0xca83 bytes cd 33 = `int 0x33`. INT 33h with AX=3 is the standard DOS mouse driver call "get pointer pos |
| ⚠️ | 0xCB4B is AX=0x14 (swap interrupt subroutine) installing SW handler at CS:0x207 with call mask CX=1 | mouse_init @0xCA0C, only when 0x92F8!=0 | [convention] FAILS under the mandated offset convention. The verification rule states resident file_off = 0x2400 + seg*16 + off, and the MZ header is exactly 0x2400 bytes (e_cparhdr=576), so resident offset R must be read at file 0x2400+R.  |
| ⚠️ | 0xCCCA is AX=4 set cursor position, only if real driver active (0x83ac!=0) | move_to @0xCC8F | [convention] FALSE on every point. Independent capstone CS_MODE_16 disasm at file_off=0x2400+resident addr:  - 0xCCCA: actual bytes are `3c fd` = `cmp al, 0xfd` — NOT `cd 33` (int 0x33). The claimed "AX=4 set cursor position" mouse call doe |
| ✅ | 0xCD2E is AX=3 get position+buttons, public get_pos entry | get_pos @0xCD0B | Bytes independently re-disassembled from raw/COLONIZE/VICEROY.EXE with capstone CS_MODE_16. At cd2e the bytes are cd 33 (int 0x33), preceded at cd2b by b8 03 00 (mov ax,3). INT 33h AX=3 is the documented mouse-driver "Get Position and Butto |
| ✅ | get_pos returns buttons in AX via 'pop ax; or ax,[0x92fa]' and writes *x=CX,*y=DX | get_pos @0xCD0B | VERIFIED. Re-disassembled raw/COLONIZE/VICEROY.EXE with capstone CS_MODE_16. The cited evidence offsets (00cd40..00cd48) are listing/file offsets and decode to exactly the claimed instructions. Raw bytes at file offset 0xcd40: 89 0f 8b 5e 0 |
| ✅ | SW-emulation flag 0x92F8 is set 0xFFFF when video mode==0x13 else 0 | mouse_init @0xCA0C | Independently re-disassembled VICEROY.EXE (capstone CS_MODE_16) at file offset 0xcac8. All four cited instructions verify byte-for-byte: 0xcac8 a10893 = mov ax,[0x9308]; 0xcacb c706f892ffff = mov word [0x92f8],0xffff; 0xcad1 3d1300 = cmp ax |
| ✅ | In SW-emulation get_pos uses cached cursor 0x92FC/0x92FE and BX=0 buttons | get_pos @0xCD0B | Independently disassembled VICEROY.EXE (capstone CS_MODE_16) at file offset 0xCD0B. get_pos prologue: 0xcd0b enter 0,0; 0xcd0f xor bx,bx. Every cited evidence line decodes byte-for-byte exactly as claimed: 0xcd11 `833ef89200` = cmp word ptr |
| ✅ | Real-driver-present flag is 0x83ac, set from detect result in mouse_init | mouse_init @0xCA0C | VERIFIED. Independently disassembled VICEROY.EXE with capstone CS_MODE_16. At file offset 0xca0c the bytes decode to a function with prologue `enter 2,0` (file_off 0xca0c, bytes c8020000) creating local [bp-2], consistent with mouse_init. T |
| ✅ | Cursor visibility nesting counter is byte 0xA899, baseline 0xFF=hidden | mouse_init @0xCA0C and show/hide_cursor | CONFIRMED by independent re-disassembly (capstone CS_MODE_16, file_off=0x2400+resident). The byte counter at DS:[0x A899] is fully corroborated:  - mov byte [0xa899],0xff  -> bytes c6 06 99 a8 ff at FILE 0xCA9F (resident 0xA69F), inside the |
| ✅ | The AX=0x14-installed SW handler is evt_handler_A at module_off 0x207 = file 0xCB87 | mouse_init DX=0x207; module base 0xC980 | Independently confirmed against raw/COLONIZE/VICEROY.EXE (capstone CS_MODE_16). INSTALL: at file 0xCB3E I disassembled `mov ax,cs; mov es,ax; mov dx,0x207 (BA 07 02); mov cx,1 (B9 01 00); mov ax,0x14 (B8 14 00); int 0x33 (CD 33)`. INT 33h A |
| ✅ | Software cursor is 16x16, keyed on transparent color 0xFF, blitted with screen stride 0x140 (320) | blit core @0xCE98, cb_show_draw @0xCDD6, cb_hide_draw @0xCDA | Independently re-disassembled VICEROY.EXE (capstone CS_MODE_16) at the cited file offsets. The conclusion (16x16 software cursor, transparency key 0xFF, screen stride 0x140=320) decodes exactly and follows from the bytes.  Verified bytes/in |
| ⚠️ | Cursor background save buffer seg/off are globals 0x586/0x588; sprite source 0xFA00+[0x5A8] | cb_hide_draw @0xCDAD, blit_setup @0xCDD6 | [convention] CONTENT is byte-accurate but the CITE OFFSETS are wrong, so the claim fails under the task's own address convention.  Stated convention: resident file_off = 0x2400 + seg*16 + off, where the cited @0xNNNN is the resident (seg*16 |
| ✅ | Per-axis mickey-to-pixel scale is shift count byte 0x598 (set to 3 for non-mode13 cases) | mouse_init @0xCA0C, scale_pos @0xCCEB, evt_handler | VERIFIED by independent re-disassembly (Capstone CS_MODE_16). All claimed evidence bytes decode exactly as stated. At file offset 0xCAF1: B0 03 = `mov al,3`; 0xCAF3: A2 98 05 = `mov byte [0x598],al` (followed by A2 99 05 = `mov [0x599],al`) |
| ⚠️ | Cursor hotspot globals 0x590/0x592 are set by set_hotspot @0xCB59 masking args &0xF | set_hotspot @0xCB59 | [convention] Substantively the claim is CORRECT but the cited addresses are MISLABELED, so it fails exact verification under the task's stated convention. Facts: a function whose prologue (enter 0,0) is at FILE offset 0xCB59 masks both word |
| ✅ | mouse_init is called once as init(0,0x13) from 0x560B (0x13 = VGA mode 13h) | caller @0x560B | Independently re-disassembled VICEROY.EXE (capstone CS_MODE_16). At file offsets 0x5607-0x560b the bytes decode exactly as claimed: 005607: 6a 13 = push 0x13; 005609: 6a 00 = push 0; 00560b: 9a 8c 00 58 0a = lcall 0xa58,0x8c; then 005610: 8 |
| ✅ | get_pos (module_off 0x38B) is called from 0x2515,0x4DC9,0x5A58,0xD0EF,0xD11B | far-call scan 9A xx 8B03 58 0A | Independently re-disassembled all 5 cited file offsets in raw/COLONIZE/VICEROY.EXE using capstone CS_MODE_16. Each of 0x2515, 0x4DC9, 0x5A58, 0xD0EF, 0xD11B contains bytes 9A 8B 03 58 0A and decodes to `lcall 0xa58, 0x38b` (far call to seg  |
| ✅ | Central input poll/edge-detector is func @0xD106; publishes mouse globals 0x7E6-0x7FA but dispatches nothing | func @0xD106 | VERIFIED via independent capstone CS_MODE_16 re-disassembly of raw/COLONIZE/VICEROY.EXE.  Addressing note: the cite "@0xD106" and all sub-offsets (0xd11b/0xd122/0xd160/0xd140/0xd194) are FILE offsets, matching the repo's own disasm-snapshot |
| ⚠️ | Button discriminator left/right is (bl & 1) stored to 0x7E4 | func @0xD106 | [convention] CLAIM IS FALSE. Independently disassembled VICEROY.EXE with capstone CS_MODE_16, file_off = 0x2400 + resident (MZ header e_cparhdr=576 paras = 9216 = 0x2400, confirms the mapping). At the cited offsets the bytes decode to a spr |
| ✅ | Mouse X/Y current state globals are 0x7E8/0x7EA; poll-start snapshot 0x7F8/0x7FA for motion test | func @0xD106 | VERIFIED. Re-disassembled VICEROY.EXE (CS_MODE_16) independently. Function starts at file offset 0xD106 with a clean prologue `55 8bec` (push bp; mov bp,sp), confirming 0xD106 is the function entry. Every cited instruction decodes exactly:  |
| ✅ | 0x109E2 is a FALSE POSITIVE, not int 0x33 — the CD 33 bytes are inside a string-escape parser instruction stream | bytes at 0x109E2 and aligned disasm | VERIFIED. Raw bytes at file_off 0x109E2 in raw/COLONIZE/VICEROY.EXE: cd 33 c0 aa (preceding context b0 22 aa eb cd... starting 0x109DE), matching the evidence exactly. Re-disassembled with capstone CS_MODE_16 from 5 independent start anchor |
| ✅ | 0x5A9F0 is a FALSE POSITIVE — CD 33 lies in an RTLink overlay far-pointer data table, not code | bytes at 0x5A9F0 and disasm | Independently confirmed from raw/COLONIZE/VICEROY.EXE. Bytes at file offset 0x5A9F0 = `cd 33 00 00`, matching the given evidence (full context 0x5A9EC: `9e 32 00 00 cd 33 00 00`). Disassembling linearly in CS_MODE_16 from a dword-aligned bo |
| ✅ | There is no AX=7/8 (set X/Y range) int 0x33 call anywhere; clipping is done in software via cursor_clip @0xCE0C | AX-per-site scan of module 0xC98D-0xCE40 | VERIFIED via independent capstone CS_MODE_16 disassembly of raw/COLONIZE/VICEROY.EXE. The cited module range 0xC98D-0xCE40 (and cursor_clip @0xCE0C) are FILE offsets (decoding at file 0xCE0C yields the claimed code; the resident formula 0x2 |
| ✅ | 0x92FA is a button OR-mask init'd to 0 and not otherwise written in the module (effectively 0) | writes scan + mouse_init @0xCA0C | VERIFIED true (addresses are raw FILE offsets, consistent with the evidence labels). Re-disassembled independently with capstone CS_MODE_16.  WRITE: file_off 0xcab5 bytes c7 06 fa 92 00 00 = `mov word ptr [0x92fa], 0`; immediate decodes to  |

### input_keyboard — 14/18 independently confirmed

| ✓ | claim | cite | note |
|---|-------|------|------|
| ⚠️ | kbhit @0xD272 issues INT 16h AH=1 (BIOS Check Key) and returns AX=0 when no key is pending, else the buffered key unchanged | func_00D272_kbhit @0xD272 | [convention] Bytes at file offset 0xD272 decode exactly as the evidence states (verified via capstone CS_MODE_16, reading VICEROY.EXE directly): 0xD272 55 push bp; 0xD273 8B EC mov bp,sp; 0xD275 B4 01 mov ah,1; 0xD277 CD 16 int 0x16; 0xD279 |
| ⚠️ | getch @0xD286 issues INT 16h AH=0 (BIOS blocking Get Key); for ordinary ASCII (AL!=0) it zeroes AH, for extended keys (AL==0) it preserves A | func_00D286_getch @0xD286 | [convention] The ASCII-path bytes match exactly: @0xD289 B4 00 MOV AH,0; @0xD28B CD 16 INT 0x16 (AH=0 = BIOS blocking Get Keystroke); @0xD28D 0A C0 OR AL,AL; @0xD28F 74 05 JE 0xD296; @0xD291 32 E4 XOR AH,AH; @0xD293 C9 LEAVE. So the part "i |
| ✅ | wait_for_keypress @0x4A5C loops calling refresh helper 0x29F:0xF6, then kbhit (LCALL 0xAE7:0x02), and on a hit getch (LCALL 0xAE7:0x16), ret | func_004A5C_wait_for_keypress @0x4A5C | Independently disassembled file offset 0x4A5C in raw/COLONIZE/VICEROY.EXE with capstone CS_MODE_16. All five cited evidence bytes decode exactly as claimed: 0x4A62 9A F6 00 9F 02 = lcall 0x29F,0xF6 (refresh helper); 0x4A67 9A 02 00 E7 0A =  |
| ✅ | LCALL 0xAE7:0x02 resolves to kbhit @0xD272 (0x2400+0xAE7*16+0x02 = 0xD272) | resident addressing formula | Independently verified. (1) MZ header at raw/COLONIZE/VICEROY.EXE has e_cparhdr=576 paragraphs = 0x2400 header bytes, so the resident image begins at file offset 0x2400 — the formula's base is correct. (2) Arithmetic: 0xAE7<<4 = 0xAE70; +0x |
| ✅ | LCALL 0xAE7:0x16 resolves to getch @0xD286 (0x2400+0xAE7*16+0x16 = 0xD286) | resident addressing formula | Independently confirmed. Arithmetic: 0xAE7<<4=0xAE70, +0x16=0xAE86, +0x2400=0xD286 (exact). Re-disassembled file_off 0xD286 in raw/COLONIZE/VICEROY.EXE with capstone CS_MODE_16: bytes 55 8b ec b4 00 cd 16 0a c0 74 05 32 e4 c9 cb ... decode  |
| ✅ | drain_keyboard_buffer @0x4AFA loops kbhit/getch/kbhit, discarding keys until kbhit returns 0 | func_004AFA_drain_keyboard_buffer @0x4AFA | Independently re-disassembled file offset 0x4AFA (CS_MODE_16) from raw/COLONIZE/VICEROY.EXE. Bytes 55 8B EC \| 9A 02 00 E7 0A \| 0B C0 \| 74 0E \| 9A 16 00 E7 0A \| 9A 02 00 E7 0A \| 0B C0 \| 75 F2 \| C9 CB. Decodes to: push bp; mov bp,sp;  |
| ✅ | The only two CD-09 byte sequences in VICEROY.EXE are not INT 09h opcodes: 0x22773 is the operand of PUSH 0x09CD (preceding byte 0x68 = PUSH  | raw byte scan of VICEROY.EXE | VERIFIED. Independent raw scan of raw/COLONIZE/VICEROY.EXE (494910 bytes, MZ header = 576 paragraphs = 0x2400, matching the cited file_off = 0x2400 + seg*16 + off mapping) found exactly TWO occurrences of byte sequence CD 09: at file offset |
| ✅ | VICEROY.EXE contains no setvect, getvect, or IVT poke for interrupt vector 9 (no MOV AX,2509h / 0925h / 3509h, no MOV AL,9+INT 21h, no MOV e | pattern search over entire EXE | VERIFIED. Independently re-searched and re-disassembled raw/COLONIZE/VICEROY.EXE (494910 bytes) with capstone CS_MODE_16.  Direct multi-byte patterns from the claim — all 0 matches: B8 09 25 (MOV AX,2509h)=0; B8 25 09 (MOV AX,0925h)=0; B8 0 |
| ✅ | There is no INT 09h opcode and no custom keyboard ISR in the resident image; keyboard input is pure BIOS INT 16h polling | combination of CD 09 scan + setvect/getvect/IVT scan | Independently verified against raw/COLONIZE/VICEROY.EXE (MZ header: hdr_para=576 => header=0x2400; load module file region [0x2400, 0x20665); resident file_off = 0x2400 + linear, matching the given formula). Capstone CS_MODE_16.  (1) INT 09 |
| ✅ | wait_keyOrClick @0x4A80 returns the getch value (stored in DI) and also samples a mouse-click region so a click can satisfy the wait | func @0x4A80 | Verified independently via capstone CS_MODE_16 against raw/COLONIZE/VICEROY.EXE (MZ header e_cparhdr=576 -> 0x2400). The function at file offset 0x4A80 has a clean prologue (0x4A7F retf, 0x4A80 'enter 4,0') and every cited byte decodes EXAC |
| ✅ | wait_keyOrClick @0x4A80 is reached from overlay code via thunk LCALL 0x181F:0x3C0 (thunk record at file 0x1A9B0, ljmp 0x262:0x60 -> 0x2680=0 | thunk record @0x1A9B0; whole-file sig scan for 9A C0 03 1F 1 | All elements verified independently via capstone CS_MODE_16 against raw/COLONIZE/VICEROY.EXE (resident file_off = 0x2400 + seg*16 + off). (1) Thunk record @file 0x1A9B0 = bytes 9A 91 0D 0D 11 EA 60 00 62 02, decoding to `lcall 0x110D:0x0D91 |
| ✅ | idle_poll @0x4D1E reads getch into SI, drains the buffer, sets [0x8A]=1, and compares SI against abort codes 0x12D and 0x110, setting byte [ | func @0x4D1E | Independently re-disassembled VICEROY.EXE (capstone CS_MODE_16) at file offset 0x4D1E. Function entry confirmed (0x4D1E: enter 8,0 prologue). Every cited byte matches exactly: 0x4D89 9A 16 00 E7 0A = lcall 0xAE7,0x16 (return AX); 0x4D8E 8B  |
| ⚠️ | idle_poll @0x4D1E is reached via thunk LCALL 0x181F:0x3AC (record @0x1A99C, ljmp 0x262:0x2FE -> 0x291E=0x4D1E) with 34 overlay callers clust | thunk record @0x1A99C; sig scan 9A AC 03 1F 18 | [convention] Re-disassembled independently from raw/COLONIZE/VICEROY.EXE (capstone CS_MODE_16). The thunk-resolution chain is byte-correct, BUT the caller-distribution claim is FALSE.  VERIFIED-TRUE parts: - Record @0x1A99C bytes = 9A 91 0D |
| ✅ | The list/scroll handler at func @0x22E50 uses wait_keyOrClick then a per-key flag table at DS:0x27ED (bit 2 -> ASCII case-fold by -0x20) and | func @0x22E50 | Independently re-disassembled file_off 0x22E50 from raw/COLONIZE/VICEROY.EXE with capstone CS_MODE_16 (resident base 0x2400, so mem=0x20A50). All five cited byte sequences decode EXACTLY as claimed at the exact offsets: - 0x22E56: 9A C0 03  |
| ⚠️ | The colony build-menu handler at func @0x2C692 compares the key to 0x0D (Enter) selecting building slot 0x10, and otherwise indexes action t | func @0x2C692 | [source] All cited raw bytes are correct and decode exactly as the EVIDENCE strings state (independently re-disassembled with capstone CS_MODE_16 from raw/COLONIZE/VICEROY.EXE; cited offsets are already raw file offsets, no seg adjustment n |
| ✅ | wait_for_keypress @0x4A5C has no static LCALL caller in the EXE; its only data far-pointer is at file 0x47886 (01B8:0ADC), an overlay functi | whole-file 0x9A LCALL scan + data far-ptr scan for flat 0x26 | Independently reproduced from raw/COLONIZE/VICEROY.EXE (resident file_off = 0x2400 + flat; flat target = 0x4A5C - 0x2400 = 0x265C). (1) Whole-file LCALL scan (opcode 0x9A; off=LE@+1, seg=LE@+3; seg*16+off==0x265C): 0 hits. (2) Data far-poin |
| ✅ | The third INT 16h byte sequence at 0x5ABEC is data, not code (surrounded by zero padding) | raw byte context at 0x5ABEC | Independently confirmed from raw/COLONIZE/VICEROY.EXE. Raw bytes: 0x5ABEB=00, 0x5ABEC=CD, 0x5ABED=16, 0x5ABEE=00, 0x5ABEF=00 — matching the evidence's cited coordinates exactly. The region 0x5AB80..0x5AC40 is a uniform table of little-endia |
| ✅ | getch/kbhit have additional resident callers beyond wait_for_keypress: kbhit @0x2504 and @0x4AA7/@0x4D80, getch @0x4AB0 and @0x4D89 | whole-file LCALL scan for targets 0xD272 and 0xD286 | Independently reproduced via a whole-file scan for far-call opcode 0x9A in raw/COLONIZE/VICEROY.EXE, then re-disassembled each cited site with Capstone CS_MODE_16.  Target reconciliation: kbhit flat 0xAE72, getch flat 0xAE86 (seg*16+off). C |

### control_bindings — 25/33 independently confirmed

| ✓ | claim | cite | note |
|---|-------|------|------|
| ✅ | The in-game command dispatcher func_0235D6 @0x0235D6 begins with enter 0x1e,0 and switches on [bp+6] (mov ax,[bp+6]; cmp ax,0x1a) | func_0235D6 @0x0235D6, @0x0235E2, @0x0235E5 | Independently re-disassembled VICEROY.EXE at file offset 0x235D6 with capstone CS_MODE_16. Bytes confirmed: @0x235D6 = c8 1e 00 00 -> enter 0x1e,0 (matches); @0x235E2 = 8b 46 06 -> mov ax,word[bp+6] (matches); @0x235E5 = 3d 1a 00 -> cmp ax, |
| ⚠️ | func_0235D6 is reached via thunk 0x181F:0x0F78 | xref.py callers 0x0235D6 | [convention] FALSE. Independent re-disassembly of raw/COLONIZE/VICEROY.EXE (capstone CS_MODE_16) refutes the claim on multiple grounds. (1) The claimed byte_sig "9a 78 0f 1f 18" (lcall 0x181F:0x0F78) does NOT exist anywhere in the binary —  |
| ⚠️ | The advisor F-key dispatch ladder lives in func_0235D6 at @0x023843-0x02390B and compares [bp+6] against per-key codes | @0x023843 ff. | [convention] The F-key ladder BYTES are genuine, but the cited RESIDENT offset is wrong. Under the task-mandated mapping (resident file_off = 0x2400 + seg*16 + off), resident @0x023843 -> FILE offset 0x25C43, which I disassembled and found  |
| ✅ | F1=code 0x48 dispatches via 0x191F:0x41A | @0x023843, @0x02384C | Independently re-disassembled raw/COLONIZE/VICEROY.EXE (capstone CS_MODE_16). @0x23843: bytes 83 7e 06 48 = `cmp word ptr [bp+6], 0x48` (immediate 0x48 at 0x23846) — matches "cmp [bp+6],0x48". @0x2384C: bytes 9a 1a 04 1f 19 = far call ptr16 |
| ✅ | F2=0x41, F3=0x42, F4=0x43, F5=0x44, F6=0x45, F7=0x46, F8=0x47, F9=0x49 (BIOS-extended scancode-style codes) | @0x023854-0x0238CB | Independently re-disassembled raw/COLONIZE/VICEROY.EXE with capstone CS_MODE_16 at the cited file offsets (offsets used directly, matching the resident mapping). All 8 sequential `cmp word ptr [bp+6], imm` decode exactly as claimed: 0x23854 |
| ✅ | F9 (0x49) is gated by test byte [0x5383], 0x20; if set it diverts to 0x181F:0x574 (broken-thunk landing), else reaches push 1; lcall 0x191F: | @0x0238D1, @0x0238D8, @0x0238E2 | All three cited offsets decode exactly as claimed in raw/COLONIZE/VICEROY.EXE. @0x238D1: f6 06 83 53 20 = test byte ptr [0x5383], 0x20 (matches "test byte [0x5383],0x20"). @0x238D6: 74 08 = je 0x238E0 — ZF=1 (bit NOT set) jumps to the push  |
| ✅ | F10 Colonization Score is NOT in the F-key cmp ladder; it routes through func_03A9C0 (score path) | advisor_reports.md §3; @0x023843-0x02390B | Independently re-disassembled VICEROY.EXE (capstone CS_MODE_16, raw file offsets) at 0x023843-0x02390B. The F-key report ladder consists of exactly nine `cmp word ptr [bp+6], imm8` instructions: 0x023843=0x48, 0x023854=0x41, 0x023865=0x42,  |
| ✅ | The in-game menu bar is built by func_072090 @0x072090 which opens the 'game'/'menu' data section | func_072090 @0x072090, @0x0720BE | Independently re-disassembled VICEROY.EXE in CS_MODE_16. func_072090 @0x072090 begins with enter 4,0 (c8 04 00 00), a valid prologue. At @0x0720BE the bytes 68 98 20 decode to `push 0x2098` and 68 9d 20 to `push 0x209d`, immediately followe |
| ⚠️ | MENU @ORDERS string table marks accelerators with ~: ~Activate unit, ~Wait for next unit, ~Fortify, ~Sentry, ~Build Colony, Join Colony (~B) | data_extracted/text/MENU_sections.json @ORDERS | [convention] Two failures.  (1) SOURCE MISMATCH — not an EXE byte claim. The task frames this as a VICEROY.EXE byte claim to be re-disassembled at a cited offset, but the @ORDERS strings do NOT exist anywhere in raw/COLONIZE/VICEROY.EXE. I  |
| ✅ | MENU @VIEW marks accelerators: ~Move Pieces, ~View Pieces, ~European Status, Zoom In ~Z, Zoom Out ~X, Show ~Hidden Terrain, ~Center View; th | data_extracted/text/MENU_sections.json @VIEW | CLAIM is byte-accurate against the actual source bytes. CAVEAT on method: the cited data lives in raw/COLONIZE/MENU.TXT (a separate data resource), NOT in VICEROY.EXE — the menu strings ("Move Pieces", "Center View", "Zoom Level", etc.) are |
| ⚠️ | MENU @REPORTS rows carry F1..F10 accelerators (~F~1 Terrain Information ... ~F~1~0 Colonization Score) | data_extracted/text/MENU_sections.json @REPORTS | [convention] The string-content claim is TRUE against the game data, but it is NOT verifiable against VICEROY.EXE as the protocol requires, so I default to false.  String content (TRUE): The @REPORTS menu with F1..F10 accelerators is byte-e |
| ⚠️ | MENU @CUP (CHEAT) rows carry F01,F02,F04,F05,F06,F07,F08,F09,F010 accelerators plus non-accel Sound Test / Memory Check | data_extracted/text/MENU_sections.json @CUP | [convention] The CLAIM's content is factually accurate, but it CANNOT be verified by the demanded method (independent re-disassembly of raw/COLONIZE/VICEROY.EXE), because this menu data does not live in VICEROY.EXE at all. It lives in the e |
| ✅ | MENU @GAME rows carry NO ~ accelerator markers (title ~GAME only); items Game Options..Exit to DOS have no single-key accelerator | data_extracted/text/MENU_sections.json @GAME | Verified against the actual ground-truth artifact raw/COLONIZE/MENU.TXT (the file the cited JSON is derived from). NOTE: the menu strings are NOT in VICEROY.EXE at all — "Game Options"/"DECLARE INDEPENDENCE"/"Exit to DOS" etc. have 0 occurr |
| ✅ | NAMES @ORDERS encodes order short-code/status columns: No Orders,- / Sentry,S / Trade Route,T / Go To,G / Live In Village,L / Fortify,F / Fo | data_extracted/text/NAMES_sections.json @ORDERS | VERIFIED against the authoritative raw source. NAMES is an external data file, not embedded in VICEROY.EXE (confirmed: substrings 'No Orders', 'Trade Route', 'Clear/Plow', 'Reserved for AI' all return zero hits in raw/COLONIZE/VICEROY.EXE), |
| ✅ | NAMES @ACTIONS lists the 10 native-village action rows | data_extracted/text/NAMES_sections.json @ACTIONS | Verified against the primary artifact NAMES.TXT (raw/COLONIZE/NAMES.TXT), which is the authoritative source for @ACTIONS (a data-file claim, not an EXE-offset claim). Raw bytes at the @ACTIONS marker decode to exactly 10 content rows, CRLF- |
| ✅ | The boot-menu BEGINMENU runner is invoked at @0x075C60 (lea bx,[0x2345]; lcall 0x181F:0x3FE) returning a 1-based index | MENUS_VICEROY_DECODE.md §3.2; @0x075C60 | Independently re-disassembled @0x075C60 from raw/COLONIZE/VICEROY.EXE in capstone CS_MODE_16. Bytes confirmed exactly: 8d 1e 45 23 9a fe 03 1f 18 (followed by 89 86 20 ff 48 7d 03...). Decode: lea bx,[0x2345]; lcall 0x181f, 0x3fe (capstone  |
| ✅ | Boot-menu dec ax selection ladder @0x075C6D selects branches: idx 0 -> exit jmp 0x75F8D, idx<=3 -> setup loop 0x75C86, idx==4 path jmp 0x75D | MENUS_VICEROY_DECODE.md §3.3; @0x075C6D | VERIFIED. Independently re-disassembled raw/COLONIZE/VICEROY.EXE (capstone CS_MODE_16) at file offset 0x75C6D. Raw bytes: 48 7d03 e91a03 48 48 7e0f 48 7503 e96d01 48 7503 e92d02 e90703. These decode byte-for-byte to exactly the claimed ladd |
| ✅ | In-game dropdown open/run/hit-test is func_06E3D0 @0x06E3D0 with a mode split cmp [0x1f5c],7 / jle and a flags&0x10 no-border path | MENUS_VICEROY_DECODE.md §7.1; func_06E3D0 @0x06E3D0 | VERIFIED. Independently re-disassembled VICEROY.EXE (capstone CS_MODE_16). MZ header = 0x2400 bytes (576 paras), confirming the file/resident split. The codebase's func_XXXXXX @0xNNNNN labels are FILE OFFSETS (proven: bytes at file off 0x06 |
| ✅ | Dropdown/menu row highlight is the 1-px hollow rectangle outline primitive 0x181F:0xCE (not a filled cell) | MENUS_VICEROY_DECODE.md §7.1; RULING 2026-05-31 | CORE CLAIM VERIFIED by independent re-disassembly of raw/COLONIZE/VICEROY.EXE (capstone CS_MODE_16, file_off=0x2400+seg*16+off). The primitive 0x181F:0xCE IS a 1-px hollow rectangle outline, NOT a filled cell.  Thunk resolution: 0x181F:0xCE |
| ⚠️ | Europe click hit-test rects are produced by the routine @0x032034 (point-in-rect 0x181F:0x3CA): recruit (281,89,37,32)=id5, dock A (143,118, | europe_screen.md §4 | [convention] The rect coordinates, IDs, and the point-in-rect call 0x181F:0x3CA are real, but the cited OFFSET 0x032034 is wrong. Independent capstone CS_MODE_16 disassembly (file_off = 0x2400 + resident):  (A) The Europe click hit-test rou |
| ✅ | Europe Exit is via the @EUROLABEL 4th token 'x' / ESC (generic screen-view close), not a Europe-painted exit button; paint origin pixel-measured (A, §9) | europe_screen.md §4 (RESOLVED 2026-06-23) | VERIFIED. Re-disassembled VICEROY.EXE at file offset 0x032034 (capstone CS_MODE_16) — the doc's @asm offsets are raw file offsets, confirmed because raw 0x032034 decodes to coherent code whereas the resident-mapped 0x2400+0x032034=0x34434 y |
| ⚠️ | Clicking an own colony tile enters the Colony screen via the entry chain func_L187 -> set_active_colony (file 0x82DC) -> lcall 0x191F:0x1DE | map_view.md; COLONY_RENDER_CHAIN.md §2 | [convention] The individual byte facts check out, but the chain as written is false. Verified TRUE independently (capstone CS_MODE_16, formula file_off=0x2400+seg*16+off): (1) file 0x82DC IS set_active_colony - stores active-colony ptr to [ |
| ✅ | GAME_MANUAL prose documents map command keys (A=Activate, W=Wait, F=Fortify, S=Sentry, B=Build/Join colony, P=Clear/Plow, R=Road, G=Go to, O | docs/GAME_MANUAL.md L63-103 | Claim is a documentation-content claim about GAME_MANUAL.md prose (not a VICEROY.EXE byte-offset claim). Read docs/GAME_MANUAL.md L63-103 directly. Section is "Map Commands" (L63). All 20 claimed key mappings are present verbatim in the cit |
| ✅ | GAME_MANUAL documents Alt+highlighted-letter opens a menu (e.g. Alt-G for game menu) and shortcut letters are shown as highlighted letters o | docs/GAME_MANUAL.md L40-46, L440-443 | Both citations resolve exactly. GAME_MANUAL.md L39-41 reads verbatim: "To open one of these menus, hold down [Alt] and press the letter that is highlighted in the menu name. (For example, to open the game menu, you would press [Alt]-[G].)"  |
| ✅ | GAME_MANUAL documents Europe screen keys: R/1 recruit, P/2 purchase, T/3 train, L/= buy full, +buy some, U sell, -/_ sell all/some, F1 info, | docs/GAME_MANUAL.md L168-184 | The claim is a documentation-content claim (what docs/GAME_MANUAL.md documents), with CITE = the manual file L168-184. I read those exact lines and every claimed mapping matches verbatim: L178 "Open recruit menu ... R or 1"; L180 "Open purc |
| ✅ | GAME_MANUAL documents Colony screen keys: Tab view-to-view, arrows within view, Enter jobs menu, L load, =/+ load all/some, U unload, -/_ un | docs/GAME_MANUAL.md L114-134 | CLAIM is a documentation-content claim (the manual documents these keys), cited to docs/GAME_MANUAL.md L114-134, not to a VICEROY.EXE func/offset, so there is no disassembly to re-do; I verified it against its actual cited source. GAME_MANU |
| ✅ | GAME_MANUAL documents the mouse model: left-click selects/presses, click-and-hold gives a direction-arrow scroll cursor, right-click gives i | docs/GAME_MANUAL.md L420-435 | Claim is a documentation-content claim about docs/GAME_MANUAL.md, not a byte-offset/EXE claim (no func_XXXXXX @0xNNNNN was cited, and none is needed — the manual is the cited source). I read docs/GAME_MANUAL.md L420-435 directly and every e |
| ⚠️ | Message popups are dismissed by Spacebar, Enter key, or a click | docs/GAME_MANUAL.md L584 | [convention] The CLAIM ("Message popups are dismissed by Spacebar, Enter key, or a click") cites only docs/GAME_MANUAL.md L584 — a prose manual line with NO EXE offset — and that line is not even about message popups: it describes the "End  |
| ✅ | The modal dialog wait loop is 0x181F:0x3C0 (func_004A80) and draws nothing (box/rows painted by builder first) | popups.md §2; context_dialogs.md | VERIFIED. Independently re-disassembled VICEROY.EXE (capstone CS_MODE_16) with file_off=0x2400+seg*16+off. (1) Thunk resolution: 0x181F:0x3C0 is the 10-byte RTLink Type-B thunk at file 0x1A9B0 (= 0x1A5F0 base + 0x3C0), bytes "9a 91 0d 0d 11 |
| ✅ | The dialog @-directive BUILD parser is func_06F0F4 @0x06F0F4 (@-key check cmp byte [bx],0x40 @0x06F193) | popups.md §3; context_dialogs.md §3 | Independently re-disassembled raw/COLONIZE/VICEROY.EXE with capstone CS_MODE_16, treating the cited values as direct file offsets (consistent with the resident image starting at file 0x2400). Both load-bearing facts match the bytes exactly: |
| ✅ | The unit/ship orders menu option text comes from GAME @UNITOPTIONS/@SHIPOPTIONS/@EUROPESHIPOPTIONS/@ARMOPTIONS (bare lists, directives={}) | context_dialogs.md §4 | VERIFIED. The claim is a GAME-data-file claim (not an EXE-offset claim), and the doc cites it as such (grep-verified GAME_sections.json / GAME.full.json directives). I verified directly against raw/COLONIZE/GAME.TXT and data_extracted/text/ |
| ✅ | The native-village action-list per-row show/enable gating is func_04B308 (enter 0xba), sole consumer of the @ACTIONS label array (DGROUP 0x9 | context_dialogs.md §6 | VERIFIED independently from raw/COLONIZE/VICEROY.EXE (capstone CS_MODE_16). MZ header: hdr=576 paragraphs => load module at file_off 0x2400 (matches prompt). func_<6hex> labels = file offset directly (ledger example entry_point @ file 0x13B |
| ✅ | The minimap panel hit/draw rect is (241,8,79,41) drawn by func_066CD6 with panel box (0xF1,8,0x4F,0x29) at @0x66CF4 | map_view.md §6.1 | Verified independently via capstone CS_MODE_16, reading raw file offsets directly (the cited @0x... values are already resident file offsets; disassembling at 0x66CD6 yields a clean prologue `push bp; mov bp, sp`, confirming the convention) |

