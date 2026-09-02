# Options & music dialogs (Game / Colony / Sound / Pick Music)

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> All dialogs here are standard @-directive dialog-framework menus
> (`spec/ui/dialog_framework.md`) over GAME.TXT sections; this sheet decodes the
> invokers, state bindings, and side effects. Cites re-resolved 2026-07-30
> (section strings byte-read at file 0x1E41B–0x1E450; resident sound functions
> re-disassembled from raw bytes). *(pending)* = decode in flight.

## 1. Reachability — the GAME menu (B)
UI-command dispatcher `func_0235D6` (page 0x01), MENU.TXT `@GAME` row order:
cmd 1 → Game Options (@0x024BB4 trampoline), cmd 2 → Colony Report Options
(@0x024BE6), cmd 3 → **Sound Options** (`0x181f:0xf24` → `func_0232AE`),
cmd 4 → **Pick Music** (`0x181f:0xf54` → `func_023344`) @0x0235EF–0x023617.

## 2. Sound Options (`@SOUNDOPTIONS`, `func_0232AE` @0x0232AE) — B
- Checkbox preset via `0x191f:0x26e` (init) + `0x191f:0x262` (set row n):
  row 1 = `[0xA2]` **Background Music**, row 2 = `[0xA0]` **Event Music**,
  row 3 = `[0xA4]` **Sound Effects**.
- Runs `lea bx,[0xa7b]` ("SOUNDOPTIONS", file 0x1E41B) → `0x181f:0x3fe`
  (section picker); reads back rows via `0x191f:0x306` into the three globals
  @0x0232E8–0x0232F3; mirrors bits into `[0x5386]` @0x023301–0x023322
  (persisted save-side flag word).
- **`[0x5386]` bit assignment (byte-pinned 2026-08-17 from 0x023301..0x023322):**
  `and byte [0x5386],0xF1` clears mask 0x0E, then `[0xA2]`≠0 → **bit1 (0x02)
  Background Music**, `[0xA0]`≠0 → **bit2 (0x04) Event Music**, `[0xA4]`≠0 →
  **bit3 (0x08) Sound Effects**. (Consistent with the new-game seed
  `mov [0x5386],0x0E` @0x755EB = all three on — see RULINGS 2026-08-08 area
  entry on the 0x5386 shared word.)
- Stop condition (pinned @0x023327–0x023343): if **any** of the three
  switches is off after the dialog — not just on an off-transition — sends
  **driver command 1 (stop)** @0x023339 via `0x181f:0x4de`.

## 3. Pick Music (`@PICKMUSIC` + 3 sub-pickers, `func_023344` @0x023344) — B
One function drives all four GAME.TXT sections (strings in one DGROUP
cluster: PICKMUSIC 0xA88 / PICKINDEPENDENCE 0xA92 / PICKMILITARY 0xAA3 /
PICKINDIAN 0xAB0; files 0x1E428–0x1E450, byte-read):

- **Preselect**: current tune id `[0x96]` → picker row via jump table file
  0x0233E4 (28 entries, ids 0x20..0x3B; ids 0x34/0x37 have no row —
  event-only tunes).
- **Main menu**: rows 1–12 = the 12 folk tunes; rows 13/14/15 = submenu rows
  ("Independence/Military/Indian Tunes") which run their section picker via
  `0x181f:0x3fe` and offset the returned row (13→id sel+0x28, 14→sel+0x2D,
  15→sel+0x31 with a skip over 0x34 @0x02351A).
- **Selection→id** jump table file 0x02353A; on pick: `mov [0x96],ax` then
  gated play `0x181f:0x4c0` @0x023556ff. No persistent lock — normal
  rotation resumes when the tune ends.

#### Both jump tables, resolved (byte-read 2026-08-05)

Each table holds near targets in the same code segment; **file = segment
offset + 0x020EE0**, fixed by the two dispatch sites (`jmp cs:[bx+0x2504]` at
file 0x0233DF, `jmp cs:[bx+0x265A]` at file 0x023535).

**Selection→id** (`dec ax; cmp ax,0x0E; ja default; shl ax,1`, 15 entries).
Rows 1–12 are each a bare `mov word [bp-8],imm16`:

