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

`DECOIND.PIK` paint = `func_03DA2A` (file 0x03DA2A..0x03DB04); it loads the background, present-buffers, then strcpy's the player leader name from `0x540E + [0x5398]*0x34` and renders the signature via the DEC-\* letter sprites. **B** Exact (x,y) per glyph/line **TBD** (the document-body layout uses GAME.TXT `@x`/`@y`/`@width` directives — not captured here).

## 3. Assets & text
- **DECOIND.PIK** — celebratory document-signing scene (Founding Fathers around the document). Painted by `func_03DA2A`. **B**
- **DECLARAT.PIK** — the printed parchment document (static body text baked in); used as backdrop for the signature overlay. No code xref found by string search in extracted VICEROY disasm (likely overlay-loaded). **B (asset) / TBD (loader)**
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
1. No native frame capture — all pixel coordinates TBD.
2. DECLARAT.PIK loader function offset not located (likely overlay).
3. Signature glyph layout (x,y, line stride, spacing) using DEC-\* sprites.
4. Which PIK shows first (DECOIND signing scene vs DECLARAT document) in the sequence, and transition.
5. `@DECLARE`/`@INDEPENDENCE` body text is empty in the extracted section dump — confirm whether bodies live in a different file or are overlay-composed.
