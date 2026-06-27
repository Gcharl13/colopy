# Unit Orders

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** order list + key letters + **order-code storage (`0x314C`) + work counter (`0x315A`) + pioneer durations + fortify `·3/2` mechanism `BYTE_VERIFIED`** (2026-06-20, cross-ref `unit.md`/`terrain_improvement.md`/`combat.md`). **Canonical primary:** `data_extracted/text/NAMES_sections.json` `@ORDERS`/`@ACTIONS`; `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
A unit can be given a standing order that persists across turns and suppresses auto-activation: Sentry, Fortify, Go To, Build Colony, Clear/Plow, Build Road, Live In Village, Trade Route, or No Orders. Pioneers do terrain work (clear/plow/road); soldiers fortify (defense bonus); ships and wagons can run trade routes. **RECONSTRUCTED** (manual §"Unit orders").

## 2. State & data
The active order is stored at **`UnitRecord 0x314C`** (base `0x3144`, stride 28) —
**BYTE_VERIFIED (2026-06-20)**: both dispatchers read it (`@0x249CB mov al,[bx+0x314c]`
→ jump table orders 2..9; `@0x051DCE` `sel=[0x314c]−7`), and immediate writes exist for
every order value (1 Sentry `@0x078CF`, 2 Trade Route `@0x22E05`, 3 GoTo `@0x22D2D`,
5 Fortify `@0x22105`, 6 Fortified `@0x41024`, 7 Build Colony `@0x2279E`, 8 Clear/Plow
`@0x22324`, 9 Build Road `@0x2250E`, 0xA–0xC AI). The pioneer **work-progress counter
is a separate field `0x315A`** (`terrain_improvement.md`).

### 2.1 Per-turn dispatcher → handler decode (BYTE_VERIFIED 2026-06-25)

The active-unit per-turn dispatcher `@0x249CB` does
`IMUL bx,[0x5392],0x1c` (active-unit idx × 28) · `mov al,[bx+0x314c]` ·
`dec ax/dec ax` (code−2) · `cmp ax,7 / ja default(0x24A22)` (handles codes **2..9**) ·
`shl ax,1` · `jmp word cs:[bx+0x3b58]`. The 8-entry word table at **file `0x24A38`** =
`{0x3b26,0x3b0e,0x3b42,0x3b36,0x3b42,0x3b1a,0x3af4,0x3b02}` (cs-relative; cs_base
`0x20EE0`) maps codes 2..9 to handler stubs `0x24A06,0x249EE,0x24A22,0x24A16,0x24A22,
0x249FA,0x249D4,0x249E2`. Each stub `LCALL`s a thunk whose **resolved per-turn executor**
is:

| Code | Order | Dispatcher stub @0x249CB | Thunk | Per-turn executor |
|----|-------|--------------------------|-------|-------------------|
| 2 | Trade Route | `0x24A06` | `0x191f:0x2b2` | **`func_041080`** |
| 3 | Go To | `0x249EE` | `0x191f:0x4ba` | **`func_040E22`** |
| 4 | Live In Village | *(default `0x24A22`)* | — | no per-turn map executor (passive) |
| 5 | Fortify | `0x24A16` | `0x191f:0x4ac` | **`func_04101C`** — *writes code 6 at `0x41024`*, byte-proving the Fortify(5)→Fortified(6) next-turn promotion |
| 6 | Fortified | *(default `0x24A22`)* | — | passive (defense bonus only) |
| 7 | Build Colony | `0x249FA` | `0x191f:0x1fa` | **`func_040C1E`** |
| 8 | Clear/Plow | `0x249D4` | `0x191f:0x1c2` | **`func_040656`** (matches `terrain_improvement.md`) |
| 9 | Build Road | `0x249E2` | `0x191f:0x216` | **`func_0409D6`** (matches `terrain_improvement.md`) |

**Reconciliation with the 2nd dispatcher `@0x051DCE`** (operand `[bp+6]`, `sel=ax−7`,
`cmp ax,5 / ja default`, table at **file `0x51E1A`** `{0x5bfc,0x5be6,0x5bf2,0x5c10,
0x5c06,0x5c06}`, cs_base `0x4C1F0`): it covers codes **7..12** and its stubs for
7/8/9 (`0x51DEC/0x51DD6/0x51DE2`) `LCALL` the **same thunks** (`0x191f:0x1fa`,
`0x191f:0x1c2`, `0x191f:0x216`) → the same executors `func_040C1E/func_040656/
func_0409D6`, cross-confirming the code→handler binding. (10→`0x181f:0x934`
unresolved; 11/12→`0x191f:0x4ba` reuse the Go-To handler; AI-only per §2.)

**Order-code STORAGE (init) vs EXECUTION (per-turn) are distinct functions.** The code is
first written by an order-**init** routine (e.g. `func_021FF2`→5, `0x21FEB`→1, `0x22E05`→2,
`0x22D2D`→3, `0x2279E`→7, `0x22324`→8, `0x2250E`→9), then read each turn by the dispatcher
above. **Row index == stored order code** for every byte-verified row (init writes confirm it).

`@ORDERS` rows (NAMES, **BYTE_VERIFIED present**) — `name, key-letter`:

Definitive keymap (command letter → @ORDERS row index → order code @ `0x314C` →
per-turn handler). **Letter+row** from NAMES `@ORDERS` (present, **B**); **code** from the
order-init writers; **handler** from the `@0x249CB` jump table (§2.1). Row index ==
order code for all proven rows.

| Idx | Order | Key | Code @0x314C | Init write (stores code) | Per-turn handler (`@0x249CB`) | Tier |
|----|-------|-----|------|------|------|------|
| 0 | No Orders | `-` | 0 | `@0x21ED7` / `@0x22CAA` (set 0) | — (auto-activate) | **B** |
| 1 | Sentry | `S` | 1 | `@0x21FEB` (set 1) | — (skip; pre-existing spec cites init `@0x078CF`, unreconciled) | **B** |
| 2 | Trade Route | `T` | 2 | `@0x22E05` | **`func_041080`** | **B** |
| 3 | Go To | `G` | 3 | `@0x22D2D` | **`func_040E22`** | **B** |
| 4 | Live In Village | `L` | 4 | **No store site exists in VICEROY.EXE** — exhaustive scan of every write to `0x314c` (immediate `C6 87 4C 31 imm8` and register `88 87/84 4C 31`) yields codes {0,1,2,3,5,6,7,8,9,0xA,0xB,0xC} but **never 4**; the one parameterized bulk-setter `func_007936 @0x7952` is fed code 1 by its sole caller `func_03ECF0 @0x3F56C` (`push 1`), and all register writes store `al=0` (order-clear). Code 4 is a menu/`@ORDERS` row with no persisted standing order. | default stub `0x24A22` (passive) — dispatcher table `@0x24A38` code-4 entry `0x3b42` = the `ja default` target `0x24A22`, same as Fortified(6), i.e. no dedicated executor | **B** (row) / handler **B** |
| 5 | Fortify | `F` | 5 | `@0x22105` (`func_021FF2`) | **`func_04101C`** → promotes to 6 | **B** |
| 6 | Fortified | `F` | 6 | `@0x41024` (set by `func_04101C`) | default stub `0x24A22` (passive, +50% def) | **B** |
| 7 | Build Colony | `B` | 7 | `@0x2279E` | **`func_040C1E`** | **B** |
| 8 | Clear/Plow | `P` | 8 | `@0x22324` | **`func_040656`** | **B** |
| 9 | Build Road | `R` | 9 | `@0x2250E` | **`func_0409D6`** | **B** |
| 10–12 | No Orders (reserved/AI) | `-` | 0xA–0xC | AI-only | AI (10→`0x181f:0x934` unresolved) | **B** |

### 2.2 `@ORDERS` accelerator/status-letter table `0x54de[13]` (BYTE_VERIFIED 2026-06-25)

A NAMES-section table-builder (loader body **file `0x074E70..0x074FE0`**; exact ENTER
entry not linearly recoverable — reached via overlay/RTLink, so cited by body region)
opens the `@ORDERS` section and parses its accelerator letters into a DGROUP byte array
at **`0x54de`**:

- `@0x074F69` `push 0x225d` — DGROUP `0x1D9A0 + 0x225d = file 0x1FBFD = "ORDERS\0"`
  (byte-verified) — `push 0x882` · `lcall 0x191f:0x928` (section opener, **`func_06F8FA`**,
  identity prior-confirmed; see blocker).
- 13-row loop: `@0x074F77` `[bp-8]=0`; `@0x074F9D` `cmp word[bp-8],0xd / jge` (exactly
  **13 rows** = the 13 `@ORDERS` rows). Per row: skip spaces (`@0x074F7E`
  `cmp byte es:[bx],0x20`), take first non-space (`@0x074F90` `mov al,es:[bx]`), store
  (`@0x074F96` `mov bx,[bp-8]; mov byte[bx+0x54de],al`).
- Result: **`0x54de[row] = {'-','S','T','G','L','F','F','B','P','R','-','-','-'}`** — **runtime-confirmed 2026-06-25** (this exact 13-byte sequence occurs once in live DOS RAM at DGROUP `0x54de`, seg `0x1cfd`; `tools/runtime_snapshot.py`, `docs/RUNTIME_SNAPSHOT.md`). (NAMES
  `@ORDERS`, 13 rows). **Row index == order code** (matches §2/§2.1). After the loop the
  same builder opens `@ACTIONS` (`@0x074FC4` `push 0x2264 = file 0x1FC04 = "ACTIONS\0"`)
  for a sibling table — confirming this is a general menu-letter builder.

### 2.3 On-map status-letter renderer `func @0x0386A` (BYTE_VERIFIED 2026-06-25)

`0x54de` is used **dually**: the same array is the on-map unit status glyph table.
**`func @0x0386A`** (prologue `enter 0x46,0`; runs to ~`0x039E0`; note: the linear-sweep label `func_038F2C` names a DIFFERENT function with no `0x54de` reference — the renderer entry is `0x0386A`, corrected via independent disasm) renders one status letter per visible unit. Registers: **`di` = owner/nationality**
= `[bx+0x3147] & 0xf` (`@0x038FE`); **`[bp-0x40]` = unit-record base ptr**; **`si` = the
per-unit loop/state selector** (si-dispatch ladder `@0x0399E..0x039DB` testing si ∈
{4,5,7,8,0xa,0xb,0xc,0x15,0x16}); `[bp-1]` = chosen glyph.

Default glyph: `@0x03907` `mov cl,[bx+0x314c]` (**order code**) → `@0x0390D`
`mov [bp-0xa],cx`; `@0x03910` `cmp ax,4 / jl` then `@0x03915` `mov [bp-0xa],0` (clamp to 0
when owner index `di>=4`); `@0x0391A` `mov bx,[bp-0xa]`; **`@0x0391D` `mov al,[bx+0x54de]`**;
`@0x03921` `mov [bp-1],al`. So **`0x54de` is indexed by the unit's order code
(`UnitRecord 0x314c`)** — the same value §2/§2.1 dispatch on.

Three overrides replace the default glyph:
- **Ship cargo count as ASCII digit** when unit type `[bx+0x3146] ∈ 0x0d..0x12` and the unit
  is not own-viewer (`@0x03927` `cmp byte[bx+0x3146],0xd/jb`; `@0x0392E` `..,0x12/ja`;
  `@0x03935` `cmp [0x5396],di/je` skip): `@0x0393B` `mov al,[bx+0x3150]` `+ 0x30`
  (`@0x0393F`) → `[bp-1]`.
- **`'X'` (0x58)** `@0x03955` when `si==0x10` (`@0x03944`) and `[0x53a2]==0` (`@0x03949`).
- **AI-state char `[bx+0x314b]`** `@0x0397B` → `[bp-1]`, replaced by **`'E'` (0x45)**
  `@0x03986` when `[bx+0x314b] >= 0x80` (`@0x03982` `cmp al,0x80/jb`).

### 2.4 No key-match scan over `0x54de` (menu selection is engine-internal) — PROVEN

A full-binary scan finds **exactly two** code references to `0x54de`: the writer
`@0x074F96` and the reader `@0x0391D` — and **zero** register-constant loads
(`mov bx/si/di,0x54de`, `lea [..],0x54de`). Therefore the on-map orders **menu** does NOT
select a row by scanning a pressed key against `0x54de[]`; accelerator matching happens
**inside the section/dialog engine `func_06F8FA`** from the `@ORDERS` text itself. `0x54de`
serves only the on-map status glyph (§2.3). The exact in-engine key-match site is **TBD**
(inside `func_06F8FA`; not byte-located here). Do not fabricate a `0x54de` key-scan loop.

> Note the two states "Fortify" (in progress) vs "Fortified" (active) — distinct rows, matching the manual's "not gain the effects until the following turn."

`@ACTIONS` (native-interaction menu, BYTE_VERIFIED present): Trade With Village, Enter Hostile Village, Establish Mission, Denounce Heresy of %Fs Mission, Live Among The Natives, Ask to Speak With Chief, Incite Indians, Demand Tribute, Attack Village, Cancel Action.

## 3. Formulas & rules
- Fortify = **+50% defense bonus**, applied as a **`·3/2` multiplier in the land
  strength-modifier chain inside `func_05CA7E`** — **mechanism BYTE_VERIFIED**
  (`spec/systems/combat.md` §3/§7.1; the `+50%` *value* is manual-sourced **R**).
- Clear/plow/road completion times, tool cost, and terrain transitions are
  **BYTE_VERIFIED** in `spec/systems/terrain_improvement.md` (executors `func_040656`
  clear/plow / `func_0409D6` road; work-counter `UnitRecord +0x16` abs `0x315A`;
  threshold from the `@TERRAIN` table `terrain·16 + 0x2F78`, **+2** clear/plow / **+0**
  road; **Hardy Pioneer halves**; tools **−20**).
- Sentry auto-board outgoing ships; aboard ship = forced sentry (manual; **RECONSTRUCTED**).

## 4. UI
Orders shown as a single key letter in the active-unit orders box; commands via on-map keys. See `docs/UI_RENDER_MAP.md`, `docs/SESSION_UI_CATALOG.md`.

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@ORDERS` (13 rows w/ key letters), `@ACTIONS`. **B**
- `docs/GAME_MANUAL.md` — fortify/sentry/clear-plow/trade-route function. **R (function HIGH; numbers EXE-win)**

## 6. Open questions (TBD)
1. ~~Find the `UnitRecord` offset storing the order code and the work-progress counter.~~
   **Done 2026-06-20** — order code = `UnitRecord 0x314C`, work-progress counter =
   `0x315A` (§2; cross-ref `unit.md` §2, `terrain_improvement.md`). **B.**
2. ~~Byte-verify the fortify defense multiplier and pioneer task durations.~~ **Done
   2026-06-20** — fortify `·3/2` (+50%) mechanism in `func_05CA7E` (`combat.md`);
   pioneer durations/tool-cost in `terrain_improvement.md` (§3). **B** (mechanism).
3. ~~Trade Route data structure → see `spec/systems/trade_routes.md`.~~ **Covered** —
   `trade_routes.md` is fully byte-verified (all §6 items closed). **B** (cross-ref).
