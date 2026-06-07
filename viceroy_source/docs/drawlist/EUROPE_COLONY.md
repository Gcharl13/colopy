# EUROPE & COLONY — overlay-resident draw-list (RTLink-resolved, code-transcribed)

**Built 2026-05-31. Re-transcribed 2026-05-31** directly from the `.asm`
bodies (every PUSH/LCALL re-read), correcting the *draw technique* and *text
alignment* of the prior pass and adding a `## PORT FIXES` strip-list. The
previous version had the dispatch chain + coords right but mislabeled how
several elements are painted (fill vs frame vs bevel) and assumed left-aligned
text where the game **centers**.

**Citation convention:** every coordinate/sprite/string traces to `@asm 0xNNNNNN`
(a VICEROY.EXE file offset) or a named DGROUP table. Unresolved → `NEEDS
VERIFICATION`. Companion: `docs/SCREEN_LAYOUTS.md` §2 (Europe) / §3 (Colony).

---

## 0. Draw-primitive vocabulary (LCALL 0x181F:NNN, resident, confirmed)

These are the only paint primitives both screens use. Re-confirmed against the
call sites below.

| dispatch | func | what it does | how it's used here |
|---|---|---|---|
| `0x181F:0x22`  | func_002462 | **FILL RECT** (push h,w,y,x[,sheet]) — BUT note: with a single arg it returns dx:ax (a value lookup), so context matters | empty-dock fill, in-string-builders it's a value fetch |
| `0x181F:0xE2`  | func_00DB3A | **FRAME / RULE** — 1-px outline of a rect (ax=x,dx=y,bx=x,push h,w,y) | panel outlines, screen-bottom rule |
| `0x181F:0x100` | func_002BC8 | **TEXT IN A BOX, HORIZONTALLY CENTERED** (push h,w,y,x, ss, &str) — centers via internal measure | empty-dock caption, in-port ship-name list, empty-minimap caption |
| `0x181F:0x13C` | func_002B38 | **TEXT at explicit x,y,color** (push color,y,x, ss, &str) — caller supplies x | market price numbers, recruit-menu rows (x is **pre-centered** by the caller) |
| `0x181F:0x254` | func_00E76A | **blit ONE sprite** (push sheet ptrs, ax=idx, bx=&sheet, dx=y; x in earlier reg) | docked ships, scene tiles, carried-cargo icon |
| `0x181F:0x510` | (frame/scene painter) | scene backdrop blit (8 sheet words + rect) | colony terrain-scene backdrop |
| `0x181F:0x444` | (patterned fill) | full-area patterned fill | func_02633E full-screen / panel fills |
| `0x181F:0x4FC`/`0x506` | (scene strip blit) | colony buildings/field backdrop strip | buildings & field bands |
| `0x181F:0xCE`  | func_00E0A2 | glyph / short horizontal rule-of-glyphs | scene divider lines |
| `0x181F:0x2BC` | func_00386A | progress/distance bar | in-port ship sail-progress bar |
| `0x181F:0x16E` | func_002992 | string copy/format (NOT a paint) | name-string assembly |
| `0x181F:0xBE6` | func_00B2A2 | sprite-width query (NOT a paint) | icon spacing |

**Key correction vs. prior pass:** `0x2cac3` (the page_02 trampoline target the
colony sub-renderers call for their panel backgrounds) resolves to
**func_02633E**, which is a **flat patterned FILL** (`lcall 0x181F:0x444`). It is
NOT a two-tone beveled panel. The only edge decoration the game adds is an
optional **single-colour 1-px frame** via `0x181F:0xE2`. There are **no HI/LO
bevel edges** anywhere in the colony composer.

---

## 1. The resolution mechanism (how the "block" was lifted)

Unchanged from prior pass and re-verified: resident page code dispatches into the
`0x191F`/`0x181F` thunk windows; type-A thunks resolve via
`rtlink_decode.py resolve <pageW> <off16>`, type-B are static
`codeOffset+(seg<<4)+off`. Self-check `resolve(0x10,0x0352)=0x5B2C2` ✔.
Page-04 trampoline table `@0x36845..0x368CC`; page-02 table `@0x2C97E..0x2CA96`.

---

# PART 1 — EUROPE (composer func_031E4C, page_04, screen-id 0x2B)

## 1.0 Composer draw ORDER — func_031E4C `@0x031E4C` (byte-read)

The composer head, transcribed call-for-call (`@asm 0x031E4C..0x031EA5`):

1. `push 0xC0,0x140,8,0; call 0x368CC` `@0x031E4C` → frame helper func_030D86
   with rect **(x=0, y=8, w=0x140=320, h=0xC0=192)** = the **play-area fill below
   the wood header** (NOT a wood-header fill; header is drawn separately). [V]
