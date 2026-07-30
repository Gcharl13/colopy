# Debug / cheat screens (DEBUG.TXT family + cheat menu)

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Covers the cheat menu, all 20 DEBUG.TXT dialog sections, and the debug
> overlays they gate. Decoded 2026-07-30 (builds on Phase 1,
> `docs/UI_PHASE1_ATTRIBUTION.md` §2/§4); load-bearing cites re-verified
> (WIN-combo compares, cheat gate, dead-string scans, bit testers).
> Dialog engine: `0x181F:0x998` = menu_lookup_run, convention AX=section ptr,
> BX=file ptr, DX=preselect row; returns 1-based row.

## 1. Cheat-mode gating — B

- **Master flag = bit 0x20 of `[0x5383]`.** Clear at new-game init
  (`mov word [0x5382],0xC600` @0x0755E5); survives load via
  `and word [0x5382],0x207F` @0x02306A.
- **Enable combo: Alt-W, Alt-I, Alt-N** ("WIN") in map-key handler
  `func_023F1C`: sequence state `[0xB92]`, key compares 0x111/0x117/0x131
  @0x023FA9/@0x023FB9/@0x023FD0 → `xor byte [0x5383],0x20` @0x023F9A +
  un/hide menu + redraw. No CLI/file enable exists.
- **Menu**: MENU.TXT `@CUP` is always built as menu 6 (`push 0x20CB "cup"`
  @0x0728C6 in `func_072090`) with hard-coded command ids 0x62,0x63,0x65,
  0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6F; hidden when the cheat bit is
  clear (`test [0x5383],0x20` @0x072A8B → `0x191F:0x45C` = `func_044A5A`
  sets menu-record hidden bit +0xC|1 @0x044A81).
- **Anti-cheat**: the F10 Colonization Score advisor (id 0x49) is refused
  with a beep while cheat mode is on (`test [0x5383],0x20` @0x0238D1).

## 2. The debug-options bitfield `[0x894]` — complete 7-bit table (B)

Builder **`func_02356C`** (cheat id 0x63 "Debug Info Flags"): checkbox
dialog DEBUG.TXT `@OPTIONS` (7 rows), preset `and dx,[0x894]` @0x023587,
readback rebuild @0x0235AA–0x0235C6.

| bit | row | tester | effect |
|---|---|---|---|
| 0x01 | Anger & Friction Levels | @0x004241 (village draw) + @0x044303 (map info panel) | white anger number `[v·0x12+0x54F6+2·viewpower]` at village px+2/py+9; panel appends 8 tribe rows via `0x181F:0x30C` |
| 0x02 | Indian AI movement | @0x0470A3 (`func_046FFA`, Indian AI mover) | shows AI move (`0x181F:0x93E`) + tile flash (`0xD9A`) when tile visible to human |
| 0x04 | Supply and Demand (Indians) | @0x0494DA/@0x0495DE (`func_048F34`) | 16-good supply/demand dump, x=1, y=8·(g+1), color 0x0F, blocking getch |
| 0x08 | Foreign AI planning modes | @0x003971 (resident map-blip letter chooser; **also requires cheat bit**: `test [0x5383],0x20` then `test [0x894],8`) | AI units' map letters become their plan-mode char `byte[unit+0x314B]` (≥0x80 → 'E') |
| 0x10 | Close Moves | @0x061F14 (`func_061F02`) | per-tile path-cost overlay, red summary (5,190), Z/X zoom |
| 0x20 | Far Moves | @0x062975 (`func_06295E`) | "Far: %d(%d,%d)…" overlay |
| 0x40 | All Movement | @0x062D94 (`func_062D84`) | sets latch `[0x1DF2]` honored by the Close-Moves renderer |

## 3. Per-section dialog map (all 20 DEBUG.TXT sections) — B

