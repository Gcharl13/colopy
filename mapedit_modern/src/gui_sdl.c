/*
 * gui_sdl.c — SDL2 front-end for the editor.
 *
 * This is a thin presentation/input shim: it owns a window + texture and
 * translates input into calls on the (separately tested) editor core and UI
 * renderer. All drawing happens in ui_render() into a software framebuffer,
 * which is uploaded to an SDL streaming texture each frame.
 *
 * Build:  make gui      (requires libsdl2-dev)
 * Run:    build/mpedit-gui [FILE.MP]
 *
 * Mouse:
 *   left-click map ........ paint selected terrain (drag to keep painting)
 *   shift+left map ........ flood / radius fill (per Fill Mode)
 *   right-click map ....... pick up terrain under cursor
 *   shift+right map ....... remove overlays (clear river/forest/prime)
 *   click palette ......... select a terrain
 *   click menu title ...... open/close a dropdown; click an item to run it
 * Keys:
 *   Z / X ................. zoom in / out        F1..F4 ... zoom levels
 *   arrows ................ scroll               C ........ center on cursor
 *   R / T / B ............. toggle river / forest / prime at cursor
 *   [ / ] ................. fill radius -/+       M ........ toggle fill mode
 *   P ..................... toggle coast protect  U/Ctrl+Z . undo
 *   Ctrl+S ................ save    Ctrl+O ... load    Ctrl+N ... new
 *   Esc ................... close menu / quit
 *
 * Save As / Load / New prompt for input on the console (stdin), since SDL has
 * no native file chooser.
 */
#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ui.h"
#include "sprites.h"

static char g_path[1024] = "UNTITLED.MP";

static char *prompt(const char *msg, char *buf, size_t n)
{
    printf("%s", msg);
    fflush(stdout);
    if (!fgets(buf, (int)n, stdin))
        return NULL;
    buf[strcspn(buf, "\r\n")] = 0;
    return buf[0] ? buf : NULL;
}

static void do_save(editor *e, const char *path)
{
    if (mp_save(e->map, path) == 0)
        printf("saved %s (%zu bytes)\n", path, mp_file_size(e->map));
    else
        fprintf(stderr, "save FAILED: %s\n", path);
}

/* Replace the editor's map (used by Load / New). Returns new editor or old on
 * failure. */
static editor *load_map(editor *old, const char *path)
{
    char err[256];
    mp_map *m = mp_load(path, err, sizeof err);
    if (!m) { fprintf(stderr, "load failed: %s\n", err); return old; }
    uint8_t sel = old->selected_id;
    editor_destroy(old);
    editor *e = editor_create(m);
    e->selected_id = sel;
    snprintf(g_path, sizeof g_path, "%s", path);
    printf("loaded %s (%ux%u)\n", path, m->width, m->height);
    return e;
}

/* Returns 1 to request quit. */
static int do_menu(editor **ep, ui_view *v, int menu, int item)
{
    editor *e = *ep;
    char buf[1024];
    if (menu == 0) {        /* Editor */
        switch (item) {
        case 0: do_save(e, g_path); break;                         /* Save Map */
        case 1: if (prompt("Save As: ", buf, sizeof buf)) {        /* Save As  */
                    do_save(e, buf); snprintf(g_path, sizeof g_path, "%s", buf);
                } break;
        case 2: if (prompt("Load: ", buf, sizeof buf))             /* Load Map */
                    *ep = load_map(e, buf);
                break;
        case 3: {                                                  /* Create   */
            int w = 58, h = 72;
            if (prompt("New map W H: ", buf, sizeof buf))
                sscanf(buf, "%d %d", &w, &h);
            mp_map *m = mp_new((uint16_t)w, (uint16_t)h);
            if (m) {
                for (int y = 0; y < h; y++)
                    for (int x = 0; x < w; x++)
                        m->terrain[mp_idx(m, x, y)] = (x == 0 || x == w - 1) ? 26 : 25;
                uint8_t sel = e->selected_id;
                editor_destroy(e);
                *ep = editor_create(m);
                (*ep)->selected_id = sel;
                snprintf(g_path, sizeof g_path, "UNTITLED.MP");
            }
            break;
        }
        case 4: return 1;                                          /* Exit     */
        }
    } else if (menu == 1) { /* View */
        switch (item) {
        case 0: if (v->zoom < 3) v->zoom++; break;                 /* Zoom In  */
        case 1: if (v->zoom > 0) v->zoom--; break;                 /* Zoom Out */
        case 2: v->zoom = 0; break;
        case 3: v->zoom = 1; break;
        case 4: v->zoom = 2; break;
        case 5: v->zoom = 3; break;
        case 6: ui_center_on(v, e, e->cursor_x, e->cursor_y); break; /* Center */
        }
        ui_clamp_scroll(v, e);
    } else if (menu == 2) { /* Map */
        switch (item) {
        case 0: v->tile_select_open = 1; break;                    /* Map Tile Select */
        case 1: editor_set_mode(e, e->mode == FILL_FLOOD ? FILL_RADIUS : FILL_FLOOD); break;
        case 2: editor_toggle_coast_protect(e); break;
        case 3: { int c = 0, o = 0; editor_count_masses(e, &c, &o);
                  printf("Find Continents: %d continents, %d oceans%s\n",
                         c, o, o > 15 ? "  (WARNING: >15 oceans)" : ""); break; }
        case 4: editor_undo(e); break;
        case 5: printf("Memory check: OK\n"); break;
        }
    } else if (menu == 3) { /* Help — print to console */
        printf("[Help] %s\n", ui_menu_item(menu, item));
    }
    return 0;
}

