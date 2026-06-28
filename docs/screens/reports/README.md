# Advisor reports (F1–F10) — live capture gallery

Captured 2026-06-25 by driving the live game to an in-game state (England, Spring 1498, one
Caravel at sea, no colonies yet) and opening each report from the `REPORTS` pulldown
(`tools/drive_game.sh`). This is visual ground-truth for the advisor-report subsystem
(`docs/ADVISOR_REPORTS_AUDIT.md`; renderer `func_037958`, located in Track 2b). At turn 1 with
no colonies several reports are sparse, but every report's **screen layout, title, and column
structure** is confirmed, and the data-rich ones (Economic, Foreign Affairs, Score) confirm
live field values.

The `REPORTS` menu order (visually confirmed, `08`-style pulldown): F1 Terrain Information,
F2 Religious, F3 Continental Congress, F4 Labor, F5 Economic, F6 Colony, F7 Naval, F8 Foreign
Affairs, F9 Indian, F10 Colonization Score.

| File | Report | What it confirms |
|------|--------|------------------|
| `F1_terrain_colonopedia.png` | Terrain Information | Opens the **Colonopedia** popup for the current tile — here "Sea Lane" (confirms the base terrain label, CLAUDE.md hard rule 2). |
| `F2_religious.png` | Religious Adviser | Report screen + title art (sparse — no immigration pool yet). |
| `F3_continental_congress.png` | Continental Congress | The founding-fathers screen (the Continental Congress assembly). |
| `F4_labor.png` | Labor Adviser | Sparse (no colonies → no labor breakdown; returns to map). |
| `F5_economic.png` | **Economic Adviser** | "European Trade" table: columns **Tons / Gold / Bid Price / Ask Price** × 16 commodities, with live prices (Food 0/8, Sugar 5/7, Silver 19/20, Rum 9/10, Muskets 2/3, …) + OK button. Confirms the market bid/ask model (`market.md`). A second page "Cargo in Port" pages via F-key (multi-page report). |
| `F6_colony.png` | Colony Adviser | Report screen (sparse — no colonies). |
| `F7_naval.png` | Naval Adviser | Sparse (one ship; returns to map). |
| `F8_foreign_affairs.png` | **Foreign Affairs** | Per-power blocks for all 4 European leaders — **Walter Raleigh (English), Jacques Cartier (French), Christopher Columbus (Spanish), Michiel De Ruyter (Dutch)** — each with **Rebels / Tories** sentiment counts (confirms leader names + the rebel-sentiment system, `revolution.md`). |
| `F9_indian.png` | Indian Adviser | Report screen + warrior art (sparse — no tribes contacted). |
| `F10_score.png` | **Colonization Score** | `func_03A9C0`: "Discoverer Walter Raleigh of the English: Spring 1498", breakdown **English Citizens +6, Continental Congress +0, Gold (1000e) +1, Total Score: 7** (confirms the scoring terms, `scoring.md`). |

## Notes
- Reports close via the **OK** button (bottom-right) or paging keys — **not** Esc (Esc quits to
  DOS from the map). Within a report, an F-key pages that report's sub-views (e.g. Economic
  "European Trade" → "Cargo in Port"), it does not switch to a different report.
- Memory snapshots were taken with the ORDERS menu and the Economic report open
  (`ingame_orders.bin`, `rep_economic.bin` — regenerable, not committed) for field-value RE.
