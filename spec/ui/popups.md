# Gameplay Popups

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers:
> B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) / R (`RECONSTRUCTED`).
> Substantive: the **shared centered-dialog FRAME engine** (`func_06C520` /
> `func_06D316` / `func_06C850`, frame blit `0x181F:0x510`) is the byte-cited
> backbone; the **10 live `@`-directives**, the **4 speaker-portrait channels**
> (`func_06BE92`/`BF12`/`BF3C`/`BF66`), the channel-reset address, the Lost-City
> variant map, the 6-key raid block, and the `@KINGNEWWAR`=KING1 finding are all
> **B**. Each per-popup section names its **GAME.TXT `@KEY`** (all grep-confirmed
> present in `GAME_sections.json` unless flagged). Body text color = glyph-engine
> mapping (**A**). No runtime residual — only the live *values* substituted into a
> popup body are game state.

**Overall confidence:** frame engine + geometry-finalize formula + 10 directives +
4 speaker channels + reset address + Lost-City index map + 6-key raid block +
`@KINGNEWWAR` sprite are **B** (byte-cited 2026-05-31 / 2026-06-21); every cited
message `@KEY` is **B** for *existence* (grep-confirmed). Per-section `@width`/`@x`/`@y`
are **B via the EXE/raw-GAME.TXT audit** but are **stripped from the decoded
`*_sections.json`** (the section extractor drops valueless `@`-directive lines), so
they cannot be re-confirmed from the committed JSON — flagged where it matters.
**No runtime residual** — placement is `@x`/`@y` (raw GAME.TXT) or the centered
formula, and colors resolve from the decodable PIK palette (see `fonts_and_colors.md`).
**Canonical primary:** `raw/COLONIZE/VICEROY.EXE`,
`viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` §B8 (the shared dialog
engine, byte-cited), `viceroy_source/docs/UI_PRIMITIVES.md` (the `0x181F:NNN` draw-verb
library), `docs/POPUP_TEMPLATE_AUDIT.md` (the @-parser + 4-channel sprite system),
`data_extracted/text/GAME_sections.json` (message keys).
**Last updated:** 2026-06-23.

---

## 1. Purpose

The gameplay popups are the modal event dialogs that interrupt the turn: king
demands, native diplomacy/raids, Lost-City results, combat outcomes, colony
loss, treasure delivery, and the Revolutionary-War message bank. **There is no
per-event painter.** Every one of the ~30 popup-bearing GAME.TXT event templates
pushes its `@KEY` string and runs the **single shared centered-dialog FRAME
engine** (`CHROME_AND_DISPATCH_INDEX.md` §B8 / index rows 25–29). The dispatcher
`func_0235D6` (resident, @0x0235D6, 27-case switch on the event/screen id) routes
the events; the event handlers themselves are thin wrappers over the §2 engine.
**B** (`CHROME_AND_DISPATCH_INDEX.md` index rows 29–30).

---

## 2. Shared popup frame engine — draw chain (the backbone) — **B**

All gameplay popups, the ~30 GAME.TXT event templates, the King-audience body,
and (via the same `func_06D316`) the menu/dropdown sizing share one engine on
**overlay page 0x17** (code base 0x06BE50). The load-bearing constants, with
their byte offsets (`CHROME_AND_DISPATCH_INDEX.md` §B8, spot-checks PASS):

### 2.1 Construction — `panel_construct func_06C520` @0x06C520

| Field | Role | Value | @asm |
|-------|------|-------|------|
| `+0x46` | border thickness | `(flags&0x10)?0:3` = **3 px** | 0x06C5E9 |
| `+0x48` | inner inset | `(flags&0x10)?0:2` = **2 px** | 0x06C5F5 |
| `+0x28` | default/min content width | **0x50 = 80 px** | 0x06C5A6 |
| `+0x4A` | body line count | (per line) | 0x06C68D |
| alloc | panel struct = 0x29 paragraphs | `lcall 0x1A1F:0x356` | 0x06C56E |

**B.** Spot-checks: 0x06C5A6 `26 c7 47 28 50 00` (minW 80); border-3 / inset-2 idioms.

### 2.2 Per-line text builder — `func_06C850` + `func_06CCxx` @0x06C850

Per body line: `line_w = text_px + sub_w + 0x0A`; `[bx+0x34] = max(...)`. The
**body margin is 10 px** (`add ax,0x0A` @0x06CCE3). Text width is measured via the
font engine `lcall 0x181F:0x204` (FONTTINY metrics). **B.** Spot-check 0x06CCE3
`05 0a 00` (+10 margin).

### 2.3 Geometry finalize — `panel_finalize_geometry func_06D316` @0x06D316

```
content_w = max(80, longest_line_px + 10, @width)       ; @0x06D392 (max of +0x28,+0x20,+0x34)
box_w     = content_w + border(3) + per-branch pad(3..6); @0x06D4BA / 0x06D606 / 0x06D61D
box_h_seed = 2·content_cursor[+0x4A] + border[+0x46]     ; @0x06D35F/63/69 — NOT line_count·2+3
            ; (+0x4A = per-item content-height cursor, init 0 @0x06C68D; see dialog_framework.md §3)
            + (title  ? title_rows·metric + (match?6:3)) ; @0x06D509 (+6) / 0x06D513 (+3)
            + (options? Σ(option_rows + 3) + 3 : 0)      ; @0x06D606 / 0x06D61D
X = (@x == -1) ? (320 - box_w)/2 : @x                    ; @0x06D522 (sar 1; sub 0xA0; neg)
Y = (@y == -1) ? (200 - box_h)/2 : @y                    ; @0x06D53B (sar 1; sub 0x64; neg)
clamp: if X+box_w>0x140 shift left; if Y+box_h>0xC8 shift up ; @0x06D563 / 0x06D571
```

So the popup rect is **static**: centered on (160,100) by default, or pinned to a
literal `@x`/`@y` when the GAME.TXT section carries them; `@width` is a **floor**
(keyword string `"WIDTH\0"` @file **0x1F989**), never a clamp. **B.** Spot-checks:
0x06D522 `26 8b 47 14 d1 f8 2d a0 00 f7 d8` (X-center), 0x06D53B
`26 8b 47 16 d1 f8 2d 64 00 f7 d8` (Y-center), 0x06D363 `d1 e0 26 03 47 46`
(rows·2 + border), 0x1F989 `57 49 44 54 48 00` ("WIDTH").