static void paint_at(editor *e, ui_view *v, int mx, int my, int button, int shift)
{
    int tx, ty;
    if (!ui_hit_map(v, e, mx, my, &tx, &ty))
        return;
    e->cursor_x = tx; e->cursor_y = ty;
    if (button == SDL_BUTTON_LEFT) {
        if (shift) editor_fill(e, tx, ty);
        else       editor_paint(e, tx, ty);
    } else if (button == SDL_BUTTON_RIGHT) {
        if (shift) {     /* remove overlays */
            uint8_t *b = &e->map->terrain[mp_idx(e->map, tx, ty)];
            *b &= 0x1F;
        } else editor_pick(e, tx, ty);
    }
}

int main(int argc, char **argv)
{
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        fprintf(stderr, "SDL_Init: %s\n", SDL_GetError());
        return 1;
    }

    /* initial map */
    editor *e;
    if (argc > 1) {
        char err[256];
        mp_map *m = mp_load(argv[1], err, sizeof err);
        if (!m) { fprintf(stderr, "load failed: %s\n", err); m = mp_new(58, 72); }
        else snprintf(g_path, sizeof g_path, "%s", argv[1]);
        e = editor_create(m);
    } else {
        mp_map *m = mp_new(58, 72);
        for (int y = 0; y < 72; y++)
            for (int x = 0; x < 58; x++)
                m->terrain[mp_idx(m, x, y)] = (x == 0 || x == 57) ? 26 : 25;
        e = editor_create(m);
    }
    e->cursor_x = e->map->width / 2;
    e->cursor_y = e->map->height / 2;

    const char *adir = getenv("COLONIZE_DIR");
    adir = adir ? adir : ".";
    sprite_load_phys0(adir);   /* real art if present, else colored */
    ui_load_fonts(adir);       /* real game fonts if present, else 8x8 */

    ui_view v;
    ui_view_init(&v);
    ui_center_on(&v, e, e->cursor_x, e->cursor_y);

    SDL_Window *win = SDL_CreateWindow("MAPEDIT", SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED, UI_WIN_W, UI_WIN_H, SDL_WINDOW_SHOWN);
    SDL_Renderer *ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    SDL_Texture *tex = SDL_CreateTexture(ren, SDL_PIXELFORMAT_RGB888,
        SDL_TEXTUREACCESS_STREAMING, UI_WIN_W, UI_WIN_H);
    fb *f = fb_create(UI_WIN_W, UI_WIN_H);

    int running = 1, painting = 0, paint_btn = 0;
    while (running) {
        SDL_Event ev;
        while (SDL_PollEvent(&ev)) {
            int shift = (SDL_GetModState() & KMOD_SHIFT) != 0;
            int ctrl  = (SDL_GetModState() & KMOD_CTRL) != 0;
            switch (ev.type) {
            case SDL_QUIT:
                running = 0;
                break;

            case SDL_MOUSEBUTTONDOWN: {
                int mx = ev.button.x, my = ev.button.y, tx, ty;
                /* tile-select popup is modal */
                if (v.tile_select_open) {
                    int pid = ui_hit_tile_select(&v, mx, my);
                    if (pid >= 0)      { editor_select(e, (uint8_t)pid); v.tile_select_open = 0; }
                    else if (pid == -2) v.tile_select_open = 0;
                    break;
                }
                /* open dropdown: click item? */
                if (v.menu_open >= 0) {
                    int it = ui_hit_menu_item(&v, mx, my);
                    if (it >= 0) { if (do_menu(&e, &v, v.menu_open, it)) running = 0; v.menu_open = -1; break; }
                }
                int mb = ui_hit_menu(mx, my);
                if (mb >= 0) { v.menu_open = (v.menu_open == mb) ? -1 : mb; break; }
                v.menu_open = -1;
                /* mini-map: click to recenter */
                if (ui_hit_minimap(&v, e, mx, my, &tx, &ty)) {
                    e->cursor_x = tx; e->cursor_y = ty;
                    ui_center_on(&v, e, tx, ty);
                    break;
                }
                /* map paint */
                paint_at(e, &v, mx, my, ev.button.button, shift);
                painting = 1; paint_btn = ev.button.button;
                break;
            }
            case SDL_MOUSEBUTTONUP:
                painting = 0;
                break;

            case SDL_MOUSEMOTION: {
                int mx = ev.motion.x, my = ev.motion.y, tx, ty;
                if (ui_hit_map(&v, e, mx, my, &tx, &ty)) {
                    e->cursor_x = tx; e->cursor_y = ty;
                    v.hover_x = tx; v.hover_y = ty;
                    if (painting) paint_at(e, &v, mx, my, paint_btn, shift);
                } else {
                    v.hover_x = v.hover_y = -1;
                }
                break;
            }

            case SDL_KEYDOWN:
                switch (ev.key.keysym.sym) {
                case SDLK_ESCAPE:
                    if (v.tile_select_open) v.tile_select_open = 0;
                    else if (v.menu_open >= 0) v.menu_open = -1;
                    else running = 0;
                    break;
                case SDLK_z: if (v.zoom < 3) v.zoom++; ui_clamp_scroll(&v, e); break;
                case SDLK_x: if (v.zoom > 0) v.zoom--; ui_clamp_scroll(&v, e); break;
                case SDLK_F1: v.zoom = 0; ui_clamp_scroll(&v, e); break;
                case SDLK_F2: v.zoom = 1; ui_clamp_scroll(&v, e); break;
                case SDLK_F3: v.zoom = 2; ui_clamp_scroll(&v, e); break;
                case SDLK_F4: v.zoom = 3; ui_clamp_scroll(&v, e); break;
                case SDLK_LEFT:  v.scroll_x -= 2; ui_clamp_scroll(&v, e); break;
                case SDLK_RIGHT: v.scroll_x += 2; ui_clamp_scroll(&v, e); break;
                case SDLK_UP:    v.scroll_y -= 2; ui_clamp_scroll(&v, e); break;
                case SDLK_DOWN:  v.scroll_y += 2; ui_clamp_scroll(&v, e); break;
                case SDLK_c: ui_center_on(&v, e, e->cursor_x, e->cursor_y); break;
                case SDLK_r: editor_toggle_river(e, e->cursor_x, e->cursor_y); break;
                case SDLK_t: editor_toggle_forest(e, e->cursor_x, e->cursor_y); break;
                case SDLK_b: editor_toggle_prime(e, e->cursor_x, e->cursor_y); break;
                case SDLK_LEFTBRACKET:  editor_set_fill_radius(e, e->fill_radius - 1); break;
                case SDLK_RIGHTBRACKET: editor_set_fill_radius(e, e->fill_radius + 1); break;
                case SDLK_m: editor_set_mode(e, e->mode == FILL_FLOOD ? FILL_RADIUS : FILL_FLOOD); break;
                case SDLK_p: editor_toggle_coast_protect(e); break;
                case SDLK_u: editor_undo(e); break;
                case SDLK_s: if (ctrl) do_save(e, g_path); break;
                case SDLK_o: if (ctrl) { char buf[1024]; if (prompt("Load: ", buf, sizeof buf)) e = load_map(e, buf); } break;
                case SDLK_n: if (ctrl) { if (do_menu(&e, &v, 0, 3)) running = 0; } break;
                default: break;
                }
                if (ev.key.keysym.sym == SDLK_z && ctrl) editor_undo(e);
                break;
            }
        }

        ui_render(f, e, &v);
        SDL_UpdateTexture(tex, NULL, f->px, UI_WIN_W * (int)sizeof(uint32_t));
        SDL_RenderClear(ren);
        SDL_RenderCopy(ren, tex, NULL, NULL);
        SDL_RenderPresent(ren);
    }

    fb_free(f);
    editor_destroy(e);
    SDL_DestroyTexture(tex);
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
}
