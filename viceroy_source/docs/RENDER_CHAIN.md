> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.
>
> **UPDATE 2026-05-30:** the `func_O514 → func_O513 → func_O512` tile chain
> IS now byte-verified and ported in `src/render/tile_chain.c`, `terrain.c`,
> and `blit.c` (O513 real body 1076 B, not the 165 B stub). Trust those `.c`
> files over the pseudo-code below where they disagree. **The per-tile
> dirty-rect skip described here is FABRICATED** — the verified chain does a
> full unconditional redraw of every viewport tile each frame; there is no
> `tile_dirty[]` array, no `tile_is_dirty()` guard, and no `tile_clear_dirty()`
> call in VICEROY.EXE. Every `dirty`-tagged passage below is marked FABRICATED
> in place; ignore it.

# Render Chain — Pixel Pipeline

## VGA Mode 13h (320×200, 256 colors)

VICEROY.EXE runs in standard VGA Mode 13h:

- Resolution: **320 × 200 × 8 bpp** (256 colors)
- Framebuffer: linear at `0xA000:0000` (64 KB visible)
- Palette: 256 × 18 bits (6-bit per RGB channel) loaded via `INT 10h`
- No scrolling; full-screen redraws each frame

The framebuffer is **direct-write**. (FABRICATED claim removed: an earlier
draft asserted flicker was mitigated by a "per-tile dirty-rect system that
only redraws what changed." No such system exists in VICEROY.EXE — the
verified `func_O514` redraws the whole 15×12 viewport unconditionally each
frame. See `src/render/tile_chain.c`. Double-buffering status: not yet decoded.)

## Top-level render dispatch

```c
void render_frame(void) {
    if (current_screen == SCREEN_MAP) {
        render_map_view();
    } else if (current_screen == SCREEN_COLONY) {
        render_colony_screen();
    } else if (current_screen == SCREEN_EUROPE) {
        render_europe_screen();
    } else if (current_screen == SCREEN_TITLE) {
        render_title_screen();
    } else if (current_screen == SCREEN_HALL_OF_FAME) {
        render_hof();
    }
    render_overlays();      /* dialogs, tooltips, mouse cursor */
}
```

## Map view rendering

The map view is a **15 × 12 tile** viewport (240 × 192 pixels) with a
sidebar on the right (80 × 200) for stats/orders.

### The drawing chain (per CLAUDE.md ruling)

The actual chain is `func_O514` → `func_O513` → `func_O512`:

```c
/* func_O514 — top-level map view render */
void map_view_render(void) {
    int viewport_x = camera_x;
    int viewport_y = camera_y;

    for (int row = 0; row < 12; row++) {
        for (int col = 0; col < 15; col++) {
            int mx = viewport_x + col;
            int my = viewport_y + row;
            int sx = col * 16;
            int sy = row * 16;
            tile_compose_and_blit(mx, my, sx, sy);  /* func_O513 */
        }
    }
    sidebar_draw();
    cursor_draw();
}

/* func_O513 — compose & blit one tile */
void tile_compose_and_blit(int mx, int my, int sx, int sy) {
    /* FABRICATED line removed: `if (!tile_is_dirty(mx, my)) return;`
     * The verified func_O513 has no dirty guard — it composes every tile
     * unconditionally. See src/render/tile_chain.c. */

    /* 1. Base terrain layer */
    int terrain = map_terrain[my * 58 + mx];
    int base = terrain & 0x1F;
    int forested = terrain & 0x80;
    int prime = terrain & 0x20;
    int road_river = terrain & 0x40;

    blit_terrain_sprite(TERRAIN_SS_BASE[base], sx, sy);     /* TERRAIN.SS */

    /* 2. Forested overlay */
    if (forested) blit_sprite(PHYS0_FOREST_OVERLAY[base], sx, sy);

    /* 3. River/road */
    if (road_river) {
        if (is_river_cell(mx, my))
            blit_sprite(PHYS0_RIVER_CONNECT[connectivity_mask(mx, my)], sx, sy);
        else
            blit_sprite(PHYS0_ROAD_CONNECT[connectivity_mask(mx, my)], sx, sy);
    }

    /* 4. Resource overlay (prime resource) */
    if (prime) {
        int rsrc = map_resource[my * 58 + mx];
        blit_sprite(PHYS0_RESOURCE[rsrc], sx, sy);
    }

    /* 5. Feature layer (colony, native, LCR) */
    int feat = map_feature[my * 58 + mx];
    if (feat != 0) {
        draw_feature(feat, sx, sy);
    }

    /* 6. Units on tile (top of stack) */
    Unit *top = top_unit_at(mx, my);
    if (top) blit_sprite(unit_sprite_id(top), sx, sy);

    /* FABRICATED line removed: `tile_clear_dirty(mx, my);` — no dirty array
     * exists in VICEROY.EXE. See src/render/tile_chain.c. */
}

/* func_O512 — actual sprite blit (RLE-decoded MS_SPRITE) */
void blit_sprite(int sprite_id, int dst_x, int dst_y) {
    SpriteHeader *h = sprite_lookup(sprite_id);
    if (!h) return;

    uint8_t *src = sprite_data(h);
    uint8_t *dst = (uint8_t*)0xA0000000UL + dst_y * 320 + dst_x;

    /* RLE-decode each row, transparent-skip pixels with COLOR_TRANSPARENT */
    for (int row = 0; row < h->height; row++) {
        rle_blit_row(src, dst);
        src += h->row_size[row];
        dst += 320;
    }
}
```