2. `push cs; call 0x368A4` `@0x031E5D` → header/backdrop sub-renderer (trampoline). [V]
3. `push 0; call 0x310B4` `@0x031E63` → **func_0310B4 market bar** (arg 0). [V]
4. `push 0; call 0x30F76` `@0x031E6B` → **func_030F76 market banner text** (arg 0). [V]
5. `push 0; call 0x314DC` `@0x031E73` → **func_0314DC dock + ships + in-port list**. [V]
6. `push 0; call 0x36863` `@0x031E7C` → sub-renderer (trampoline). [V]
7. `push 0; call 0x36926` `@0x031E85` → sub-renderer (trampoline). [V]
8. `push 0; call 0x31DC8` `@0x031E8D` → **func_031DC8 RECRUIT/PURCHASE/TRAIN menu**. [V]
9. `push 0,0x140,0xC8; …; lcall 0x181F:0xE2` `@0x031E95/0x031EA0` → **screen
   outer rule** at **(x=0, y=0xC8=200, w=320)** (bottom frame line). [V]

## 1.1 Market PRICE bar — func_0310B4 `@0x0310B4`

- **Background fill:** `push 0x15,0x140,0xB3,0; call 0x368CC` `@0x0310B9` → frame
  helper, **rect (x=0, y=0xB3=179, w=0x140=320, h=0x15=21)**. [V]
- 16-cell loop: commodity icon index `= i + 0x17` (`add ax,0x17` `@0x0310F2`),
  cell-pitch via `[0x83E]:[si+0x152]` half-width (`sar cx,1` `@0x031101`). Icon
  blit (sheet `[0x83E]`=ICONS). [V]
- **Price NUMBER per cell** (`@0x031179..0x0311B3`): the x is **CENTERED in the
  cell**: `textW = measure(0x204)`, `x = cell_center − textW/2 + 8` (`sar ax,1;
  sub; neg; add 8` `@0x031191`). Then `push 0x2F (color); cx=0xC2 (Y=194);
  lcall 0x181F:0x13C` `@0x03119E/0x0311AE`. So **prices are CENTERED, Y=194,
  text-colour palette 0x2F**. (0x13C is "explicit x", but the caller hands it a
  centered x — net effect = centered.) [V]

## 1.2 Market BANNER text ("Selling …") — func_030F76 `@0x030F76`

A sprintf-style string builder (chains `lcall 0xD1D:0x117e/0x11b4/0x7a4/0x8fa` to
format good-name + price into `[bp-0x50]`), then the final paint
`lcall 0x181F:0xB0` `@0x0310AD` takes `[bp+4]` as the draw arg. The composer
passes arg 0 (`@0x031E6B`), so the banner sits in the **header band** (the
`0x181F:0x22` calls at `@0x030F84/0xFB1/0xFDE` here are **value lookups** that
fetch good/price words — NOT fills). **Banner pixel origin = NEEDS
VERIFICATION** (it is inside the func at the `0x181F:0xB0` paint; the x/y are
built from the formatted-string metrics, not a literal push). [P]

## 1.3 Dock + 6 docked SHIPS + in-port list — func_0314DC `@0x0314DC`

**Dock background fill** (`@0x0314E1`): `push 0x3C,0x51,0x76,0x8F; call 0x368CC`
→ frame helper, **rect (x=0x8F=143, y=0x76=118, w=0x51=81, h=0x3C=60)**. [V]

**Branch on `[0xFA2]` (count of ships IN PORT)** (`cmp [0xFA2],0; jne 0x31560`
`@0x0314F1`):

- **`[0xFA2]==0` (no ship in port)** → the empty-dock path:
  - `push 0x45,0x78,0x51,0x8F, [0x2DD0]; lcall 0x181F:0x22 (fill); lcall
    0x181F:0x100` `@0x0314F8..0x03150F` → **FILL rect (x=143, y=0x51=81, w=0x78=120,
    h=0x45=69)** then a **CENTERED caption** (string `[0x2DD0]`) in that box. [V]
  - Then the **6-slot ship-sprite loop** (`@0x031517..0x03155E`, `cmp 6`):
    geometry from **func_0314AE** (`call 0x36845`), sprite **ICONS 0x7B (123)**
    (`mov ax,0x7B @0x03154F`), `lcall 0x181F:0x254`. [V]
- **`[0xFA2]!=0` (ship[s] in port)** → branch at `0x31560`:
  - per in-port ship: name string fetched, then a **CENTERED ship-name row**:
    `push 0x45,0x78,0x51,0x8F, ss,&str; lcall 0x181F:0x100` `@0x0315C9` (and a
    second centered line `@0x031621` at y=0x51+font-height). **In-port name list
    rect = (x=143, y=81, w=120, h=69), text CENTERED.** [V]
  - status-band row Y seeded `[bp-0x56]=0x92 (146)` `@0x031631`. [V]
  - then the same **6-slot ship loop** (`@0x0316DA..0x03173D`) blits docked-ship
    sprite 0x7B at the func_0314AE geometry. [V]

**func_0314AE `@0x0314AE` (per-slot geometry, byte-exact):**
- **x = slot·12 + 0x93 (147)**: `shl ax,1; add ax,cx; shl ax,2` = ×12, then
  `add ax,0x93` `@0x0314BD` (bytes `059300`). [V]
