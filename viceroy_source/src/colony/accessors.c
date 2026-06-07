/* ============================================================================
 * colony/accessors.c — small bound-checked accessors for colony_t fields
 * ----------------------------------------------------------------------------
 * Each function in this file is a bound-checked or transformation accessor
 * that reads or writes a single colony_t field.  Most are 30-70 bytes of
 * assembly; the originals fall through past their RETF when out-of-bounds
 * (an idiom we capture here as explicit returns).
 * ============================================================================ */
#include "viceroy.h"

/* ============================================================================
 * current_unit_field_at_20
 * @asm 0x0090C8..0x0090E4  (29 bytes)  ENTER 2 / LEAVE / RETF
 * ============================================================================ */
int current_unit_field_at_20(int i)
{
    if ((unsigned)i >= ctx->population) {
        return ctx->population;       /* sentinel: out-of-range returns count */
    }
    return ctx->job_at_20[i];
}

/* ============================================================================
 * current_unit_field_at_40
 * @asm 0x009102..0x00911E  (29 bytes)  sister of 0x90C8
 * ============================================================================ */
int current_unit_field_at_40(int i)
{
    if ((unsigned)i >= ctx->population) {
        return ctx->population;
    }
    return ctx->unit_type_at_40[i];
}

/* ============================================================================
 * test_bit_at_8a
 * @asm 0x0085B2..0x0085D5  (34 bytes)
 * ============================================================================ */
int test_bit_at_8a(int bit_idx)
{
    return (ctx->bits_at_8a[bit_idx >> 3] & (1u << (bit_idx & 7))) != 0;
}

/* ============================================================================
 * set_or_clear_bit_at_8a
 * @asm 0x0085D6..0x00860D  (56 bytes; auto-detector split set/clear branches)
 * ============================================================================ */
void set_or_clear_bit_at_8a(int bit_idx, int set_flag)
{
    uint8_t *p = &ctx->bits_at_8a[bit_idx >> 3];
    uint8_t mask = 1u << (bit_idx & 7);
    if (set_flag) *p |=  mask;
    else          *p &= ~mask;
}

/* ============================================================================
 * set_or_clear_bit_at_84
 * @asm 0x0092E0..0x009317  (40 bytes; same pattern, +0x84 offset)
 * ============================================================================ */
void set_or_clear_bit_at_84(int bit_idx, int set_flag)
{
    uint8_t *p = &ctx->bits_at_84[bit_idx >> 3];
    uint8_t mask = 1u << (bit_idx & 7);
    if (set_flag) *p |=  mask;
    else          *p &= ~mask;
}

/* ============================================================================
 * unpack_nibble_at_60
 * @asm 0x008F2A..0x008F5F  (53 bytes)
 * ============================================================================ */
int unpack_nibble_at_60(int i)
{
    if ((unsigned)i >= ctx->population) {
        return 0;     /* original falls through past RETF; we return 0 */
    }
    uint8_t b = ctx->expertise_60[i >> 1];
    return (i & 1) ? ((b >> 4) & 0xF) : (b & 0xF);
}

/* ============================================================================
 * pack_nibble_at_60
 * @asm 0x008F6C..0x008FB3  (72 bytes)
 * ============================================================================ */
void pack_nibble_at_60(int i, int value)
{
    if ((unsigned)i >= ctx->population) return;
    if (value > 15) value = 15;

    uint8_t *p = &ctx->expertise_60[i >> 1];
    if (i & 1) {
        *p = (*p & 0x0F) | ((uint8_t)value << 4);
    } else {
        *p = (*p & 0xF0) | (uint8_t)value;
    }
}

/* ============================================================================
 * step_100_or_level_scaled
 * @asm 0x008D00..0x008D25  (38 bytes)
 * ============================================================================ */
int step_100_or_level_scaled(void)
{
    /* reads ColonyRecord+0x95 (field_at_95) — OPEN CONFLICT era-vs-food, see colony.h */
    if (ctx->field_at_95 == 0) return 100;
    return (ctx->field_at_95 + 1) * 100;
}

/* ============================================================================
 * find_pair_in_table_C8_DE
 * @asm 0x008892..0x0088CF  (62 bytes)  ENTER 4 / LEAVE / RETF
 *
 * Two parallel byte tables of 20 entries each at DGROUP:0xC8 and 0xDE.
 * Inputs are 1-based; -2 converts them to the table's 0-based domain.
 * ============================================================================ */
