# Dialog / Window Framework — the layout engine (B)

> **Layer 2 — UI Specification.** The authoritative decode of the engine that lays out and runs
> every GAME.TXT `@`-template dialog, popup, and menu panel. Decoded 2026-07-28 from
> `raw/COLONIZE/VICEROY.EXE` (decode → adversarial-verify; every fact byte-cited, verifier
> corrections folded in). **Supersedes** `docs/UI_RENDERER_SPEC.md`, `docs/DIALOG_GEOMETRY.md`,
> `docs/UI_DIALOGS.md` (stamped) and corrects `popups.md` §2.3's `box_h` and the
> `0x181F:0x510 @0x0263D6` frame mis-attribution.
>
> Core functions (all page 0x17 unless noted): **`func_06C520`** init · **`func_06F0F4`** template
> parser (ENTER 0x168) · **`func_06D316`** finalize/layout (ENTER 0x2C) · **`func_06E3D0`** modal
> pump (ENTER 0x38) · **`func_06D938`** element painter · **`func_044D16`** row append (page 0x0A,
> thunk `0x1A1F:0x33E`).

## 1. The dialog struct (far ptr; `les bx,[bp+4]` in `func_06D316`)

| Offset | Meaning | Cite |
|---|---|---|
| `+0x02` | **option-row** count (inc `@0x06CA2B`, `func_06C850` — the @OPTIONS-mode appender; parser mode-2 handler `@0x06F49E` calls `0x191F:0x176`→`func_06C850`) *(2026-07-31: the old "text-line" label was swapped)* | B |
| `+0x04` | **text-line** count (inc `@0x06CB87`, `func_06CA82` — the TEXT-mode appender; parser mode-1 handler `@0x06F42C` calls `0x191F:0x8C6`→`func_06CA82`) | B |
| `+0x08` | third item-class count (inc `@0x06CD57`, `func_06CB94`) | B |
| `+0x0A` | FLAGS: `0x10`=borderless, `0x40`=off-screen (set `@0x06D73F`), `0x20`=sibling attach (test `@0x06D89A`), checkbox sets `|=5` (`@0x06F36B`) | B |
| `+0x0C`/`+0x0E` | requested X/Y from `@x`/`@y` (−1 = center sentinel); parser stores `@0x06F2A6`/`@0x06F25E` | B |
| `+0x10`/`+0x12` | final on-screen X/Y (copied from +0x0C/+0x0E `@0x06D349..0x06D355`, then center/clamp resolved) | B |
| `+0x14`/`+0x16` | box W/H | B |
| `+0x18..+0x1E` | final absolute rect (stores from `@0x06D5B9`) | B |
| `+0x20` | longest-line pixel width (clamped vs +0x28 `@0x06D392`) | B |
| `+0x22` | pad = 4 (`@0x06C5AC`; also `+0x32`=4 `@0x06C5B3`) — the option-row **x-indent** component, NOT part of outer box width (§3) | B |
| `+0x24` | content x-origin = `(FLAGS&0x10)?0:3` (`@0x06D36D..0x06D38A`), absolutized `+= box_x` `@0x06D863`; option-row x = `+0x24 + inset(+0x48) + pad(+0x22)` = box_x+**9** (`@0x06D9D6..0x06D9E2`) | B (Phase-3 promoted 2026-07-31) |
| `+0x26` | **row y-seed for the pump's loop A** = `inset'(3) + border(3)` = box-relative **6** (`@0x06D382..0x06D38E`), `+= border + text-block-h` when text list non-empty (`@0x06D440..0x06D449`), absolutized `+= box_y` `@0x06D86B` | B (Phase-3 promoted 2026-07-31) |
| `+0x2A`/`+0x2C` | text-line x-origin (=3) / text-block y-pen seed (=6) (`@0x06D37C/0x06D386`); text painter `func_06CFE8` starts its y-cursor at `+0x2C` (`@0x06D012`), line x = `+0x2A + inset(+0x48)` = box_x+**5** (`func_06CFBC @0x06CFD4..0x06CFDC`) | B (Phase-3 promoted 2026-07-31) |
| `+0x28` | content-width floor — init **0x50** (`@0x06C5A6`), overridden by `@WIDTH` (`func_06CA72 @0x06CA7B`) | B |
| `+0x3C`/`+0x3E` | fill color pair ← `[0x1F3C]/[0x1F3E]` at construct (`@0x06C5B7..0x06C5C1`); `[0x1F3C]/[0x1F3E]` = pixel of TEXTCOLR.SS sprite 1/2 (`func_06F6DA @0x06F720/@0x06F73D`, sheet name "TEXTCOLR" `[0x200A]` = file `0x1F9AA` — the string is NOT orphaned, it is the color-table sheet load); fill value **7** is the wood-tile sentinel (§6.5) | B |
| `+0x40`/`+0x42` | **selection-band color pair** ← `[0x1F40]/[0x1F42]` (`@0x06C5C5..0x06C5CF`); boot-menu value 0x37 (`@0x0734DD..0x0734E3`) | B (Phase-3 promoted 2026-07-31) |
| `+0x44` | ring-2 frame color ← `[0x1F44]` (`@0x06C5D3..0x06C5D6`) | B |
| `+0x46` | **border** = `(FLAGS&0x10) ? 0 : 3` (`@0x06C5DA..0x06C5E9`) | B |
| `+0x48` | **inset** = `(FLAGS&0x10) ? 0 : 2` (`@0x06C5ED..0x06C5F5`) | B |
| `+0x4A` | **content-height cursor** — init 0 (`@0x06C68D`); each appended node's y = `[+0x46]+[+0x4A]` (`@0x06CE24/0x06CE28`); incremented in the add-item path (candidate sites `@0x0529D1`/`@0x052DDB`) | B |
| `+0x54`/`+0x56` | **option-row list head** (appender `func_06C850` stores `@0x06C8DC/0x06C8E0`; non-null gate `@0x06D457`; pump loop-A head; row painter `func_06D9CC` iterates it) *(2026-07-31: not a "title ptr")* | B |
| `+0x58`/`+0x5A` | **text-line list head** (appender `func_06CA82` stores `@0x06CAFC/0x06CB00`; measured+painted by `func_06CFE8` `@0x06CFF2`) | B |
| `+0x5C`/`+0x5E` | child/widget list head (pump loop B `@0x06E699`; painter `func_06DE6E`) | B |
| `+0x60`/`+0x62` | prompt/third-class list head (appender `func_06CB94` stores `@0x06CC10/0x06CC14`; gate `@0x06D47F`; painter `func_06DC64`) | B |
| `+0x68`/`+0x6A` | attached submenu ptr; on widget nodes: the **element sprite far-ptr the painter blits** (`func_06D938 @0x06D952/0x06D956`) | B |
| `+0x74` | **ink record** (5 words + font ptr) built at construct by `func_06C296` (`0x1A1F:0xAE6`, args pushed `@0x06C63B..0x06C69E`): `+2`=normal ink←`[0x1F4A]`, `+4`=disabled ink←`[0x1F4C]`, `+6`=**hilite ink**←`[0x1F4E]`, `+8`←`[0x1F50]`, `+0xA`←`[0x1F52]`, `+0xC/+0xE`=font. Per-glyph ink selected by `func_06C346`: disabled→`+4` (`@0x06C354`), hilite (`[0x1F62]!=0`)→`+6` (`@0x06C365`), else `+2` (`@0x06C373`) → set-ink `0x181F:0x1F0` `@0x06C37E`. `{`/`}` in any string toggle `[0x1F62]` 1/0 (`func_06C388 @0x06C3C4→0x06C46C` / `→0x06C478`); `|` ends the visible span | B (Phase-3 promoted 2026-07-31) |
| `+0x80`/`+0x82` | identity key (cmp vs `[0x89E]/[0x8A0]`) **and** the far-ptr actually passed to the text-measure `0x06CD66` (`@0x06D461/0x06D466`, `@0x06D489/0x06D48E`); `@SMALLFONT` stores the font latch here (`@0x06F211/0x06F216`) | B |

## 2. Template parser `func_06F0F4` (file `0x06F0F4`, ENTER 0x168 — 1061 B)

Reads template lines via **`lcall 0x191F:0x91C`** (`@0x06F174` — *not* `0xD1D:0x91C`), strlen
`0xD1D:0x842` (`@0x06F17D`); blank line → paragraph count `[bp-4]++` (`@0x06F189`); `@`-directive
test `cmp byte [bx],0x40` (`@0x06F193`). **Ten directives** (strcmp chain `0xD1D:0x816`, string
pool at file `0x1F967..0x1F9A7`, DGROUP base `0x1D9A0`):

| Directive | strcmp site | Effect | Cite |
|---|---|---|---|
| `OPTIONS` | `@0x06F1B0` (str `0x1FC7`) | mode `[bp-4]=2` — subsequent lines are option rows | `@0x06F1CF` |
| `PROMPT` | `@0x06F1C3` (str `0x1FCF`) | prompt mode | B |
| `TEXT` | `@0x06F1DF` (str `0x1FD6`) | back to body-text mode `[bp-4]=1` | `@0x06F1EB` |
| `SMALLFONT` | `@0x06F1FB` | copies font latch `[0x89E]/[0x8A0]` → struct `+0x80/+0x82` | `@0x06F211/16` |
| `Y` | `@0x06F227` (atoi `0xD1D:0x8BC`) | → `+0x0E` | `@0x06F25E` |
| `X` | `@0x06F26F` | → `+0x0C` | `@0x06F2A6` |
| `WIDTH` | `@0x06F2B7` | **pixel** content-width floor → `+0x28` via `func_06CA72` | `@0x06F2EB/0x06CA7B` |
| `LENGTH` | `@0x06F309` (`0xD1D:0xCC2`) | text-entry max length → global `[0xA5B6]` | `@0x06F347` |
| `CHECKBOX` | `@0x06F35B` | `[bp-0x10]=1` + struct `FLAGS |= 5` | `@0x06F363/0x06F36B` |
| `DEFAULT` | `@0x06F37D` | default-option select (cmp `[0x2008]` `@0x06F389`; idx `@0x06F3FB`; applied `@0x06F4D1/D5`) | B |

Unmatched directive → `[bp-4]=3` (`@0x06F402`), loop exits on mode 3 (`@0x06F4EC`).
**`@TEXTCOLR` is NOT parsed** — the string at file `0x1F9AA` (DGROUP `0x200A`) has zero strcmp
references in the parser. *(Amended 2026-07-31: the string is not orphaned — it is the sheet
name for the **TEXTCOLR.SS color-table load** in `func_06F6DA @0x06F6F0` (`lea bx,[0x200A]` →
`0x1A1F:0x372`), whose sprite-pixel reads seed the ink globals `[0x1F3C..0x1F4E]`, §6.5.)* *(The earlier "8 directives" count in `fonts_and_colors.md` §3 was two
short — X and Y are separate entries, and PROMPT/DEFAULT were folded; this table is the
byte-complete set.)*

## 3. Box geometry `func_06D316` (file `0x06D316..0x06D889`, ENTER 0x2C, `ret 4`)

- **Width (corrected 2026-07-31, Phase-3 promoted):** `box_w = content_w + 2·border` — NO `+pad`
  term. `[+0x14]` starts 0 (`@0x06D359`); `content_w = max(@WIDTH [+0x28], longest_line_px
  [+0x20], [+0x34])` (clamp `@0x06D392..0x06D3B2`, result re-stored to all three);
  `box_w += 2·inset'(3) + content_w` (`shl @0x06D4D0; add [+0x20] @0x06D4E5; add [+0x14]
  @0x06D4E9`). Boot menu: `@width=160` → box_w = **166**. The Phase-3 "+4 pad" was correctly
  re-identified as the option-row x-indent: rows at `box_x+9` (= `+0x24`(3)+inset(2)+pad(4),
  `@0x06D9D6..0x06D9E2`), text/title lines at `box_x+5` (= `+0x2A`(3)+inset(2), `func_06CFBC
  @0x06CFD4..0x06CFDC`).
- **Height seed:** `[+0x16] = 2·[+0x4A] + [+0x46]` (`shl @0x06D35F; add @0x06D365; store
  @0x06D369`). `+0x4A` is the **content-height cursor** summed as items are appended — the box
  height is item-driven, **not** `line_count·2+3` (the old `popups.md` §2.3 formula is retracted;
  its "2 px per line" misread the `shl` operand). ⚠ The ×2 scale on the cursor (also seen in the
  row-extent formula, §5) is byte-exact but its unit convention (half-height accumulation in the
  add-item path) is the one remaining trace: increment sites `@0x0529D1`/`@0x052DDB`.
- **Vertical seeds (B, Phase-3 promoted 2026-07-31):** `+0x24`=3 / `+0x26`=`+0x2C`=6
  box-relative (`@0x06D36D..0x06D38E`: `inset' = (FLAGS&0x10)?0:3`; `+0x26 = inset'+border`).
  Text block: painter/measurer `func_06CFE8` (near entry `0x14E8`; ax=0 measure, ax=1 draw)
  pens from `+0x2C` (`@0x06D012`) with **text-line pitch = glyph_h+1** (`call 0x1266; inc ax`
  `@0x06D07E..0x06D085`, `@0x06D205..0x06D20C`) — FONTTINY bordered ⇒ 5+1 = 6/line — and draws
  at the pen y exactly (`func_06CFBC` passes dx through). If the text list `+0x58` is non-empty,
  finalize bumps the option seed: `+0x26 += border(3) + text_h` (`@0x06D440..0x06D449`).
  Option-row text is drawn at `row_y+1` (`func_06D9CC @0x06DB8C..0x06DB8F`). Boot menu
  (`@y=91`, 1 title line): title top = 91+6 = **97**; first option top = 91+6+3+6+1 = **107**. ✓
- **Centering:** if requested X == −1 (`@0x06D51B`): `X = 160 − W/2` (`sar @0x06D522; sub 0xA0
  @0x06D528; neg; store +0x10 @0x06D52D`). If Y == −1 (`@0x06D534`): `Y = 100 − H/2`
  (`@0x06D53B..0x06D546`).
- **Clamps:** right > 320 → shift left (`@0x06D563`); bottom > 200 → shift up (`@0x06D571`);
  **negative left/top → `lcall 0x181F:0x772`** (`@0x06D5AD`, args X,Y,0xFFAF,2,0x29 — the
  error/assert logger; consistent with the tracker's "0x772 is NOT enter_screen_view" ruling).
- **Return:** AX=**0** = laid out OK (`[bp-8]=0 @0x06D87F`); AX=**1** = empty item-count bail
  (`@0x06D3C8` skips the store). The off-screen FLAGS path (`@0x06D73F` → `jmp @0x06D744`) still
  returns 0. *(Corrects an inverted claim in the first-pass decode.)*
- Final rect stores `@0x06D5B9..0x06D5D1`; absolutize `@0x06D863..0x06D87B`; attached-submenu
  fly-out `@0x06D5E2..0x06D884` keys off direction global `[0x1F5C]` (0..8, tested
  `@0x06D633..0x06D654`) — 4 edge-formula cases, runtime-direction-driven.

## 4. Modal pump `func_06E3D0` (file `0x06E3D0`, ENTER 0x38; thunk `0x191F:0x16A` via stub `@0x1B75A`)

Mouse gates `[0x7F6]/[0x7F0]` (`@0x06E5A7/0x06E5B1`), cursor `[0x7E8]/[0x7EA]`. Hit-test against
the frame bbox: x=`+0x10` (`@0x06E5C1`), y=`+0x12` (`@0x06E5CB`), w=`+0x14` (read `@0x06E5D1`,
right=x+w `@0x06E5D5`), h=`+0x16` (read `@0x06E5DD`, bottom=y+h `@0x06E5E1`).

- **Loop A (rows, head `+0x54/+0x56`** `@0x06E60A/0x06E610`): y-seed = `dialog[+0x26]`
  (`@0x06E61E`); **row pitch = clamped_glyph_height + border** — `call 0x1266` = `func_06CD66`
  `@0x06E469` + `dialog[+0x46]` `@0x06E472` (stored `@0x06E476`). **`func_06CD66` @0x06CD66 is
  NOT a raw height read** (corrected 2026-07-31, Phase-3 promoted): it reads the font header
  byte, then clamps **6→5 when `[0x1F8A]==0`** (`cmp ax,6 @0x06CD75; cmp [0x1F8A],0 @0x06CD7A;
  mov 5 @0x06CD81`), where `[0x1F8A] = (FLAGS&0x10)?1:0` is latched at pump entry
  (`@0x06E3F6..0x06E406`). Bordered dialog + FONTTINY (cell 6) ⇒ **8 px** (5+3), matching the
  Phase-3 boot-menu measurement; borderless ⇒ 6+0 = 6. The paint-side pitch uses the same
  helper (`func_06D9CC @0x06DC0A..0x06DC17`), so hit-test and paint agree. *(The old "9 px"
  claim came from the unclamped chain `les bx,[0x89E]; add ax,3` `@0x3AB3..0x3ABC` — a
  different, resident site that does not serve the dialog row loop.)*
  Rows with `node[0] & 1` are **skipped** (disabled, `@0x06E64E`); the hit row is stored to
  `+0x4C/+0x4E` (`@0x06E659/0x06E65D`); advance via `node+0x10/+0x12`.
- **Loop B (widgets, head `+0x5C/+0x5E`** `@0x06E699`): rowtop = `dialog_y[+0x12] + inset +
  node[0]` (`@0x06E6C7/0x06E6CE`; inset = `(FLAGS&0x10)?0:3` `@0x06E6B6..0x06E6C2`), height =
  `node[+2]` (`@0x06E6D7`); action dispatch `call 0x3D26` (`@0x06E6F2`).
- **Row x-origin = frame X (`+0x10`) + inset.** There is **no universal y-seed/x-origin
  constant** — both are per-dialog struct state; screens that hard-code them (congress x=4
  y=0x19; F9 x=2 y=0x14) bypass the framework with their own painters.
- Double-buffer flush `0x181F:0x444` `@0x06E518`/`@0x06EA53`.

## 5. Row records — `func_044D16` (page 0x0A, file `0x044D16`, thunk `0x1A1F:0x33E` via stub `@0x1C92E`)

Append-row: allocates a **0x16-byte (22 B) node** (`mov ax,0x16 @0x044D6A`; alloc
`0x181F:0x2C @0x044D6E`):

| Node offset | Meaning | Cite |
|---|---|---|
| `+0x00` | flags (zeroed `@0x044DCE`; **bit 0 set when text empty → pump skips** `@0x044E11/0x044E19`) | B |
| `+0x02` | string-derived scalar from `call 0x1815` (`@0x044E2B/0x044E33`) — accelerator column or pixel width, callee untraced (**TBD**) | B (site) |
| `+0x04` | **caller id** (= the command id the row fires) from `[bp+0x10]` (`@0x044E22`) | B |
| `+0x06/+0x08` | row text far-ptr (strlen `0xD1D:0x113C @0x044DEA`, alloc, strcpy `0xD1D:0x117E @0x044E06`) | B |
| `+0x0A/+0x0C` | never written by the appender (reserved) | B |
| `+0x0E/+0x10` | NEXT (`@0x044DCA/0x044DC6`; prev-patch `@0x044D84/0x044D88`) | B |
| `+0x12/+0x14` | PREV (`@0x044DBC/0x044DC0`) | B |

List-parent (`LP`, found via `call 0x17FC @0x044D2E`): head `+0x1E/+0x20`
(`@0x044D4C/0x044DAF`), count `+0` (`inc @0x044E6F`), extent `+6 = MAX(2·parent[+0xC] +
row_metric, existing)` (`shl @0x044E59 … store @0x044E6B`; row_metric from `call 0x1806
@0x044E49` on `parent+0x2C`). **The node carries NO screen coordinates** — row (x,y) is computed
at pump/paint time from the dialog struct (§4).

> ⚠ **Unproven linkage (do not assume):** the pump's loop lists (heads `+0x54`/`+0x5C`, NEXT at
> `node+0x10/+0x12`) are **widget/control records** — a different record type from this 22-byte
> text-item node (NEXT at `+0x0E/+0x10`, head at `LP+0x1E`). How a list-control widget references
> its `func_044D16` item sublist is untraced (**TBD**: the control-construct path on page 0x0A/0x17).

## 6. Element painter + the frame mis-attribution (B, closes a poisoned cite)

- **`0x181F:0x510` is called exactly ONCE in the whole binary** — `@0x0263D6`, inside
  **`func_026374`**, the **colony-scene composite blit** (reads the colony struct `[0x8542]`
  `@0x026379`; consts `0x50,0x50,8,0xC8,0,0` `@0x0263A9`; rect `[0x839E..0x83A4]`; per-record
  tile blits `0x181F:0x254 @0x026492`). `colony_screen.md:440` owns this correctly; **the
  identical cite in `popups.md` §2.5, `menus.md`, `context_dialogs.md` ("WOODFRAM frame painter
  @0x0263D6") is wrong and is retracted.**
- **The real dialog element painter is `func_06D938`** (file `0x06D938`, ENTER 0xC): for each
  widget node it blits the **sprite far-ptr at `node+0x68/+0x6A`** (`@0x06D952/0x06D956`), pushing
  the sprite's own h/w from `sprite+0x0E/+0x0C` (`@0x06D975/0x06D979`), rect buffer `[0x2DA8]`
  (`@0x06D987`), via **`0x181F:0x254`** (`@0x06D98B`). The frame/panel/name-plate are therefore
  **pre-loaded sprite handles bound by the dialog builder** into `node+0x68`; no
  WOODFRAM/WOODPANL/NAMEPLAT name-push or load_PIK exists anywhere in the dialog overlay
  (`0x6BB00..0x6F850` scanned). The WOODPANL name-loads that DO exist are **full-screen
  backgrounds** (`func_07431E @0x7439C`, `func_0759E8 @0x75E00`, via `0x191F:0x87A`, rect
  320×200) — a different use.

## 6.5 Box paint chain (B, Phase-3 promoted 2026-07-31 — decoded from the boot-menu pixel diff)

The pump repaints via the **paint driver `func_06E2DE`** (thunk `0x1A1F:0xAF2`; only callers:
pump `@0x06E58D` sibling path and pump `@0x06EA7F` when the dirty flag `[bp-0xC]` is set —
initialized 1 `@0x06E3D5`, so the first loop iteration is the initial full paint). Driver order
(`@0x06E2ED..0x06E3A0`): finalize `0x1816` → element sprite `func_06D938` → **box `func_06E0C8`**
(`call 0x3d1c` `@0x06E33C` = `0x1A1F:0x710`) → widgets `func_06DE6E` → text lines `func_06CFE8`
(ax=1) → option rows `func_06D9CC` (`@0x06E36B`) → prompt `func_06DC64` (`@0x06E376`) → footer
`func_06D8C8` → screen blit `func_06D88C` (`0x181F:0xE2` of rect `+0x18..+0x1E`, `@0x06D8BD`).

**Box painter `func_06E0C8`** (file `0x06E0C8`, dialog-ptr or explicit-rect args; skips all
chrome when FLAGS&0x10 `@0x06E11B`):

1. **Outline** = 1-px hollow rect, **color 0 (black), a pushed immediate** (`push 0 @0x06E13F`;
   `0x181F:0xCE` `@0x06E155`), rect `(x, y)–(x+w−1, y+h−1)`.
2. **Ring 2** = 1-px hollow rect inset 1, color `[0x1F44]` (`@0x06E16E`, call `@0x06E17D`).
3. **Ring 3 (bevel)** = four 1-px spans at inset 2: left v-span color `[0x1F48]`
   (`@0x06E192`/`0x191F:0x8B2 @0x06E1AB`), right v-span color `[0x1F46]` (`@0x06E1C0/@0x06E1CF`),
   top h-span `[0x1F46]` (`@0x06E1E4`/`0x191F:0x8BC @0x06E1EF`), bottom h-span `[0x1F48]`
   (`@0x06E204/@0x06E20F`) — light top+right, dark left+bottom. Rings 2+3 are the "~2px interior
   bevel band" seen in the Phase-3 diff (item 7 closed).
4. **Interior fill** `(x+3, y+3, w−6, h−6)` with color `[0x1F3C]`/`[0x1F3E]` via `func_06C18C`
   (`call 0x68c @0x06E2D7`).

**Fill helper `func_06C18C`** (file `0x06C18C`): if `[0x1F6C]!=0` **and color1 == 7**
(`@0x06C190..0x06C19B`) → **tiled fill** `0x181F:0xC4` = `func_00E350` using the 4-word tile
record at near ptr **`[0x1F6C]`** (`@0x06C1D8..0x06C1F3`); else flat `w×h` fill `0x181F:0xBA` =
`func_00DDEA` (`@0x06C216`; args ax=x, dx=y, bx=w; stack color,h,sheet — verified from the
`0x00DDEA` body). `[0x1F3C]`'s only writer is `func_06F6DA @0x06F720` (TEXTCOLR.SS sprite-1
pixel), so wood tiling is enabled by the TEXTCOLR color table carrying the sentinel 7.

**Tile records & mode switch (page 0x1A):** the boot asset loader builds three 32×24 tile
records — `[0x93F0]` ← WOODTILE.SS spr 1 (name `[0x23A2]`, blit `@0x07620F`), `[0x93F8]` ←
PARCH.SS spr 1 (`@0x07624D`), **`[0x9400]` ← OPENTILE.SS spr 1** (name literal "opentile"
DGROUP `0x23B1` = file `0x1FD51`; record w/h stores `@0x07627C/0x076282`, blit `@0x0762A7`);
default `[0x1F6C]=0x93F0` `@0x0762BA`. Two mode setters (RETF entries, page 0x1A):
- **in-game** `@0x073474`: inks from DGROUP `[0x830..0x839]`, `[0x1F6C]=0x93F0` (WOODTILE)
  `@0x0734AF`;
- **boot/title** `@0x0734BC`: immediates `[0x1F4A]=0xFE` text, `[0x1F4E]=0xFC` **gold hilite**
  (`@0x0734C2`), `[0x1F4C]=8`, `[0x1F44]=0x2E`, `[0x1F50]=[0x1F46]=0xFD`,
  `[0x1F42]=[0x1F40]=[0x1F48]=0x37`, **`[0x1F6C]=0x9400` (OPENTILE)** `@0x0734E9`.
  Reached from the title composer `func_0759E8 @0x075C52` (`push cs; call 0x4F0D` → trampoline
  `@0x07639D` `ljmp 0x1A1F:0xD74`) immediately before the `@BEGINMENU` run `@0x075C60`.

**Tiling anchor `func_00E350`** (file `0x00E350`): phase_x = `|fill_x0 − anchor_x| mod tile_w`
(`@0x00E371..0x00E387`), phase_y = `|fill_y0 − anchor_y| mod tile_h` (`@0x00E38A..0x00E3A2`);
the anchor passed by `func_06E0C8` is the **box origin** (`+0x10/+0x12`), so the wood grid is
phase-anchored at the box corner — exactly what the Phase-3 diff measured. Partial tiles are
blitted per cell via `0xBAA:6` (`@0x00E423`).

**Selection bar (`func_06D9CC`, hit row == `+0x4C/+0x4E` `@0x06DA85..0x06DA8F`):** filled band
via `func_06C18C` (`call 0x68c @0x06DAF0`) with rect **x = `+0x24`+inset−1 = box_x+4**
(`@0x06DAD1..0x06DAE8`: row_x − pad − 1), **y = row pen y = option-text top − 1** (text at
pen+1 `@0x06DB8C`), **w = content_w−2 = 158** (`@0x06DAD9..0x06DAEB`: `(1−inset)·2 + [+0x20]`),
**h = clamped_glyph_h+2 = 7** (`call 0x1266 @0x06DAAB; inc ax; inc ax @0x06DAB1/0x06DAB2`),
color byte `+0x40` (`@0x06DAC3`) ← `[0x1F40]` = **0x37** on the boot path (tiled instead if the
byte were 7). ⚠ The Phase-3 measurement `(box_x+2, w=160)` is **refuted on the left edge**: the
byte math gives `(box_x+4, w=158)` — the right edge (box_x+161) and h=7 and y=option_top−1
match exactly; the 2-px left-edge difference needs a re-measure, not a code change.

## 7. Open items (each with its exact closer — honest, not reworded)

1. **`+0x4A` increment unit** (the ×2 scale): trace the add-item stores `@0x0529D1`/`@0x052DDB`
   (page 0x0A) to settle whether the cursor accumulates half-heights. Static, small.
2. **Row-node `+0x02` semantics**: disassemble the `call 0x1815` callee (page 0x0A local thunk).
   Static, small.
3. **Widget-record layout + item-sublist linkage** (§5 caveat): trace the control-construct path.
   Static, medium.
4. **`node+0x68` frame-sprite binder**: which builder writes the WOODFRAM handle into the frame
   widget node — needs the builder trace or one runtime watchpoint on `node+0x68`.
5. **`0x181F:0x772`** (negative-position handler): resolve the thunk target and confirm
   error-logger behaviour. Static, small.
6. ✅ **Pitch helper `call 0x1266` — CLOSED (B, 2026-07-31).** `func_06CD66 @0x06CD66` returns
   the passed font's header cell-height byte, **clamped 6→5 when `[0x1F8A]==0`** (bordered
   dialogs) — see §4. It is not tied to `[0x89E]` specifically; the font ptr is an argument.
7. **Phase-3 selection-bar left edge**: pixel diff read `(box_x+2, w=160)`; bytes say
   `(box_x+4, w=158)` (same right edge, §6.5). Re-measure the bar's left edge on a live frame.
