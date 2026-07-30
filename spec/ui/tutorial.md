# Tutorial overlays + hot-seat multiplayer dialogs

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Decoded 2026-07-30; multiplayer strings byte-read (COLONIZE/MULTI env pair at
> DG 0x2064/0x206D, MULTINEXT DG 0x137, MULTIREV DG 0x138E), dispatcher entry
> and gates verified in the listings.

## 1. Tutorial overlays (`@TUTORIAL1..19`) — B

All are ordinary GAME.TXT popups via `0x181f:0x652` = `func_06F5F2(name,
advisor)` (sets portrait channel `[0x1F5E]` → MSS<n>.SS) or the `0x3FE` GAME
wrapper (advisor unchanged). Placement = the standard popup engine; sections
with literal `@x/@y` in GAME.TXT: T1 (10,40), T4 (x10), T12 (y5), T16
(5,10 smallfont), T17/T18 (y10 w300 smallfont) — fixed literals, never
unit-relative. Gate: Game Options bit 0x80 "Tutorial Hints" (T18 is
ungated). Once-flags live in save bytes `[0x5380]/[0x5386]/[0x5387]`.

### Unit-focus dispatcher `func_020F50` @0x020F50 (page 0x01, IP 0x8E0)
Handles T1, T3, T8, T9, T10, T11, T13, T14, T15, T19 via a compiled-in
if/else chain over the selected unit `[0x5392]`. Callers (both gated on the
option bit): end-of-move handler @0x021E63 and the map idle loop @0x024AC6
(after a ~30-tick wait). Highlights (full condition set byte-cited in the
2026-07-30 decode): T1 first turn (%STRING0 = unit-type name, advisor 0);
T11 idle ship (turn<20); T13 pioneer before first colony (advisor 3);
T14 soldier (advisor 1); T15 colonist on a colony tile (%STRING0 = colony
name, advisor 5); T3 pioneer on a ≥5-resource site (%STRING0 = signature
good, advisor 3); T8 petty-criminal/servant near a training village
(advisor 5); T9 pioneer on unroaded forest/hills near colony (advisor 3);
T10 pioneer on plowable/clearable colony ring (advisor 3); T19 Indian
convert (advisor 4).

### Event-driven tutorials
| # | site | trigger | advisor |
|---|---|---|---|
| T2 | @0x020F43 | land discovered (tail of `func_020EFE`; no once-flag) | 0 |
| T16 | @0x0286F6 | colony food deficit (red-X corn counters `[0x8E32]/[0x8E5A]`) | — |
| T7 | @0x028D36 | colony pop ≥3 and no stockade | 1 |
| T4 | @0x02C73F | colony open: better job available from terrain ring (%STRING0/1 = current/alternative goods) | 5 |
| T12 | @0x02C7B1 | colony open with a ship at the tile (%STRING0 = colony name) | 5 |
| T6 | @0x02EA41 | goods ready for export at end of turn (%NUMBER0 qty, %STRING0..2 goods/colony/port) | 0 |
| T18 | @0x032760 | Europe buy: can't afford 100 units (**ungated** — no hints bit, no once-flag) | — |
| T17 | @0x035C22 | Europe screen first open | — |
| T5 | @0x036514 | religious-unrest immigration (chained after `@UNREST`, advisor 4) | 0 |

## 2. Hot-seat multiplayer (`@MULTI/@MULTINEXT/@MULTIREV`) — B, **LIVE**

- **Unlock**: `getenv("COLONIZE") == "MULTI"` (`SET COLONIZE=MULTI`) →
  `[0x201E]=1` @0x070EDD–0x070EFB (also a CLI switch @0x070D0E). Adds a 5th
  game-start menu entry (mode 4) @0x070B9F.
- **`@MULTI`** (new-game setup `func_07431E` @0x074531): checkbox dialog —
  each checked power becomes human (`[0x543F+p·0x34]=0`, read from the
  dialog bitmask `[0x1F54]`); >1 humans → **hot-seat flag `[0x5381]|=0x80`**
  @0x0745D5; none → England.
- **`@MULTINEXT`** (turn loop @0x00597C): between human turns the screen is
  blanked, %STRING0 = next nation, "Press any key for {%STRING0} player's
  turn." (advisor 2); then view power switches and re-centers.
- **`@MULTIREV`** (`func_03E984` @0x03E9C5): declaring independence in
  hot-seat warns (advisor 1) and, if confirmed, **clears the multiplayer
  flag** (`and [0x5381],0x7F` @0x03E9D3) — the game continues single-player,
  exactly as the text warns.
- Other consumers of `[0x5381]&0x80`: rebel sentiment clamped to 75%
  (@0x02391C region — auto-revolution suppressed); the War-of-Succession
  merge `func_03C638` is skipped (@0x03C63D).

## 3. Open items (exact trace sites)
1. `0x181F:0x768` (→0x0062B4) semantics (T13/T14 gate).
2. `0x181F:0x614`/`[0x8DB8]` (T9/T10 gate) — `func_0083F2`.
3. `0x181F:0xA38` attitude bit 0x20 (T8) — `func_007F34` bit naming.
4. T15/T6 colony-record base convention (0x5D48+idx·0xCA vs `*(0x8542)`)
   — anchor-map cross-check.
5. `[0x53A6]`/`[0x53A2]` roles in the combat gates (see combat_analysis.md).
