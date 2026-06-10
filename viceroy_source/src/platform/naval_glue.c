/* ============================================================================
 * naval_glue.c -- platform leaves for naval_move_arrive (func_03FDDE)
 * ----------------------------------------------------------------------------
 * Implements the dialog/commit thunks the byte-cited dispatch calls:
 *   ovl_yesno_dialog (0x181F:0x652)  GAME.TXT @KEY prompt + options; SDL keys
 *     1..9 pick; headless returns the section's @default (the file's own).
 *   ovl_popup_simple/ovl_msg_simple  one-shot message render/log.
 *   ovl_landfall_unit (0x1A1F:0x142) THE MOVE COMMIT -- composite of the
 *     byte-verified primitives unit_chain_unlink + unit_place_on_tile, plus
 *     the movement-point deduction (RECONSTRUCTED rule, cite-marked: moves
 *     are stored in thirds; allowance = @UNIT movement column *3 at
 *     [type*9+0x5234]; sea step costs 3 -- pending the order-engine decode).
 *   ovl_landfall_begin/next (0x181F:0x2EE/0x2E4) = the chain walk.
 *   ovl_unload_at (0x181F:0x86C)  place the chosen lander at the move dest
 *     (dest mirrored here by the shell before arrive()).
 *   ovl_reveal_tile -> func_00BD28; ovl_fortify_accum -> func_0062B4.
 *   ovl_sailhome_* / ovl_shipcombat_fx / ovl_post_landfall: logged stubs
 *     (Europe screen / combat fx are later milestones).
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "viceroy_types.h"
#include "dgroup.h"
#include "platform.h"

#define UB(i, off)  DG8(0x3144 + (i)*0x1C + (off))

extern int  unit_chain_resolve(int idx);
extern int  unit_chain_next(int idx);
extern void unit_chain_unlink(int16_t idx);
extern void unit_place_on_tile(int16_t idx, int16_t x, int16_t y);
extern int  func_00BD28_op_sz_34(uint16_t x, uint16_t y);
extern int  func_0062B4_op_sz_39(uint16_t x, uint16_t y);
extern const char *viceroy_data_dir(void);

static int g_dest_x = -1, g_dest_y = -1;
void viceroy_set_move_dest(int x, int y) { g_dest_x = x; g_dest_y = y; }

/* ---- GAME.TXT @KEY message sections --------------------------------------- */
typedef struct { char prompt[256]; char opt[6][64]; int nopt, def; } msg_t;

static int load_msg(const char *key, msg_t *m)
{
    char path[512], line[256];
    snprintf(path, sizeof path, "%s/GAME.TXT", viceroy_data_dir());
    FILE *f = fopen(path, "r");
    if (!f) return -1;
    memset(m, 0, sizeof *m);
    m->def = 1;
    int in = 0, blank = 0;
    size_t klen = strlen(key);
    while (fgets(line, sizeof line, f)) {
        char *p = line + strspn(line, " \t");
        size_t len = strcspn(p, "\r\n"); p[len] = 0;
        if (p[0] == '@') {
            if (in) break;
            in = (p[1] && !strncmp(p+1, key, klen) &&
                  (p[1+klen] == 0));
            continue;
        }
        if (!in) continue;
        if (!p[0]) { if (m->prompt[0]) blank = 1; continue; }
        if (!strncmp(p, "@", 1)) continue;
        if (!blank) {
            if (m->prompt[0]) strncat(m->prompt, " ", sizeof m->prompt - strlen(m->prompt) - 1);
            strncat(m->prompt, p, sizeof m->prompt - strlen(m->prompt) - 1);
        } else if (m->nopt < 6) {
            strncpy(m->opt[m->nopt++], p, 63);
        }
    }
    fclose(f);
    /* directives: re-scan for @default within the section */
    f = fopen(path, "r"); in = 0;
    while (f && fgets(line, sizeof line, f)) {
        char *p = line + strspn(line, " \t");
        size_t len = strcspn(p, "\r\n"); p[len] = 0;
        if (p[0] == '@' && p[1] && !strncmp(p+1, key, klen) && p[1+klen] == 0) { in = 1; continue; }
        if (in && !strncmp(p, "@default=", 9)) { m->def = atoi(p+9); break; }
        if (in && p[0] == '@' && strncmp(p, "@width", 6) && strncmp(p, "@default", 8)) break;
    }
    if (f) fclose(f);
    return m->prompt[0] ? 0 : -1;
}

static int g_dialog_force = 0;
void viceroy_dialog_force(int n) { g_dialog_force = n; }   /* test hook */

int ovl_yesno_dialog(const char *key, int flag)
{
    (void)flag;
    msg_t m;
    if (g_dialog_force) {
        int n = g_dialog_force; g_dialog_force = 0;
        printf("dialog [%s]: (forced) -> %d\n", key, n);
        return n;
    }
    if (load_msg(key, &m) != 0) {
        printf("dialog [%s]: (section missing) -> 1\n", key);
        return 1;
    }
    printf("dialog [%s]: %s\n", key, m.prompt);
    for (int i = 0; i < m.nopt; i++)
        printf("   %d) %s%s\n", i+1, m.opt[i], (i+1 == m.def) ? "  (default)" : "");
    /* SDL: wait for 1..N / ENTER(default) / ESC(default); headless: default */
    extern int vid_poll_key(void);
    extern void vid_delay_ms(int);
    extern int viceroy_interactive(void);
    if (viceroy_interactive()) {
        for (;;) {
            int k = vid_poll_key();
            if (k == 0) { vid_delay_ms(16); continue; }
            if (k == 13 || k == 27) break;                 /* default */
            if (k >= '1' && k < '1' + m.nopt) {
                printf("dialog [%s]: -> %d\n", key, k - '0');
                return k - '0';
            }
        }
    }
    printf("dialog [%s]: -> %d\n", key, m.def);
    return m.def;
}

