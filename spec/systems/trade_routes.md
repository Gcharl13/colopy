# Trade Routes

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R. breadth-pass baseline (populated).

**Overall confidence:** **fully implemented + byte-traced (2026-06-20)** — order
field + dispatch, route-definition structure, per-turn automation, and load/unload
primitives all `BYTE_VERIFIED`. The two former sub-detail items are now CLOSED (verified 2026-06-25):
(1) the `load`-vs-`unload` nibble split — low nibble = UNLOAD lane `+0x06..+0x08`, high nibble = LOAD
lane `+0x03..+0x05` — is byte-confirmed at `func_060D8C @0x060E83` (`cmp [bp+6],0; je 0x60E8E;
push 0x1D3D @CARGOLOAD; jmp; push 0x1D47 @CARGOUNLOAD`); (2) the Europe-side write is scalar-only in
the `func_032914` subtree — reseg of `VICEROY.EXE @0x032A8E..0x032A9F` shows `mov bx,[0x84FC]` (PowerRecord)
then `add [bx+0x22],ax`/`adc [bx+0x24],dx` (REF, `@0x032A92`) and `add [bx+0x26],ax`/`adc [bx+0x28],dx`
(tally, `@0x032A9C`), with gold credited via `lcall 0x181f:0xaba` at `@0x032A82`; no good-indexed array
write exists in the subtree. **Canonical primary:** `func_041080`
(automation), `func_05FE60` (route selector/editor), `data_extracted/text/NAMES_sections.json`
`@ORDERS`; `GAME_sections.json` `@TRADE*` keys.

## 1. Purpose & behavior
A trade route automates a ship or wagon train: the player defines a sequence of destinations (colonies and/or Europe) plus which goods to load and unload at each. Once assigned the "Trade Route" order, the unit ferries cargo automatically each turn, delegating supply logistics to the AI. **RECONSTRUCTED** (manual §"Trade Routes").

## 2. State & data

### Unit order field & dispatch — **BYTE_VERIFIED**
- **Order field = `UnitRecord +0x08` (abs `0x314C`, byte).** The per-turn order
  dispatcher reads it at `@0x249CB` (`mov al,[bx+0x314c]`), then `@0x24A28`
  (`dec ax; dec ax; cmp ax,7; ja default`) — a jump table over orders 2..9.
- **Order 2 = "Trade Route"** (`@ORDERS` row 2, key `T`) → automation entry
  `func_041080` (via `@0x24A06` `lcall 0x191f:0x2b2`). The order-menu case
  `@0x22E05` writes `+0x314c := 2` then calls the same automation. The automation
  re-checks `cmp byte[bx+0x314c],2` at `@0x041089` (else clears the order). **B.**

### Route-definition table — **BYTE_VERIFIED**
- **Routes live in segment `0x1B22`, base offset 0, record stride `0x4A` (74 B),
  max 12 routes.** Selector `func_05FE60` (`select_route(id)`): `route_base =
  id·0x4A`, stored as far-ptr `[0x9E14:0x9E16] = 0x1B22:(id·0x4A)`. Active route
  **count = `DGROUP:0x53A0`**; the **12-route cap** is `@0x610B5` (`cmp [0x53a0],0xC`
  → `@TRADEMANY` "Only 12 routes"); inc `@0x612D5`, dec on delete `@0x605ED`; delete
  shifts records `rep movsw cx=0x25` (=0x4A bytes) `@0x605DB`. **B.**
- **Route record (0x4A bytes):**
  | off | field | tier |
  |-----|-------|------|
  | `+0x00..+0x1F` | route **name** string (32 B; memcpy `@0x61273`, uniqueness strcmp `@0x611FF`) | **B** |
  | `+0x20` | route **type** byte: **0=sea, 1=land** (`@0x61282`; selects `@TRADENAMES` idx 3/4) | **B** |
  | `+0x21` | stop **COUNT** (init 2 `@0x61286` = the two creation stops; inc `@0x60C7A` on add; `dec` on stop delete `@0x06051A`; loop bound `@0x02EEED`) — **Amendment 2026-09-02**: the earlier "current-stop cursor" gloss was a label error; the current stop lives in the unit's `+0x17` high nibble | **B** |
  | `+0x22..+0x49` | **stop array** — stride `0x0A`, **up to 4 stops** (`(0x4A−0x22)/0x0A`); `set_stop_ptr(i)` `@0x05FE7A` (`[0x9E18] = base + 0x22 + i·0x0A`) | **B** |
