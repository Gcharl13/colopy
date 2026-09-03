# Declaration of Independence Screen

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Complete: asset attribution & cinematic split **B**; signature glyph layout **B** (pen seed +
> per-glyph advance byte-verified inline in `func_03DA2A`, §2). DECLARAT.PIK is an **orphan** (the
> engine draws DECOIND.PIK). **No open questions remain** (§6).

**Overall confidence:** asset attribution & cinematic split **B** (byte-cited via paint funcs); signature glyph layout **B** (byte-verified inline, §2). · **Canonical primary:** `docs/KING_AND_CINEMATIC_AUDIT.md` §5, `docs/SESSION_UI_CATALOG.md` (Declaration sprites), `data_extracted/text/GAME_sections.json`.

## 1. Purpose
The post-revolution signing screen shown when the player declares independence. A parchment Declaration document is displayed and the player's leader signature is composed glyph-by-glyph from cursive letter sprites. Two distinct PIKs cover two moments: a celebratory signing scene and the printed document itself. **B** (`KING_AND_CINEMATIC_AUDIT.md` §5). The event never fired in the recorded session, yet no value here is unresolved: the signature **pixel layout is byte-verified inline** in `func_03DA2A` (§2) — pen seed (x=0x94, y=0x7E) at `mov [bp-0x4fe],0x94 @0x3DC42` / `mov [bp-0x1fc],0x7e @0x3DC3C`, advance `add [bp-0x1fc],ax @0x3DDD9` / `add [bp-0x4fe],ax @0x3DDE0`, end-test `cmp [bp-0x1fc],0xdc @0x3DE04` (all re-confirmed by capstone over `raw/COLONIZE/VICEROY.EXE`).

## 2. Layout — "what is drawn where"
No frame capture exists (event never fired in session), but the layout is **byte-cited from the paint funcs** (the signature geometry is fully resolved inline — see below):

| Element | Source | Tier | Notes |
|---------|--------|------|-------|
| Document background | DECLARAT.PIK (printed "We the People…" baked in) OR DECOIND.PIK (signing scene) | B | two distinct PIKs/funcs — see §3 |
| Leader signature | DEC-UPP\*/DEC-LOW\*.SS cursive letter sprites | B | composed per-letter from player leader name |
| Signature seed | DGROUP player-name table at 0x540E + player_idx*0x34 | B | `func_03DA2A` reads leader name (`KING_AND_CINEMATIC_AUDIT.md` §5) |

