# Woodcut event screens + intro caption cards

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Decoded 2026-07-30; caller enumeration re-verified (exactly 10
> `lcall 0x181F:0x524` sites, 1 `0x52E` site), asset-name strings byte-read at
> file 0x1F8A6+ ("WDCUT"/"FONT-NP"/"WOODFRAM"/"NAMEPLAT"/"WOODCUT").
> **Supersedes four popups.md woodcut glosses** (RULINGS.md 2026-07-30):
> WDCUT04/10/12/13 were misattributed; only WDCUT11 survived.

> **Frame-numbering convention (RULING 2026-07-31):** engine frame numbers are
> 1-based over disk descriptors (WOODFRAM.SS "frame 1" = its only disk
> descriptor 0; NAMEPLAT frames 1/2/3 = disk 0/1/2).

## 1. Woodcut system (B)
- **Text**: WOODCUT.TXT is ONE section `@WOODCUT` with 17 caption lines
  (0–16; 14–16 placeholders). **Art**: WDCUT01..WDCUT13.SS (no 00/14/15/16);
  chrome WOODFRAM.SS + NAMEPLAT.SS; font FONT-NP.
- **Renderer `func_06B722`** @0x06B722 (page 0x16; `0x181F:0x52E`):
  `show_woodcut(n)`; n<0 = save-under popup mode (caption 1→0 remap
  @0x06B88E). Missing-file exists-check @0x06B79F bails (makes 0/14–16
  unshowable). Layout: black clear + present; WOODFRAM frame 1 centered from
  sheet-header words; title = `"<year>: <CAPTION>"` (`[0x538A]` year, line n
  of `@WOODCUT`); **NAMEPLAT strip at y=162** (left cap + N mid tiles + right
  cap, centered on x=160); **caption at y=165** centered, FONT-NP, ink LUT
  palette indices 0x5C/0x5D/0x5E; WDCUT art blit; staged present/fade
  `func_005160(8)`; modal wait `0x3C0` @0x06BA83; clear; palette restore.
- **Wrapper `func_00543C`** (`0x181F:0x524`): once-only bitmask at DG
  `[0x540A]` (test `func_005418`, set `func_0053DE`); per-woodcut sound cues
  (n=0/1/9 music class 2; n=3/4/5/6 tune 0x33/0x35/0x36/0x39).

### Trigger table (B — caller scan exhaustive)
| n | caption | trigger |
|---|---|---|
| 0 | A NEW WORLD | **no caller** (latent popup mode; possibly COLONIZE.EXE-era) |
| 1 | DISCOVERY OF THE NEW WORLD | first **SIGHTING** of land from a ship (running-game observation 2026-08-30; the old "first landfall" gloss was wrong) — `func_020EFE` @0x020F00 (woodcut + @LANDHO name prompt + T2), reached from the ship-move chain `func_03FDDE`; the exact sighting predicate is unread |
| 2 | BUILDING A COLONY | first colony — Build-Colony executor `func_040C1E` @0x040E00 (human only, sfx 0x54) |
| 3 | MEETING THE NATIVES | first tribe contact, tribe ≥2 — `func_056C3E` @0x056DA6 (then `@INDIANWELCOME`) |
| 4 | THE AZTEC EMPIRE | same site, tribe 1 = Aztec |
| 5 | THE INCA NATION | same site, tribe 0 = Inca |
| 6 | DISCOVERY OF THE PACIFIC OCEAN | **no caller** (sound cue wired @0x0054A2 — planned, never hooked) |
| 7 | ENTERING INDIAN VILLAGE | `func_04B308` @0x04B56C (human) |
| 8 | THE FOUNTAIN OF YOUTH | Lost City Rumor outcome 1 — `func_061454` @0x0618F9 (after tune 0x37) |
| 9 | CARGO FROM THE NEW WORLD | first cargo arrival in Europe — `func_041EEA` @0x0420EF |
| 10 | MEETING FELLOW EUROPEANS | first power-to-power contact — `func_057F4E` @0x057FDF |
| 11 | COLONY BURNING | colony burned — `func_05CA7E` @0x05DADC (with "BURNED" popup) and @0x05DFCB (sfx 0x53 + tune 0x32) |
| 12 | COLONY DESTROYED | **no caller** |
| 13 | INDIAN RAID | natives attack human colony — `func_05CA7E` @0x05D219 |
| 14–16 | placeholders | unreachable (no caller, no .SS) |

