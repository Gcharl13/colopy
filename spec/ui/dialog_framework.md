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
| `+0x02` | text-line count (inc `@0x06CA2B`, `func_06C850`) | B |
| `+0x04` | option-row count (inc `@0x06CB87`, `func_06CA82`) | B |
| `+0x08` | third item-class count (inc `@0x06CD57`, `func_06CB94`) | B |
| `+0x0A` | FLAGS: `0x10`=borderless, `0x40`=off-screen (set `@0x06D73F`), `0x20`=sibling attach (test `@0x06D89A`), checkbox sets `|=5` (`@0x06F36B`) | B |
| `+0x0C`/`+0x0E` | requested X/Y from `@x`/`@y` (−1 = center sentinel); parser stores `@0x06F2A6`/`@0x06F25E` | B |
| `+0x10`/`+0x12` | final on-screen X/Y (copied from +0x0C/+0x0E `@0x06D349..0x06D355`, then center/clamp resolved) | B |
| `+0x14`/`+0x16` | box W/H | B |
| `+0x18..+0x1E` | final absolute rect (stores from `@0x06D5B9`) | B |
| `+0x20` | longest-line pixel width (clamped vs +0x28 `@0x06D392`) | B |
| `+0x22` | pad = 4 (`@0x06C5AC`) | B |
| `+0x26` | **row y-seed for the pump's loop A** (live, set during construct) | B (site) |
| `+0x28` | content-width floor — init **0x50** (`@0x06C5A6`), overridden by `@WIDTH` (`func_06CA72 @0x06CA7B`) | B |
| `+0x46` | **border** = `(FLAGS&0x10) ? 0 : 3` (`@0x06C5DA..0x06C5E9`) | B |
| `+0x48` | **inset** = `(FLAGS&0x10) ? 0 : 2` (`@0x06C5ED..0x06C5F5`) | B |
| `+0x4A` | **content-height cursor** — init 0 (`@0x06C68D`); each appended node's y = `[+0x46]+[+0x4A]` (`@0x06CE24/0x06CE28`); incremented in the add-item path (candidate sites `@0x0529D1`/`@0x052DDB`) | B |
| `+0x54`/`+0x56` | title far-ptr **gate** (non-null test `@0x06D457`); in the pump, loop-A list head | B |
| `+0x5C`/`+0x5E` | child/widget list head (pump loop B `@0x06E699`) | B |
| `+0x60`/`+0x62` | subtitle far-ptr gate (`@0x06D47F`) | B |
| `+0x68`/`+0x6A` | attached submenu ptr; on widget nodes: the **element sprite far-ptr the painter blits** (`func_06D938 @0x06D952/0x06D956`) | B |
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
**`@TEXTCOLR` is NOT parsed** — the string exists once at file `0x1F9AA` (DGROUP `0x200A`) with
zero strcmp references. *(The earlier "8 directives" count in `fonts_and_colors.md` §3 was two
short — X and Y are separate entries, and PROMPT/DEFAULT were folded; this table is the
byte-complete set.)*

## 3. Box geometry `func_06D316` (file `0x06D316..0x06D889`, ENTER 0x2C, `ret 4`)

- **Width:** `box_w = content_w + 2·border + pad` (accum `@0x06D4DD/0x06D4E5/0x06D4E9`), where
  `content_w = max(0x50, longest_line_px [+0x20], @WIDTH [+0x28])` (clamp `@0x06D392..`), line
  widths measured via `0x06CD66` on the `+0x80/+0x82` string.
- **Height seed:** `[+0x16] = 2·[+0x4A] + [+0x46]` (`shl @0x06D35F; add @0x06D365; store
  @0x06D369`). `+0x4A` is the **content-height cursor** summed as items are appended — the box
  height is item-driven, **not** `line_count·2+3` (the old `popups.md` §2.3 formula is retracted;
  its "2 px per line" misread the `shl` operand). ⚠ The ×2 scale on the cursor (also seen in the
  row-extent formula, §5) is byte-exact but its unit convention (half-height accumulation in the
  add-item path) is the one remaining trace: increment sites `@0x0529D1`/`@0x052DDB`.
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
  (`@0x06E61E`); **row pitch = glyph_height + border** — `call 0x1266` (glyph-height helper)
  `@0x06E469` + `dialog[+0x46]` `@0x06E472` (stored `@0x06E476`). With FONTTINY (cell 6) and
  border 3 ⇒ **9 px**, matching the independent chain `les bx,[0x89E]; add ax,3` `@0x3AB3..0x3ABC`.
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
6. **Pitch helper `call 0x1266`** (page 0x17): confirm it returns the `[0x89E]` cell height.
   Static, small.
