# Founding-Father pick (@WHICHFREEDOM) + nation briefings (@NATION*)

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Decoded 2026-07-30; key strings byte-read ("WHICHFREEDOM" file 0x1EC02,
> "NATION0A" 0x1FB3D, "LEADERNAME" 0x1FB32, "MULTI" 0x1FB46), invoker sites
> verified. Companions: `spec/ui/continental_congress.md` (F3 screen; the
> `func_03C282` cost formula there is corroborated by this decode) and
> `spec/ui/colonizopedia.md` §8 (FATHER pedia page reached from both flows).

## 1. Founding-Father pick — B

- **Driver `func_03C322(nation, bells)`** @0x03C322, sole caller @0x02D6A7
  (colony-turn update). Bells accrue into `[0x84FC]+0x0C` (progress) and
  +0x0E (lifetime). No candidate selected (`+0x12 < 0`) → pick dialog;
  progress ≥ cost (`func_03C282` — same formula as congress spec §"Next
  Session") → acquire.
- **Candidate build `func_03BFD2`**: father table = runtime array DG 0x9652
  stride 6 (NAMES `@FATHERS` rows 0..24: +0 name, +2 category, +3/4/5
  era-weight bytes); era = year <1600 / 1600–1699 / ≥1700 (`func_03B95A`).
  Per each of the **5 categories**: weighted-random pick over un-owned
  fathers with nonzero current-era weight (`random(1,sum)` walk
  @0x03BFFC–0x03C046); empty category → no row.
- **Dialog** (`@WHICHFREEDOM`, width 190): rows = "FATHERNAME (Category
  Adviser)" — category names from `[0x96E8]` = NAMES `@FOUNDING`
  (Trade/Exploration/Military/Political/Religious), "Adviser" = LABELS
  `@MISC` `[0x2E88]`; row id = category+1. **Cannot cancel** (result ≤0
  re-shows @0x03C231); right-click/help (`[0x1F68]`) → **pedia FATHER page**
  for the candidate @0x03C24E, then re-show. Result → `[0x84FC]+0x12` =
  father id @0x03C269. AI path: category via `func_03BA5A` (internals TBD).
- **Acquisition `func_03BC42`**: owned-bit = bit(father&7) of
  `[0x880F + nation·0x13C + father>>3]`; first-owner byte `[0x53A9+father]`.
  Player flow: `@FREEDOM` popup (%STRING0 father, %STRING1 nation
  adjective) → **congress splash `func_03BB4A`**: full-screen CCBKGD.PIK
  (push 0x1253 @0x03BB6A), portraits drawn without the new father, then bit
  set + redraw (the reveal), sound 8, wait-key → **pedia FATHER page**
  @0x03BD26. Bookkeeping `+0x14`++, `+0x12=0xFFFF`. Per-father instant
  effects byte-cited for ids 1 (Fugger boycott reset), 6 (Coronado reveal),
  9 (La Salle stockades), 14 (Jones frigate), 16 (Pocahontas attitude
  reset), 18 (Paine +20 bells sentiment), 22 (Brebeuf missions), 24 (Las
  Casas convert upgrade).

## 2. Nation briefings — B

- **Keys**: `@NATION<n>A` (history) + `@NATION<n>B` (gameplay bonus) for
  nations 0–3; all `@width=300`, centered, standard template engine
  (WOODPANL.PIK backdrop beneath).
- **Single invoker** (byte-negative elsewhere): new-game setup
  `func_07431E` — `strcpy(buf,"NATION0A")` @0x074440–0x074447, **digit
  patched `buf[6] += [0x5398]`** @0x07444F, page A shown via the GAME
  wrapper @0x0744A3, then **`inc buf[7]`** ('A'→'B') @0x0744A8, page B
  @0x0744F9. Appears exactly once, at game start after leader-name entry —
  no F-key/advisor/pedia route.
- **The surrounding new-game chain** (all B): difficulty picker
  (`func_070580`, `@DIFFICULTY`) → nation picker (`func_070A1A`,
  `@PICKNATION`; quick-start `[0x828]` randomizes) → WOODPANL backdrop →
  **`@LEADERNAME`** entry (width 300, maxlen 23, default = the nation's
  leader name `[0x540E+n·0x34]`, result copied back) → briefings A/B →
  nation records init (all AI, chosen human) → optional `@MULTI` hot-seat
  checkbox dialog (`spec/ui/tutorial.md` §2).

## 3. Open items (exact trace sites)
1. NAMES `@FATHERS` → DG 0x9652 loader (watchpoint 0x9652).
2. `func_03BA5A` AI category heuristic (76 bytes @0x03BA5A — read pass).
3. String helpers `0x181f:0x11e/0x128` ("("/")" glyphs — likely same pool
   as pedia's, see colonizopedia.md §4) formal binding at these sites.
