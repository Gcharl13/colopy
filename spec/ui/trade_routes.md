# Trade-route editor

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Decoded 2026-07-30 (page 0x12, file 0x05FE60..0x061454); handlers, record
> layout, editor geometry, and dead-code negative verified in the listings.
> Corrects `spec/ui/menus.md` §func_06083A note: that function is the
> **trade-route editor painter** (title "EDIT TRADE ROUTE n"), which the
> 2026-06-24 scrub had already identified as the "Route N title strip".

## 1. Commands & data model (B)
- Menu ids **0x50 Edit / 0x51 Create / 0x52 Delete** (MENU.TXT `@TRADE` row
  order) → `func_060FBC` / `func_0610B0` / `func_0612E6` via
  `0x191f:0x38e/0x39c/0x380` (@0x0238F2/@0x0238EA/@0x0238FC).
- **RouteRecord, stride 0x4A, max 12** (`[0x53A0]` count; cap @0x0610B5 →
  `@TRADEMANY`): +0 name[0x20] · +0x20 type (1=sea, 0=land) · +0x21 stop
  count (max 4) · +0x22 stops[4] stride 0xA. Selected route via
  `func_05FE60` (`[0x9E14]=route·0x4A`, far seg `[0x9E16]`).
- **StopRecord (0xA)**: +0 dest word (colony index or **0x3E7 = Europe**) ·
  +2 count nibbles (lo=unload, hi=load) · +3..5 load-cargo nibbles ·
  +6..8 unload-cargo nibbles · +9 pad (TBD). Nibble get/set
  `func_0603DA`/`func_06040A`.
- **Unit linkage**: unit byte +0x17 — lo nibble route id, hi nibble stop
  index (`0x181f:0x858/0x862/0x876/0x8b2`); order code 2 = "Trade Route".

## 2. Editor screen (`func_060FBC` + painter `func_06083A`) — B
Clear to color 0x22. Labels from the runtime table `[0x93DE..0x93EE]` =
LABELS.TXT `@ROUTE` (9 entries; binding A — loader fill TBD):
- Title `"EDIT TRADE ROUTE <n+1>"` centered y=5 color 0x0F @0x060898.
- "Route Name:" + name at (10, 0x19); "Route Type:" + Sea/Land at
  (10, glyph_h+0x1B).
- Column headers Destination / Unload Cargo / Load Cargo at y=0x37−glyph_h,
  x = width("0.  ")+10 / 0x7D / 0xD0.
- **Stops table**: 5 row bands, pitch 0x14, y=0x3D..0x8D; vertical
  separators x=0x73 and x=0xC6; per stop "N. <destname>" at (10, rowY+8);
  unload icons from x=0x7D, load icons from x=0xD0 — **ICONS.SS frame
  cargo+0x17**, advance = sprite width+2 from the sheet header.
- **OK button**: box (0x118,0xAA)–(0x135,0xBD), label `[0x2E16]`="OK"
  (LABELS @MISC) @0x060BD6–0x060C16.
- Hit zones (`func_060F32`): stops table y∈[0x3D,0x8D) → row/column click
  (row=(y−0x3D)/0x14; x<0x73 destination, <0xC6 unload, else load); name
  band → `@TRADENAME` text entry (maxlen 0x1F); y≥0xAA → exit. Enter/Esc
  exit @0x061072.
- Destination cell: append (or re-pick) via the shared picker (§3); cargo
  cells: click icon = remove (shift-left); click space = `@CARGOUNLOAD`/
  `@CARGOLOAD` 16-row cargo menu (NAMES `@CARGO` names, width 120), max 6.
- The editor creates a **phantom probe unit** at (0xFF,0xFF) (`0x1a1f:0x1ca`
  = `func_04007E`, type ship/colonist by route type @0x061035) to filter
  reachable destinations; deleted at exit @0x0610A0.

## 3. Destination picker (`func_060026`) — B, shared with Go-To orders
Header `@SAILPORT` (ship) / `@TRAVELPLACE` (land unit) / `@TRADESTART`
(route editing, %NUMBER0 = stop ordinal). Rows = eligible own colonies
(water/land region match via `func_05FEF4`); **Europe row only for ships**
(label = per-nation port name `[0x838C]`); pages of 10 with "(More)";
optional "(Delete Destination)" row; current-location colony excluded
(land) or disabled (ship). Also the **Go to Port / Go to Place** picker
(`func_022CDC`: order 3 + goto coords; Europe → set-sail).

## 4. Create / delete / assign (B)
- **Create**: cap check → pick dest 1 → coastal test `0x181f:0xd12` →
  `@TRADETYPE` (sea/land) or forced land → default name = colony name +
  random `@TRADENAMES` word (collision → append " A", increment) →
  `@TRADENAME` entry → stop count preset 2 → pick dest 2 (cancel aborts
  before `inc [0x53A0]`) → opens the editor.
- **Delete**: route menu + `@TRADEDELETE` → `@SUREDELETE` confirm; units on
  the route get route/stop/order cleared; higher route ids decrement;
  array compacted (rep movsw 0x25 words). **`func_060522` is a dead
  duplicate** of the delete with a set-stop/set-route nibble swap — never
  cite it as the live path.
- **Assign** ("Begin Trade Route" order, `func_022D46`): `@TRADENONE` if no
  routes; route menu filtered sea-only for ships / land-only otherwise
  (`@TRADENONE2` if filter empties); sets order 2 + immediate step.
- Execution (located, out of scope): page 0x08 `func_041080` region;
  `@ROUTELOOP` posted for 1-stop routes @0x0413F7; colony-delete fixups
  `func_02EE34`.

## 5. Open items (exact trace sites)
1. LABELS `@ROUTE` table fill (`[0x93DE]` writers) — boot loader trace.
2. Stop byte +9 (pad?) — save-file diff.
3. `0x191f:0x8bc/0x8b2` (row fill / vline) arg conventions.
4. Dialog `+0x22` rows-per-page overwrite (0xA/8) vs dialog_framework.md §1
   "pad=4" — reconcile in the framework sheet.