## 2. Intro caption cards `@BUILD1..10` (B)
- **Art**: LEVN0001..LEVN0010.PIK, one per card. Renderer **`func_004B72`**
  (resident): builds `"LEVN00"+n` name, loads via `0x181F:0x44E` load_PIK
  (768-byte palette captured; card 1 blanks the screen first and latches the
  palette via `func_00D1E4`), then renders GAME.TXT section `"BUILD"+n` at
  **pen (14,54)** (`[0x1F4A]=0xE`, `[0x1F50]=0x36`, restored after) with
  `^^`-centered lines; staged present `func_005160(8)`.
- Per-card substitutions: card 2 %STRING0 = difficulty-rank
  (`[0x8394+2·diff]`), %STRING1 = leader name (`0x540E+p·0x34`); card 3
  %STRING0 = home port (`[0x838C+2·nation]`); card 4 %STRING0 = nation name,
  %STRING1 = `@MYLEADER[nation]` ("King/King/King/Stadtholder").
- **Sequencer `func_004D1E`** (`0x181F:0x3AC`), called from 34 sites in the
  new-game world-generation code (28 in page 0x14, 6 in `func_0755CC`):
  advances one card per **0x23A ticks** via counter `[0x8C]` (no other
  writer — runs once per process); any key/click skips (`[0x8A]=1`);
  Alt-X/Alt-Q exits to DOS (`exit(3)`). The cards are a self-advancing
  slideshow **over world generation** — each card is its own full screen.

## 3. Open items (exact trace sites)
1. WDCUT/WOODFRAM placement words (sheet-header +0x46..+0x4C) — asset dump
   or trace `0x181F:0x254` at @0x06B71B/@0x06BA67.
2. `0x181F:0xBA` band-fill args @0x06BA48 semantics.
3. `[0x540A]` shown-bitmask savegame persistence.
4. ~~Card-interval tick unit (trace `func_00E4C6`/`[0x267A]`).~~ **Closed
   2026-09-02** — see the amendment below: 3.285 ms per tick, 1873 ms per card.
5. Runtime pointer tables `[0x838C]` (@HOMEPORT) / `[0x8394]`
   (@DIFFICULTY) loader — pins card-2/3 bindings A→B.

## Amendment 2026-09-02 — §2 re-read whole (B3.10 close; RULINGS 2026-09-02c)

`func_004B72` (0x004B72..0x004D1C) and `func_004D1E` (0x004D1E..0x004DF6) were
read end to end, with the new-game driver `func_0755CC` @0x0755CC and the
King painter `func_075352` @0x075352. Corrections and additions to §2:

- **Not a pen.** `[0x1F4A]`/`[0x1F50]` (and `[0x1F52]`) are the popup engine's
  **ink slots** (`dialog_framework.md` +0x74 record; `func_073474 @0x073474`
  stores the in-game ink table into the same words). The card renderer saves
  them, stores **0x0E / 0x36** (@0x004CD6/@0x004CDC), calls the GAME-section
  popup wrapper `0x181f:0x3fe` = `func_06F594` on `"BUILD"+n` (@0x004CE5), and
  restores them (@0x004CEA). The text is therefore laid out by the **standard
  popup engine** from `@BUILDn`'s own directives — raw GAME.TXT lines
  3367-3416 carry `@width=310 @y=30` (the JSON extractor strips them). Under
  LEVN0001's palette 0x0E = (255,255,154), 0x36 = (105,138,195). The ports'
  `y=54, pitch 9` is a measured stand-in (no DOS capture of a card exists to
  diff) — **TBD** until one does. Same shape for the scroll: `func_075352`
  stores **0xF2 / 0x2F / 0** @0x075526..0x075532 (KINGLSS1 palette: (113,85,69)
  / (97,28,40) / black) and renders `@VICEROY` (`@VICEROY2` for the Dutch,
  `strcat_itoa(2)` @0x0755AE) through the same wrapper @0x075540 from its own
  `@width=78 @x=232 @y=21`; the earlier "pen (242,47)" was these ink stores.
  Which glyph level reads which slot needs the 2bpp text primitive
  (`func_00E51C`) — TBD.