- **y = 0xA5 = 165** const `@0x0314C8` (`c707a500`). [V]
- **w = 0x0A = 10** `@0x0314CF`; **h = 0x0C = 12** `@0x0314D6`. [V]
- ⇒ **docked ships at x = 147,159,171,183,195,207 ; y = 165 ; 10×12 ; ICONS 0x7B.** [V]
- Carried-cargo variant (`si=0x27` base `@0x0316E2`) repositions a ship carrying
  a unit; the carried-icon offset uses sheet `[0x83E]:[si+0x3E]`. [V] *(role of
  the 0x27 base = the sea-slot vs in-dock discriminator — NEEDS VERIFICATION.)*

## 1.4 Per-ship STATUS state + row — func_031298 / func_031366

- **func_031298 `@0x031298`** bins a ship's sail-distance `[bp+6]` into state
  0..3 (`@0x0312AC..0x0312DE`) and computes the row x = `state·tilewidth +
  base_x` (`@0x031313`), tile width `0x10>>zoom` (`@0x0312E5`). The Y output
  `[bp+0x12]` is set per state by the jump-table tail (`@0x031321..`):
  - **state 1 → Y = 0x92 = 146** (`@0x031329`, byte-verified `c7079200`). [V]
  - **state 2 → Y = 0x89 = 137** (`@0x03133F`, byte-verified `c7078900`). [V]
  - **state 3 → Y = 0x84 = 132** (`@0x031353`, byte-verified `c7078400`). [V]
  - state 0 keeps the passed-in Y. (Offsets 0x3133F/0x031353 live in the
    split-out jump-table tail between func_031298 and func_031366; bytes
    re-confirmed in `COLONIZE/VICEROY.EXE` this session.)
- **func_031366 `@0x031366`** (one status row): calls func_031298 (via
  `0x3689F`), then paints:
  - **sail-progress bar** for state<2: width `0x64>>state` (`@0x0313A4`),
    `lcall 0x181F:0x2BC` `@0x0313C2`. [V]
  - **cargo/flag icon** for ship classes (`[bx+0x3146]` in 0x0D..0x12), state 0,
    `[bx+0x3150]≠0`: icon idx `+0x17`, `lcall 0x181F:0x254` `@0x031417`. [V]

> **Band-header CAPTIONS** ("Expected Soon / Bound For / Loading"): still **NOT**
> literal pushes inside func_0314DC/func_031298/func_031366 — those draw the ship
> NAME (@UNIT[type]+0x5230) and type ICON (+0x5232). The captions come from the
> **EUROLABEL table** (DGROUP `[bx-0x6C28]`, the same table func_031DC8 uses) or
> the composer head; the exact `coltext0` string IDs and their per-state Y are
> **NEEDS VERIFICATION**. State→band mapping: state1↔Y146, state2↔Y137,
> state3↔Y132. [P]

## 1.5 RECRUIT / PURCHASE / TRAIN menu — func_031DC8 `@0x031DC8`

- **One panel background** (`@0x031DCC`): `push 0x20,0x25,0x59,0x119; call
  0x368CC` → frame helper, **rect (x=0x119=281, y=0x59=89, w=0x25=37,
  h=0x20=32)**. [V]
- **3 rows** (`@0x031DEB..0x031E2F`, `cmp 3`): each pushes a label from
  **EUROLABEL `[bx-0x6C28]`** plus x=`[bp-2]=0x119 (281)`, y=`[bp-4]` (starts
  0x59=89), a state flag, and `call 0x31BE6` (the row drawer). y advances by
  `(rowH)+2` (`inc;inc;add [bp-4]` `@0x031E23`). [V]
- **func_031BE6 `@0x031BE6` — row drawer (alignment-critical):**
  the text X is computed **CENTERED**: `x = (boxW − textW)/2 + box_x`
  (`mov ax,[bp-0xac]; sub ax,[bp-6]; sar ax,1; add ax,[bp+6]` `@0x031C40..0x031C4C`),
  stored `[bp-0xB4]`, then drawn via `lcall 0x181F:0x13C` `@0x031DA2/0x031DB4`.
  So **RECRUIT/PURCHASE/TRAIN are HORIZONTALLY CENTERED** in the 37-px panel,
  text-colour 0xF/0 by selection (`@0x031C10/0x031BF4`). A selection-fill
  (`lcall 0x181F:0x22 @0x031D42`) and a 4-side bevel of *rules* (`lcall
  0x191F:0x8bc/0x8b2 @0x031C8A..0x031D04`, + a `0x181F:0xBA @0x031D3A`) frame the
  row only when the row's state-bit-2 is clear. [V]
- Trailing `[bp+4]≠0`: `lcall 0x181F:0xE2` `@0x031E45` re-outlines the (281,89,37,32)
  panel. [V]

## 1.6 EXIT / info line

- The composer's screen-bottom rule (`lcall 0x181F:0xE2 @0x031EA0`, rect y=200)
  is the only outer frame. [V]
