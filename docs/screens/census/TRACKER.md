# Screen census — coverage tracker

The systematic answer to "how do you test it is fully working like the
original": every distinct UI state gets a reference capture from the REAL
game under DOSBox (`tools/dosbox_harness`), a port render posed in the same
state (`port/tools/shots.py` census scenarios), and a `render_diff.py` pair.
A state is only "tested against the original" when it appears here as
PAIRED. Anything not in this file has NO pixel oracle — the port is only as
good as the spec reading behind it.

Capture session 1 (2026-08-08, the 1653 Dutch save at load + one turn):

## Paired (capture + port scenario + render_diff gate)

| state | capture | found & fixed |
|---|---|---|
| GAME pulldown | census_menu_game.png | group separators; DECLARE INDEPENDENCE caps |
| VIEW pulldown | census_menu_view.png | separators; groups |
| ORDERS pulldown (ship) | census_menu_orders.png | context row HIDING (no Build Colony for ships), DIMMING (Load Cargo away from port, Return to Europe off the sea lane), the one Clear/Plow row, separators |
| REPORTS pulldown | census_menu_reports.png | separators/groups |
| TRADE pulldown | census_menu_trade.png | (matched) |
| Go To picker (ship) | census_goto_ship.png | Europe row FIRST as "Amsterdam (Netherlands)"; 10-row pages + (More) |
| Europe RECRUIT | census_euro_recruit.png | "(None)" head row; no per-row price; (F1 for Help) footer |
| Europe TRAIN | census_euro_train.png | @SMALLFONT renders small (overturns the no-switch ruling); "None" head; "(Cost: N)" format; footer |

## Captured, reference-only (not deterministically posable yet)

| state | capture | note |
|---|---|---|
| ORDERS pulldown (wagon) | census_menu_orders_wagon.png | drove the land-unit gating rules |
| Go To picker (land) | census_goto_land.png | land-mass filter confirmed; the port's REGION plane keeps Vlissingen where the engine drops it — OPEN divergence |
| combat bulletin | census_combat_bulletin.png | pinned military speaker = MSS0 (was MSS5 — swapped with the colony family) |
| ship-evade bulletin | census_turnevent_0.png | MSS0, left anchor |
| tools-shortage ask | census_turnevent_2/5.png | MSS5 + "Continue turn./Zoom to colony." rows — implemented (askZoom) |
| warehouse-cap ask | census_turnevent_3.png | same rows |
| cargo-ready ask | census_cargoready.png | same rows |
| foreign-colony refusal | census_noentry.png | @TRADEATWAR body |
| load picker + loaded popup | census_loadpick / census_map0.png | boot flow references |
| Europe harbour | census_europe.png | reference |
| PURCHASE menu | census_euro_purchase.png | reference |

## Open divergences (seen, not yet fixed)

- Land Go-To reachability: the port lists Vlissingen where the engine's
  region test excludes it — the REGION plane's connectivity differs from
  func_05FEF4's.
- The map viewport auto-centring differs by a small offset from the
  engine's (the census pairs' residual floor).
- The advisor figure's left/right anchor varies per popup in the engine
  (runtime cel state); the port uses fixed per-family anchors.
- Turn-status caption on the top bar during turn processing ("Dutch Galleon
  Inbound From Amsterdam") — not implemented.

## Not yet captured (next sessions)

Colony popups (build picker / jobs / occupation) · village menu + chief ·
King tax demand + tea party · woodcuts · combat panel · options dialogs ·
Colonizopedia pages · trade-route editor · Find Colony · Zoom levels ·
declaration + war screens · Hall of Fame (crafted-DAT pair exists).
