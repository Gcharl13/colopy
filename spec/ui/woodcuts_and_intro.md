# Woodcut event screens + intro caption cards

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Decoded 2026-07-30; caller enumeration re-verified (exactly 10
> `lcall 0x181F:0x524` sites, 1 `0x52E` site), asset-name strings byte-read at
> file 0x1F8A6+ ("WDCUT"/"FONT-NP"/"WOODFRAM"/"NAMEPLAT"/"WOODCUT").
> **Supersedes four popups.md woodcut glosses** (RULINGS.md 2026-07-30):
> WDCUT04/10/12/13 were misattributed; only WDCUT11 survived.

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
| 1 | DISCOVERY OF THE NEW WORLD | first landfall — `func_020EFE` @0x020F00 (sole caller `func_03FDDE`, after `[0x543E]|=0x80`) |
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
4. Card-interval tick unit (trace `func_00E4C6`/`[0x267A]`).
5. Runtime pointer tables `[0x838C]` (@HOMEPORT) / `[0x8394]`
   (@DIFFICULTY) loader — pins card-2/3 bindings A→B.