- A dedicated **Exit button** is not painted by func_031E4C's body — the Europe
  **hit-test** function (orphan `@0x032034`) tests rects via `0x181F:0x3CA`
  (point-in-rect): recruit (281,89,37,32), market-minus-exit (0,179,0x131=305,21),
  dock (143,118,81,60), (72,118,70,51), (1,118,70,51), (224,120,96,59). These
  confirm the *clickable* rectangles but are not draw calls. **Exit-button paint
  origin = NEEDS VERIFICATION** (likely in the func_036863/036926 sub-renderers). [P]

---

# PART 2 — COLONY (composer func_028592, page_02, screen-id 0x2C)

## 2.0 Composer draw ORDER — func_028592 `@0x028592` (byte-read, 12 steps)

Transcribed call-for-call (`@asm 0x028592..0x02860D`). **The prior pass listed
11 callees and missed `call 0x2CA19`.**

1. `lcall 0x181F:0xC22` `@0x028595` — scene context/clear setup. [V]
2. `call 0x2CA5A` `@0x02859B` → **func_025C32** (colonist sort/stage A). [V]
3. `call 0x2CACD` `@0x02859F` → **func_026374** (TERRAIN scene + scene units). [V]
4. `push 0xC8,0x140,0,0; call 0x2CAC3` `@0x0285A2` → **func_02633E full-screen
   FILL (0,0,320,200)**. [V]
