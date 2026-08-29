# Unit System

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R. Details pending — breadth pass.

**Overall confidence:** **UnitRecord base `0x3144` + near-complete field map +
`@UNIT` stat-column→runtime mapping `BYTE_VERIFIED`** (2026-06-20). **Canonical
primary:** the placer/renderer/loader byte-traces (§2/§3); `data_extracted/text/NAMES_sections.json`
`@UNIT`/`@CLASS`/`@ORDERS`. (Prior `docs/DATA_MODEL.md` base `0x3146` + map_x=+0x07
labels superseded — RULINGS 2026-06-20.)

## 1. Purpose & behavior
A unit is any mobile actor on the map — colonists, soldiers, pioneers, scouts, ships, wagon trains, treasure, artillery, and native braves. Each carries a type, a position, movement, combat values, and current orders. Land units may be carried by ships (sentry while aboard, per manual). **RECONSTRUCTED** (manual + @UNIT).

## 2. State & data
`UnitRecord` base **`DGROUP:0x3144`**, **stride 0x1C (28 bytes)** (corrected from the
prior `0x3146` base — RULINGS 2026-06-20). Fields by **absolute** address (the base
convention is ambiguous, so offsets are given absolute):

| abs | Type | Meaning | Tier | Evidence |
|-----|------|---------|------|----------|
| `0x3144` | u8 | **map_x** (drawn position) | **BYTE_VERIFIED** | renderer `@0x03A63`, placer `@0x06958` |
| `0x3145` | u8 | **map_y** | **BYTE_VERIFIED** | renderer `@0x03A5E`, placer `@0x0695E` |
| `0x3146` | u8 | **unit_type** (`@UNIT` row 0..23; ×stat-table index) | **BYTE_VERIFIED** | dispatcher `@0x51D6B`; 694 refs |
| `0x3147` | u8 | **owner/power nibble** (`&0xF` = power 0..11) + state hi-nibble | **BYTE_VERIFIED** | `set_unit_owner @0x738E`; `@0x51D88` |
| `0x3148` | u8 | **transient per-unit flag/scratch register** (bits set & cleared *within* individual processing passes, not a stable persistent attribute; bit `0x08` = tile-dirty/redraw **BYTE_VERIFIED**, bit `0x80` = draw-time/active marker) | **A** | full site map below; 0x08 set→test→clear→redraw `func_046FFA @0x0481B0/@0x0481EA`; 0x80 set/draw/clear `func_0696C6 @0x069923/@0x069942`, renderer test `@0x037AD`/`@0x079EF` |
| `0x3149` | u8 | **AI move-credits SPENT this turn — RESOLVED 2026-06-26** (was AI-GATED). A points-per-action accumulator: reset to 0 for every unit at turn start (`@0x005872`) + on spawn/re-task (`@0x006D7F`/`@0x04FD92`); charged **+3** per step (`@0x05CAE2`), **+0x32/+2** per heading-AI move (`func_059B90 @0x059F20/@0x059F3C`). A unit may act while `allowance − [0x3149] ≥ 3` (`@0x03EE95`); "out of moves" once `≥ allowance` (`func_0079A0 @0x007A08`). **Allowance** = per-type byte from data table `0x5234` (stride 14, `@0x006CEE`) +3 for ships. The `cmp [0x3149],0` gates select units that already acted (spent≠0). Full trace: **`spec/systems/ai.md` §5.** Oracle: player units = 0, native braves nonzero (6,6,8,3,3,9). | **BYTE_VERIFIED (= move-credits spent)** | reset `@0x005872`/`@0x04FD92`; charge `@0x05CAE2`(+3)/`@0x059F20`(+0x32); gate `@0x03EE95`/`@0x007A08`; allowance table `0x5234` `@0x006CEE`; see `ai.md` §5 |
| `0x314A` | u8 | countdown timer (init `0xFF`, `dec`) | **A** | `@0x2EF17`, init `@0x06DBA` |
| `0x314B` | u8 | **AI state-char — persistent per-unit AI mode (full alphabet RESOLVED 2026-06-26).** The prior turn writes a letter; the next turn's dispatch reads it to resume the right mission. ~30 states decoded: `X`=cleared/init, `-`=dead slot, `0`=idle/sentry, `1`=target-selected, `t`/`i`=goal-class 1/7, `?`=goal-lost, `@`=dropped, `9`=out-of-budget, `A`=colony-task-committed, `G`=garrisoned, `E`=en-route-goto, `R`=routed, `V`=arrived-at-colony, `L`=routing-in, `=`=absorbed, `U`=on-target, `C`=work-done, `B`/`e`=terrain-build, `F`=region-match-step, and `2 3 4 5 8 D J N P W`=mission-dispatch tags (via `func_04E2B6`). Full table + assign sites: **`spec/systems/ai.md` §4.** | **BYTE_VERIFIED (alphabet)** | init `@0x06D84`; full assign-site table in `ai.md` §4 |
| `0x314C` | u8 | **order code** (0..0x0C) | **BYTE_VERIFIED** | dispatchers `@0x249CB`/`@0x51DCE` |
| `0x314D`/`0x314E` | u8×2 | **goto-target x/y** (also trade-route next-stop) | **BYTE_VERIFIED** | GoTo writer `@0x22D38` |
| `0x314F` | u8 | **facing / heading direction** (8-way compass, values 0..7; **8 = invalid/none sentinel**). NOT europe/recruit state — that gloss is refuted. Proven by the `xor al,4` reverse-direction test (8-way compass reverse) at `@0x047AA8` and `@0x062F7C`, the angular-distance scoring `d = 0x314F − target; if d>4 then d=8−d; score −= d²·2` at `@0x051712..0x051737`, and the `cmp [bx+0x314f],8 / jge` bound at `@0x0516F0`. AI reads it as a turn/momentum cost and writes it (`@0x051A95`, `@0x05A0C4`, `@0x0633B8`). | **BYTE_VERIFIED (= heading 0..7)** | `@0x047AA8`(xor4)/`@0x062F7C`(xor4)/`@0x0516F0`(cmp 8)/`@0x051712`(angular sq)/write `@0x051A95`,`@0x05A0C4`,`@0x0633B8` |
| `0x3150` | u8 | **cargo count** (# goods in hold) | **BYTE_VERIFIED** | `get_nth_cargo @0x0B2AB`, init `@0x06D93` |
| `0x3151..0x3153` | nib | **cargo good-ids** (nibble-packed, 2/byte, ≤6) | **BYTE_VERIFIED** | `@0x0B2CB` |
| `0x3154..0x3155` | u8×2 | **cargo quantities** (per slot) | **A** | `@0x0B2FB` |
<!-- +0x12 (0x3156): overloaded timer field, NOT cost/sale/treasure — see resolution note below; init byte 0xFF @0x06DA3 (owner<4) / word [0x538e] @0x06DB3 (owner>=4) -->
| `0x3156` | u16 / i8 | **overloaded per-unit timer field — NOT cost/sale/treasure.** AI/native units (owner nibble ≥4): word = snapshot of game-progress counter `[0x538e]`; the AI scorer reads it as `elapsed = (progress·k) − stored` (SUB sites). Player units (owner <4): byte `0xFF` sentinel, lazily replaced by a random byte `0..0x13` on first use. | **BYTE_VERIFIED** | init word `=[0x538e]` for owner≥4 `@0x06DB3` / byte `0xFF` for owner<4 `@0x06DA3`; AI read `SUB ax,[bx+0x3156] @0x4769C`/`@0x476B6`/`@0x4822B`; re-stamp `=[0x538e]` + set +0x06 bit8 `@0x481E6..0x481EA`; player RNG byte path `CMP byte,0;JGE;rand(1,0x14)-1 @0x50C75..0x50C8C` |
| `0x3158` | u8 | **per-turn land-unit boolean (0/1)** — cleared at turn-refresh for land units and at Wagon-Train creation; set to 1 after the unit's cargo-load/move; **read only for Wagon Trains** (gates a colony-search block). Exact label (moved-this-turn vs trade-leg-done vs route-recompute) needs a runtime trace — set/clear/test sites all byte-verified. **R (label)** | **A** | init0 (land) `@0x04968D` / init0 (Wagon Train) `@0x006E0C`; set1 (land, after cargo-load LCALL `func_00B368`=`0x181F:0x0D58`) `@0x04F730`; test ==0 (Wagon Train only) `@0x0507E1`; all in `func_04E2D6` |
| `0x3159` | u8 | **tools** (0..100; −20/pioneer-action, revert to Colonist if <20) | **BYTE_VERIFIED** | `@0x4060F`, init `@0x06E3F` |
| `0x315A` | u8 | **work/turns-in-activity counter** (clear/road/fortify) | **BYTE_VERIFIED** | `@0x04071D`/`@0x2EFD6` |
| `0x315B` | u8 | **class/profession** (0x13..0x1C); route units: lo nib=route, hi=stop | **BYTE_VERIFIED** | combat `@0x5B60E`, write `@0x09548` |
| `0x315C`/`0x315E` | u16×2 | per-tile occupancy back/next links (unit idx) | **BYTE_VERIFIED** | placer `@0x06976`/`@0x06968` |

(`0x3149` and `0x314B` are now **RESOLVED** via the L4 AI decode — see `spec/systems/ai.md`
§4/§5. `0x3158` and the minor `0x3148` bits remain at their ceiling: their meaning-bearing
consumers are the orphan-overlay AI routines `func_04E2D6`/`func_04CC50`/`func_02F052`; the
exact English label of each is recoverable only by the strategic-AI pass that fills the plan
map — the next L4 target. See the per-field rows, the `0x3148` bit table, and `ai.md`.)

**`0x3148` bit register — byte-verified site inventory (set/clear/test).** Exhaustive
scan of VICEROY.EXE finds 46 instructions referencing `[..+0x3148]`. The byte is a
*transient scratch register* — bit `0x08` is a tile-dirty/redraw flag in `func_046FFA`
but a ship-route flag (set with `0x04` via `OR 0x0C`) in `func_04CC50`/`func_04E2D6`,
proving the bits are context-overloaded, NOT a single persistent attribute map.
Per-bit set/clear/test sites (all byte-verified):
| bit | SET sites | CLEAR sites | TEST sites | proven? |
|-----|-----------|-------------|-----------|---------|
| `0x80` | `OR 0x80` @0x05B6F6, @0x05BB9E (combat), @0x069923 (`func_0696C6`, then blit) | `AND 0x7F` @0x02F135 (`func_02F052`), @0x069942 | `@0x037AD`(→sprite 0x42), `@0x079EF`, `@0x02F088`, `@0x052E66`, `@0x05B6A2`, + resident `@0x030B8F`/`@0x0331F2`/`@0x033A22`/`@0x0359C4` etc. (16 total) | **two byte-verified uses, distinct subsystems.** (a) DRAW: `func_0696C6 @0x069923 OR 0x80` then blit / `@0x069942 AND 0x7F`; renderer `@0x037AD test 0x80 → sprite 0x42` — a draw-time active/highlight marker. (b) AI per-power pass `func_02F052`: `@0x02F088 test 0x80` (skip set units unless type 0xB Artillery), and after a unit's accumulated `0x315A` counter reaches its defense stat `0x5235` it `AND 0x7F` clears it (`@0x02F135`) — i.e. "unit still pending in this AI pass." The two are not byte-linked; a single English name needs a runtime trace of the blit wrapper (`needs: new_oracle_capture`). |
| `0x40` | `OR 0x40` @0x02F37A (`func_02F052`, after goto+work-counter) | — | `@0x05BD1E` (combat bombardment gate) | **per-site BYTE_VERIFIED, unified label blocked.** SET site `func_02F052 @0x02F351..0x02F37A` (page_03): for a unit relocated by the active power, copies relocation-target x/y from `[0x84fc]+0x32/+0x33` into goto `0x314D/0x314E`, stores an lcall-returned work-count in `0x315A`, then `OR 0x40` — i.e. "unit assigned a fresh goto/relocation target this pass." TEST `@0x05BD1E` (page_10) gates a 6-entry type-vs-table scan (`cmp [bx-0x6873]`) into a 0x13c-stride combat record — a distinct subsystem. No dataflow proven between the two; a single English label needs a runtime trace (`needs: new_oracle_capture`). |
| `0x20` | `OR 0x20` @0x04CE44 (`func_04CC50`, type 0x0E Merchantman) | `AND 0xD1` @0x04CEB1 | `@0x04F3D7`, `@0x0507A3`, `@0x052467` | **RESOLVED (fully static) = "current record is a Merchantman" — a per-pass trade-AI Merchantman tag.** The whole SET→CLEAR→TEST dataflow is statically determined (no runtime input). SET `@0x04CE38..0x04CE49` (`func_04CC50`, page 0x0D, record stride 0x1c): `imul bx,[bp-0x152],0x1c / cmp byte [bx+0x3146],0xe / jne / OR [bx+0x3148],0x20` (+`[bp-0xa]=1`) — set iff unit_type (+0x3146) == 0x0E (Merchantman, the `@UNIT` row index). CLEAR `AND 0xD1` @0x04CEB1 re-derives the 0x20/0x08/0x04/0x02 scratch nibble each pass, so the bit is a recomputed-per-pass tag, not a persistent attribute. All three TEST sites (page 0x0D, same array, `imul bx,...,0x1c`) consume it as a "this record is a Merchantman" gate, verified by capstone of VICEROY.EXE: `@0x04F3D7 test [bx+0x3148],0x20 / je 0x4f3e1 / jmp 0x4f73e` (Merchantman → divert), `@0x0507A3 test ...,0x20 / je 0x507ad / jmp 0x50196` (Merchantman → divert), `@0x052467 test ...,0x20 / je 0x52473 / mov [bp-2],1` (Merchantman → set local flag). The bit's English is therefore fully recovered: per-pass marker "unit_type==0x0E (Merchantman)", used by the trade-AI to skip/divert Merchantman units. |
| `0x10` | `OR 0x10` @0x05106E (`func_04E2D6`, path≥8), @0x05D4BF (combat) | `AND 0xEF` @0x051094 | `@0x050FEA`, `@0x05B3A9` | **AI-path SET BYTE_VERIFIED = "pathfinder hop-count ≥ 8" (long-haul marker); combat SET is a separate use.** `@0x051069 cmp ax,8 / jl skip / @0x05106E OR 0x10`, where `ax` is the return of pathfind lcall `0x181f:0x37a` — confirmed hop-count, not move-budget. CLEAR `@0x051094 AND 0xEF` after a different pathfind returns 0. The combat SET `@0x05D4BF` is in an unrelated branch (reads current-colony `[0x8542]+0x1f`, sets a co-flag `[bp-4]=1`) — overloaded second use. Unified label needs a runtime trace (`needs: new_oracle_capture`). |
| `0x08` | `OR 0x08` @0x0481EA (`func_046FFA`), @0x04CDCC (as `0x0C`, `func_04CC50` ship) | `AND 0xF7` @0x0481A2/@0x0481B7, `AND 0xD1` @0x04CEB1 | `@0x0481B0`(→clear+redraw), `@0x04CDFC`(`0x0C`), `@0x04E08A`, `@0x056E63` | **dirty/redraw flag in `func_046FFA` — BYTE_VERIFIED**; overloaded as ship flag elsewhere |
| `0x04` | `OR 0x04` @0x04CDDC, @0x04CDCC (as `0x0C`) (`func_04CC50` ship) | `AND 0xD1` @0x04CEB1 | `@0x04CDFC`(`0x0C`), `@0x04E068` | **per-site BYTE_VERIFIED structure; exact cargo condition needs the cargo-class jump table.** Set in `func_04CC50` only for ships (`cmp [bx+0x3146],0xd / jb skip; cmp 0x12 / ja skip` @0x04CD0F-0x04CD1E) gated on the two cargo-classifier results `[bp-0x1c]`/`[bp-0x1a]` returned by lcall `0x181f:0x8bc` (a per-cargo-good classifier; `[bp-0x1a]` for slot-class, loop counter `[bp-0x1c]`). `OR 0x0C` (=0x08|0x04) vs `OR 0x04` distinguish two cargo conditions. CLEARED with 0x20/0x08/0x02 by `AND 0xD1` @0x04CEB1 each pass → a recomputed ship-cargo scratch bit. The precise English (which cargo class sets 0x0C vs 0x04) is blocked on decoding the `JMP cs:[bx+0xd78]` 15-entry good-class table in `func_0073A8 @0x0073E2` (RTLink-overlaid resident cs base ambiguous; static cs:base for that table not resolvable here without a runtime cs read). |
| `0x02` | `OR 0x02` @0x04CEC9 (`func_04CC50`, order 0x314C∈{5,6}) | `AND 0xD1` @0x04CEB1 | `@0x051AB9` (Fortify↔Fortified promote) | **RESOLVED 2026-06-27 = "unit was in a fortify state this pass" (Fortify→Fortified eligibility).** Orders 5/6 are byte-decoded from `@ORDERS` (NAMES) as **5=Fortify, 6=Fortified** (idx0=No Orders,1=Sentry,2=Trade Route,3=Go To,4=Live In Village,5=Fortify,6=Fortified,7=Build Colony,8=Clear/Plow,9=Build Road). SET `@0x04CEB6..0x04CEC9`: `cmp 0x314C,5 / je; cmp 0x314C,6 / jne skip; OR 0x02` — set iff current order is Fortify or Fortified. TEST `@0x051AA2..0x051AC3`: if order∉{5,6} force order:=5 (Fortify); then `test 0x02 / jne -> order:=6 (Fortified)` — i.e. a unit already fortifying last pass is promoted to Fortified. So 0x02 = "was-fortifying" promotion gate. |
| `0x01` | — none — | — none — | — none — | **unused** (no site in EXE) |

Enclosing functions: `func_02F052` (page 0x03, per-power AI auto-move pass — gates on
`0x80`+type 0x0B, clears `0x80`, sets `0x40`); `func_04CC50` (page 0x0D, per-unit
flag classification — ship/order bits); `func_04E2D6` (page 0x0D, AI reachability pass);
`func_046FFA` (page 0x0C, `0x08` dirty/redraw cycle); `func_0696C6` (page 0x16, `0x80`
draw wrapper). All eight bits have **byte-verified set-sites + primary meanings** (table above): `0x20`=Merchantman
tag and `0x02`=was-fortifying are fully static **B**; `0x80`/`0x40`/`0x10`/`0x08`/`0x04` are **B** at
their primary use. The only residual is a single *unified English label* for the three **overloaded**
bits (`0x80`/`0x40`/`0x10`, each reused by a second subsystem) plus `0x04`'s precise cargo-class
(blocked on the `func_0073A8` good-class jump-table cs-base) — **R (label)**, not a structural gap.

`@UNIT` rows (NAMES, **BYTE_VERIFIED present**): Colonists, Soldiers, Pioneers, Missionaries, Dragoons, Scouts, Regulars, Cont. Cav., Cavalry, Cont. Army, Treasure, Artillery, Wagon Train, Caravel, Merchantman, Galleon, Privateer, Frigate, Man-O-War, Braves, Armed Braves, … (24 rows). Each row carries `name, sprite_id, <8 numeric cols>, <8-bit flag string>`. **Column semantics: BYTE_VERIFIED** — the `@UNIT` loader at `@0x074EC3` parses each row into the runtime stat table (base `0x5230`, stride 14) per the column map in §3 (movement=col1 stored ×3 @`0x5234`, attack=col2 @`0x5236`, defense=col3 @`0x5235`, cargo=col4 @`0x5237`, then move-class/hull/size/guns/ai-value @`0x5238..0x523C`, flags @`0x523D`). The per-column parse+store sequence is byte-verified at `func_074EC3 @0x074EF9..0x074F59` (sprite store @`0x074EF9`; movement ×3 via `SHL al,1 / ADD al,cl` @`0x074F04`).

`@CLASS` (8 colonist classes w/ a number, BYTE_VERIFIED present): Petty Criminals 300, Indentured Servants 400, Peasant Farmers 600, Skilled Craftsmen 800, Hardy Pioneers 1450, Town Merchants 1500, Trained Mercenaries 1900, Educated Elite 2000.

## 3. Formulas & rules
**@UNIT column → runtime stat table — BYTE_VERIFIED (2026-06-20).** The `@UNIT`
loader (`@0x074EC3`/`@0x074EEE`) parses 23 rows into a per-type table at base
**`DGROUP:0x5230`, stride 14 (0x0E)**, indexed `type·14`:
| @UNIT col | runtime | field |
|-----------|---------|-------|
| name | `0x5230` (word) | name-string pointer |
| sprite | `0x5232` | sprite_id |
| 1 | `0x5234` (stored ×3) | **movement** (thirds; road = 1/3) |
| 2 | `0x5236` | **attack** |
| 3 | `0x5235` | **defense** |
| 4 | `0x5237` | **cargo-hold capacity** (Caravel 2 / Galleon 6) |
| 5 | `0x5238` | **movement class** (99 = naval/free) |
| 6 | `0x5239` | **hull / base strength** |
| 7 | `0x523A` | **size / transport-cost** |
| 8 | `0x523B` | **guns** |
| 9 | `0x523C` | **AI value / build weight** |
| flags | `0x523D` | 8-bit role/flag string (bit-tested `@0x51D7D` etc.) |
("tools" is not an @UNIT column — it is the runtime UnitRecord field `0x3159`.)
- Carry/embark, ZoC, movement-point costs: a unit's movement *budget* is stored ×3
  (`0x5234`, `@UNIT` col 1), road = 1/3 cost. **Per-terrain move COST = the NAMES.TXT
  `Movement` column × 3 — RESOLVED 2026-06-27.** The `Movement` field of each terrain
  row (`@UNFORESTED`/`@FORESTED`/`@OTHER` in `data_extracted/tables/names_tables.json`)
  is loaded by `func_0745F0 @0x074612` into the runtime terrain table at
  `terrain·16 + 0x2F76` (stride 16; +0x2F76 Movement, +0x2F77 Defensive, +0x2F78
  Improvement, +0x2F79 Value, +0x2F7B.. the 9 yields), and charged as `Movement·3` at
  `func_04E2D6 @0x051125..0x051131` (`mov al,[terrain·16+0x2F76]; al·3; SUB [bp-0x26],ax`).
  Byte values (NAMES, **B**): open land (Tundra/Desert/Plains/Prairie/Grassland/Scrub)=1,
  forested (Boreal/Mixed/Broadleaf/Conifer)=2, Hills=2, Arctic=2, Mountains=3,
  Ocean/Sea Lane=1.
- **AI move/destination scoring (`func_04E2D6`, page 0x0D, byte-verified).** The AI
  evaluates candidate moves into a word accumulator `[bp-0x26]`. It **DOES read the
  per-terrain `Movement` table** — `SUB [bp-0x26], [terrain·16+0x2F76]·3` at
  `@0x051125..0x051131` (the same terrain-cost table the engine uses for real movement;
  corrected 2026-06-27 — the prior "NOT a per-terrain cost table" claim was wrong) — and
  then layers **additional inline flat immediate AI penalties** on top. Examples:
  `SUB [bp-0x26],0x3e7` (999, an "infeasible"/out-of-ship-type-range penalty, `@0x05170A`),
  `SUB [bp-0x26],0xa` (10, charged when a neighbour unit has nonzero attack `0x5236`,
  `@0x051760`), plus `−0x14`/`−0x2d`/`−0xf`/`+0x10` and squared-distance terms elsewhere
  in the loop. Ships (type `0x0d..0x12`) add a heading penalty
  `≈ angular_dist(0x314F,target)²·2` (`@0x051712..0x051737`). So the §3 "full move-cost
  table" is now **RESOLVED** (terrain `Movement`·3, see the bullet above); the immediate
  constants here are **extra AI evaluation weights** layered on the real terrain cost.

### Damaged-ship repair — **BYTE_VERIFIED** (`func_02F052 @0x2F084..@0x2F1E2`, read 2026-08-29)
Every unit of the power whose `+0x04` flags carry bit **0x80** (damaged),
except **type 0x0B Artillery** (`@0x2F08F` — a damaged piece keeps its
demotion), ticks its **`+0x16` counter +1 per turn** (`@0x2F0E0`) and
**+1 more when its coordinates pass the map-bounds test**
(`is_xy_in_map_bounds` via `0x181F:0x302`, `@0x2F0FE`) — so a ship anywhere
ON the map (port or open sea, no Drydock required) mends at 2 a turn, and a
ship in Europe (off-map coordinates) at 1.  Repair completes when the
counter reaches the **`@UNIT` DEFENSE column** (stride-14 record byte
`+0x5235`, `@0x2F126` — Caravel 2, Merchantman 6, Galleon 10, Privateer 8,
Frigate 16, Man-O-War 24): the flag clears (`@0x2F135`) and the human gets
`@REFIT` (id 0xEEF = key `@0x1E88F`) naming the colony under the ship
(`@0x2F1A4`) or the homeport when off-map (`@0x2F1BA`); at sea the location
slot is left stale.  Both engines carry this model (the ports also zero the
counter on completion — hygiene, the engine leaves `+0x16` as-is, FLAGGED).

### The `@UNIT` stride-14 record (DGROUP `0x5230`) — **BYTE_VERIFIED** (parser `@0x74ED5..@0x74F5D`)
`+0` name ptr · `+2` icon · `+4` **movement ×3** (thirds, `shl+add`
`@0x74F04`) · `+6` attack · `+5` defense (written out of order `@0x74F1A`) ·
`+7` cargo holds · `+8` the "99" column · `+9` hammers (÷32) · `+10` tools
(÷10) · `+11..+12` the last two columns · `+13` the role bits
(`0x1a1f:0xb2e`).

## 4. UI
Active-unit orders box and map cursor. See `docs/UI_RENDER_MAP.md`, `notes/SPRITE_CATALOG.md` (renderer sprite indices per CLAUDE.md hard rule 6).

## 5. Evidence
- placer `@0x06958` / renderer `@0x03A63` / GoTo writer `@0x22D38` — position `0x3144/0x3145`, goto-target `0x314D/0x314E` (base `0x3144`). **B**
- `@UNIT` loader `@0x074EC3`/`@0x074EEE` — stat table `0x5230` stride 14 (§3). **B**
- cargo-hold `get_nth_cargo @0x0B2AB` (count `0x3150`, ids `0x3151..`, qty `0x3154..`); tools `@0x4060F` (`0x3159`); class `@0x5B60E` (`0x315B`). **B**
- `docs/DATA_MODEL.md` — UnitRecord (base `0x3146`/+0x07 pos labels **superseded**, RULINGS 2026-06-20). **A→corrected**
- `data_extracted/text/NAMES_sections.json` — `@UNIT` (24 rows), `@CLASS` (8), `@ORDERS`. **B**

## 6. Open questions
1. ~~Map every `@UNIT` numeric column.~~ **Done 2026-06-20** — table `0x5230` stride 14
   (§3): movement `0x5234`(×3) / attack `0x5236` / defense `0x5235` / cargo `0x5237` /
   move-class `0x5238` / hull `0x5239` / size `0x523A` / guns `0x523B` / ai-value
   `0x523C` / flags `0x523D`. **B.**
2. ~~Trace the 28-byte UnitRecord fields.~~ **Mostly done 2026-06-20** — base `0x3144`,
   full field map in §2 (position/type/owner/order/goto/cargo/tools/work/class/links).
   Residual: `0x3158` **partly resolved 2026-06-25** — u8 0/1 per-turn land-unit flag, cleared at turn-refresh (`@0x04968D`, land-only) and at Wagon-Train creation (`@0x006E0C`), set to 1 for land units after the cargo-load LCALL `func_00B368`/`0x181F:0x0D58` (`@0x04F730`), and tested only for Wagon Trains (`@0x0507E1`); exact semantic label is **R (label-pending, runtime)**. Also residual: `0x314F` europe state, and exact bits of `0x3148`/`0x314B`.
3. ~~Confirm unit→sprite mapping against `notes/SPRITE_CATALOG.md`.~~ **Done 2026-06-20**
   — unit sprites are in **ICONS.SS**, byte-cited from `@UNIT` column 1 "Icon" (Colonists
   101, Soldiers 103, Caravel 6, …, Cont. Cav. 130; PORT png = VICEROY index − 1), per
   `spec/data/index_tables.md` §4 / SPRITE-A. (CC-NN are FF portraits, not units.) **B.**
