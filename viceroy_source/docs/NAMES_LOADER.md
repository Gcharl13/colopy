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

## 3. ~~Remaining inner~~ CLOSED (2026-06-09)

`func_07637F` is a 5-byte TRAMPOLINE (`EA 20 0D 1F 1A` = `jmp far 0x1A1F:0xD20`)
whose real body is **file 0x745F0** = `func_0745F0_terrain_row_load`
(overlay_0745F0_077A6A.c — role corrected from "power_record_field_init"; the
0x191F:0x91C/0x1A1F:0xB22/0x1A1F:0x88A calls are this section-read API, not
"random bytes").  The prior "file 0x72DB0" attribution came from the AMBIG
seg-26 fingerprint (0x72DB0 is a text-layout routine) and is WITHDRAWN.

Call sites (all `push k; push cs; call 0x7637F`): UNFORESTED k=i @asm 0x074A38,
FORESTED k=i+8 @asm 0x074A61 (the just-loaded row is then REP-MOVSW copied to
row k+8: @asm 0x074A6D..0x074A7C `lea di,[bx+0x3074]; lea si,[bx+0x2FF4]`,
rows 16..23 = byte-copies of 8..15), OTHER k=i+0x18 @asm 0x074AA1.

**Terrain stat row @ DS:0x2F74 + k*0x10 (BYTE_VERIFIED):**

| off | size | field | cite |
|---|---|---|---|
| +0x00 | word | name ptr (interned) | @asm 0x074607 |
| +0x02 | byte | Movement (= the `type*16 + DS:0x2F76` cost read) | @asm 0x074612 |
| +0x03 | byte | Defensive | @asm 0x07461B |
| +0x04 | byte | Improvement | @asm 0x074624 |
| +0x05 | byte | Value | @asm 0x07462D |
| +0x06 | byte | derived max(cargo_weight×yield), filled later over all 29 rows | @asm 0x074EAD |
| +0x07..+0x0F | 9 bytes | yields: Farmer, Planter(s/t/c), Trapper, Lumberjack, Ore Miner, Silver Miner, Fisherman (= the yield table @0x2F7B stride 0x10) | @asm 0x07463D |

Modern loader: `src/runtime/data_load.c` `load_terrain()` mirrors this exactly.

## 4. Correction it forces (see REPORTS.md §13)

func_0749E0 loads **NAMES.TXT name tables only** — it does NOT fill the F-key
report label-pointer slots `[DS:0x2DE0..0x2F5C]`. It reaches `DS:0x2DB0`
(OTHER_NAMES, 5 words) and stops; the report-label region begins above that and
is filled by a **different** loader (a LABELS.TXT-style section loader, still
unidentified — `func_06AF1C`, the only "MISC"-string referencer, is a *message
renderer* that draws a @MISC-keyed line + OK button, not the bulk loader).
`REPORTS.md` §13 #1's attribution to func_0749E0 is therefore corrected.