- **Stop entry (0x0A bytes):**
  | off | field | tier |
  |-----|-------|------|
  | `+0x00` (word) | destination = **colony id**, or **`0x3E7`(999)=Europe**, `0x3E8`(1000)=none; colony via `dest·0xCA + 0x5D46` (ColonyRecord) `@0x05FEE1` | **B** |
  | `+0x02` (byte) | packed good-list counts: **low nibble = UNLOAD count (lane bytes `+0x06..+0x08`), high nibble = LOAD count (lane bytes `+0x03..+0x05`)** — resolved 2026-06-25, see §3; `get_stop_field @0x060382` (arg 0 → `&0x0F` low nibble `@0x603A2`, arg 1 → `>>4` high nibble `@0x60394`) | **B** |
  | `+0x03..+0x09` | **nibble-packed good ids** (two 4-bit goods/byte); `get_nth_good @0x603DA → addr_of_good_byte @0x060350` | **B** |
- **Unit→route binding — `UnitRecord +0x17` (abs `0x315B`), split into two nibbles
  for a route-carrying unit:**
  - **low nibble = route index** — get `func_0075D4` (`[bx+0x315b]&0xF`), set
    `func_0075E4` (XOR-mask nibble replace).
  - **high nibble = current-stop index** — get `func_0075FE` (`[bx+0x315b]>>4`), set
    `func_007610`.
  ⚠ **Field overload (resolved):** `+0x315B` is also the colonist **profession/
  vet_type** byte (`0x13..0x1C`, full byte — `training.md`). A trade route is carried
  by **ships/wagons** (no colonist profession), so for route units the byte holds the
  route+stop nibbles while for colonists it holds the profession — uses on **different
  unit types**, not a contradiction. Per-stop GoTo cache is `UnitRecord +0x09/+0x0A`
  (`0x314D`/`0x314E` next-stop X/Y, `@0x4115F`). **B.**

`@TRADE*` GAME.TXT keys (dialog text, ids 0xEA–0xF6 = GAME.TXT section indices):
`@TRADENAME @TRADENAMES @TRADESELECT @TRADESTART @TRADETYPE @TRADEWHICH @TRADEDELETE
@TRADEMANY @TRADENONE @TRADENONE2 @TRADENOCARGO @TRADENOWANT @TRADEWITH` (some also
serve native trade — see `spec/systems/natives.md`). **B (present).**

> **Amendment 2026-09-02 (C3.7):** the route table IS SAVED — it is the last
> block of the `.SAV` (segment `0x1B22`, 0x378 bytes, serializer `@0x073A73`,
> loader `@0x07422C`; `save.md` block 55). Both ports read and write it, with
> unit binding in `UnitRecord+0x17` (nibbles) + orders 2. The "session runtime
> only" model and the port's `.CPX` sidecar are gone.
>
> **Correction:** the earlier `[0x82c]` "route table" hint was **wrong** — `[0x82c]`
> is a graphics clip/draw-context far pointer (used by blitters `@0x5234`/`@0x42C50`),
> not the route table. The route table is segment `0x1B22` via `func_05FE60`.

## 3. Formulas & rules
**Per-turn automation — `func_041080` BYTE_VERIFIED.** For a unit whose order is 2:
- Reads the route id (`0x181f:0x858 → func_0075D4`) and the route's stop meta
  (`0x181f:0x876 → func_0075FE`); the **arrival test** `@0x041034` compares the
  unit's position to the current stop: **Europe** (dest `0x3E7`) → the sea-lane
  column `0x14`; a **colony** → its `(X,Y)` from `[colony·0xCA + 0x5D46/47]`. **B.**