5. `call 0x2CAE6` `@0x0285B5` → **func_0268CE** (title text). [V]
6. `call 0x2C9A1` `@0x0285BD` → **func_0264A8** (field-production panel). [V]
7. `call 0x2C9DD` `@0x0285C5` → **func_0270D0** (colonist plaza row). [V]
8. `call 0x2CA19` `@0x0285CD` → sub-renderer (**NEW — was omitted**; trampoline
   target, role NEEDS VERIFICATION). [V that it's called]
9. `call 0x2C9E7` `@0x0285D7` → **func_02853C** (flag panel). [V]
10. `call 0x2C9FB` `@0x0285DF` → **func_027DB2** (surrounding-tile minimap). [V]
11. `call 0x2C983` `@0x0285E7` → **func_02814C** (SoL/cargo/msg panel). [V]
12. `call 0x2C97E` `@0x0285EF` → **func_02701C** (buildings loop, 15 slots). [V]
13. Trailing `[bp+6]≠0`: `lcall 0x181F:0xE2` `@0x028607` → screen rule (0,200,320). [V]

**Paint-order note:** the terrain SCENE + scene-units (step 3) are drawn FIRST,
*then* the full-screen fill (step 4) is composited, *then* the title/panels/
buildings on top. (func_02633E uses sheet pointers + bp args = a region paint,
not a destructive clear of the whole frame — the scene survives.)

## 2.1 Title text — func_0268CE `@0x0268CE`

Builds the colony-name + season/year + gold string into `[bp-0x50]` via
`0x181F:0x182` (number-format) and `0x181F:0x178` (string draw/concat)
(`@0x026906..0x0269ED`), guarded by several state checks (`[0xB98]`, `[0x828]`).
The final string is drawn via `0x181F:0x178`. **Title paint x/y/centering =
NEEDS VERIFICATION** — the terminal paint call sits past `0x26A61` (beyond the
decoded slice); the assembly is confirmed but the literal origin is not pinned.
DOS convention for this band is centered, but mark [P] until the tail is read. [P]

## 2.2 Field-production panel — func_0264A8 `@0x0264A8`

- **Background fill** (`@0x0264E9`): `push 0x48,0x48,0x20,0xE0; call 0x2CAC3`
  → func_02633E FILL, **rect (x=0xE0=224, y=0x20=32, w=0x48=72, h=0x48=72)**. [V]
- A scene strip blit at `(0x78,0x78,8,[0x835])` via `0x181F:0x506` `@0x0264E1`,
  and two `0x181F:0xCE` glyph-rules at `(0xC7,7,0x140)` `@0x026517` and
  `(0xDF,0x1F,0x128)` `@0x026539` (scene divider lines). [V]
- Per-field-worker loop: commodity icon idx `+0x17` (`add ax,0x17 @0x026573`),
  h=0xC, sheet `[0x2DA8]`. [V]
- ⇒ **field-production panel is a FILL at (224,32,72,72) + commodity icons.**
  (The prior port placement at (0,130,130,25) is wrong — see PORT FIXES.) [V]

## 2.3 Colonist PLAZA row — func_0270D0 `@0x0270D0`

- **Background fill** (`@0x0270D6`): `push 0x30,0x78,0x82,0; call 0x2CAC3`
  → func_02633E FILL, **rect (x=0, y=0x82=130, w=0x78=120, h=0x30=48)**. [V]
- Colonist count = colony-struct `[0x8542]:[bx+0x1F]` + `[0x8D72]`
  (`@0x0270E6`). [V]
- **Row x ORIGIN = 0x8F = 143** (`mov [bp-0x60],0x8F @0x0270FA`), and the row
  walks **leftward** (`dec [bp-0x60] @0x027178`) once a row's packed width
  exceeds 0x60 (96) (`cmp ax,0x60 @0x027170`). Per-colonist sprite width from
  `[0x83E]:[si+0x3E]` (ICONS) (`@0x027131`). The exact per-colonist pitch is a
  packing loop (width-accumulate + wrap); the **x-origin 143 is byte-exact**, the
  pitch is data-driven. [V origin; pitch = NEEDS VERIFICATION] [P]
- Scene-row marker sprite via `0x181F:0xC0E`/`0xA74` lookups. [V]

## 2.4 Flag panel — func_02853C `@0x02853C`

- **Background fill** (`@0x028540`): `push 0x2D,0x11,0x84,0x12F; call 0x2CAC3`
  → func_02633E FILL, **rect (x=0x12F=303, y=0x84=132, w=0x11=17, h=0x2D=45)**.
  (The disassembler tags `0x84` as STRING "BUILD"; in context it is the y-coord
  132.) [V]
- **Flag sprite** (`@0x028558`): `push 0x44 (ICONS 68), push 3, push [0x337]/[0x339]
  (frame); call 0x2C979` (sprite blit). **Sprite ICONS 0x44=68**, drawn at panel
  +3. [V]
- Trailing `[bp+6]≠0`: `lcall 0x181F:0xE2` `@0x02858A` outlines (303,132,17,45). [V]

## 2.5 Surrounding-tile minimap — func_027DB2 `@0x027DB2`

- **Background fill** (`@0x027DB7`): `push 0x30,0x54,0x82,0x79; call 0x2CAC3`
  → func_02633E FILL, **rect (x=0x79=121, y=0x82=130, w=0x54=84, h=0x30=48)**. [V]
- `[0x33C]==0` (no tiles) → sub-fill `(0x79,0x54,0x84,0x39)` + **CENTERED caption**
  string `[0x2DD0]` via `0x181F:0x22`+`0x181F:0x100` `@0x027DCE..0x027DE5`. [V]
- Else: **6-slot surrounding-tile loop** (`cmp 6 @0x027DF7`), geometry from
  `call 0x2C9D8`, sprite **ICONS 0x7B (123)** (`mov ax,0x7B @0x027E25`), sheet
  `[0x2DA8]`, `lcall 0x181F:0x254`. [V]
- ⇒ **The "minimap" is NOT a world map — it is the surrounding-tile scene drawn
  with sprite 0x7B per tile (6 slots) over a flat fill at (121,130,84,48).** [V]

## 2.6 SoL / cargo / message panel — func_02814C `@0x02814C`

- **Background fill** (`@0x02814F`): `push 0x30,0x5B,0x82,0xD3; call 0x2CAC3`
  → func_02633E FILL, **rect (x=0xD3=211, y=0x82=130, w=0x5B=91, h=0x30=48)**. [V]
- Branches on `[0x337]` to one of three sub-renderers (`call 0x2C9B0 / 0x2CA50 /
  0x2CAA0` `@0x028166/0x02816C/0x028172`) — the SoL bar vs cargo vs message
  variants. [V]
- Trailing `[bp+6]≠0`: `lcall 0x181F:0xE2` `@0x028197` outlines (211,130,91,48). [V]

## 2.7 Buildings loop — func_02701C `@0x02701C`

- Scene backdrop: `0x181F:0xCE` glyph-row at `(0xC7,7,…)` `@0x02703F`, and a
  `0x181F:0x4FC` strip blit `(7,0x78,0xC7,8,0)` `@0x02705F`. [V]
- **15-slot loop** (`@0x027067..0x0270B1`, `cmp 0xF`): per slot
  `bx = slot·4` (`shl bx,2`), then **x = `[bx+0x266]`**, **y = `[bx+0x268] + 8`**
  (`@0x027087/0x02708B`). So **building positions come from a DGROUP table at
  0x266, stride 4** (x at +0, y at +2 +8). The building TYPE from `[bx-0x729E]`
  and a present-gate byte from `[bx-0x717E]` (skip if `<0`). The building blit is
  `call 0x2CA23`. [V]
- ⇒ **buildings are TABLE-POSITIONED (DGROUP 0x266 stride 4), NOT a fixed 5-col
  grid.** [V]

## 2.8 Terrain SCENE — func_026374 `@0x026374` (unchanged, re-verified)

- colony cell from `[0x8542]:[bx+0]` (X→`[0x17C]`) / `+1` (Y→`[0x17E]`)
  `@0x026381`. [V]
- scene-cell ptr via `lcall 0x181F:0xC5E` (→func_03200A) `@0x02638A`. [V]
- three page-21 hops set up the viewport + per-tile sprite select:
  `lcall 0x191F:0x8A4` (→func_0678FE clip), `:0x896` (→func_066A98 per-tile
  select), `:0x888` (→func_06693A viewport origin) `@0x02639A/0x02639F/0x0263A4`. [V]
- scene backdrop blit: `push 0x50,0x50,8,0xC8,0,0` + 8 sheet words `[0x839E..0x83A4]×2;
  lcall 0x181F:0x510` `@0x0263A9..0x0263D6`. [V]
- **scene UNIT/worker loop** (`@0x0263E5..`): count `[bx+0x329]`; each record cell
  `[rec+0xC8]`(col)/`[rec+0xDE]`(row); **x = cell·0x18 (24) + 0xFC (252)**,
  **y = cell·24 + 0x3C (60)** (+0x5A=90 carried); sprite from
  `lcall 0x181F:0x718` (→func_0060A0); sheet `[0x839E]`; blit `0x181F:0x254`. [V]
- per-tile blit (companion `@0x066968`): **x = col − [0x9CCC] + 252**,
  **y = row − [0x9CCA] + 9**, sheet `[0x2DA8]`, `lcall 0x181F:0x290`; scroll
  origin = colony (x=[0x17C]−28, y=[0x853C]−40). [V] (16-px terrain pitch vs
  24-px unit-cell pitch — both byte-confirmed.) [V]
- per-tile sprite select (func_066A98): forest=type 0x10→glyph 8; coast via
  `[bx-0x5A8A]`; special terrain via `[di+0x848]`. [V]

---

# DGROUP tables referenced (named, byte-verified elsewhere)

- **UnitRecord** base `0x3144`, stride `0x1C`; type `+0x02=0x3146`, feature
  `0x3147` (`MEMORY: project_unit_table_correction`).
- **@UNIT** base `0x5230`, stride `14`: `+0x00`=name ptr, `+0x02`=ICONS icon,
  `+0x07`=cargo, `+0x37`(=`+0x5237`)=cargo-slot count.
- **EUROLABEL** `[bx-0x6C28]` (recruit-menu + ship-status labels).
- **Building-slot position table** `[bx+0x266]` stride 4 (x at +0, y at +2).
- **Building type table** `[bx-0x729E]`; **building present-gate** `[bx-0x717E]`.
- Sprite sheets: **`[0x2DA8]`** (terrain/ship sheet — colony scene + europe dock),
  **`[0x83E]`** (ICONS — commodity/colonist/flag icons), **`[0x839E]`** (scene-unit
  sheet). Sprite **0x7B (123)** = the dock-ship-slot / scene-tile-slot base.
- Scroll origins `[0x9CCA]`(y)/`[0x9CCC]`(x); colony anchors `[0x17C]`(x)/`[0x853C]`(y).

---

# Coordinate summary (the answers)

**EUROPE** (all [V] unless marked)
| element | primitive | rect / origin | alignment | sprite |
|---|---|---|---|---|
| play-area fill | frame-helper fill | (0,8,320,192) | — | — |
| market price bar bg | frame-helper fill | (0,179,320,21) | — | ICONS 23..38 |
| market price numbers | 0x13C | cell-centered, Y=194 | **CENTERED**, colour pal 0x2F | — |
| market banner text | 0x181F:0xB0 | header band | NEEDS VERIFICATION | — |
| dock fill | frame-helper fill | (143,118,81,60) | — | — |
| in-port name list | 0x100 | (143,81,120,69) | **CENTERED** | — |
| docked ships | 0x254 | x=147+slot·12, y=165, 10×12 | — | **ICONS 0x7B** |
| ship status row Y | (state) | 146 / 137 / 132 (state 1/2/3) | — | type ICON +0x5232 |
| status band captions | — | EUROLABEL | NEEDS VERIFICATION | — |
| RECRUIT/PURCHASE/TRAIN panel | frame-helper fill | (281,89,37,32) | — | — |
| RECRUIT/PURCHASE/TRAIN rows | 0x13C (pre-centered x) | x=281-panel, y=89+row·(h+2) | **CENTERED** | — |
| screen rule | 0xE2 | (0,200,320) | — | — |
| Exit button | — | clickrect ~(305,..,..) | NEEDS VERIFICATION | — |

**COLONY** (all [V] unless marked)
| element | primitive | rect / origin | alignment | sprite |
|---|---|---|---|---|
| full-screen fill | func_02633E (0x444) | (0,0,320,200) | — | — |
| title text | 0x178 | NEEDS VERIFICATION (origin) | NEEDS VERIFICATION | — |
| field-production panel | func_02633E fill | (224,32,72,72) | — | ICONS 23+ |
| colonist plaza row bg | func_02633E fill | (0,130,120,48) | — | — |
| colonist plaza sprites | 0x254 (via 0xA74) | **x origin 143**, walk left | — | ICONS (per-unit) |
| flag panel | func_02633E fill | (303,132,17,45) | — | **ICONS 0x44=68** |
| minimap panel | func_02633E fill | (121,130,84,48) | — | tiles **ICONS 0x7B** (6) |
| SoL panel | func_02633E fill | (211,130,91,48) | — | — |
| panel outlines | 0xE2 (single colour) | each panel | — | — |
| buildings (15) | 0x254 (via 0x2CA23) | **DGROUP 0x266 stride 4** (x+0,y+2+8) | — | BUILDING.SS type+1 |
| terrain tiles | 0x290 | x=col−[0x9CCC]+252, y=row−[0x9CCA]+9 | — | sheet [0x2DA8] |
| scene units | 0x254 | x=cell·24+252, y=cell·24+60 | — | sheet [0x839E] |

---

# PORT FIXES (code-transcribed)

Targets: `colonize_sdl/render/screens.py` `_render_europe_screen`
(L1667-1811), `_render_colony_screen` (L1480-1665), `_colony_panel`
(L1465-1478). **READ-ONLY here — this is the fix spec, not applied.** Each item
is FABRICATION-to-STRIP vs CORRECTED-technique. "Fabrication" = drawn but the
game doesn't draw it, or drawn with the wrong technique/position/alignment.

## EUROPE — `_render_europe_screen`

**STRIP (fabricated chrome / colours):**
1. **`bevel()` helper (L1696-1701) — the whole two-tone bevel is INVENTED.**
   The game's panel backgrounds are FLAT fills via the frame-helper (func_030D86
   / func_02633E → `0x181F:0x444`); the only edge is a single-colour 1-px frame
   (`0x181F:0xE2`). Strip `PANEL_HI`/`PANEL_LO` highlight/shadow lines; keep a
   flat fill + optional 1-px frame.
