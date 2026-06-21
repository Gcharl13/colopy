# Declaration of Independence Screen

> **Layer 2 — UI Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** asset attribution & cinematic split **B** (byte-cited via paint funcs); pixel layout **TBD** (not observed in session). · **Canonical primary:** `docs/KING_AND_CINEMATIC_AUDIT.md` §5, `docs/SESSION_UI_CATALOG.md` (Declaration sprites), `data_extracted/text/GAME_sections.json`.

## 1. Purpose
The post-revolution signing screen shown when the player declares independence. A parchment Declaration document is displayed and the player's leader signature is composed glyph-by-glyph from cursive letter sprites. Two distinct PIKs cover two moments: a celebratory signing scene and the printed document itself. **B** (`KING_AND_CINEMATIC_AUDIT.md` §5). Not triggered in the recorded session (pre-revolution), so pixel layout is **TBD**.

## 2. Layout — "what is drawn where"
No frame capture exists (event never fired in session) → geometry **TBD**. Known structure (byte-cited from paint funcs):

| Element | Source | Tier | Notes |
|---------|--------|------|-------|
| Document background | DECLARAT.PIK (printed "We the People…" baked in) OR DECOIND.PIK (signing scene) | B | two distinct PIKs/funcs — see §3 |
| Leader signature | DEC-UPP\*/DEC-LOW\*.SS cursive letter sprites | B | composed per-letter from player leader name |
| Signature seed | DGROUP player-name table at 0x540E + player_idx*0x34 | B | `func_03DA2A` reads leader name (`KING_AND_CINEMATIC_AUDIT.md` §5) |

`DECOIND.PIK` paint = `func_03DA2A` (file 0x03DA2A..0x03DB04). Raw disasm (re-verified
2026-06-21 via `KING_AND_CINEMATIC_AUDIT.md` §5): `03DA47 push "DECOIND" → load_PIK_fullscreen`;
`03DA59 lcall 0x181F:0x3B6` present; `03DAB4 imul ax,[0x5398],0x34; 03DAB9 add ax,0x540E;
03DAC1 strcpy(local,name)` — the leader-name read matches `0x540E + [0x5398]*0x34` exactly;
then the signature is composed glyph-by-glyph from DEC-UPP\*/DEC-LOW\* cursive sprites. **B**.
> Note: the Ghidra C export of this function is **overlay-thunked** (the name read sits inside
> `overlay_call_191F_0ED0`, not inline) — so the **audit-doc raw disasm is the load-bearing
> source**, not the C export. The export-side signature pen origin (`pen_x=0x94`, `pen_y=0x7E`)
> is **R** (export reconstruction, not raw-cited). Per-glyph (x,y)/line stride **TBD**.

## 3. Assets & text
- **DECOIND.PIK** — celebratory document-signing scene (Founding Fathers around the document). Painted by `func_03DA2A`. **B**
- **DECLARAT.PIK — ORPHAN ASSET (RESOLVED 2026-06-21, negative).** The string `"DECLARAT"` is
  **absent from VICEROY.EXE, OPENING.EXE, CLOSING.EXE and COLONIZE.EXE** (verified) — no code
  path loads it (analogous to TERRAIN.SS/BDARK.SS per CLAUDE.md hard rule #5). The parchment the
  engine actually draws is **DECOIND.PIK**, loaded by `func_03DA2A` via the PIK loader
  `func_076B9E` (thunk `0x181F:0x44E`; basename ptr DGROUP `0x12E8` = "DECOIND", `.PIK` appended
  in code). So there is no "DECLARAT loader" to find — the residual is closed as a negative.
  *(Any tool that names DECLARAT.PIK as the Declaration background is wrong; it's DECOIND.PIK.)*
  **B.**
- **DEC-UPPA..Z + DEC-LOWA..Z (+ DEC-SQIG)** = 52–53 cursive letter sprites for the signature/Declaration text (`SESSION_UI_CATALOG.md` "Declaration of Independence letter sprites"; CLAUDE.md / SPRITE_CATALOG ruling). **B**
- **Text keys** present in `data_extracted/text/GAME_sections.json` (verified as keys; bodies are section markers / driven by overlay): `@DECLARE`, `@INDEPENDENCE`, `@PICKINDEPENDENCE`, `@DECLAREWAR`. The declare-independence menu item is in MENU `@GAME` ("DECLARE INDEPENDENCE", verified). **B**
- Note: the King's mocking response to declaration is `@KINGLAUGH` ("Ha ha ha ha…", verified in GAME) — a separate King-audience popup, not this screen. **B**

## 4. Interactions
- Triggered from GAME menu → "DECLARE INDEPENDENCE" (MENU `@GAME`, verified) → `@PICKINDEPENDENCE` confirmation → Declaration cinematic. **B**
- Final OK / continue to dismiss (per cinematic convention). **R**

## 5. Evidence
- `docs/KING_AND_CINEMATIC_AUDIT.md` §5 — DECOIND vs DECLARAT distinction, `func_03DA2A` byte trace, DEC-\* letter sprites, signature seed at 0x540E. **B**
- `docs/SESSION_UI_CATALOG.md` — Declaration letter sprites (52–53), DECLARAT/DECOIND PIK identification. **B**
- `docs/UI_DIALOGS.md` — "Independence declaration" row: `func_03DE46` + `func_03E984` guard, DECLARAT.PIK + DEC-LOW*/UPP*. **B**
- `data_extracted/text/{GAME,MENU}_sections.json` — `@DECLARE`, `@INDEPENDENCE`, `@PICKINDEPENDENCE`, `@DECLAREWAR`, MENU `@GAME` "DECLARE INDEPENDENCE" (all verified as keys). **B**

## 6. Open questions (TBD)
*(Resolved 2026-06-21: DECLARAT.PIK is an **orphan** never loaded — the engine uses DECOIND.PIK
(`func_03DA2A` → `func_076B9E`), so items 2 and 4 are moot. `@DECLARE`/`@INDEPENDENCE` "empty"
bodies are the same `GAME_sections.json` extraction defect seen across the UI specs — present in
`raw/COLONIZE/GAME.TXT`.)*

1. **Signature glyph (x,y)/line-stride** — the pen origin (export-side `pen_x=0x94`/`pen_y=0x7E`)
   is computed in the signature loop of `func_03DA2A` (and its `overlay_call_191F_0ED0` helper).
   It is **findable by disassembling that loop** — *not* "runtime-only"; the earlier
   "would need a runtime capture" framing was wrong (the layout is in code, the only runtime
   input is the leader's *name string* `0x540E+[0x5398]*0x34`, which is game data). **R→findable.**