void ovl_popup_simple(const char *key, void *p, int z)
{
    (void)p; (void)z;
    msg_t m;
    printf("popup [%s]: %s\n", key, load_msg(key, &m) == 0 ? m.prompt : "");
}
void ovl_msg_simple(const char *key) { ovl_popup_simple(key, 0, 0); }

/* ---- the MOVE COMMIT ------------------------------------------------------ */
extern int unit_move_cost_thirds(int unit, int dest_x, int dest_y);
                       /* the cost head of func_03ECF0 (the executor the
                        * 0x1A1F:0x142 commit record resolves to); see
                        * src/unit/move_cost.c for the byte cites */
void ovl_landfall_unit(int unit_idx, int dy, int dx)
{
    /* price the step from the unit's CURRENT tile (the executor reads src
     * x/y from the record @0x3ED0F/0x3ED18) before relocating */
    int cost3 = unit_move_cost_thirds(unit_idx, dx, dy);

    /* relocate the unit (and implicitly its carried stack stays chained to
     * it through the cargo model) to (dx,dy) via the BYTE-VERIFIED pair */
    unit_chain_unlink((int16_t)unit_idx);
    unit_place_on_tile((int16_t)unit_idx, (int16_t)dx, (int16_t)dy);

    /* deduct the REAL cost (terrain Movement*3 / road / river / owned-clamp).
     * The shell tracks remaining thirds in UnitRecord +6; the executor's own
     * used-accumulator model (+5 vs allowance @0x3EE84..0x3EE9D) converges
     * when the full func_03ECF0 is ported. */
    {
        int mv = (int8_t)UB(unit_idx, 6);
        mv -= cost3;
        if (mv < 0) mv = 0;
        UB(unit_idx, 6) = (uint8_t)mv;
    }
}

void ovl_unload_at(int aux)
{
    if (aux < 0 || g_dest_x < 0) return;
    unit_chain_unlink((int16_t)aux);
    unit_place_on_tile((int16_t)aux, (int16_t)g_dest_x, (int16_t)g_dest_y);
    UB(aux, 8) = 0;                          /* clear orders */
    printf("landfall: unit %d ashore at %d,%d\n", aux, g_dest_x, g_dest_y);
}

int  ovl_landfall_begin(int unit_idx) { return unit_chain_resolve(unit_idx); }
int  ovl_landfall_next(int prev_idx)  { return unit_chain_next(prev_idx); }

void ovl_reveal_tile(int x, int y)    { func_00BD28_op_sz_34((uint16_t)x, (uint16_t)y); }
int  ovl_fortify_accum(int x, int y)  { return func_0062B4_op_sz_39((uint16_t)x, (uint16_t)y); }

void ovl_sailhome_191f(void)          { printf("sailhome: Europe transit (screen pending)\n"); }
void ovl_sailhome_fin(int unit_idx)   { (void)unit_idx; }
void ovl_shipcombat_fx(int x, int y, int a, int b, int c)
{ (void)a;(void)b;(void)c; printf("ship combat at %d,%d (fx pending)\n", x, y); }
void ovl_post_landfall(void)          { /* 0x181F:0xF6C overlay; pending */ }

int  power_scan_done(int power) { return DG8(0x543E + power*0x34) & 0x80; }
void power_scan_mark(int power) { DG8(0x543E + power*0x34) |= 0x80; }

#endif /* _VICEROY_MODERN */

/* ---- main-loop pickers (near 0x24BD7/0x24BA5: thunk records resolve past
 * EOF with the current segmap -- shell semantics, cite-marked pending the
 * segid re-fingerprint) ----------------------------------------------------- */
void mainloop_pick_next_unit(void)
{
    int n = (int16_t)DG16(0x539C);
    int cur = (int16_t)DG16(0x5392);
    for (int k = 1; k <= n; k++) {
        int i = (cur + k) % n;
        if ((int8_t)UB(i, 6) > 0 && UB(i, 8) == 0 &&
            (UB(i, 3) & 0x0F) == (DG16(0x5396) & 0x0F)) {
            DG16(0x5392) = (uint16_t)i;
            return;
        }
    }
    DG16(0x5392) = 0xFFFF;                        /* none left this rotation */
}

void mainloop_finish_rotation(void)
{
    /* new rotation: refresh movement from the @UNIT column (the original's
     * per-unit reset lives in the not-yet-located rotation engine) */
    int n = (int16_t)DG16(0x539C);
    for (int i = 0; i < n; i++)
        UB(i, 6) = DG8(0x5234 + UB(i, 2) * 9);
    DG16(0x538A)++;                                /* year tick (display) */
    DG16(0x5392) = 0;                              /* restart at unit 0 */
    printf("rotation: new turn, movement refreshed\n");
}

void ovl_deselect_fx(int x, int y) { (void)x; (void)y; /* 0x181F:0x9BA overlay fx */ }
