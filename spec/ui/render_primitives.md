# UI Render Primitives — the draw-verb vocabulary (B)

> **Layer 2 — UI Specification.** The canonical table of every low-level draw call a screen
> painter issues, so a rebuild knows exactly what each `lcall 0x181F:0xNNN` in the other
> `spec/ui/*.md` sheets *does*. Every target is byte-verified via the type-B thunk formula
> `target_file_offset = 0x2400 + (jmpf_seg<<4) + jmpf_off` (`code/VICEROY/thunks_resolved.json`),
> spot-checked by disassembling the target in `raw/COLONIZE/VICEROY.EXE`. Supersedes the partial,
> partly-wrong vocabulary in `viceroy_source/docs/UI_PRIMITIVES.md` (which omits 10 of these) and
> corrects the `0x35C`-is-text-draw error propagated into `advisor_reports.md`.

## 0. Two colour-sourcing families (important for a rebuild)
Text verbs split into two families by **where the pen colour comes from**:
- **Global-colour text** (`func_002Axx`/`002Cxx`): colour = byte **`[0x830]`** (and `[0x831]`),
  a screen-level pen latch — e.g. `func_002AFE` pushes `[0x830]` `@0x002B07` then the font latch
  `[0x89E]:[0x8A0]` and `(x,y)`. No per-call colour arg.
- **Explicit-arg text** (`func_002Bxx`): colour is a push-arg to the call.
Both bottom out in the same string rasteriser core **`func_00E51C`** (`0x181F:0x1FA`), whose ink
levels map through the 4-entry LUT `[0x269E]:[0x26A0]` (`spec/ui/fonts_and_colors.md` §1b).

## 1. Canonical draw-verb table (all type-B → resident, byte-verified)

| Thunk | Target (file) | Class | What it does |
|-------|---------------|-------|--------------|
| `0x181F:0x1FA` | `func_00E51C` | **text core** | Proportional string rasteriser: `ch−1` glyph lookup, 2 bpp → `[0x269E]` LUT. All text bottoms out here. |
| `0x181F:0x204` | `func_00E6A6` | **text measure** | Returns pixel width of a string (Σ glyph widths). The width source for every centered/right-aligned element. |
| `0x181F:0x100` | `func_002BC8` | text | **Centered** title/string (centres in a pushed box width). |
| `0x181F:0x13C` | `func_002B38` | text | Draw string at `(x,y)` — **explicit-colour** family. |
| `0x181F:0x132` | `func_002AFE` | text | Draw string at `(x,y)` — **global-colour** (`[0x830]`). |
| `0x181F:0x150` | `func_002B72` | text | String draw variant (global-colour family). |
| `0x181F:0x18C` | `func_002C4A` | text | String draw variant. |
| `0x181F:0x1AA` | `func_002C82` | text | String draw variant. |
| `0x181F:0x182` | `func_0029DE` | text | Append a **decimal number** to the working string. |
| `0x181F:0x1A0` | `func_002A06` | text | Append a **zero-padded** number. |
| `0x181F:0x16E` | `func_002992` | text | **strcat** into the working string buffer. |
| `0x181F:0x10A` | `func_002912` | text | string-build helper (append). |
| `0x181F:0x11E` | `func_002922` | text | string-build helper. |
| `0x181F:0x128` | `func_002932` | text | string-build helper. |
| `0x181F:0x146` | `func_002962` | text | string-build helper. |
| `0x181F:0x178` | `func_0028B0` | text | string-build helper (call-overlay-with-80). |
| `0x181F:0x1BE` | `func_0028F2` | text | string-build helper. |
| `0x181F:0xE2`  | `func_00DB3A` | **sprite** | **Clipped sprite blit** (the workhorse — units, icons, panels). |
| `0x181F:0x254` | `func_00E76A` | sprite | Blit ONE sprite (reads `[bx]`=w−1, `[bx+2]`=h−1). |
| `0x181F:0x24A` | `func_00380C` | sprite | Sprite blit variant. |
| `0x181F:0x1468`| `func_00D9E0` | sprite | Sprite blit variant. |
| `0x181F:0x18F8`| `func_00DB80` | sprite | Sprite blit variant. |
| `0x181F:0x222` | `func_0033F2` | sprite | **Icon-bar** strip (discrete indicators — SoL/crosses/bells). |
| `0x181F:0x2BC` | `func_00386A` | sprite | **Unit-info panel** composite (used by map sidebar + reports). |
| `0x181F:0x510` | `func_00531C` | **blit** | src→dst rect/scene blit (normalises two far ptrs via `0xA4E:8`, copies with transparent skip). Used for full-scene backdrops AND (via a different call site) the popup frame — see caveat. |
| `0x181F:0xBA`  | `func_00DDEA` | fill | **Span fill** (horizontal run). |
| `0x181F:0x444` | `func_00DCF6` | fill | **Rect fill** (box). |
| `0x181F:0xCE`  | `func_00E0A2` | line | Line / plot. |
| `0x181F:0x590` | `func_00BCEA` | fill | Span-fill + vram (variant). |
| `0x181F:0xDAE` | `func_00BCAA` | fill | Span-fill + vram (variant). |
| `0x181F:0x44E` | *(type-A, overlay)* | load | **load_PIK** — load a `.PIK` background by name. |
| `0x181F:0x438` | *(type-A, overlay)* | load/blit | PIK/asset blit-by-name (paired with `0x44E`). |

## 2. NOT a draw — the `0x35C` correction (B)
**`0x181F:0x35C` → `func_0048CC` is `clamp(v, lo, hi)`**, not a text/sprite verb. Body
(`@0x0048CC`): `dx=[bp+6]` (lo), `ax=[bp+8]` (v), `cmp ax,dx; jge …; mov ax,dx` (max), then
`cmp ax,[bp+0xa]; jle …; mov ax,[bp+0xa]` (min) → returns `max(lo, min(v, hi))`. It **draws
nothing**. Any spec citing `0x35C` as a draw is wrong — see `advisor_reports.md` ("`0x35C`→`0x2BC`
sprite-strip") and `docs/ADVISOR_REPORTS_VICEROY_DECODE.md:246`; those refer to the value being
*clamped before* a subsequent real draw, not a draw itself.

## 3. Notes for the other sheets
- The 10 previously-undocumented verbs (`0x132/0x150/0x18C/0x1AA/0x1FA/0x24A/0x590/0xDAE/0x1468/
  0x18F8`) are now in §1 — no rasteriser-reaching thunk is missing from the vocabulary.
- When a sheet says "draws text via `0x181F:0xNNN`", resolve the colour family here: if the verb is
  in the `002Axx` group the colour is the `[0x830]` latch (find its most-recent set), not a
  per-call arg.
- `0x181F:0x510` is a genuine blit primitive; the open question is *which call site* draws the
  popup frame vs the colony scene (both currently cite site `0x0263D6`) — resolved separately in
  the dialog-framework decode / `popups.md`.