> **Note on the older `func_067DC8` "popup-from-cursor" path.** `POPUP_TEMPLATE_AUDIT.md`
> documents a separate 65-byte rect-setter `func_067DC8` @0x067DC8 that derives a
> rect from cursor `[0x174]/[0x176]` + `[0x1EA4]/[0x1EA5]` char counts. That path
> writes the 4-word header rect `[0x839E..0x83A4]` used by the §2.5 frame blit;
> the §2.3 centered formula is the **dialog-engine** geometry. Both are byte-cited;
> the centered/`@x@y` path is the one the GAME.TXT event templates use. **B.**

### 2.4 Body & speaker render (the `0x181F:NNN` primitives) — **B**

Body text renders through the resident draw-verb library (`UI_PRIMITIVES.md`),
**font = FONTTINY** (`[0x89E]/[0x8A0]`, the engine default):

| `0x181F:` | resident func | role (byte-verified) |
|-----------|---------------|----------------------|
| 0x13C | `func_002B38` @0x2B38 | draw text at explicit (x,y), left-aligned |
| 0x100 | `func_002BC8` @0x2BC8 | center text in box (option/title rows) |
| 0x114 | `func_002AC6` @0x2AC6 | measure string width (line-grow + right-align) |
| 0x16E / 0x182 | `func_002992` / `func_0029DE` | strcat / append-number (body `{%NUMBER}`/`{%STRING}` substitution) |
| 0xE2  | `func_00DB3A` @0xDB3A | **clipped sprite blit** (NOT a horizontal rule — corrected `UI_PRIMITIVES.md` §0xE2) |
| 0x254 | `func_00E76A` @0xE76A | blit one sprite (the speaker portrait bottoms out here) |
| 0x3C0 | `func_004A80` @0x4A80 | **modal wait-for-OK/keypress loop** (~120-tick timeout; DRAWS NOTHING — the OK box/label are painted by the dialog builder first) |

The body is dispatched through wrappers `func_06F5B0..0x6F64C` (one per channel),
all of which call `func_06F7EF` (= `LJMP 0x181F:0x998`, render-popup-body) and,
when input is expected, `func_06F7F9` (= `LJMP 0x191F:0x16A`, show-and-wait). The
section-load core is `func_06F803` (= `LJMP 0x191F:0x182`). **B**
(`POPUP_TEMPLATE_AUDIT.md` "Convenience wrappers").

### 2.5 Frame blit (WOODFRAM) — **B** (painter relocated 2026-07-28)

**RETRACTED mis-attribution:** `0x181F:0x510 @0x0263D6` is the **colony-scene composite blit**
(sole `0x510` call site in the binary, inside `func_026374`, colony struct `[0x8542]` @0x026379)
— it draws no popup. The **real dialog element painter is `func_06D938`**: it blits the sprite
far-ptr stored at **widget-node `+0x68/+0x6A`** via `0x181F:0x254` (`@0x06D952/0x06D956/0x06D98B`,
sprite h/w from `sprite+0x0E/+0x0C`). WOODFRAM is a whole-sprite carved-wood frame, **not** an
indexed corner set, bound into `node+0x68` by the dialog **builder** (binder site TBD — see
`dialog_framework.md` §6/§7). **B** (painter + mechanism). Background fill = tiled **WOODPANL.PIK** (some `WOODPAN2.PIK`) +
**NAMEPLAT.SS** speaker title strip; these asset *roles* are **A**
(`POPUP_TEMPLATE_AUDIT.md` "Frame & body rendering"), and the per-popup
WOODPANL-vs-WOODPAN2 choice is **RESOLVED (B, negative): gameplay popups never
use WOODPAN2.** `WOODPAN2` is referenced **exactly once** in the whole EXE — at
file **0x3AAFF** in `func_03A9C0` (the score / hall-of-fame screen; string
`"WOODPAN2"` @file 0x1EB77 sits next to `"EXPLOITS"`/`"HALLFAME.DAT"` @0x1EB92,
and the push feeds the full-screen PIK verb `lcall 0x181f:0x44e` @0x3AB02). The
popup frame engine (`func_06C520` family, 0x6BE50..0x6D800) pushes **no**
WOODPANL/WOODPAN2/WOODFRAM/NAMEPLAT string offset at all (byte-scan: 0 hits), so
the earlier "WOODPAN2 = king-audience" inference is byte-refuted — every gameplay
popup uses the WOODPANL/WOODFRAM/NAMEPLAT roles. **B (negative)** (func_03A9C0 @0x3AAFF).

### 2.6 The 10 live `@`-directives — **B**

The `@`-directive parser is `func_06F0F4` @0x06F0F4 (`enter 0x168`; `@`-key check
`cmp byte [bx],0x40` @0x6F193). The keyword table at file **0x1F967** holds **11
strings** but only **10 are live** (`OPTIONS / PROMPT / TEXT / SMALLFONT / Y / X /
WIDTH / LENGTH / CHECKBOX / DEFAULT`):

| directive | file off | handler | effect |
|-----------|----------|---------|--------|
| `OPTIONS`  | 0x1F967 | — | begins the option-list section |
| `PROMPT`   | 0x1F96F | — | input-prompt mode |
| `TEXT`     | 0x1F976 | 0x6F1D8 | section-kind latch `[bp-4]=1` |
| `SMALLFONT`| 0x1F97B | 0x6F207 | copies `[0x89E]/[0x8A0]`→+0x80/+0x82 (does **NOT** load FONTSMAL — RULING) |
| `WIDTH`    | 0x1F989 | 0x6F2B0 | atoi → content-width floor (§2.3) |
| `LENGTH`   | 0x1F98F | 0x6F302 | `[0xA5B6]` |
| `X`        | (table) | 0x6F266 | `+0xc` (literal popup origin x) |
| `Y`        | (table) | 0x6F21E | `+0xe` (literal popup origin y) |
| `CHECKBOX` | 0x1F996 | 0x6F350 | `or es:[bx+0xa],5` |
| `DEFAULT`  | 0x1F99F | 0x6F374 | highlighted-row index (NOT a color) |

**`TEXTCOLR`** (file 0x1F9AA) is **vestigial — never compared** by `func_06F0F4`
(`push 0x200A` appears nowhere as a directive); there is **no per-popup text-color
override**. **B.** *(Infra note: the DGROUP→file delta is `0x1D9A0` — DGROUP off +
0x1D9A0 = the literal's file offset; this is why earlier audits that treated DGROUP
offsets as file offsets saw "garbage".)*