2. **Info box `bevel(2,9,316,32)` + "Sold N at N/ton" / "Price:" / "0% Tax:"
   (L1738-1743) — NOT in func_031E4C.** There is no (2,9,316,32) panel in the
   composer. The market readout is the **func_030F76 banner** (single formatted
   line in the header band) + the price NUMBERS in the bar. Strip the invented
   info box and its 4 hard-coded INK labels.
3. **`EXIT_RED` button `(305,188,14,10)` + 'E' glyph (L1809-1810) — origin
   fabricated.** The composer paints no such button in its body; only a
   click-rect exists. Mark NEEDS VERIFICATION; do not invent the red box at a
   guessed origin. (If kept as a placeholder, flag it.)
4. **"Expected Soon" hard-coded at (145,146) (L1783) — caption SOURCE
   unverified.** The string is not a literal in the decoded funcs; it belongs to
   EUROLABEL/coltext0. The **Y=146 is correct (state-1 band)** but the literal
   text + x are not pinned. Strip the literal; drive from EUROLABEL when resolved.
5. **Recruit colonist icons at `(146+i·14, 132)` ICONS 100 (L1784-1785) —
   placement fabricated.** func_0314DC has **no standalone pier-colonist sprite**;
   waiting colonists render as @UNIT type-icons INSIDE the in-port list box
   (143,81,120,69), and the recruit POOL is the func_031DC8 menu, not loose icons
   at y=132. Strip these.