- **Non-modal.** The renderer ORs `[0x1F56] |= 0x20` (@0x004C9E) before the
  popup call; the modal runner tests that flag byte (`@0x06E583 test es:[bx+0xa],
  0x20`) and **skips its whole input loop**, and `func_06D88C @0x06D890` skips
  the popup's own present because the card presents itself through the staged
  fade `func_005160(8)` (@0x004D05). The audience does not set 0x20, so the
  scroll waits in the normal modal loop — that wait is the audience's only
  "dismissal"; **no caption is drawn on either screen** (the ports' "(click to
  continue)"/"(click to begin)" were inventions, removed).
- **Sequencer semantics (replaces "any key/click skips").** `[0x92]` starts at
  -1 (.data, file 0x1DA30) so card 1 shows on the first call; card k+1 when
  `now - [0x90:0x92] >= 0x23A` (@0x004D35..0x004D46); with `[0x8C] == 10`
  the next interval sets the done flag `[0x8A]` (@0x004D4F). A key (getkey +
  drain @0x004D89..0x004D94) or click (@0x004DD5) sets `[0x8A]` **and nothing
  else** — the cards keep advancing on the timer. The driver ignores the
  return during world generation and spins on it only afterwards
  (`@0x07596F lcall 0x181f,0x3ac ; or ax,ax ; je`), so a key/click ends the
  slideshow as soon as generation is done. Alt-X (0x12D) / Alt-Q (0x110) set
  the demo flag `[0x828]` and exit to DOS (`exit(3)` @0x004DB9); with `[0x828]`
  already set, any key/click exits.
- **Tick unit (open item 4).** `[0x267A:0x267C]` → `0x1B5A:0x92E8` at timer
  install (@0x00C84E..0x00C857); the INT 8 handler bumps `[0x8338]` every
  interrupt (@0x00C69B) and `[0x92E8]` on even ones (@0x00C6A5 → @0x00C741);
  PIT divisor 0x7A8 = 1960 (@0x00C843 → `out 0x43,0x36 / out 0x40` @0x00E508).
  One tick = 2·1960/1193182 s = **3.285 ms**; 0x23A = 570 ticks = **1873 ms**
  per card, ≈ 18.7 s for ten untouched.
- **Substitutions.** The `switch n-2` @0x004C0D registers slots for cards
  2/3/4 only (@0x004C1C..0x004C96; card 4's `%STRING1` is `@MYLEADER[player]`
  via `0x181f:0x422(0x87c, 0x7b, player)` = `func_06FAE8`). Card 7's
  "%STRING0" has **no registration** — slot 0 still holds card 4's nation name
  (nothing clears it), so the nation name is the byte-true result by slot
  persistence. Card 1 alone blanks the screen first (`func_004A32` @0x004BB3)
  and latches the PIK palette (`func_00D1E4` @0x004CFE).
- **Boot order** (`func_0755CC`): `[0x5382]=0xC600`, `[0x5386]=0x0E`
  (@0x0755E5/@0x0755EB) → 16 price seeds → `func_07431E` (difficulty, nation,
  name, briefings; Tutorial Hints `|= 0x80` iff difficulty 0 @0x074348) → the
  audience `func_075594` @0x0756DC (skipped when `[0x828]`) → cursor hide,
  **tune 0x39** @0x0756E4, first sequencer call @0x0756EC → world generation
  with the sequencer polled → the spin @0x07596F → palette restore → **queue
  tune 0x25** @0x0759A0. The audience itself queues **tune 0x3E** @0x07544B.
  No RNG draw occurs inside the audience or the cards (no `0x181f:0x4d4`/`0x35c`
  in 0x075352..0x0755CB or 0x004B72..0x004DF6).
- **Port state (both engines, lockstep):** `cardsPoll` (game.js) / `in_tick`
  (colopy_input.c) advance the card from a clock stamped on entering the
  cards (`G.cardT0` / `UI.card_t0`) at 1873 ms per card; the harnesses script
  that clock (`TICK` events / `T ms`); a key/click on the cards begins the game
  at once (world generation is instant here). Oracles:
  `tools/render_boot_compare.py` (king ×2 nations, cards ×4) and
  `tools/input_compare.py boot`/`bootclick`.