### 2.7 The 4 speaker-portrait channels — **B**

The sprite shown above/beside the popup is dispatched through 4 DGROUP-word
channels; each channel `< 0` (`0xFFFF`) means "no sprite this popup". The master
dispatcher `func_06E3D0` @0x06E3D0 fires whichever channels are `≥ 0`:

| channel | global | builder | name built (from channel value) |
|---------|--------|---------|----------------------------------|
| KING / tribe | `[0x1F5C]` | `func_06BE92` @0x06BE92 | `0..7` → `IND<n>A<pose>.SS`; `> 7` → `KING<n>.SS` (the `CMP 7 / JLE` split @0x06BE96) |
| advisor | `[0x1F5E]` | `func_06BF12` @0x06BF12 | `0..5` → `MSS0..MSS5.SS` |
| missionary | `[0x1F60]` | `func_06BF3C` @0x06BF3C | `0..3` → `MYR0..MYR3.SS` |
| (blitter) | — | `func_06BF66` @0x06BF66 | makes a cel from the loaded sheet handle + blits it; **no box-relative x/y math** (see §2.7.1) |

**Sheet identities (frame 0, asset-visual + capture, A/B):** MSS0 = blue naval
officer with epaulettes — **worn by the @SAILAWAY ask** (capture
`78_europe_setsail_portrait.png`); MSS1 = tricorn colonial with musket (the
`push 1` @FOREIGNNOTAVAIL advisor); MSS2 = gold-doublet merchant, purple cap
(the price/trade wrapper's 2); MSS3 = coonskin scout shading his eyes with a
long rifle — **worn by the landfall asks** (captures `60_landfall_dialog.png` /
`77_landfall_portrait.png`; also the `push 3` siting warnings); MSS4 = black-hat
priest (the Jesuit channel 4); MSS5 = woman in a white bonnet; KING1 = the
red-coated King with hound; MYR0 = red-robed judge wig, MYR1 = blue-coated
grey wig. Placement on screen stays runtime cel state (§2.7.1) — the captures
show the MSS figures top-anchored left of centre with the popup over their
legs, and the IND tribe figures full-height at the right edge
(`61_arawak_first_contact.png`).

### 2.7.1 Speaker/special-sprite POSITION math — **RESOLVED (B): no box-relative formula**

The four channel functions take **only the popup-descriptor far-pointer** (`[bp+4]/[bp+6]`,
from dispatcher `func_06E3D0` @0x06E4AB `call 0x466`) — **never an explicit x/y**. There is
**no `sprite_x = popup.x − sprite_w` / `sprite_y = popup.y − sprite_h` arithmetic anywhere**
in `func_06BF66`/`06BE92`/`06BF12`/`06BF3C` (full bodies decoded). Placement is:

1. **`func_06BE50`** @0x06BE50 loads the sheet **by name** (`lcall 0x181f:0x2c` @0x06BE6D)
   and stores the **sheet handle** at `es:[desc+0x6c]/[desc+0x6e]` (@0x06BE75). No position.
2. **`func_06BF66`** allocates a 0x14-byte cel (`lcall 0x181f:0x2c` @0x06BF9F), **copies the
   sheet handle** into a local cel descriptor `[bp-0x80]` (`lcall 0xd1d:0x117e` =
   `func_01074E strcpy_far` @0x06BFFE), then **blits** it (`lcall 0x1a1f:0x372` @0x06C043)
   to the **fixed full-screen back-buffer 0xA000:0xFC00** (`[0x23f2]=0xfc00`/`[0x23f4]=0xa000`,
   @0x06C032/@0x06C038), storing the result position into the cel's `es:[bx+0xc]/[bx+0xe]`.
   The cel's `es:[bx+0x10]/[bx+0x12]` words are **next-cel link pointers** (set to a 2nd
   alloc'd object or 0 @0x06BFC1/@0x06BFE6), **not** coordinates.
3. **Clip only:** the sole rect input is the popup rect globals `[0x839e..0x83a4]`, applied
   as a clip by the dispatcher (`lcall 0x181f:0x444` @0x06E518) and the per-cel callback
   `func_06C18C` @0x06C18C (pushes `[0x839e..0x83a4]` @0x06C1A4-B0).

So the **landing pixel = the SS cel's intrinsic anchor** (an asset datum carried in the
handle/descriptor) transformed by the **pageid-27 blit overlay** (`0x1a1f:0x372` → file
`0x764d2`, the swappable graphics overlay) — **runtime/AI-GATED, not a coordinate literal**.
The `+0xf0` added in `func_06BE92`'s KING branch (@0x06BEBA → `[0xa5b0/a5b2]`) is an
**animation-timer seed** (stepped by `inc [0xa5ae]` in `func_06E9F4` @0x06EA26), **not** a
screen y. **B (negative + mechanism).** *(Earlier draft's `popup.x/y − sprite_w/h` guess is
byte-refuted.)* **Landing pixel — RESOLVED (B, runtime/asset-state):** there is **no static
x/y** anywhere — `func_06BF66` calls the blitter `lcall 0x1a1f:0x372` (= `func_076642`, page-27
overlay @file 0x76642) with `bx=[bp-0x80]` (the local cel descriptor) and `ax=0`, pushing **no**
coordinate immediate (`9a 72 03 1f 1a` @0x06C043); the destination is the fixed back-buffer
`[0x23f2]=0xfc00`/`[0x23f4]=0xa000` (0xA000:0xFC00 @0x06C032/@0x06C038). The blitter
**computes the landing position internally and RETURNS it in ax/dx**, which `func_06BF66` stores
back into the cel's `es:[bx+0xc]`=x / `es:[bx+0xe]`=y (@0x06C04C/@0x06C050). `formats/SS.md`
confirms the .SS directory carries **no per-cel screen-anchor field** (entries are only
flag/mode/unpacked_len/packed_len). So the on-screen pixel is a **per-cel runtime value produced
by `func_076642` from the loaded sheet handle + the back-buffer config**, clipped to popup rect
`[0x839e..0x83a4]`; it is per-asset/per-frame runtime state, **not a static EXE coordinate
literal**. The literal number for any one speaker frame would need a running-game capture of
`es:[bx+0xc]/[bx+0xe]` after the blit (no popup-speaker snapshot exists today).