### Sprite sources

Per CLAUDE.md and the SPRITE_CATALOG.md:

| Layer        | Source                       | Notes                            |
|--------------|------------------------------|----------------------------------|
| Base terrain | `TERRAIN.SS`                  | Per-terrain textured ground     |
| Forest       | `PHYS0.SS` rows 0x10..       |                                  |
| River        | `PHYS0.SS` rows 0x01, 0x11   | NOT coast — see CLAUDE.md ruling|
| Coast halo   | water-tile beach mechanism   | Generated from sea adjacency    |
| Mountains    | `PHYS0.SS` row 0x21          | Snow peaks                       |
| Hills        | `PHYS0.SS` row 0x31          | Brown rolling                    |
| Buildings    | `BUILDING.SS`                | Per-building sprite              |
| Wood frame   | `WOODFRAM.SS`                | Frame for in-construction       |
| Wood tile    | `WOODTILE.SS`                | Texture for floors              |
| Units (map)  | `ICONS.SS` 100..127          |                                  |
| Founding     | `CC-NN.SS` files             | Father portraits                 |
| Resources    | `PHYS0.SS` overlays          | Sugar, Tobacco, etc.             |

**NEVER load BDARK.SS** — orphan, per CLAUDE.md.

## Colony screen rendering

The colony screen is a full-screen layout showing:

- The colony tile + 8 ring tiles (top-center, scaled 2×)
- Building slot grid (left)
- Stockpile bar (bottom)
- Construction queue (right)
- Worker assignment dropdowns (overlaid on tiles)

```c
void render_colony_screen(Colony *c) {
    blit_background(COLONY_BG_PIK);

    /* Ring tiles, scaled 2×16 = 32 pixels per tile */
    for (int i = 0; i < 9; i++) {
        int tx, ty;
        ring_offset(i, &tx, &ty);
        compose_tile_2x(c->map_x + tx, c->map_y + ty,
                        COLONY_RING_X + (i % 3) * 32,
                        COLONY_RING_Y + (i / 3) * 32);
    }

    /* Building slots */
    for (int i = 0; i < 32; i++) {
        if (c->building[i] == BLD_NONE) continue;
        int sx = BUILDING_SLOT_X[i];
        int sy = BUILDING_SLOT_Y[i];
        blit_sprite(BUILDING_SPRITE[c->building[i]], sx, sy);
    }

    /* Workers in slots */
    for (int i = 0; i < 24; i++) {
        if (c->worker_slots[i] == 0) continue;
        int unit_id = c->worker_slots[i] & 0xFF;
        int slot_x, slot_y;
        slot_screen_pos(i, &slot_x, &slot_y);
        blit_sprite(unit_sprite_for_slot(units[unit_id]), slot_x, slot_y);
    }

    /* Stockpile bar */
    for (int g = 0; g < 16; g++) {
        int x = STOCK_BAR_X + g * 18;
        int y = STOCK_BAR_Y;
        blit_sprite(GOOD_ICON_SPRITE[g], x, y);
        draw_text(font_small, x + 2, y + 18, "%d", c->stock[g]);
    }

    /* Headers */
    draw_text(font_large, 8, 4, "%s", c->name);
    draw_text(font_med, 8, 24, "Pop: %d  SoL: %d%%  Tory: %d%%",
              c->population, c->sol_pct, c->tory_pct);
}
```