| row | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| id | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | **39** | **38** | **3A** | **3B** |
| file | 0x023480 | 0x023488 | 0x023490 | 0x023498 | 0x0234A0 | 0x0234A8 | 0x0234B0 | 0x0234B8 | 0x0234C0 | 0x0234C8 | 0x0234D0 | 0x0234D8 |

The ids are **not contiguous**: @PICKMUSIC lists the four late folk tunes as
Hornpipe / Bonny Morn / Hole In The Wall / Nightingale = 0x39 / 0x38 / 0x3A /
0x3B, so rows 9 and 10 are transposed relative to id order.

Rows 13/14/15 (files 0x0234E0 / 0x0234F8 / 0x02350E) are
`lea bx,<section>; call 0x181f:0x3fe; test ax,ax; jz cancel; add ax,<bias>`
with sections 0xA92 / 0xAA3 / 0xAB0 and biases 0x28 / 0x2D / 0x31. The Indian
handler alone inserts `cmp ax,2; jle +4; inc ax` (file 0x02351A) before the
bias, stepping the third and fourth rows over event-only id 0x34 → 0x35/0x36.
A sub-picker returning 0 (cancel) leaves `[bp-8]` zero, and the tail
`cmp word [bp-8],0; je` (file 0x023558) then skips the write to `[0x96]`
entirely — cancelling changes nothing.

**Id→row** (`sub ax,0x20; cmp ax,0x1B; ja default`, 28 entries), each target a
`mov word [bp-2],imm16`: ids 0x20–0x27 → rows 1–8; **0x28–0x2D → row 13**,
**0x2E–0x31 → row 14**, **0x32/0x33/0x35/0x36 → row 15** (a tune reached
through a sub-picker preselects its *submenu* row, not the tune); 0x38 → row
10, 0x39 → row 9, 0x3A → row 11, 0x3B → row 12; 0x34 and 0x37 fall to the
default at 0x02341C with no row set.

### Tune-id table (byte-verified row↔id)
0x20 Bird Song · 0x21 Smoky Tune · 0x22 Cornwall · 0x23 Shady Grove ·
0x24 Fiddler's Dance · 0x25 Jine the Cavalry · 0x26 Joe Clark ·
0x27 Little Fiddle · 0x28 (unnamed, independence-class scheduler-only) ·
0x29 Love Forever · 0x2A York Fusiliers · 0x2B Washington Artillery March ·
0x2C Road to Boston · 0x2D Independence Way · 0x2E The Reveille ·
0x2F Successful Campaign · 0x30 Morelli's Lesson · 0x31 To Arms ·
0x32 Indian Victory · 0x33 Natives · 0x34 (event-only) · 0x35 Tenochtitlan ·
0x36 Pizarro at Cuzco · 0x37 (event-only, requested @0x0618ED) ·
0x38 Bonny Morn · 0x39 Hornpipe · 0x3A Hole In The Wall · 0x3B Nightingale ·
0x3E (event-only; requested @0x02F30A/@0x05C93D/@0x07544B).
No `.XMI` filenames exist in VICEROY.EXE — ids resolve inside the external
sound driver (§5).

## 4. Background-music rotation (`func_004EE6` @0x004EE6, pump verb `0x181f:0x470`) — B

Called from input-idle loops. Fully byte-pinned 2026-08-17 (tail
0x5016..0x50BB and both jump tables read from the reconstituted EXE).

**Flow**: skips unless `[0xA2]` (BG on) or one-shot `[0x9E]` (@0x4EEA);
polls driver id 8 "playing?" and returns while sounding (@0x4EFB, result also
clears `[0x9E]` @0x4F0C); forced-next `[0x94]` ≥ 0 wins (played, then reset
to 0xFFFF, @0x4F15); otherwise seeds RNG from tick word `[0x83A8]` (@0x4F24)
and selects a window `(base,count)` of 1-based tune *indices*:

- peace (`[0x5382]&1`==0): `(1,12)` folk; `random(0,8)==0` (1-in-9) →
  `(13,11)` = indices 13–23 (@0x4F37–0x4F5B);
- War of Independence: `(13,6)`; `random(0,4)==0` (1-in-5) → `(1,12)` folk
  (@0x4F5E–0x4F7D);