The builders mutate the template string in place: `func_06BE92` pushes `"KING"`
(file 0x1F72) on the `> 7` branch and `"IND0A0"` (file 0x1F77) on the else branch,
adding the channel byte into the 4th char (`add [bp-0x11],al` @0x06BEF5) and a pose
index into the suffix. **B** (`POPUP_TEMPLATE_AUDIT.md`, byte-cited 0x06BE92..0x06BF11).

The tribe order matches NAMES `@TRIBES` (`[0x1F5C]` 0=Inca, 1=Aztec, 2=Arawak,
3=Iroquois, 4=Cherokee, 5=Apache, 6=Sioux, 7=Tupi). The native-event dispatchers
read the owner byte from the NativeSettlement table (`[0x54EC]` +0x02 stride 18)
into `[0x1F5C]` (e.g. `func_04B036` warpath). **B.**

After a popup closes, **all three channels are reset** (usually to `0xFFFF`) at
file **0x06EE6B** (`mov [0x1f5c],ax; mov [0x1f5e],ax; mov [0x1f60],ax`). **B.**

### 2.8 Multi-section popups (`@KEY` body + `@OPTIONS` list) — **B keys / INFERRED combine**

A popup such as the king-tax demand concatenates a body section (`@KINGTAX`) with
an option-list section (`@TAXOPTIONS`). `func_06F0F4` is recursive over sections:
it parses the body, and on hitting an `@OPTIONS` directive (or the next bare
`@KEY`) re-parses the following section for the option lines (parser core
`lcall 0x191F:0x928` → file 0x02591A). Section *existence* + adjacency **B**; the
exact two-call combine is **INFERRED** (`POPUP_TEMPLATE_AUDIT.md` "Multi-section").

---

> Each section below lists the **verified message `@KEY`(s)** (grep-confirmed in
> `GAME_sections.json` unless flagged), the speaker channel, the special-sprite
> name (via §2.7 `func_06BE92`/etc.), and the tier. Geometry follows §2.3.