| section | invoker | trigger | effect |
|---|---|---|---|
| `@MEMORY` | @0x022EF8 (entry 0x022EB2) | cheat id 0x6A | display-only: %NUMBER0..3 = far-heap / menu-arena / near / stack free, %HEX4 = PSP seg (slot array DS:0x9CB0) |
| `@CREATE` | @0x0239A8 (handler @0x02397A) | cheat id 0x62 (peacetime) | unit spawner at map cursor (`[0x853E]/[0x8540]`) via `0x181F:0x95C`→`func_006D24`; result table @0x023B9A: rows→@UNIT types 0/2/1/3/5/0xB/0xC(+home)/0xA(+flag); row 9→`@CSHIP`; rows 10–13→Indian types 0x13..0x16 owned by the village under the cursor (aborts if none); row 14→`@FOREIGN`; after create `flags|=0xF0` + redraw |
| `@CREATE2` | @0x02399D | id 0x62 at war (`[0x5382]&1` @0x023996) | rows 10–13 remap → Continental Army 9 / Cont. Cavalry 7 (human power) / King's Regulars 6 / King's Cavalry 8 (REF power `[0x53D2]`) @0x023AF0–0x023B3A |
| `@CSHIP` | @0x023A8C | @CREATE row 9 | ship type = result+0xC → 0xD..0x12 (Caravel..Man-O-War) |
| `@FOREIGN` | @0x023B4B | @CREATE row 14 (peace) | creating power = result−1 (England/France/Spain/Netherlands); loops back to @CREATE |
| `@FOREIGN2` | @0x023B6A | row 14 at war | Rebel→human power / Loyal→REF power; loops to @CREATE2 |
| `@SETVIEW` | @0x023CBF (handler @0x023C9E) | cheat id 0x65 "Reveal Map" | rows 1–4: view-as-power `[0x53A4]`=result−1; row 5 Complete Map: `[0x53A2]=1` + `and [0x5383],0x7F`; row 6: no special view; then `[0x5396]`←`[0x53A4]` if ≥0; redraw |
| `@SETHUMAN` | @0x023D0C | cheat id 0x66 | sets all 4 powers AI (`PowerRec+0x543F=1` loop @0x023D2E), then result power human + `[0x5398]/[0x5394]/[0x5396]`=power; "None" → falls into `@SETAUTO` |
| `@SETAUTO` | @0x023D68 | from @SETHUMAN "None" | Yes → autoplay `[0x826]=1` (polled @0x024B01) |
| `@SETREPORT` | @0x023826 | NOT cheat — power-picker preamble for REPORTS ids 0x41–0x49 when full view `[0x53A2]≠0` @0x023816 | picked power passed to the advisor bodies (dispatch @0x023843–0x0238CF) |
| `@SETEUROPE` | @0x0236DE | VIEW id 0x22 "European Status" when full view | result power's Europe port opened via `0x181F:0x5FA`→`func_035B06`; without debug view uses `[0x53A4]`/`[0x5394]`; at war without view → GAME.TXT `@EUROPENOTAVAIL` |
| `@DANGER` | `func_078142` @0x078173 (page 0x1E) | **ungated** — 37 call sites via `0x181F:0x77E` (33 in the page-0D foreign-AI planner) | AI assertion/warning box: %STRING0 = tag ("AI1".."AI19", "Bad defense", …), %NUMBER0..2 = args; fires in the shipping binary on AI sanity-check failure |
| `@SOUND` | @0x023D86 | cheat id 0x69 "Sound Test" | numeric dialog (`0x191F:0x436`, entry → `[0x9CC8]` @0x06F6CF) → gated play `0x181F:0x4C0` — arbitrary sound-id playback |
| `@OPTIONS` | @0x023599 (`func_02356C`) | cheat id 0x63 | §2 bitfield |
| `@FORCED` | @0x023967 (handler @0x02391C) | cheat id 0x68 "Advance Revolution Status" | staged, one per invocation: (a) `[0x53D0]<0x4B` → set 75 + create REF power if none (`0x191F:0x364`→`func_03C638`); (b) declare independence (`0x191F:0x356`→`func_03DE46`, sets `[0x5382]|=1`); (c) next war stage (`0x348`→`func_03D948`, `|=2`); (d) `[0x5382]|=0x20` + show @FORCED text. `[0x5381]&0x80` blocks b–d |
| `@TEST` | @0x0217D1 (entry 0x0217AC) | cheat id 0x6F "Test Routine" | `and [0x5382],0xF4` (clears bits 0/1/3) + dialog with %NUMBER0=unit count `[0x539C]`, %NUMBER1=colony count `[0x539E]` |
| `@MOTD` `@MOTD2` `@BADGUYS` `@END` | — | — | **DEAD**: section-name strings absent from every shipped EXE (byte-scanned; @END's body is empty anyway) |

### Non-TXT cheat items
- **id 0x67 "Kill Indians"** @0x023BDC: runtime-built tribe menu (8 recs
  stride 0x4E, dead bit `[0x5AD9+i·0x4E]&0x80`); result → `0x191F:0x442` =
  `func_046FC2`: destroys every village (base DS:0x54EC, stride 0x12) whose
  owner = tribe+4.
- **id 0x6B "Show Strategy"** → `func_02165E`: pass 1 plots 64×4-byte AI
  strategy slots per power (BSS DS:0x98B0+power·0x100, `{x,y,?,type}`)
  via `0x191F:0x12C`; wait-key; pass 2 prints 14 counter rows at
  (5, i·7+10) color 0xF (labels from runtime BSS table DS:0x85C8+2i — TBD).
- **id 0x6C "Show Colony Sites"** → `func_021602`: per-tile site
  desirability (low nibble of flag byte via `0x181F:0x74A(0xF,·,·)`) drawn
  over the map; wait-key + redraw.
- **id 0x40 "Terrain Information"** @0x023808 → the **Colonizopedia
  TERRAIN page** (`0x191F:0x428` → `func_069D8C`) with the tile at
  (`[0x8540]`,`[0x853E]`) — consistent with the 2026-07-30 pedia ruling.
- **id 0x2A "Show Hidden Terrain"** → `func_022E16` (top entry).

## 4. Side-effect global index (write/read sites in §3)
`[0x894]` debug bits · `[0x5383]`&0x20 cheat master · `[0xB92]` WIN state ·
`[0x53A2]` complete-map · `[0x53A4]` view-as-power · `[0x5396]` render
power · `[0x5398]` human · `[0x5394]` current · `[0x53D2]` REF power ·
`[0x53D0]` revolution meter · `[0x5382]` game-state bits · PowerRec+0x543F
AI flag · `[0x826]` autoplay · unit array DS:0x3134 stride 0x1C · village
array DS:0x54EC stride 0x12 · `[0x9CB0..]` %NUMBER slots · `[0x9CC8]`
numeric-entry · `[0x1F5E]` dialog-context word (consumer TBD).

## 5. Open items (exact trace sites)
1. Show-Strategy row labels: dump BSS DS:0x85C8+2i during `func_02165E`
   pass 2 @0x0216F0.
2. Sound-Test menu record patch `es:[rec+2]=0x13` @0x072A85 — meaning TBD.
3. `[0x1F5E]` consumer; `[0x853E]/[0x8540]` x-vs-y naming anchor.
4. `0x191F:0x2A4/0x296/0x288` semantics in Show-Hidden-Terrain @0x022E22.
5. `@CUP` "~F~0~1…" accelerator wiring in the menu runner.
6. MAPEDIT's dead `_memory_check` references DEBUG.TXT `@MEMORY` too
   (`spec/ui/map_editor.md` §5) — same section, different program.