int find_pair_in_table_C8_DE(int key1, int key2)
{
    key1 -= 2;
    key2 -= 2;
    for (int i = 0; i < 20; i++) {
        if (g_pair_key1[i] == (uint8_t)key1 && g_pair_key2[i] == (uint8_t)key2) {
            return i;
        }
    }
    return -1;
}

/* ============================================================================
 * lookup_byte_from_pair
 * @asm 0x008956..0x008981  (44 bytes)
 * ============================================================================ */
int lookup_byte_from_pair(int key1, int key2)
{
    int idx = find_pair_in_table_C8_DE(key1, key2);
    if (idx < 0) return 0xFF;
    return ctx->tile_state_70[idx];
}

/* ============================================================================
 * blit_at_origin_if_pair_visible
 * @asm 0x008918..0x008955  (62 bytes)
 *
 * Far-call to overlay drawer at 0x37F:0x15E with translated coords.
 * ============================================================================ */
extern void overlay_call_037F_015E(int x, int y, int param, int arg3);

void blit_at_origin_if_pair_visible(int key1, int key2, int arg3)
{
    if (find_pair_in_table_C8_DE(key1, key2) < 0) return;
    int adj_x = key1 + (ctx->map_x - 2);
    int adj_y = key2 + (ctx->map_y - 2);
    overlay_call_037F_015E(adj_x, adj_y, 0x10, arg3);
}

/* ============================================================================
 * classify_pair_bounds
 * @asm 0x00929A..0x0092DF  (70 bytes; auto-detector split into 4 branches)
 * ============================================================================ */
int classify_pair_bounds(int primary, int secondary)
{
    int p_in = (unsigned)primary < ctx->population;
    int s_in = secondary < 0x13;
    if (p_in)  return s_in ? 0 : 2;
    else       return s_in ? 3 : 1;
}

/* ============================================================================
 * count_field_at_20_matching
 * @asm 0x009626..0x00965A  (53 bytes)
 * ============================================================================ */
int count_field_at_20_matching(uint8_t target)
{
    int tally = 0;
    for (int i = 0; i < ctx->population; i++) {
        if (current_unit_field_at_20(i) == target) tally++;
    }
    return tally;
}

/* ============================================================================
 * count_field_at_40_matching
 * @asm 0x00965C..0x009690  (53 bytes)
 * ============================================================================ */
int count_field_at_40_matching(uint8_t target)
{
    int tally = 0;
    for (int i = 0; i < ctx->population; i++) {
        if (current_unit_field_at_40(i) == target) tally++;
    }
    return tally;
}

/* ============================================================================
 * count_field_40_matches_field_20
 * @asm 0x009692..0x0096D9  (72 bytes)
 *
 * Counts colonists whose +0x40 field is a valid commodity (< 0x13) AND
 * matches their +0x20 field.  "Correctly-employed" colonist count.
 * ============================================================================ */
int count_field_40_matches_field_20(void)
{
    int tally = 0;
    for (int i = 0; i < ctx->population; i++) {
        int field40 = current_unit_field_at_40(i);
        int field20 = current_unit_field_at_20(i);
        if (field40 < 0x13 && field40 == field20) tally++;
    }
    return tally;
}

/* ============================================================================
 * find_nth_match_in_field_at_20
 * @asm 0x0096DA..0x009725  (75 bytes)
 *
 * Returns the index of the Nth slot whose +0x20 field equals `target`,
 * or -1 if there are fewer than N matches.
 * ============================================================================ */
int find_nth_match_in_field_at_20(uint8_t target, int n)
{
    int hits = 0;
    for (int i = 0; i < ctx->population; i++) {
        if (ctx->job_at_20[i] == target) {
            if (++hits == n) return i;
        }
    }
    return -1;
}

/* ============================================================================
 * nibble_to_4_tier_quantity
 * @asm 0x009184..0x0091CB  (72 bytes; auto-detector split into 4 branches)
 *
 * Bucketizes the 0..15 packed nibble into a 4-tier UI display value.
 * ============================================================================ */
int nibble_to_4_tier_quantity(int i)
{
    int n = unpack_nibble_at_60(i);
    if (n == 15) return 3;
    if (n >= 8)  return 2;
    if (n >= 4)  return 1;
    return 0;
}
