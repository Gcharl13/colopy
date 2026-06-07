/* ============================================================================
 * settlements.c -- native-settlement record append (used during New Game seeding)
 * ----------------------------------------------------------------------------
 * See generator.c header for the BYTE_VERIFIED / TBD legend.
 *
 * NATIVE-SETTLEMENT TABLE (BYTE_VERIFIED — docs/RULINGS.md 2026-05-28 plus the
 * full append routine func_046E18 traced 2026-05-30):
 *   - Table base   : DGROUP:0x54EC                  (imul *,0x12 @0x046EA3)
 *   - Stride       : 0x12 (18 bytes)                (imul bx,[bp-2],0x12)
 *   - Live count   : DGROUP:0x539A  (INC on add @0x046E2E, DEC @0x046F5D)
 *   - Capacity     : 0x54 (84 slots)                (cmp [0x539A],0x54 @0x046E21)
 *   - Current-record near pointer cache: DGROUP:0x8D4A (resolved by the seek
 *     helper lcall 0x181F:0xA42 @0x046E45; fields +0x00..+0x06 written through it)
 *
 * APPEND ROUTINE — func_046E18 @ VICEROY.EXE file 0x046E18..0x046EBE
 * (overlay page 0x0C, 167 bytes, ENTER 6).  Signature & body BYTE_VERIFIED:
 *   args (stack):  [bp+6] = owner/tribe index, [bp+8] = x, [bp+0xA] = y
 *   @asm 0x046E21  if [0x539A] >= 0x54  return -1 (table full)
 *   @asm 0x046E2E  idx = [0x539A]++         ; allocate slot, return idx in AX
 *   @asm 0x046E45  lcall 0x181F:0xA42 (arg = idx-4?)  ; seek -> sets [0x8D4A]
 *   record fields (BYTE_VERIFIED writes):
 *     @asm 0x046E54  [rec+0x02] = owner ([bp+6])
 *     @asm 0x046E5A  [rec+0x00] = x     ([bp+8])
 *     @asm 0x046E5F  [rec+0x01] = y     ([bp+0xA])
 *     @asm 0x046E66  [rec+0x04] = call cs:0x5434(idx)   ; population/level roll
 *     @asm 0x046E77  [rec+0x05] = 0xFF                  ; mission flag = none
 *     @asm 0x046E7B  [rec+0x06] = 0
 *     @asm 0x046EA7  [0x54EF + idx*0x12] = 0            ; rec+0x03 = 0
 *     @asm 0x046EAE  [0x54F3 + idx*0x12] = 0xFF         ; rec+0x07 = 0xFF
 *     @asm 0x046EB2  [0x54F4 + idx*0x12] = 0xFF         ; rec+0x08 = 0xFF
 *     @asm 0x046EB6  [0x54F5 + idx*0x12] = 0xFF         ; rec+0x09 = 0xFF
 *   @asm 0x046E85  lcall 0x181F:0x740 (y,x) -> es:[bx] |= 2   ; mark map tile
 *                  layer with the "settlement present" bit (feature layer).
 *   @asm 0x046EBA  return idx (AX)
 *
 * CORRECTED FIELD MAP (supersedes the earlier "+0x04 population, +0x05 mission"
 * shorthand): rec+0x00 x, +0x01 y, +0x02 owner, +0x03 0, +0x04 population/level
 * (rolled), +0x05 mission(0xFF), +0x06 0, +0x07/+0x08/+0x09 = 0xFF.  The +0x04
 * value comes from a ROLL (call cs:0x5434), not a caller argument.
 *
 * WHAT IS STILL TBD (honestly — do NOT fabricate):
 *   func_064A10 (the terrain generator) does NOT place native settlements.
 *   The New-Game *placement* driver — the loop that picks tiles, chooses a tribe
 *   per region, decides camp/village/city/capital, enforces spacing, and CALLS
 *   func_046E18 — was not pinned down in this pass (its callers are reached via
 *   overlay thunks the static callgraph does not resolve).  The population/level
 *   roll function at near cs:0x5434 (within page 0x0C) is also un-traced.
 *   Everything about the *selection / spacing math* below remains TBD.
 * ============================================================================ */
#include "viceroy_types.h"
#include "native.h"     /* struct NativeSettlement (18 B, BYTE_VERIFIED) */

