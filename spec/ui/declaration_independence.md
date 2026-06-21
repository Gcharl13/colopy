# Declaration of Independence Screen

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.
> Complete: asset attribution & cinematic split **B**; signature glyph layout **B** (pen seed +
> per-glyph advance byte-verified inline in `func_03DA2A`, §2). DECLARAT.PIK is an **orphan** (the
> engine draws DECOIND.PIK). **No open questions remain** (§6).

**Overall confidence:** asset attribution & cinematic split **B** (byte-cited via paint funcs); signature glyph layout **B** (byte-verified inline, §2). · **Canonical primary:** `docs/KING_AND_CINEMATIC_AUDIT.md` §5, `docs/SESSION_UI_CATALOG.md` (Declaration sprites), `data_extracted/text/GAME_sections.json`.

## 1. Purpose
The post-revolution signing screen shown when the player declares independence. A parchment Declaration document is displayed and the player's leader signature is composed glyph-by-glyph from cursive letter sprites. Two distinct PIKs cover two moments: a celebratory signing scene and the printed document itself. **B** (`KING_AND_CINEMATIC_AUDIT.md` §5). The event never fired in the recorded session, but the signature **pixel layout is byte-verified inline** in `func_03DA2A` (§2), so it is **not** TBD.

## 2. Layout — "what is drawn where"
No frame capture exists (event never fired in session), but the layout is **byte-cited from the paint funcs** (the signature geometry is fully resolved inline — see below):

| Element | Source | Tier | Notes |
|---------|--------|------|-------|
| Document background | DECLARAT.PIK (printed "We the People…" baked in) OR DECOIND.PIK (signing scene) | B | two distinct PIKs/funcs — see §3 |
| Leader signature | DEC-UPP\*/DEC-LOW\*.SS cursive letter sprites | B | composed per-letter from player leader name |
| Signature seed | DGROUP player-name table at 0x540E + player_idx*0x34 | B | `func_03DA2A` reads leader name (`KING_AND_CINEMATIC_AUDIT.md` §5) |

`DECOIND.PIK` paint = `func_03DA2A` (file 0x03DA2A..0x03DB04). Raw disasm (re-verified
2026-06-21 via `KING_AND_CINEMATIC_AUDIT.md` §5): `03DA47 push "DECOIND" → load_PIK_fullscreen`;
`03DA59 lcall 0x181F:0x3B6` present; `03DAB4 imul ax,[0x5398],0x34; 03DAB9 add ax,0x540E;
03DAC1 strcpy(local,name)` — the leader-name read matches `0x540E + [0x5398]*0x34` exactly;
then the signature is composed glyph-by-glyph from DEC-UPP\*/DEC-LOW\*/DEC-SQIG cursive sprites.
**Signature layout — now BYTE_VERIFIED (B, 2026-06-21; the pen geometry is INLINE in
`func_03DA2A`, not overlay-thunked):**
- pen seed **(x=0x94=148, y=0x7E=126)** — `mov [bp-0x4FE],0x94` `@0x3DC42`, `mov [bp-0x1FC],0x7E`
  `@0x3DC3C`;
- per-glyph **primary advance** adds the glyph width `es:[sprite+0x4A]` to the **y axis**
  `[bp-0x1FC]` (`@0x3DDD9`); **cross advance** adds a small kern **{−1,−2,−3,−4}** (by glyph
  class) to the **x axis** `[bp-0x4FE]` (`@0x3DDE0`);
- the run **ends when `[bp-0x1FC] ≥ 0xDC (220)`** (`cmp @0x3DE04`);
- each glyph is a single sprite blit `0x181F:0x254` at `(x,y)=([bp-0x4FE],[bp-0x1FC])`.
- **No text color** — the signature is pure sprite blits (each `DEC-*.SS` carries its own
  palette); there is no `vid_text_color`/color push in `func_03DA2A`. The only runtime input is
  the leader-name string at `0x540E+[0x5398]*0x34`. DECOIND.PIK background fills (0,0,320,200).

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

1. ✅ **Signature glyph (x,y)/advance — CLOSED 2026-06-21 (B).** Pen seed (0x94,0x7E); per-glyph
   y-advance = glyph width `es:[sprite+0x4A]`, x-advance = kern {−1..−4} by class; ends at
   y≥0xDC; glyph blit `0x181F:0x254` (§2). The layout is **inline** in `func_03DA2A` — the
   earlier "overlay_call_191F_0ED0 hides it / runtime-capture needed" framing was wrong. The
   only runtime input is the leader name string. **No open questions remain** (DECLARAT orphan,
   DECOIND used, signature geometry byte-verified).