**CORRECT technique / alignment (drawn, but wrong):**
6. **RECRUIT/PURCHASE/TRAIN labels (L1752-1753) are LEFT-aligned at x=283 —
   must be CENTERED in the (281,89,37,32) panel.** func_031BE6 computes
   `x=(boxW−textW)/2+box_x` before the `0x13C` draw. Center each label in the
   37-px panel; row pitch = glyphH+2 (not a flat 10). [V @0x031C40]
7. **Docked-ship sprites (L1776-1777):** geometry is CORRECT (x=147+slot·12,
   y=165, ICONS 0x7B). Keep.
8. **Market price bar (L1802-1805):** CORRECT — prices centered, Y=194, colour
   pal 0x2F. Keep.
9. **In-port list:** the port draws no list rows; when ships are in port the
   game draws **CENTERED** ship-name rows in (143,81,120,69) via `0x100`. Add
   centered name rows (currently missing). [V @0x0315C9]
10. **Wood header / gold title (L1706-1733):** the title band exists; the gold
    "<Port> Harbor … Gold:" line corresponds to the func_030F76 banner. Keep the
    band but note banner origin is [P]; the centered title is a reasonable
    stand-in.

## COLONY — `_render_colony_screen` + `_colony_panel`

**STRIP (fabricated chrome / colours):**
1. **`_colony_panel` HI/LO bevel lines (L1473-1478) — INVENTED.** All four colony
   panels (flag, minimap, SoL, field) are FLAT fills (func_02633E → `0x181F:0x444`)
   with at most a single-colour 1-px frame (`0x181F:0xE2`). Strip
   `COLONY_PANEL_HI` (152,186,227) and `COLONY_PANEL_LO` (62,91,165) edge lines;
   keep a flat `COLONY_PANEL` fill + optional 1-px frame.
2. **Mid-band field panel drawn at (0,130,130,25) (L1580) — WRONG POSITION.**
   The field-production panel (func_0264A8) is a FILL at **(224,32,72,72)** in the
   scene's top-right, showing commodity icons (ICONS 23+). Strip the (0,130,130,25)
   placement; the left-mid region (0,130,120,48) is the **colonist-row** fill, not
   a field panel. The hard-coded "Bells:"/"Food:" readouts at (4,133)/(4,144)
   (L1583-1587) are invented for the wrong panel — remove or relocate.
3. **Plaza grass bands (L1571-1572) `COLONY_PLAZA_GRASS`/`_LO` at
   (0,155,211,23)+(0,171,211,7) — INVENTED.** No such green grass strip is
   painted by func_0270D0 (which fills (0,130,120,48) via func_02633E and stands
   colonists on it). Strip both grass rects and their colours.