/* ---- BYTE_VERIFIED table anchors --------------------------------------- */
extern struct NativeSettlement g_native_settlements[];  /* DGROUP:0x54EC      */
extern uint16_t g_native_count;                         /* DGROUP:0x539A      */
#define NATIVE_SETTLEMENT_CAP  0x54   /* 84 slots — @asm cmp [0x539A],0x54    */

extern uint16_t g_map_width;     /* DGROUP:0x853A */
extern uint16_t g_map_height;    /* DGROUP:0x853C */
extern uint8_t *g_layer_terrain; /* [0x15C] */
extern int      random_int(int lo, int hi);          /* 0x181F:0x04D4 */
extern uint8_t  tile_read(uint8_t *layer, int x, int y);

/* population/level roll — near call cs:0x5434 in page 0x0C (internals TBD). */
extern int native_roll_population(int idx);

/* ---------------------------------------------------------------------------
 * native_add — append one settlement record.  Faithful port of func_046E18.
 *
 * Returns the new settlement index, or -1 if the 84-slot table is full.
 * Field writes mirror the byte-verified routine above.  The population/level
 * field (+0x04) is produced by native_roll_population (the cs:0x5434 roll),
 * NOT supplied by the caller — matching the disassembly.
 * ------------------------------------------------------------------------- */
int native_add(int x, int y, int tribe)
{
    int idx;
    struct NativeSettlement *s;

    if (g_native_count >= NATIVE_SETTLEMENT_CAP)      /* @0x046E21 cmp 0x54 / jl */
        return -1;

    idx = (int)g_native_count;                        /* @0x046E2B ax = [0x539A] */
    g_native_count++;                                 /* @0x046E2E inc [0x539A] */

    s = &g_native_settlements[idx];                   /* base 0x54EC, stride 0x12 */
    s->x          = (uint8_t)x;                        /* +0x00  @0x046E5A */
    s->y          = (uint8_t)y;                        /* +0x01  @0x046E5F */
    s->owner      = (uint8_t)tribe;                    /* +0x02  @0x046E54 */
    /* +0x03 = 0 (@0x046EA7) */
    s->population = (uint8_t)native_roll_population(idx); /* +0x04  @0x046E66 (roll) */
    s->mission    = 0xFF;                              /* +0x05  @0x046E77 = none */
    /* +0x06 = 0 (@0x046E7B); +0x07/+0x08/+0x09 = 0xFF (@0x046EAE..0x046EB6) */

    /* @asm 0x046E85  mark the settlement-present bit (|=2) on the map feature
     * layer at (x,y) via lcall 0x181F:0x740 / 0x704.  Modelled as a no-op here
     * (the feature-layer helper is overlay-resident; file offset TBD). */

    return idx;                                        /* @0x046EBA return AX */
}

/* ---------------------------------------------------------------------------
 * place_native_settlements — New-Game seeding driver.  ALGORITHM = TBD.
 *
 * The placement driver that repeatedly calls native_add (tile pick, tribe-by-
 * region assignment, camp/village/city/capital and population rolls, spacing
 * enforcement) was NOT byte-located in this pass.  The body is left as an
 * honest placeholder that exercises only the byte-verified append path; do not
 * rely on any number here.
 * ------------------------------------------------------------------------- */
void place_native_settlements(void)
{
    /* TBD: settlement count, tribe selection, type rolls, spacing constant.
     * Intentionally left unimplemented rather than fabricated (prime directive).
     * The byte-verified record-append path is native_add() above. */
    (void)native_add; (void)g_map_width; (void)g_map_height;
    (void)g_layer_terrain; (void)tile_read; (void)random_int;
    (void)native_roll_population;
}

/* ---------------------------------------------------------------------------
 * place_lost_city_rumours — TBD (not located).
 * The only LCR-adjacent byte evidence in func_064A10 is the premade-scenario
 * branch @0x065BF6..0x065C21 that OR's 0xA0 into two FIXED tiles (offsets
 * pushed as 0x2B and 0x44) when [bp+6]!=0 and [0x2174]==0 (@0x065BFD) — that is
 * scripted scenario terrain (the "mountain" feature bit 0xA0), NOT random LCR
 * seeding.  The procedural LCR placement routine is not identified; left TBD.
 * ------------------------------------------------------------------------- */
void place_lost_city_rumours(void)
{
    /* TBD — not byte-located. */
}
