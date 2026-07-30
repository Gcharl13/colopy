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
- If an option was turned off: sends **driver command 1 (stop)** @0x023339
  via `0x181f:0x4de`.

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
Called from input-idle loops. Skips unless `[0xA2]` (BG on) or one-shot
`[0x9E]`; polls driver id 8 ("playing?"); honors forced-next `[0x94]`;
otherwise seeds RNG from `[0x83A8]` and picks a tune-index window:
- peace (`[0x5382]&1`==0): indices 1–12 folk, 1-in-9 → 13–23;
- War of Independence: 13–18, 1-in-5 → folk;
- class requests `[0x9A]` (set by events via `0x181f:0x498/0x4a2/0x4ac/0x4b6`
  = `func_0050F0/0050FC/005108/00513C`, plus scenario helper `func_00543C`):
  1→folk A, 2→folk B, 3→independence, 4→military, 5→0x33 once, 6→0x35,
  7→0x36 (jump table @0x005008).
Index→id map `func_004DF8` (table @0x004EAC); re-rolls on ==`[0x96]`;
plays via `func_00518E`. "Queue tune next" API = `func_0050BC`
(`0x181f:0x48e`): sets `[0x94]`, sends stop so the pump switches.

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
3. Tune-id→XMI names for 0x28/0x34/0x37/0x3E — inside `?SOUND.COL` (driver
   binary absent from `raw/COLONIZE/`).
4. 16×8-byte table at DGROUP 0x26F0 (id→byte[+6] @0x0129FF) — writer TBD.
5. `[0x828]` flag (widens rotation to all 24) — meaning TBD.