`DECOIND.PIK` paint = `func_03DA2A` (file 0x03DA2A..0x3DE44, terminal RETF; 324 insns). NOTE: the committed per-function disasm `code/VICEROY/disasm/func_03DA2A_unknown.asm` truncates at 0x3DB04 (stray `DB 0xEB`); the **full** body — including every §2 offset below (0x3DC3C/0x3DC42 pen seed, 0x3DDD9/0x3DDE0 advance, 0x3DE04 end-test) — is in `code/VICEROY/disasm_overlay_reseg/page_06.asm` (func_03DA2A, size=1051) and was re-confirmed by capstone over `raw/COLONIZE/VICEROY.EXE[0x3DA2A:0x3DE45]`. Raw disasm (re-verified
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
- During the signature typewriter, a keypress skips the per-glyph animation: the paint loop polls `kbhit` (func_00D272 `lcall 0x181F:0xF6` @0x3DD7A) and, if a key is pending, consumes it with `getch` (func_00D286 `lcall 0x181F:0x3E0` @0x3DD83) and sets the skip flag `[bp-0x51A]=1` (@0x3DD88); that flag zeroes `dx` (`cmp [bp-0x51A],1; sbb dx,dx; neg dx` @0x3DD8E) so the per-glyph tick delay func_00D1CA (`lcall 0x181F:0x45C` @0x3DD99) returns immediately, drawing the rest of the signature instantly. Each glyph otherwise waits a class-based delay of 0xA or 7 ticks (`mov [bp-0x51E],0xA/7` @0x3DC96/0x3DCCB/0x3DCF2). **B** (func_03DA2A-continuation @0x3DD7A–0x3DD99)
- Screen teardown after the signature: `func_03DA2A` does **not** block on a final key-wait. Once `[bp-0x1fc] ≥ 0xDC` the glyph loop falls through to the exit block @0x3DE12–0x3DE3D (palette/restore lcalls `0x191F:0AAC→func_076594`, `0x181F:03C0→func_004A80(ESC)`, `0x181F:03B6→func_0049FC`, screen-rect blit `0x181F:03F4→func_00D1E4`, flag write `[0x372]` from `[0x5383]` bit-8), then a final screen-present `lcall 0x181F:056A→func_00C0D0` (@0x3DE3D) and `retf` @0x3DE44 — verified by capstone over `raw/COLONIZE/VICEROY.EXE[0x3DE04:0x3DE45]` and in `code/VICEROY/disasm_overlay_reseg/page_06.asm` (func_03DA2A, terminal RETF @0x3DE44). The within-screen skip-key is the §4 kbhit/getch poll; there is **no separate final-OK key-wait inside `func_03DA2A`**. The adjacent `func_03DE46` (file 0x3DE46, ENTER 0x324 right after the 0x3DE45 NOP pad) is the Independence **event-resolution** handler (gold transfer `0x181F:0A06→func_007F96`, sidebar `0x181F:0E1C→func_067700`, percentage math on `[0x538a]÷100→[0x53a7]/[0x53a8]`) — it is **not** the paint-caller of `func_03DA2A` and contains no dismiss key-wait. `func_03DA2A` has **no static caller anywhere in the disassembled corpus** — this is now byte-verified, not a pending lookup: (a) it is classified `"func_03DA2A": "orphan"` in `code/VICEROY/flat/roles.json` (line 100); (b) a full call-graph scan of `code/VICEROY/flat/functions.jsonl` returns **zero** functions that call it; (c) **no** entry in `code/VICEROY/flat/thunk_resolve.json` targets its page-6 local offset 0x26AA — all ten registered page-6 overlay-dispatch thunks point elsewhere (`191F:0312→func_03E984`, `191F:0348→func_03D948`, `191F:0356→func_03DE46`, `191F:0364→func_03C638`, `191F:09F8→func_03C322`, `191F:0A66→func_03E844`, `191F:0F66→func_03C282`, `191F:0F74→func_03BB4A`, `1A1F:00D2/00E0→func_03C932`); (d) `page_06.asm` contains **no** near `call 0x26AA` and the entire `disasm_overlay_reseg` corpus contains **no** far `lcall`/`ljmp` to offset 0x26AA. The turn-event dispatcher `func_0235D6` (region `overlay`/`load_image`) reaches the declaration handlers only via `191F:0312→func_03E984` and `191F:0356→func_03DE46`, and neither handler (nor any other page-6 function) calls the paint `func_03DA2A` or contains a post-screen dismiss key-wait beyond §4's in-screen kbhit/getch poll. **B** for the teardown chain AND for the negative caller finding (`roles.json` orphan + exhaustive thunk/near-call/far-ref scan). The signing screen's paint+dismiss must therefore be wired through an indirect/data-table dispatch that exists only at runtime (absent from every static call path); pinning that exact site is the sole residual and **requires a live DOSBox capture of the Independence event firing** — there is no further static byte to decode.

## 5. Evidence
- `docs/KING_AND_CINEMATIC_AUDIT.md` §5 — DECOIND vs DECLARAT distinction, `func_03DA2A` byte trace, DEC-\* letter sprites, signature seed at 0x540E. **B**
- `docs/SESSION_UI_CATALOG.md` — Declaration letter sprites (52–53), DECLARAT/DECOIND PIK identification. **B**
- `docs/UI_DIALOGS.md` — "Independence declaration" row: `func_03DE46` + `func_03E984` guard, DECLARAT.PIK + DEC-LOW*/UPP*. **B**
- `data_extracted/text/{GAME,MENU}_sections.json` — `@DECLARE`, `@INDEPENDENCE`, `@PICKINDEPENDENCE`, `@DECLAREWAR`, MENU `@GAME` "DECLARE INDEPENDENCE" (all verified as keys). **B**

## 6. Open questions
*(Resolved 2026-06-21: DECLARAT.PIK is an **orphan** never loaded — the engine uses DECOIND.PIK
(`func_03DA2A` → `func_076B9E`), so items 2 and 4 are moot. `@DECLARE`/`@INDEPENDENCE` bodies are
now **present in `data_extracted/text/GAME_sections.json`** (the extractor was fixed — see
`popups.md` §Open-questions).)*

1. ✅ **Signature glyph (x,y)/advance — CLOSED 2026-06-21 (B).** Pen seed (0x94,0x7E); per-glyph
   y-advance = glyph width `es:[sprite+0x4A]`, x-advance = kern {−1..−4} by class; ends at
   y≥0xDC; glyph blit `0x181F:0x254` (§2). The layout is **inline** in `func_03DA2A` — the
   earlier "overlay_call_191F_0ED0 hides it / runtime-capture needed" framing was wrong. The
   only runtime input is the leader name string. **No open questions remain** (DECLARAT orphan,
   DECOIND used, signature geometry byte-verified).

## 7. Amendment 2026-09-02 — axes corrected, cadence resolved, ported (screens track)

Re-read of `func_03DA2A` @0x03DA2A..0x3DE44 against the blit verb `func_00E76A`
(`0x181F:0x254`) — RULINGS 2026-09-02w. **Supersedes §1/§2's axis reading and §4's
"no final key-wait".**

- **Axes.** `0x181F:0x254` takes **x in `dx`** (clipped against the surface width
  @0xE7E2..0xE7FC) and **y on the stack** (`[bp+6]`, clipped against the height
  @0xE833..0xE848). The loop passes `dx = [bp-0x1FC]` @0x3DD36 and pushes `[bp-0x4FE]`
  @0x3DD2C. So the pen seed is **x = 0x7E = 126** (@0x3DC3C), **y = 0x94 = 148** (@0x3DC42);
  the glyph's descriptor-0 width (`es:[bx+0x4A]` @0x3DD16) advances **x** (@0x3DDD9); the
  class delta moves **y** (@0x3DDE0); the run ends when **x ≥ 0xDC = 220** (@0x3DE04), which
  forces one squiggle before stopping.
- **Text.** Leader name from `0x540E + [0x5398]·0x34` (@0x3DAB4) → `strlwr` (`0xD1D:0xD46`
  @0x3DACD = file 0x10316, A..Z only) → word-initial capitalisation (@0x3DB06..0x3DB3C: an
  alpha char following a non-alpha, if lower, `-= 0x20`; ctype table DG 0x27ED = file
  0x2018D, MSC bit0 upper / bit1 lower / bit2 digit / bit3 space / bit4 punct).
- **Per char** (@0x3DC58..0x3DCFD): space|punct → x+3, y−1, no glyph (@0x3DC6B/0x3DC70);
  not alpha (digits, controls) → `DEC-SQIG`, 10 frames, y−4, then stop (@0x3DC88..0x3DCA1);
  upper → `DEC-UPP<c>`, 10 frames, y−3 (@0x3DCCB/0x3DCD1); lower → `DEC-LOW<c>`, 7 frames,
  y−2 (@0x3DCF2/0x3DCF8). Frames i=0..n−1 are engine frames i+2 (@0x3DD30/0x3DD31) = disk
  descriptors 1..n; descriptor 0 is the empty stroke (opaque counts UPPA
  `[0,4,7,13,19,27,34,40,40,42,45]`, LOWA `[0,2,4,7,13,18,22,25]`, SQIG `[0,2,…,54]`). Every
  DEC descriptor is 22 px tall; the widths (UPP A..Z `13,11,19,15,12,14,18,13,11,8,15,13,16,
  18,11,14,13,13,9,16,19,13,14,14,14,13`, LOW `8,6,6,9,6,5,7,7,6,6,8,8,11,9,6,8,8,7,8,7,9,7,
  8,8,9,8`, SQIG 28) come from the sheets, not from code.
- **Cadence** (@0x3DD51..0x3DDC3): after each frame's present the ISR tick word `[0x8338]` is
  zeroed; the loop polls mouse/keyboard (a click or key sets the skip flag @0x3DD74/
  @0x3DD88), waits one `0xC0C:6` tick (`func_00D1CA`, skipped when the flag is set) and
  exits once ≥ 5 ISR ticks have elapsed (@0x3DDB9). `0xC0C:6` (file 0xE4C6) reads through
  `[0x267A]`, set to `0x92E8` by `timer_install` @0xC857 = the **60.8766 Hz** software counter
  (docs/PALETTE_AND_CYCLING.md). Five ISR ticks (608.766 Hz) are 8.2 ms < one 16.43 ms
  tick, so **one stroke frame per 60.8766 Hz tick**; only the first frame's phase (up to
  5 ISR ticks) is unmodelled. The §4 "delay of 0xA or 7 ticks" reading was the frame COUNT.
- **Exit.** `0x191F:0xAAC` reload @0x3DE12, then **`wait_keyOrClick` `0x181F:0x3C0`
  @0x3DE17** (a real dismissal wait — §4's "no separate final-OK key-wait" is withdrawn),
  DAC restore @0x3DE27, cycling flag @0x3DE3A, present @0x3DE3D.
- **Caller: still TBD.** No `lcall`/`ljmp`/far pointer to `0x191F:0x109A` exists (raw search
  for `9A 10 1F 19` = 0 hits); the tracker's "dispatch slot 4 @0x3EA0B" is `ljmp 0x191F:0x364`
  = `func_03C638`. The ports show the page after `@INDEPENDENCE`; a live capture pins the
  real order.
- **Ports.** JS `declEvents`/`drawDeclaration` (`port/src/game.js`), C `rm_draw_declaration`
  (`cport/render/colopy_report_render.c`), both boards advance `UI.decl_step` at 60.8766 Hz;
  oracle `tools/render_declaration_compare.py`.