- On arrival, selects the **next stop**, writes that destination's `(X,Y)` into the
  unit's GoTo target (`+0x314D/+0x314E`), and moves the unit (`@0x41818 →
  0x191f:0x4ba`). **B.**
- **Load/unload loop** `@0x411D8..0x4128C`: iterates the stop's good list
  (`count → func_060382`, `nth → func_0603DA`) and calls the cargo primitives; the
  cargo valuation reads `ColonyRecord +0x9A + good·2` (the 20×u16 good array,
  `bx=[0x8542]`) `@0x41315`. **B.**

**Cargo primitives (where cargo meets the colony stores) — BYTE_VERIFIED:**
- **LOAD (colony → unit)** `func_00B880`: `sub [colony+0x9A + good·2], ax` (`@0xB8A5`,
  cap 100) then hands the goods to the unit's cargo hold (`func_00B368`).
- **UNLOAD (unit → colony)** `func_00B8D0`: pulls from the unit (`func_00B42C`) then
  `add [colony+0x9A + good·2], ax` (`@0xB8F5`).
- **Europe side:** when dest `== 0x3E7` (`@0x4119A`) the trade routes through the
  generic Europe load/unload subtree (`func_0324F2`/`func_032914`, the same sell/buy
  path as `market.md §3.1`); the boycott/"wants" mask is `PowerRecord +0x20`
  (`1<<good & [bx+0x20]`, `func_030B38`). **Resolved (no good-indexed PowerRecord array
  write exists in the subtree)** — a full disasm of `func_032914`/`func_0324F2` shows the
  *only* PowerRecord (`[0x84FC]`) writes are the two scalar dwords: `add word[bx+0x22],ax`
  / `adc word[bx+0x24],dx` (REF accumulator) at `func_032914 @0x032A92`, and
  `add word[bx+0x26],ax` / `adc word[bx+0x28],dx` (tally) at `func_032914 @0x032A9C`.
  Gold is credited separately via `func_008806 @0x032A82` (`lcall 0x181f:0xaba`) into the
  per-power treasury pool `[0x8832 + power·0x13C]`, clamped to `0xF423F` (=999,999); the
  buy path `func_0324F2 @0x03274C` only *reads* the gold dword `[bx+0x2A]/[bx+0x2C]` for
  display. So the trade-route Europe sale credits gold + REF + tally scalars only — the
  good-volume market arrays are untouched here (`func_0322D0`/`func_03234A` per §6.4). **B.**

**Limits & naming:** max **12 routes** (`[0x53A0]` cap `0xC`), **4 stops/route**,
**up to ~14 goods/stop** (nibble-packed `+0x03..+0x09`); route names are
user-entered strings at record `+0x00`, uniqueness-checked. `@TRADENAMES` offers 5
preset names. **B.**

## 4. UI — route editor (**BYTE_VERIFIED function map**)
The editor subsystem lives at file `0x05FE60..0x0614xx` (overlay seg `0x191f/0x1a1f`),
with a CS-near dispatch thunk table at `0x613F0..0x61453`:
- **Create route** `func_0610B0` (`@TRADEMANY` guard → `@TRADETYPE` → `@TRADENAME(S)`).
- **Delete route** `func_0612E6` (`@TRADEDELETE`).
- **Destination picker** `func_060FBC` (`@TRADESELECT`) / add-edit stop `func_060C34`.
- **Cargo load/unload selector** `func_060D8C` (`@CARGOLOAD`/`@CARGOUNLOAD`).
- **Route-list renderer** `func_060026`.
Working globals during edit: active-route index `[0xA15C]`, active-stop index
`[0xA15E]`, route-base far-ptr `[0x9E14:0x9E16]`, current-stop far-ptr
`[0x9E18:0x9E1A]`. Dialog ids `0xEA..0xF6` = the `@TRADE*` GAME.TXT section indices.
See `docs/SESSION_UI_CATALOG.md`, `docs/UI_DIALOGS.md`.

## 5. Evidence
- `func_041080` (file `0x041080`) — per-turn trade-route automation (arrival test `@0x41034`, move `@0x41818`, load/unload loop `@0x411D8`). **B**
- `func_05FE60` (file `0x05FE60`) — `select_route(id)`: route table seg `0x1B22`, stride `0x4A`, max 12 (`[0x53A0]` cap `@0x610B5`); `set_stop_ptr @0x05FE7A`. **B**
- `func_0075D4`/`func_0075FE` (file `0x0075D4`/`0x0075FE`) — `UnitRecord +0x315B` low nibble = route index, high nibble = current-stop index (setters `func_0075E4`/`func_007610`, XOR-mask). **B**
- `func_0610B0` create / `func_0612E6` delete / `func_060FBC` dest-picker / `func_060D8C` cargo selector / `func_060026` list — route editor. **B**
- `func_00B880`/`func_00B8D0` — LOAD/UNLOAD primitives moving `ColonyRecord +0x9A+good·2`. **B**
- order dispatch `@0x249CB`/`@0x24A28` (jump table orders 2..9); order-menu writer `@0x22E05`. **B**
- `data_extracted/text/NAMES_sections.json` — `@ORDERS` row 2 "Trade Route, T". **B**
- `data_extracted/text/GAME_sections.json` — `@TRADE*` dialog keys present (ids 0xEA–0xF6). **B**
- `docs/GAME_MANUAL.md` §"Trade Routes" — function/columns. **R**

## 6. Open questions
1. ~~Locate the route-definition structure.~~ **Done 2026-06-20** — seg `0x1B22`,
   stride `0x4A`, 4 stops × nibble-packed goods (§2). **B.**
2. ~~Byte-trace the per-turn automation.~~ **Done 2026-06-20** — `func_041080` +
   LOAD/UNLOAD `func_00B880`/`func_00B8D0` (§3). **B.**
3. ~~Port the per-stop good lists.~~ **Done 2026-08-29 (B3.4)** — both engines
   carry the six-good LOAD/UNLOAD lanes per stop and honour them in the
   automation (unload all carried tons of the listed goods, load ≤100 each per
   `@0xB8A5`); the **Edit Trade Route** menu row opens the editor (route →
   stop → `@CARGOLOAD` lane → `@CARGOUNLOAD` lane). A route with no lanes
   keeps the port's first-stop-loads convenience default (the engine's empty
   lanes would do nothing); Europe stops still sell through the crossing
   (the `func_032914` scalar path), the per-lane Europe buy is not modelled —
   FLAGGED.
3. ~~Route count / stop limits / name storage.~~ **Done** — 12 routes / 4 stops /
   name at record `+0x00` (§2). **B.**
4. ~~Load-list vs unload-list split + Europe-array write offset.~~ **Mostly resolved
   2026-06-20:**
   - **Two cargo lanes, geometry BYTE_VERIFIED** (`func_060350`/`func_060D8C`): each
     nibble is a **good-id 0..15** (a quantity-counted list, not a flag). One lane =
     stop bytes **`+0x06..+0x08`** (count = `+0x02` low nibble, dialog string ptr
     `0x1D47`); the other = stop bytes **`+0x03..+0x05`** (count = `+0x02` high nibble,
     string `0x1D3D`). Which lane is **load vs unload** is set by the cargo-selector's
     arg (`func_060D8C [bp+6]` 0/1) under `@CARGOLOAD`/`@CARGOUNLOAD`; the manual puts
     **unload = center, load = rightmost column**. **arg→string binding RESOLVED** —
     `func_060D8C @0x060E83`: `cmp word[bp+6],0; je 0x60E8E; push 0x1D3D (@CARGOLOAD);
     jmp; @0x60E8E: push 0x1D47 (@CARGOUNLOAD)`. So **`[bp+6]==0` → `@CARGOUNLOAD`**
     (string `0x1D47`, the `+0x06..+0x08` / low-nibble lane) and **`[bp+6]!=0` →
     `@CARGOLOAD`** (string `0x1D3D`, the `+0x03..+0x05` / high-nibble lane); the lane
     byte-offset is set in parallel at `@0x060DA9` (`cmp [bp+6],1; cmc; sbb ax,ax;
     and ax,6` ⇒ `[bp-8]=0` for arg 0, `6` for arg 1). This matches §2 (low nibble =
     UNLOAD, high nibble = LOAD). **B.**
   - **Europe-array write — CORRECTED:** the good-indexed market arrays
     (`+0x5C`/`+0x7C`/`+0xBC`/`+0xFC` + pool `0x8864`) are **not** written inside the
     `func_0324F2`/`func_032914` subtree — that subtree writes only the **scalar**
     fields (`+0x22` REF / `+0x26` tally / `+0x2A` gold, `@0x32A82..0x32A9C`). The
     good-arrays are moved separately by `func_0322D0`/`func_03234A` (the accumulator
     updaters, `market.md §3.1`), reached from the per-turn market-update sites
     (`0x52xxx`). So a trade-route Europe sale credits gold/REF/tally directly; the
     market-volume side-effects ride the same accumulator path as a manual sale. **B.**