- `[0x828]` ≠ 0 overrides to `(1,24)` — all 24 rotation indices (@0x4F82;
  the flag's writer is still open item 5);
- class request `[0x9A]` ≠ 0 (set by events via
  `0x181f:0x498/0x4a2/0x4ac/0x4b6` = `func_0050F0/0050FC/005108/00513C`,
  plus scenario helper `func_00543C`) overrides via jump table @0x005008
  (7 near targets, pinned): **1→(1,7)** folk A, **2→(8,5)** folk B,
  **3→(13,6)** independence, **4→(19,4)** military, **5→(23,1)** = 0x33,
  **6→(25,1)** = 0x35, **7→(26,1)** = 0x36. Classes 5/6/7 guard
  "already playing that tune" (`cmp [0x96],0x33/0x35/0x36` @0x4FCA/0x4FDE/
  0x4FEC) and on match fall through to the RNG-chosen window instead.

**Pick** (@0x5016–0x503A): `i = base + random(0, count-1)`; id =
`func_004DF8(i)`; **re-roll the whole pick while id == `[0x96]`**.

**Index→id map `func_004DF8`** (dispatch `dec ax; cmp ax,0x19; ja default`
@0x4E9E, 26-entry jump table @0x004EAC, all read):

| index | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| id | 20 | 21 | 22 | 23 | **3A** | **3B** | **38** | 24 | 25 | 26 | 27 | **39** |

indices 13–22 → `id = index + 0x1B` (0x28–0x31, shared default body
@0x4E68); **23 → 0x33 (Natives)** and **24 → 0x32 (Indian Victory)** —
explicit cases @0x4E76/@0x4E80, *swapped* relative to the +0x1B formula;
25 → 0x35 @0x4E8A; 26 → 0x36 @0x4E94; out-of-range → +0x1B default.

**After the pick** (@0x503C–0x50BB): re-seed from the *other* tick word
`[0x83A6]` (@0x503C); if `[0x9A]`==0, derive it from the picked index
(@0x504F–0x5097: 7, then ≤25→6, ≤24→5, ≤22→4, ≤18→3, ≤12→2, ≤6→1 — i.e.
the class of what will play); publish **`[0x9C]` = that class** (@0x50A0);
shift **`[0x98]` → `[0x9A]`** and clear `[0x98]` (@0x50A3–0x50A9) —
class requests are double-buffered: `[0x9A]` consumed this round, `[0x98]`
is the queued-next request. Finally `[0x96]` = id and far call
`0x2D8:0xE` with AX=id (@0x50B5) — the play path.

"Queue tune next" API = `func_0050BC` (`0x181f:0x48e`): sets `[0x94]`,
sends stop so the pump switches.

## 5. Sound-driver architecture (B)
- **Gate `func_00518E`** (AX=id): ids <0x10 = driver commands always pass;
  bit 0x20 (tunes) gated on `[0xA0]`; bit 0x40 (SFX 0x40–0x5F) gated on
  `[0xA4]`; then `lcall 0x1059:0xa`.
- **Dispatch @0x01299A**: lock byte `[0x26C5]`; unlocked → `ljmp [0xA658]`
  (driver vector 1 = play/query); locked → queue (8 deep, `[0x26B4]`/count
  `[0x26C4]`). Vectors 0–4 at DGROUP 0xA654–0xA667, installed by
  `func_012928` from the driver header, reset by @0x012976.
- **Driver load** `func_01287A`: DOS int 21h AX=4B03 (load overlay) with tag
  `"$sound$ "` (file 0x2004B); boot init `func_07845A` (called @0x0762E6)
  templates **`"#SOUND.COL"`** (file 0x1FD5A) — the `#` replaced by config
  byte `[0x2608]` — loads it, installs vectors, feeds 7 config words.
- **Servicing**: timer ISR @0x00C6D9 clocks vector 4 every tick, vector 3
  every 5th; exit path stops (id 1), polls id 8 until silent, vector 2.
- **Cheat "Sound Test"** (MENU.TXT `@CUP`, cmd 0x69 → handler @0x023D86):
  numeric-input dialog from DEBUG.TXT `@SOUND` ("Play what sound #?") via
  `0x191f:0x436`, result `[0x9CC8]` → gated play — arbitrary id playback.

## 6. Game Options (`@GAMEOPTIONS`, `func_022FD6` @0x022FD6) — B
Standard checkbox dialog ({width:190, checkbox, options} directives); state
lives in **word `[0x5382]`** (bytes 0x5382/0x5383). Flow: reset checkbox
mask (`0x191f:0x26e`) → seed rows 1–8 → run (`lea bx,[0xa61]`
"GAMEOPTIONS" @0x023061 + `0x181f:0x3fe`) → `and word [0x5382],0x207F`
@0x02306A → per-row writeback.

| row | option | bit | polarity |
|---|---|---|---|
| 1 | Show Indian Moves | 0x8000 | direct (@0x02307C) |
| 2 | Show Foreign Moves | 0x4000 | direct |
| 3 | Fast Piece Slide | 0x1000 | direct (consumer @0x004734: slide step 8 vs 10, shifted by zoom) |
| 4 | End of Turn | 0x0800 | direct (@0x021E4F) |
| 5 | Autosave | 0x0400 | direct — turn-loop consumer @0x0058D7/@0x005A29 → helper @0x005642: rolling slot 9 each turn + slot 8 on decade boundaries |
| 6 | Combat Analysis | 0x0200 | direct (@0x05D221) |
| 7 | Water Color Cycling | 0x0100 | **INVERTED** (bit set = cycling OFF) @0x02303B/@0x0230E2 |
| 8 | Tutorial Hints | 0x0080 | direct (@0x024AC6) |

Bit 0x2000 (cheat master, §debug_screens.md) is deliberately preserved by
the 0x207F clear mask. **Side effect**: water-cycling master `[0x372]` =
!(bit 0x100); when disabling, a vblank-synced full DAC upload restores the
base palette (`0x181f:0x3f4` @0x023113 → `func_00D1E4`, A000:FC00 shadow →
ports 3C8/3C9). Same re-derivation at map palette init @0x03BC29.

## 7. Colony Report Options (`@COLONYOPTIONS`, `func_02311A` @0x02311A) — B
Checkbox dialog ({width:220}); state in **word `[0x5384]`**; run
`lea bx,[0xa6d]` @0x0231F3; clear `and word [0x5384],0xFC00` @0x0231FC.
**All 10 bits are INVERTED — each set bit means "suppress"**:

| row | option | bit |
|---|---|---|
| 1 | Labels on buildings | 0x0002 (consumer @0x02BBEB) |
| 2 | Labels on cargo and terrain | 0x0001 (@0x02BC0E) |
| 3 | Report when colonists trained | 0x0080 (@0x02DF0B…) |
| 4 | Report food shortages | 0x0040 (@0x02E321) |
| 5 | Report raw materials shortages | 0x0020 (@0x02E370) |
| 6 | Report tools needed | 0x0010 (@0x02E5FF) |
| 7 | Report inefficient government | 0x0008 (@0x02DCF0) |
| 8 | Report new cargos available | 0x0004 (@0x02E909) |
| 9 | Report Sons of Liberty membership | 0x0100 (@0x02DC59) |
| 10 | Report rebel majorities | 0x0200 (@0x0232A7 write) |

## 7a. Persistence (B)
`[0x5382]` (game options), `[0x5384/5]` (colony options), `[0x5386]` (sound
mirror) all live in **save block #3 (base 0x5380, size 0x8E)** written
verbatim by `func_0734F8` / restored by `func_073BB0` — all three dialogs
survive save/load. Derived-on-load: `[0xA0]/[0xA2]/[0xA4]` re-expanded from
`[0x5386]` @0x074249; `[0x372]` from bit 0x100. The debug bitfield
`[0x894]` is in no save block — **session-only**. No config file exists.

## 7b. Dialog framework confirmation (B)
Builder verb `0x181f:0x3fe` → wrapper @0x06F594: hardwires file "GAME"
(DS:0x87C) + section from bx, near-calls the engine core at file 0x06F7EF
(same core as menu_lookup_run). Checkbox channel = bitmask word
`[0x1F54]`: reset `0x191f:0x26e` (@0x06F54C), pre-seed `0x262`
(`func_06F554`), read-back `0x306` (`func_06F57E`).

## 8. Open items (exact trace sites)
1. Upstream caller of dispatcher `0x181f:0xf78` (stub 0x01B568) — runtime
   only; break on the far call.
2. Config byte `[0x2608]` + words `[0x260A..0x2616]` writers (driver
   filename selection) — trace boot config parse.
3. Tune-id→sequence names for 0x28/0x34/0x37/0x3E — the id→sequence
   resolution lives inside `?SOUND.COL` (MZ driver overlays; in `col.zip`,
   materialized to `raw/COLONIZE/` by `bin/reconstitute.py` — not decoded).
4. 16×8-byte table at DGROUP 0x26F0 (id→byte[+6] @0x0129FF) — writer TBD.
5. ~~`[0x828]` flag — its window override is byte-pinned (§4: `(1,24)`, all
   indices); its *writer/meaning* is still TBD.~~ **CLOSED 2026-09-02** —
   see §9: two writers, both byte-read.
6. ~~Play far-call target `0x2D8:0xE` — carries AX=id at every caller
   (@0x50B5 the scheduler's pick; @0x50E5/@0x5134 stop issued as AX=1,
   matching the gate's command-1 semantics), so it behaves as the gated
   play entry; its thunk identity vs `0x181f:0x4c0`/`func_00518E` is
   still untraced.~~ **CLOSED 2026-09-02** — it IS the gate: file =
   `0x2400 + 0x2D8·16 + 0xE = 0x518E = func_00518E` (a resident far call,
   not in the RTLink map). See §9.

## 9. Amendment 2026-09-02 — the gate's polarity, the dispatcher ring, the driver commands, the scheduler's PRNG, `[0x828]` (B)

Byte-read for the cport audio engine (`cport/audio/colopy_audio.c`);
corrections to §5 recorded in `notes/rulings/RULINGS.md` 2026-09-02c.

- **Gate `func_00518E` @0x518E — the compare is SIGNED.** `cmp cx,0x10 /
  jge` is `83 F9 10 7D 03` @0x5197 (`7D` = JGE), so every id ≥ 0x8000 is a
  negative int16 and takes the `bx=1` "command" branch (@0x519C) straight
  to `lcall 0x1059:0xA` @0x51C8 — the **fanfares 0x8020..0x8027 bypass both
  switches**. For ids 0x10..0x7FFF: `dx` = bit 0x20, `di` = bit 0x40;
  `or dx,dx; je` (@0x51B3) → with 0x20 set the play happens iff `[0xA0]`
  (Event Music) ≠ 0 (@0x51B7); otherwise (or with Event off) `or di,di; je
  ret` (@0x51BD) → with 0x40 set the play happens iff `[0xA4]` ≠ 0
  (@0x51C1). An id with neither bit (0x10..0x1F) never plays. §5's "bit
  0x20 → tune gate applies to fanfares" is withdrawn.
- **`0x2D8:0xE` = the gate** (file `0x518E`); **`0x1059:0xA` = the resident
  dispatcher @0x01299A** (`cmp byte [0x26C5],0; jne queue; ljmp [0xA658]` =
  driver vector 1). Queue path @0x129A5: `cmp al,8; jae ret` (drop at 8
  pending), `mov [bx+0x26B4],id; inc [0x26C4]`. Lock @0x129C1 (`mov byte
  [0x26C5],0xFF`), unlock @0x129C7 + FIFO replay through `0x1059:0xA`
  @0x129D6..0x129E7.
- **The 8-deep ring is dead code.** The only writers of `[0x26C5]` are the
  two `C6 06 C5 26` at 0x129C1/0x129C7; no `lcall 0x1059:0x31/0x37`
  (`9A 31 00 59 10` / `9A 37 00 59 10`), no far pointer `31 00 59 10` /
  `37 00 59 10`, and no near `E8` call in segment 0x1059 targets them. The
  lock stays 0 from load, so every play/command reaches the driver
  synchronously — VICEROY never queues or preempts on its side.
- **Commands VICEROY sends** (`lcall 0x1059:0xA` sites: 0x4EFD, 0x51C8,
  0x559D, 0x55E4, 0x129DC; `lcall 0x181F:0x4DE` sites: 0x2333B, 0x74276,
  0x75C2A, 0x77AEC, 0x7842B): **0** @0x7842B (boot, after the driver load)
  and @0x77AEC (abort path); **1** @0x2333B (Sound Options), @0x74276 (load
  game), @0x559D (exit), and via the gate from the queue/class verbs;
  **8** @0x4EFD (scheduler) and @0x55E4 (exit spin); and **tune 0x33 raw**
  @0x75C2A in the title composer `func_0759E8` (`push 0x33; lcall
  0x181f,0x4de` — bypasses the gate and every switch).
- **Driver side (ASOUND.COL, file offsets; load = file − 0x200).**
  Dispatcher @0x1C35: id ≤ 8 → `call cs:[0x1B59+2·id]`; 0x20..0x3F → `mov
  byte [0x24D],0xFF` then `cs:[0x1B6B+…]`; 0x40..0x5D → `cs:[0x1BB9+…]`;
  0x8020..0x8026 → `cs:[0x1BAB+…]` (`cmp bx,0x8026; ja` rejects 0x8027 —
  the shipped config's driver evidently accepts it, since F2a captured
  signal for it; the port lets the pak decide). Handlers: **1 @0x1AA0 =
  `call 0x1A64; call 0x1A8C`** = stop-mark FM channels 1–6 **and** 7–9 (the
  nine 0x2C-byte records at 0x8036…); the digital ring is not touched. 3
  @0x1A64 ch1–6 only; 5 @0x1A8C ch7–9 only; 4 @0x188F ch7–9 release +
  `lcall 0:0xD82` (DSP stop + sample-ring clear); 0 @0x150F full OPL reset;
  2 @0x1866 release/fade ch1–6; 6 @0x18AB / 7 @0x1934 mute/unmute (volume
  save/restore — register-pattern glosses); **8 @0x1AA7 = OR of byte+0 over
  the nine FM records** — a digital sample in flight does NOT hold the
  pump. SFX wrapper @0x1DF6: plays the digital sample only when `[0xA0]==0`
  and `[0x24D]==0xFF`, via `0:0xCE2` (@0xEE2): a busy DSP (`[0x5E]≠0`) is
  stopped first (`call 0x684; call 0x96E` @0xF12) — **new kills old**; a
  success pops the return address so the FM effect is skipped, a rejection
  falls back to FM. Tune heads (e.g. 0x20 @0x3724) `call 0x1864` first, so
  a **new tune replaces** the playing one — there is no driver-side queue
  either.
- **The scheduler's PRNG is the game's.** `0x9EF:0x32` = `func_00C322` =
  `random_int(lo,hi)`: `lcall 0xD1D:0xE04` (= MS C `rand` @0x103D4: state
  `[0x28EE]/[0x28F0]` ← state·0x343FD + 0x269EC3, return `(state>>16) &
  0x7FFF`) then `lo + ((rand·(hi−lo+1)) >> 15)` (the `sar dx,1; rcr ax,1`
  ×7 after the byte shift @0xC336..0xC358). `0x9EF:0x2C` = @0xC31C → `call
  0xC2F8`: `lcall 0xC0C:0x12` (@0xE4D2 reads the BIOS tick dword at
  0040:006C), `and ah,0x7F`, `lcall 0xD1D:0xDF2` (= `srand` @0x103C2:
  `[0x28EE]=arg, [0x28F0]=0`). The tick words the scheduler pushes
  (`[0x83A8]` @0x4F24, `[0x83A6]` @0x503C) are **ignored** — @0xC31C reads no
  argument. So each pump that picks runs `srand(ticks&0x7FFF)` @0x4F28 →
  `random_int(0,8|4)` → `random_int(0,count−1)` (re-rolled while == `[0x96]`)
  → `srand(ticks&0x7FFF)` @0x5040, on the **same** state every `0x181F:0x4D4`
  call in the game uses. Port decision: RULINGS 2026-09-02c (private state,
  same generator, same seed points).
- **`[0x828]`** — writers: `mov byte [0x828],1` @0x70D00 (command-line
  switch **'D'**: parser @0x70CB4, `sub ax,0x43; cmp ax,0x17; ja; jmp
  cs:[bx+0x156]`, table @0x70DB6 index 1) together with `mov word
  [0x826],1` (autoplay); and @0x4DA6 in `func_004D1E` (idle poll) when the
  key code is 0x12D or 0x110 (@0x4D9A/@0x4DA0), followed by the driver
  reset + exit. Readers (22 `80 3E 28 08` sites): the scheduler @0x4F82
  (window (1,24)); new game @0x756D4; the difficulty/player menus
  @0x74329/0x7434D/0x74380; input suppression @0x5A49/@0x674BB; timed
  screen exits @0x2C7DE/@0x35C30/@0x53215; colony paint skip @0x268F8; the
  boot flow @0x7598D..@0x75C37; the exit filename @0x56A9. The gloss
  "auto-play / demo mode" is from those consumers (ANCHOR); the two
  key codes' keyboard meaning is TBD.