## 3. King tax demand
- **Purpose:** Crown raises (or adjusts) the European-sales tax rate.
- **Keys (B, present in GAME_sections.json):** body `@KINGTAX` (body confirmed:
  *"It is essential that the Crown receive proper recompense…raise your tax rate
  by {%NUMBER0%%}…"*); punitive raise `@KINGRAISE`; lower `@KINGLOWER`; no-change
  `@KINGNOTHING`; manufactory tax `@MERCANTILISM`; Crown-resource tax
  `@PURCHASETAX`; pretexts `@KINGNAVACT`, `@KINGSTAMPACT`, `@KINGWAR`, `@KINGWIFE`.
  Options `@TAXOPTIONS` ("Kiss pinky ring." / "Hold '{%STRING3 Party}.'" — body
  confirmed) and `@TEAPARTY`.
- **Speaker:** `[0x1F5C]=8` → `KING1.SS` via wrapper `func_06F5DA` (`mov [0x1f5c],8`
  @0x06F5DD). **B.**
- **Geometry:** raw `@KINGTAX @width=190` (confirmed in `GAME.full.json` /
  `POPUP_TEMPLATE_AUDIT.md` direct file read; **stripped from `*_sections.json`**).
  Centered (no `@x/@y`). **B via EXE/raw audit.**
- **Cross-ref:** full formula + state layout in `spec/systems/king.md` (tax-raise
  `func_034AE0`, threshold 60 `func_0349F4`). **Tier: B (keys) / see king.md.**

## 4. Native village raze
- **Purpose:** player destroys a native settlement; gold reward + razed message.
- **Keys (B):** `@CHIEFKILL` (chief executes the player — taboo), `@INDIANGOLD`
  (raze gold reward), `@INDIANBURN`. Raze handler `func_04A7CA` (CHIEFKILL,
  `docs/UI_DIALOGS.md`, **A**). ~~razed-scene woodcut `WDCUT12`~~ **REFUTED 2026-07-30** (RULINGS.md): WDCUT12 has no caller in the EXE; no woodcut fires here.
- **Speaker:** `IND<tribe>A<pose>.SS` via `[0x1F5C]=tribe_idx` (§2.7). **A.**
- **Tier:** keys **B**; trigger fn **A**; geometry centered **B (engine)**.

## 5. Native attitude
- **Purpose:** report a tribe's stance toward the player.
- **Keys (B):** `@VILLAGEHAPPY`, `@VILLAGEMEDIUM`, `@VILLAGESAVAGE`, `@VILLAGEBAD`,
  `@VILLAGEWAR`; ship/wagon anger `@MADATSHIPS`, `@MADATWAGONS`; `@DONTKNOWSHIPS`.
  Attitude word-list is NAMES `@ATTITUDE` (Content/Uneasy/Restless/Angry/War —
  `NAMES_sections.json`, **B**). Handler `func_04B308` (`docs/UI_DIALOGS.md`, **A**).
- **Speaker:** tribe `IND<n>` (§2.7). **Tier:** keys **B**.

## 6. Native gift / haggle
- **Purpose:** trade-overture outcomes and gifts from a village.
- **Keys (B):** haggle outcomes `@BADHAGGLE0..@BADHAGGLE3`; trade prompts `@BUY0`,
  `@BUY1`, `@BUYWHICH`, `@TRADE0`, `@TRADE1`, `@BADCARGO`, `@NOTENOUGH`; gifts
  `@INDIANGIVEFOOD`, `@INDIANGIVESTUFF`, `@INDIANSCONVERT`, `@CHIEFGIFT`,
  `@CHIEFGUIDES`, `@CHIEFAREA`, `@CHIEFHOWDY`, `@CHIEFBORED`. Handlers `func_049600`
  (haggling), `func_0572E6` (gift/tribute) per `docs/UI_DIALOGS.md`, **A**.
- **Speaker:** tribe `IND<n>`; trade popups also set the advisor channel
  `[0x1F5E]` (e.g. MSS2/MSS3/MSS4 via `func_034DD4` @0x034E5E/74/98 — `POPUP_TEMPLATE_AUDIT.md`
  caller map). **Tier:** keys **B**.

## 7. Native raid / warpath
- **Purpose:** native attack on a player colony/unit; warpath declaration.
- **Raid outcomes = exactly 6 (B, raw-verified).** The EXE raid-key block at file
  **0x1F52A** is six contiguous keys: `RAIDWREAK, RAIDSTORES, RAIDBURN, RAIDSHIP,
  RAIDGOLD, RAIDNOTHING` (all present in JSON; `@RAIDWREAK` body confirmed
  *"{%STRING0} raiding party wreaks havoc…"*). Handler `func_05BE84` (enter 0x24
  @0x5BE84; uses the `[0x8542]` colony anchor). **B.**
- **`@RAIDSCALP`:** exists as a GAME.TXT section but is **not** referenced by the
  6-key raid block (absent from the EXE block) — it is an orphan / separate
  (warpath/scalp) key, **not** a 7th raid outcome. **B (negative).**
- **Warpath keys (B — corrected prefixes):** `@INDIANWARPATH`, `@INDIANWARPATH2`,
  `@INDIANWARFARE`, `@INDIANWAR`, `@INDIANGRUDGE`, `@INDIANSURPRISE` (the prior
  draft cited bare `WARFARE/WAR/GRUDGE/SURPRISE`; the actual JSON keys all carry
  the `@INDIAN` prefix — grep-confirmed). Handler `func_04B036` (sets
  `[0x1F5C]=tribe_owner`). ~~war-dance woodcut `WDCUT13`~~ **REFUTED 2026-07-30**: WDCUT13 = Indian raid on a human colony, fired from func_05CA7E @0x05D219 (RULINGS.md). **B.**
- **Tier:** keys **B**; raid count = 6 **B**.

## 8. Lost City (10 variants)
- **Purpose:** result of a unit entering a Lost City Rumor tile.
- **Keys (B):** the 10 `@LOSTCITY0..@LOSTCITY9` are all present in
  `GAME_sections.json` (`@LOSTCITY1` body confirmed *"You have discovered a
  {Fountain of Youth}!…"*), plus adjacent outcome keys `@BURIAL1`, `@BURIAL2`,
  `@BURIAL3` (burial-grounds anger), `@SCREWED`, `@VANISH`. Label "Lost City
  Rumor" is `LABELS @MISC` (**B**).
- **Variant→outcome mapping — RESOLVED (B, 2026-06-21).** Handler `func_061454`
  (enter 0x3c @0x61454) builds `@LOSTCITY<n>` by appending the outcome index
  `[bp-6]` (1–9) to the "LOSTCITY" template (`push 0x1dae @0x618C2`) and shows it
  (`lcall 0x181f:0x182 @0x618D9`). Byte-cited per-index side effects (matching
  `events.md` §2): **1** Fountain of Youth (sound 0x37 @0x618ED; promotes to 2 if
  `[0x5382]&1`); **2** Cibola/treasure (sound 0x3c); **3** ruins gold
  (`10·3d8` @0x61770); **4** burial-grounds anger (`or [bx+0x543e],0x40` @0x61877;
  sub-dispatches `@BURIAL1/2/3`+`@SCREWED`); **5** expedition vanished (`@VANISH`,
  downgrades to 6); **6** nothing; **7** gift/larger treasure (`2·4d10` @0x617C0);
  **8** trespass near shrines; **9** survivors/recruit (spawn `lcall 0x191f:0xac8`
  @0x61809; `@LOSTCITY0` is the recruit prompt reused by FoY/survivors). **B.**
- **Tier:** key existence + per-variant index map **B**.

## 9. Combat result
- **Purpose:** land/colony combat resolution outcome.
- **Keys (B):** `@DEMOTE`, `@COLONISTCAPTURE`, `@COLONISTCAPTURE2`, `@CARGOCAPTURE`,
  `@WAGONCAPTURE`, `@SHIPDAMAGE`, `@ARTILLERY`, `@ARTILLERY2`, `@VETERAN`, `@VALOR`,
  `@WELLSEASONED`. Handler `func_05B2C2` (`docs/UI_DIALOGS.md`, **A**; thunk
  0x1CCD0 → func_05B2C2 validated in the RTLink resolver). ~~Battle woodcut `WDCUT10`~~ **REFUTED 2026-07-30**: WDCUT10 = first European contact, fired from func_057F4E @0x057FDF (RULINGS.md).
- **Tier:** keys **B**.

## 10. Ship combat / landfall
- **Purpose:** naval combat and shore-arrival events.
- **Keys (B):** `@SHIPCOMBAT` (body confirmed *"Only {Privateers} and {Frigates}
  can attack enemy ships."*), `@SHIPLAKE`, `@SHIPDAMAGE`, `@SHIPSUNK`, `@LANDFALL`
  (body confirmed — has inline options "Stay With Ships / Make Landfall"),
  `@LANDFALL2`, `@LANDFIRST`, `@SAILHOME`, `@SHIPRUN`, `@SHIPSLOW`, `@FORTFIRE`,
  `@OVERBOARD`, `@EVASIVE`. Handler `func_03FDDE` (`docs/UI_DIALOGS.md`, **A**).
- **Tier:** keys **B** (all present); some bodies are short single-line prompts.

## 11. Heresy denunciation
- **Purpose:** missionary denounces a rival nation's mission.
- **Keys (B):** `@HERESY0`, `@HERESY1`; mission keys `@MISSION0..@MISSION3`.
  Action label "Denounce Heresy of %Fs Mission" is NAMES `@ACTIONS` (**B**).
- **Speaker:** missionary channel `[0x1F60]` → `MYR<n>.SS` (`func_06BF3C`), or
  Jesuit `MSS4` via the advisor channel. **A.**
- **Tier:** keys **B**.

## 12. Rebel-sentiment change (Sons of Liberty)
- **Purpose:** announce a colony crossing a SoL/Tory threshold.
- **Keys (B):** `@REBELUP`, `@REBELUP50`, `@REBELDOWN`; `@SONSUP`, `@SONSDOWN`;
  `@REBELMAJORITY`, `@REBELUNANIMOUS`, `@TORYMINORITY`, `@TORYMAJORITY`,
  `@TORYUPRISING`. Handler `func_03E844` (REBELUP/REBELDOWN, `docs/UI_DIALOGS.md`,
  **A**); `@TORYUPRISING` event handler `func_03CAC6` runs the shared engine
  (`CHROME_AND_DISPATCH_INDEX.md` §B8). Rebel/Tory % is shown in the Continental
  Congress report (F3, see `advisor_reports.md` §4). **Tier:** keys **B**.

## 13. Food shortage / starvation
- **Purpose:** warn of low food / a colonist starving.
- **Keys (B):** `@FOODLOW`, `@STARVE1`, `@STARVE2`, `@FOOD1`, `@FOOD2`; spoilage
  `@SPOIL1..@SPOIL4`; `@WAREHOUSEFULL`, `@NOMOREWAREHOUSE`.
- **Trigger fn — RESOLVED (B):** `func_02D658` @0x02D658 (colony-turn food/production update;
  reads the current-colony anchor `[0x8542]`). It builds & posts each food message by pushing the
  GAME.TXT key's DGROUP offset and calling the section-show helper `func_02EF5F` (= ljmp
  `0x191f:0x9dc`) via the `push <args>; push cs; call 0x2ef5f; add sp,0xe` idiom: `@FOOD1`
  (push 0xe3b @0x2E219), `@FOOD2` (0xe41 @0x2E234), `@STARVE1` (0xe4e @0x2E296), `@STARVE2`
  (0xe56 @0x2E2B0), `@FOODLOW` (0xe5e @0x2E362), `@SPOIL<n>` (built from 0xead @0x2E8B8). The
  template is selected by `cmp [bx+0x1f],[bp-0x12c]` (pop vs food-OK flag, bx=[0x8542]) @0x2E242;
  a once-per-turn `[0xa898]` shown-flag gates repeats (`cmp byte [0xa898],1` before each push,
  `or [0xa898],al` after the call). (Cross-checked: `spec/systems/colony.md` already cites
  `func_02D658` as the food-message poster.)
- **Tier:** keys **B**; trigger fn **B** (`func_02D658` @0x02D658).

## 14. Colony burn / capture
- **Purpose:** a colony is razed or captured (by natives or a rival power).
- **Keys (B):** `@BURNED`, `@BURNED2`, `@BURNED3`; `@CAPTURED`, `@CAPTURED2`,
  `@CAPTURED3`; `@INDIANBURNCOLONY`, `@INDIANBURNCOLONY2`, `@INDIANWINCOLONY`,
  `@INDIANWINCOLONY2`; war outcome `@EUROPEWIN`, `@EUROPELOSE`. Handler `func_05CA7E`
  (`docs/UI_DIALOGS.md`, **A**). Burning-colony woodcut `WDCUT11` — **byte-confirmed 2026-07-30 (B)**: fired @0x05DADC and @0x05DFCB in func_05CA7E.
- **Tier:** keys **B**.

## 15. Intervention
- **Purpose:** a foreign power's Intervention Force joins the Revolution.
- **Keys (B):** `@INTERVENTION`, `@INTERVENE`, `@CONSIDER`; ally names `@FRIEND`
  (body confirmed: *"British General Cornwallis / French General Lafayette /
  Spanish Generals / Dutch Admiral de Ruyter"*). Event handler `@INTERVENE`
  `func_03D510` runs the shared engine (`CHROME_AND_DISPATCH_INDEX.md` §B8);
  announce handler `func_03D948` (`docs/UI_DIALOGS.md`, **A**). "Intervention
  Force" label in `LABELS @MISC`. **Tier:** keys **B**.

## 16. Treasure delivery
- **Purpose:** a treasure train is shipped to Europe (King's Galleon) and cashed.
- **Keys (B):** `@CASHTREASURE`, `@KINGGALLEON2`, `@KINGGALLEON3`, `@LOOTCASH`,
  `@LOOT`, `@LOOT2`, `@LOOTFOREIGN`, `@LOOTCAPTURE`, `@NOLOOT`. Handler `func_05C878`
  (King's Galleon, `docs/UI_DIALOGS.md`, **A**). Speaker `[0x1F5C]=8` → `KING1.SS`.
  ~~Treasure woodcut `WDCUT04`~~ **REFUTED 2026-07-30**: WDCUT04 = Aztec first contact (func_056C3E; RULINGS.md). **Tier:** keys **B**.

## 17. Unit capture / demotion
- **Purpose:** a unit is captured or demoted after combat.
- **Keys (B):** `@DEMOTE`, `@COLONISTCAPTURE`, `@COLONISTCAPTURE2`, `@CARGOCAPTURE`,
  `@WAGONCAPTURE`, `@CAPTURED`, `@CONFISCATE`, `@LOBOTOMIZE`.
- **Tier:** keys **B** (overlaps Combat-result handler `func_05B2C2`).

## 18. Revolutionary-war messages
- **Purpose:** declaration, mobilization, REF, and end-of-war events.
- **Keys (B):** `@DECLARE`, `@INDEPENDENCE`, `@DECLARAT`-screen (see
  `spec/ui/cinematics.md`), `@MOBILIZE`, `@MOBILIZE2`, `@CANTMOBILIZE`,
  `@KINGMOBILIZE`, `@UPKEEP`; king-war keys `@KINGFRIGATE`, `@KINGNEWWAR`,
  `@KINGVICTORY`, `@KINGWAR`, `@KINGMERCY`, `@KINGBUY`, `@REFIT`; guards
  `@NOWARSDURINGREV`, `@NOCOLONIESEITHER`, `@NOMAYORSDURINGREV`, `@EUROPENOTAVAIL`,
  `@FOREIGNNOTAVAIL`, `@ALREADYREVOLUTION`; siege/invasion `@INVASION`, `@SEIZURE`,
  `@SEIZURESEA`, `@SEIZURELAND`, `@TOOTORY`, `@LOSENOCOLONIES`. Independence handler
  `func_03DE46` + guard `func_03E984`; event templates `@SEIZURE` `func_03C5A8`,
  `@INVASION` `func_03CDA2`, `@TOOTORY`/`@WAR`/`@PEACE` via the shared engine
  (`CHROME_AND_DISPATCH_INDEX.md` §B8). **A**.
- **`@KINGNEWWAR` sprite — RESOLVED (B, negative):** `KING2.SS` **does not exist**
  in the binary (`"KING2"` has **zero** GAME.TXT sections and zero string
  occurrences; only `"KING1"` @file 0x1FCB4, built by the `> 7` branch of
  `func_06BE92`), so `@KINGNEWWAR` uses **`KING1.SS`** (or a static portrait), not a
  KING2 arm-raise animation — the KING2 hypothesis is byte-refuted.
- **Tier:** keys **B**; `@KINGNEWWAR` sprite **B** (=KING1); per-message geometry
  centered **B (engine)**.

---

## 19. Interactions
- **Dismiss:** every popup ends with the modal wait loop `0x181F:0x3C0`
  (`func_004A80` @0x4A80) — polls keyboard (kbhit/getch) + mouse with a ~120-tick
  timeout; OK/keypress/click dismisses. It **draws nothing** (the OK box/label are
  painted by the dialog builder first). **B** (`UI_PRIMITIVES.md` §0x3C0).
- **Option select:** option-list popups (`@OPTIONS` / `@TAXOPTIONS` / `@SMITEINDIANS`
  inline options / `@LANDFALL`) stack the option rows below the body, left-aligned
  to the body margin; the `@DEFAULT=N` row is the highlighted index (handler
  @0x6F374), **not** a color. Selection is read by the show-and-wait thunk
  `0x191F:0x16A`. **B (mechanism).** Highlight RGB capture is **not needed** — it
  resolves via the loaded PIK palette (`fonts_and_colors.md`), and there is no
  dedicated OK/Cancel/button sprite (the modal wait loop `func_004A80` @0x4A80
  blits nothing; no `"OK"`/`"Cancel"` string exists in the EXE — see §22.5). **B.**
- **Speaker portrait:** drawn above the popup by `func_06BF66` from the active
  channel sheet (§2.7); reset to `0xFFFF` on close (@0x06EE6B). **B.**
- **Channel reset:** the dispatcher clears all three channels after close so the
  next popup starts with no speaker unless it sets one. **B.**

## 20. Assets & text
- **Frame/background:** WOODPANL.PIK (some WOODPAN2.PIK) tiled body + WOODFRAM.SS
  frame (`0x181F:0x510` @0x0263D6) + NAMEPLAT.SS title strip. **A** (asset roles).
- **Speaker sheets:** `KING1.SS`, `IND0A0..IND7A0.SS`, `MSS0..MSS5.SS`,
  `MYR0..MYR3.SS` — built by NAME (not index) by `func_06BE92`/`BF12`/`BF3C`. **B.**
- **Body font:** FONTTINY (`[0x89E]/[0x8A0]`, engine default). `SMALLFONT` does
  **not** load FONTSMAL (handler @0x6F207 only copies the latched FONTTINY
  descriptor — RULING). **B.**
- **Message keys:** `data_extracted/text/GAME_sections.json` — every `@KEY` in §3–§18
  grep-confirmed present (2026-06-23). `@KINGTAX`, `@TAXOPTIONS`, `@RAIDWREAK`,
  `@LOSTCITY1`, `@KINGNEWWAR`, `@FRIEND`, `@SMITEINDIANS`, `@WANTSTUFF`, `@VICEROY`,
  `@KINGLOSE`, `@KINGWIN`, `@SHIPCOMBAT`, `@LANDFALL` bodies spot-confirmed. **B.**
- **NAMES tables:** `@ATTITUDE`, `@ACTIONS`, `@TRIBES` (all present in
  `NAMES_sections.json`). **B.** **LABELS:** "Lost City Rumor", "Intervention
  Force" in `LABELS @MISC` (present). **B.**
- **Woodcuts:** ~~WDCUT04 (treasure), WDCUT10 (battle), WDCUT12 (burning village), WDCUT13 (war dance)~~ **REFUTED 2026-07-30** — only WDCUT11 (burning colony) survives, byte-confirmed. The true trigger table is in `spec/ui/woodcuts_and_intro.md` (RULINGS.md 2026-07-30). **B.**

## 21. Evidence
- `raw/COLONIZE/VICEROY.EXE` — dialog engine `func_06C520` @0x06C520 /
  `func_06D316` @0x06D316 / line builder `func_06C850` @0x06C850 / frame blit
  `0x181F:0x510` @0x0263D6 / @-parser `func_06F0F4` @0x06F0F4 / sprite builders
  `func_06BE92`/`BF12`/`BF3C`/`BF66` / dispatcher `func_06E3D0` @0x06E3D0 /
  reset @0x06EE6B / directive table @0x1F967 / `"WIDTH"` @0x1F989 /
  raid block @0x1F52A / Lost-City handler `func_061454` @0x61454. **B.**
- `viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` §B8 — the shared
  centered-dialog FRAME engine + the ~30 GAME.TXT event templates (index rows
  25–29), spot-checks PASS. **B** (mechanism) / **A** (per-event attribution).
- `viceroy_source/docs/UI_PRIMITIVES.md` — the resident `0x181F:NNN` draw-verb
  library (corrected: `0x22`=string-scan not fill, `0xE2`=clipped sprite blit not
  rule, `0x3C0`=modal wait not OK-draw). **B.**
- `docs/POPUP_TEMPLATE_AUDIT.md` — 11-string directive table @0x1F967, 4 sprite
  channels `[0x1F5C/5E/60]`, builders, reset @0x06EE6B, `func_067DC8` cursor-rect
  path, multi-section combine. **B** (mechanism) / **A** (per-event attribution).
- `data_extracted/text/{GAME,NAMES,LABELS}_sections.json` — message keys, attitude/
  action/tribe lists, misc labels (all grep-verified present). **B.**
- `docs/UI_DIALOGS.md` — per-popup trigger functions (`func_05BE84` raid,
  `func_05B2C2` combat, `func_05CA7E` burn, `func_03E844` rebel, etc.). **A.**

## 22. Open questions
*(Resolved 2026-06-21/23: Lost-City variant map (`func_061454`, index 1–9); raid
count = 6 (`@RAIDSCALP` is an orphan key, not a raid outcome); `@KINGNEWWAR` =
KING1.SS (KING2.SS absent); the centered geometry formula (`func_06D316`); the
warpath key prefixes are `@INDIAN…`. All struck.)*

1. **Per-section `@width`/`@x`/`@y` literals — B-via-EXE, NOT re-confirmable from
   the committed JSON.** `func_06D316` reads these as the content-width floor /
   literal origin, and `POPUP_TEMPLATE_AUDIT.md` quotes `@KINGTAX @width=190`
   directly from the raw GAME.TXT — but the section extractor **strips valueless
   `@`-directive lines**, so `data_extracted/text/GAME_sections.json` does **not**
   carry `@width`/`@x`/`@y` (only 2 stray `@width=200` captures survive in
   `GAME.full.json`). To re-confirm specific per-popup values, read raw
   `GAME.TXT` / the EXE, not the sections JSON. **RESOLVED (B): the literal
   per-popup values ARE recoverable from the committed `raw/COLONIZE/GAME.TXT`**
   (the `@width=`/`@y=`/`@x=` directive lines are intact there). Confirmed values
   for the §3–§18 gameplay popups (all centered — no `@x`/`@y`): `@KINGTAX`,
   `@KINGRAISE`, `@KINGLOWER`, `@RAIDWREAK`, `@LOSTCITY0..9`, `@FOODLOW`,
   `@STARVE1`, `@SPOIL1`, `@SHIPCOMBAT`, `@LANDFALL`, `@HERESY0`, `@REBELUP`,
   `@VILLAGEHAPPY`, `@INDIANGOLD`, `@BURNED`, `@CAPTURED`, `@DECLARE`,
   `@KINGNEWWAR`, `@INVASION`, `@SEIZURE` all = **`@width=190`**; the wider king/
   treasure/intervention popups `@TEAPARTY`, `@CASHTREASURE`, `@INTERVENTION`,
   `@INDEPENDENCE`, `@SONSUP`, `@SMITEINDIANS` = **`@width=220`**. Across all of
   GAME.TXT the width histogram is {190:336, 220:99, 300:11, 310:10, 160:8, …};
   only 21 sections carry an `@x`/`@y` (menus, tutorials, `@VICEROY` x=232/y=21,
   `@KINGLOSE` x=232/y=31, `@KINGWIN` x=202/y=125 — none of them §3–§18 gameplay
   popups). **B (raw GAME.TXT — `raw/COLONIZE/GAME.TXT`).**
2. **WOODPANL-vs-WOODPAN2 background per popup — RESOLVED (B, negative).**
   `WOODPAN2` occurs **once** in the EXE (string @file 0x1EB77, DGROUP 0x11D7),
   pushed **only** at file 0x3AAFF in `func_03A9C0` — the **score / hall-of-fame**
   screen (adjacent strings `EXPLOITS`/`HALLFAME.DAT` @0x1EB92; push feeds the
   full-screen PIK verb `lcall 0x181f:0x44e` @0x3AB02). The shared popup frame
   engine (`func_06C520` family, 0x6BE50..0x6D800) pushes **no** WOODPANL/WOODPAN2/
   WOODFRAM/NAMEPLAT offset (byte-scan = 0 hits). So there is **no per-popup
   WOODPAN2 path** — every gameplay popup uses WOODPANL; the king-audience
   inference is byte-refuted. **B (negative)** (func_03A9C0 @0x3AAFF).
3. **`func_06BF66` sprite-blit POSITION math — RESOLVED (B, see §2.7.1).** The full
   550-byte body is now decoded: **there is NO box-relative x/y arithmetic** (the prior
   `sprite_x/sprite_y = popup.x/y − sprite_w/h` guess is **byte-refuted**). `func_06BF66`
   copies the sheet handle into a cel descriptor (`lcall 0xd1d:0x117e` strcpy @0x06BFFE)
   and blits it (`lcall 0x1a1f:0x372` @0x06C043) to the **fixed back-buffer 0xA000:0xFC00**;
   the only rect input is the **clip** rect `[0x839e..0x83a4]`. The channel funcs receive
   **only** the descriptor far-ptr (no x/y). The literal landing pixel = the **SS cel's
   intrinsic anchor** put through the **pageid-27 blit overlay** (`0x1a1f:0x372` → file
   `0x764d2`) — **runtime / AI-GATED**, needing an SS-cel-header read + a blitter trace,
      NOT a coordinate literal in these functions. **RESOLVED (B, runtime/asset-state, see §2.7.1):**
the blitter `lcall 0x1a1f:0x372` (= `func_076642` @file 0x76642, page 27) is called @0x06C043 with
**no x/y immediate** (only the cel-descriptor ptr `bx=[bp-0x80]`, `ax=0`); it **computes and returns**
the landing position, which `func_06BF66` writes back to the cel's `es:[bx+0xc]`=x/`es:[bx+0xe]`=y
(@0x06C04C/@0x06C050), and `formats/SS.md` confirms the .SS directory has **no per-cel anchor
field**. So the on-screen pixel is a **per-frame runtime value produced by the page-27 blitter**
(clipped to `[0x839e..0x83a4]`), not a static EXE literal — a specific frame's number needs a
running-game capture of the post-blit `es:[bx+0xc]/[bx+0xe]`. **B (negative + mechanism;
position = blitter-returned runtime state).**
4. **Food-shortage trigger function — RESOLVED (B):** `func_02D658` @0x02D658, the colony-turn
   food/production update (reads the colony anchor `[0x8542]`). It posts the food messages by
   pushing each GAME.TXT key's DGROUP offset and calling the section-show helper `func_02EF5F`
   (= ljmp `0x191f:0x9dc`): `@FOOD1` 0xe3b @0x2E219, `@FOOD2` 0xe41 @0x2E234, `@STARVE1` 0xe4e
   @0x2E296, `@STARVE2` 0xe56 @0x2E2B0, `@FOODLOW` 0xe5e @0x2E362, `@SPOIL<n>` 0xead @0x2E8B8
   (the food-key string offsets are file 0x1E7DB..0x1E84D; DGROUP→file delta 0x1D9A0). Template
   choice = `cmp [bx+0x1f],[bp-0x12c]` @0x2E242 (colony pop vs food-OK flag); a `[0xa898]`
   once-per-turn flag gates repeats. **B (func_02D658 @0x02D658; cross-confirmed in
   `spec/systems/colony.md`).**
5. **Option-highlight RGB / button SS index — RESOLVED (B, negative): there is no
   OK/Cancel button sprite.** `@DEFAULT` stores a row index, not a color; the
   highlight resolves via the loaded PIK palette (`fonts_and_colors.md`) — no
   capture needed. The gameplay popups have **no OK/Cancel button SS sprite**: the
   strings `"OK"`/`"Okay"`/`"Cancel"` do **not** exist anywhere in the EXE (the only
   `CANCEL` hits @0x1ED6B/0x1F238 are GAME.TXT keys `CANCELPEACE`/`CANCELTREATY`,
   not button labels), and the wait loop `func_004A80` @0x4A80 is a pure input-poll
   (timer `lcall 0xc0c:6`, keyboard `lcall 0xae7:2`/`0x16`, 0x78=120-tick timeout
   @0x4ADD) that **blits nothing** and returns the keypress in `di`. Dismissal is
   any keypress/click; inline choices (`@LANDFALL`/`@TAXOPTIONS`) are GAME.TXT
   option *text* rows (center-text verb `0x100`), not sprites. **B (negative)**
   (func_004A80 @0x4A80; no OK/Cancel string in EXE).

*No runtime residual remains for popups* — the live **values** substituted into a
popup body (gold, names, counts via `{%NUMBER}`/`{%STRING}`) are game state, but the
layout, text keys, sprite channels, geometry, and colors are all static.