## Europe screen rendering

The Europe screen shows:

- The dock with up to 4 ships side-by-side
- A buy/sell market panel
- A recruit-from-pool panel
- Custom House toggle (if enabled)

```c
void render_europe_screen(PowerRecord *p) {
    blit_background(EUROPE_BG_PIK);

    /* Ships at dock */
    int dock_x = DOCK_BASE_X;
    for each ship in europe_dock:
        blit_sprite(ship_sprite(ship), dock_x, DOCK_Y);
        dock_x += SHIP_SLOT_WIDTH;

    /* Market panel */
    for (int g = 0; g < 16; g++) {
        int x = MARKET_X + g * 18;
        blit_sprite(GOOD_ICON_SPRITE[g], x, MARKET_Y);
        draw_text(font_med, x, MARKET_Y + 18, "%d/%d",
                  p->sell_price[g], p->buy_price[g]);
        if (p->boycotted[g])
            blit_sprite(SPRITE_BOYCOTT_X, x, MARKET_Y);
    }

    /* Recruit pool */
    for (int u = 0; u < 8; u++) {
        if (p->recruit_pool[u] <= 0) continue;
        blit_sprite(unit_sprite_recruit(u),
                    RECRUIT_X + u * RECRUIT_W, RECRUIT_Y);
    }
}
```

## Title screen

```c
void render_title_screen(void) {
    blit_background(TITLE_PIK);              /* TITLE.PIK */
    draw_menu(MAIN_MENU_OPTIONS, MENU_X, MENU_Y);
    if (mouse_over_menu_item()) {
        draw_highlighted_item();
    }
    blit_sprite(LOGO_PIK, LOGO_X, LOGO_Y);
}
```

## Mouse cursor

Drawn last, every frame. The cursor is a small sprite from `ICONS.SS`:

```c
void cursor_draw(void) {
    int sx = mouse_x - CURSOR_HOTSPOT_X;
    int sy = mouse_y - CURSOR_HOTSPOT_Y;
    blit_sprite_with_hotspot(current_cursor_sprite, sx, sy);
}
```

The cursor changes contextually:

- Hand (default)
- Sword (over enemy)
- Coin (over tradeable)
- Hammer (over construction site)
- Question mark (unknown / unrecognized)

## Dirty-rect optimization — ⚠️ FABRICATED, DOES NOT EXIST

> **This entire section is fabricated.** VICEROY.EXE has **no** dirty-rect
> system. There is no `tile_dirty[]` array, no `tile_mark_dirty()`,
> `tile_is_dirty()`, or `tile_clear_dirty()` function anywhere in the binary.
> The byte-verified `func_O514` (`src/render/tile_chain.c`) redraws all
> 15×12 viewport tiles unconditionally every frame. The code block and the
> "marked dirty when…" list below are retained only as a record of what was
> fabricated; **do not port or trust any of it.**

```c
/* ⚠️ FABRICATED — no such code exists in VICEROY.EXE (see warning above) */
uint8_t tile_dirty[58 * 72];     /* one byte per tile */

void tile_mark_dirty(int x, int y) {
    if (in_bounds(x, y)) tile_dirty[y * 58 + x] = 1;
}

int tile_is_dirty(int x, int y) {
    return tile_dirty[y * 58 + x];
}

void tile_clear_dirty(int x, int y) {
    tile_dirty[y * 58 + x] = 0;
}
```

A tile would (per the fabrication) be marked dirty when:

- A unit moves into/out of it
- A colony is founded/razed
- A road/forest changes
- A river is created
- The viewport scrolls (all viewport tiles dirty)
- A new turn starts (full repaint)

…but again, none of this is in the binary — full unconditional redraw only.

## Cross-references

- Sprite catalog: `SPRITE_CATALOG.md` (project root)
- Asset roles: [ASSET_ROLES.md](ASSET_ROLES.md)
- MS_SPRITE format: [../formats/SS.md](../formats/SS.md)
- PIK format: [../formats/PIK.md](../formats/PIK.md)
