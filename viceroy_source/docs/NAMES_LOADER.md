# func_0749E0 — NAMES.TXT data-table loader (decoded 2026-05-31)

Byte-traced from `reverse_engineered/code/VICEROY/disasm/func_0749E0_unknown.asm`
(file 0x0749E0..0x074C39, 601 bytes) via the 0x191F/0x1A1F resolver. This was a
`NEXT_TARGETS.md` Group-A `not yet decoded-inner` item; the outer section dispatch is now
fully mapped (only the orphan sub-loader `func_07637F` remains inner — see §3).

## 1. Mechanism

Per NAMES.TXT section, a fixed 3-call idiom (the "section-read API", all in
overlay page 0x1A, code base file 0x72090):

| thunk | role | cite |
|---|---|---|
| `0x191F:0x928` | **select section** `<tag>` (first call also passes file "NAMES") | @asm 0x0749F9 |
| `0x191F:0x91C` | **next entry** → ptr in ax | @asm 0x074A06 |
| `0x1A1F:0xB22` | **intern/dup** entry string → stored ptr in ax | @asm 0x074A0B |
| `0x1A1F:0xB16` | intern variant (NATIONALITY/ABBREV/HOMEPORT) | @asm 0x074B64 |
| `0x1A1F:0x88A` | per-entry attribute byte → al | @asm 0x074B03 |
| `0x191F:0xFC4` | leader-name variant | @asm 0x074C17 |
| `0xD1D:0x117E` | strcpy entry → record field (stride-0x34 records) | @asm 0x074BEF |

Store idiom: `bx = i; shl bx,1; MOV [bx + <DS_base>], ax` (word-ptr table), or
`IMUL ax,i,0x34; ADD ax,<rec_base>` + strcpy for the stride-0x34 records.

## 2. Section → DGROUP base map (byte-verified)

| order | section | count | DGROUP destination | cite |
|---|---|---|---|---|
| 1 | SEASONS (+NAMES file open) | 2 | word table @ **DS:0x9800** | @asm 0x074A15 |
| 2 | UNFORESTED | 8 | via `func_07637F(i)` (not yet decoded-inner) | @asm 0x074A38 |
| 3 | FORESTED | 8 | REP MOVSW 8 words **0x2FF4→0x3074** (i*16) | @asm 0x074A7C |
| 4 | OTHER | 5 | via `func_07637F(i+0x18)` (not yet decoded-inner) | @asm 0x074AA1 |
| 5 | **OTHER_NAMES** | 5 | word table @ **DS:0x2DB0** | @asm 0x074AD1 |
| 6 | RESOURCE | 14 | words @ **DS:0x930C** + attr byte @ **DS:0x97B2** | @asm 0x074AFF / 0x074B0B |
| 7 | COUNTRY | 4 | words @ **DS:0x8D42** + attr byte @ **DS:0x0848** | @asm 0x074B39 / 0x074B45 |
| 8 | NATIONALITY | 4 | words @ **DS:0x8D0A** | @asm 0x074B6E |
| 9 | NATIONABBREV | 4 | words @ **DS:0x97F0** | @asm 0x074B97 |
| 10 | HOMEPORT | 4 | words @ **DS:0x838C** | @asm 0x074BC0 |
| 11 | COLONYNAME | 4 | strcpy → **PowerRecord 0x5426** (stride 0x34) | @asm 0x074BEA |
| 12 | LEADERNAME | 4 | strcpy → **AIPersonality 0x540E** (stride 0x34) | @asm 0x074C22 |

Cross-references closed: COUNTRY's attr byte lands at **DS:0x848** = the terrain
palette/icon table the F1 Terrain report reads (`REPORTS.md` §4 `[bx+0x848]`);
COLONYNAME/LEADERNAME confirm the **PowerRecord @0x5426 / AIPersonality @0x540E**
stride-0x34 layout (`DATA_MODEL.md`, `project_powerrecord_layout`).

## 3. Remaining inner (narrowed)

`func_07637F` (an orphan near-call in `orphans_overlay.asm`, called for
UNFORESTED `i` and OTHER `i+0x18`) is the per-terrain-name entry sub-loader; its
exact store target + its `0x1A1F:0xD20` (file 0x72DB0) helper are the last
`not yet decoded-inner` for func_0749E0. Everything else above is byte-verified.

## 4. Correction it forces (see REPORTS.md §13)

func_0749E0 loads **NAMES.TXT name tables only** — it does NOT fill the F-key
report label-pointer slots `[DS:0x2DE0..0x2F5C]`. It reaches `DS:0x2DB0`
(OTHER_NAMES, 5 words) and stops; the report-label region begins above that and
is filled by a **different** loader (a LABELS.TXT-style section loader, still
unidentified — `func_06AF1C`, the only "MISC"-string referencer, is a *message
renderer* that draws a @MISC-keyed line + OK button, not the bulk loader).
`REPORTS.md` §13 #1's attribution to func_0749E0 is therefore corrected.