4. **Colonist plaza row x=8 walking RIGHT (L1639-1642) — WRONG ORIGIN/DIRECTION.**
   func_0270D0 sets **x origin = 143** and walks **LEFT** (`dec`), wrapping when
   packed width >96. Replace the cx=8/rightward layout with x-origin 143; the
   per-colonist pitch is data-driven (mark pitch [P]). The port's own comment
   rejecting x=143 is mistaken — 143 is byte-verified `@0x0270FA`.
5. **TERRAIN.SS ground-tiling fallback (L1524-1537) + `COLONY_SCENE_TAN` /
   `COLONY_TITLE_STRIP` (0..7 strip):** the real scene is the live page-21 tile
   renderer (func_026374, §2.8) — tiles via sheet [0x2DA8] at
   x=col−[0x9CCC]+252. The TERRAIN.SS tiling is an *acknowledged stand-in*; keep
   ONLY as a documented placeholder (it is not the byte-true scene). The brown
   title strip (0,0,320,7) is reasonable chrome but its ink/extent is [layout].

**CORRECT technique / position (drawn, but check):**
6. **Flag panel (L1621-1624):** rect (303,132,17,45) + ICONS 68 — CORRECT.
   Strip the bevel (item 1); the sprite is at panel+3 in DOS (port uses +1/+2 —
   minor, adjust to +3 X / +3 Y per `@0x028558` push 3). [V]
7. **Minimap panel (L1600-1601):** the port draws a flat blue info panel and
   explicitly omits a world map — this is DEFENSIBLE, but the byte-true content is
   **6 surrounding-tile sprites (ICONS 0x7B)** over the (121,130,84,48) fill, not
   an empty panel. Keep the flat fill (strip bevel); rendering the 6 tile sprites
   is a tracked feature, not a fabrication to add now.
8. **SoL panel (L1605-1617):** rect (211,130,91,48) — CORRECT. Strip bevel; the
   SoL/Pop readouts are a reasonable stand-in for the func_02814C variant content.
9. **Buildings loop (L1555-1562) uses a fabricated 5-col grid
   (slot_x0=6, slot_w=62, col=slot%5).** Real positions come from **DGROUP table
   0x266 stride 4** (x at +0, y at +2, then +8). The fixed grid is a fabrication;
   the table bytes are the source. Mark the per-slot (x,y) [P] until the 0x266
   table is dumped, but stop computing a grid that isn't in the binary.
   BUILDING.SS index = type+1 is CORRECT. [V @0x027087]
10. **Stockpile bar (L1652-1665):** (0,179,320,21), 16 cells, ICONS 23..38, gold
    @306 — CORRECT. Keep. (Bar is a flat fill in DOS; the port's flat
    `COLONY_STOCK_BG` is fine.)
11. **Title (L1542-1544):** centered title is a reasonable stand-in; func_0268CE
    assembles "Name. Season Year. Gold:N" but its paint origin/centering is [P].

## Net verdict — real-fill vs invented-panel

- **REAL FILLS** (keep as flat fills, strip any bevel): Europe dock (143,118,81,60),
  Europe market bar (0,179,320,21), Europe recruit panel (281,89,37,32); Colony
  full-screen (0,0,320,200), field panel (224,32,72,72), colonist-row
  (0,130,120,48), flag (303,132,17,45), minimap (121,130,84,48), SoL
  (211,130,91,48). All via the frame-helper / func_02633E (`0x181F:0x444`).
- **INVENTED PANELS / CHROME to strip:** the Europe `bevel()` HI/LO edges, the
  Europe (2,9,316,32) info box + Sold/Price/Tax labels, the loose recruit-colonist
  icons at y=132, the Exit-red box at a guessed origin; the Colony `_colony_panel`
  HI/LO bevel edges, the (0,130,130,25) field-panel mislocation + its Bells/Food
  text, the plaza grass bands, the colonist row at x=8, the fabricated 5-col
  buildings grid.
- **ALIGNMENT:** Europe recruit menu rows and in-port ship-name rows are
  **CENTERED** (game), not left-aligned (port). Market prices are already
  correctly centered.
- **PINNED SPRITES:** docked ships / dock slots / surrounding-tile slots =
  **ICONS 0x7B (123)**; colony flag = **ICONS 0x44 (68)**; commodity bar =
  **ICONS 0x17..0x26 (23..38)**; buildings = **BUILDING.SS index type+1**; scene
  units = sheet **[0x839E]** via func_0060A0 lookup; in-port ship type icon =
  **@UNIT[type]+0x5232**.

---

All numeric coordinates carry an `@asm` byte offset re-read from the disassembly
this session; the three status-band Y constants (0x92/0x89/0x84) were
byte-confirmed directly against `COLONIZE/VICEROY.EXE`. Items marked [P] are
NEEDS VERIFICATION (band captions, banner/title paint origins, Exit-button paint,
colonist pitch, buildings 0x266 table dump).
