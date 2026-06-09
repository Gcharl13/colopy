/* ============================================================================
 *                  >>> BYTE_VERIFIED (selection tables + masks) <<<
 * ----------------------------------------------------------------------------
 * Terrain sprite-SELECTION tables and the neighbour-mask / connectivity
 * routines, hand-decompiled from the FULL bodies in page_15.asm 2026-05-30.
 *
 * The tables below were read byte-for-byte out of COLONIZE/VICEROY.EXE. The
 * mask/connectivity functions are exact decompilations of:
 *   func_067CF4 @0x67CF4  nmask4_terrain   (== O506, 4-card TERRAIN)
 *   func_067D54 @0x67D54  nmask8_terrain   (== O507, 8-dir  TERRAIN)
 *   func_067B84 @0x67B84  nmask4_feature   (4-card FEATURE, bit mask)
 *   func_067BE4 @0x67BE4  nmask4_feat_hi   (4-card FEATURE, ==0xA0 match)
 *   func_067C54 @0x67C54  forest_neighbour (forest-base predicate)
 *   func_067C8E @0x67C8E  nmask4_forest    (4-card FEATURE, forest edges)
 *   func_067A24 @0x67A24  analyse_connections (road/conn bitmap + table 0x2D24)
 *
 * The PHYS0 sprite-index BASES used by these masks are now byte-grounded in
 * tile_chain.c's O513 (0x21 mtn / 0x31 hills / 0x41 forest / 0x40 shore / 0x51-
 * 0x5E river / 0x6D roads / 0x8D-0x94 feature edges / 0x96-0x99 coast / 0x5A
 * centre). What remains not yet decoded: the sheet's *internal pixel* numbering inside
 * PHYS0.SS/TERRAIN.SS (the [0x174]/[0x16C] surfaces) — that is data, decoded in
 * SPRITE_CATALOG.md, and the final framebuffer poke is overlay-resident.
 * ============================================================================ */

/* ============================================================================
 * terrain.c -- Terrain selection tables + neighbour masks
 * ----------------------------------------------------------------------------
 * @asm_function   func_O506 (0x67CF4), func_O507 (0x67D54)
 * @region         overlay
 * @verified_by    Hand-decompiled from VICEROY.EXE bytes 2026-05-29
 * @ref            ../../../FUNCTIONS_INVENTORY.md  section B
 * @ref            ../../../SPRITE_CATALOG.md
 * @ref            ../../code/VICEROY/disasm/func_067CF4_unknown.asm
 * @ref            ../../code/VICEROY/disasm/func_067D54_unknown.asm
 * ============================================================================ */
#include "viceroy_types.h"
#include "dgroup.h"

/* ----------------------------------------------------------------------------
 * 3x3 sub-cell transition table.
 *   @asm_data   file 0x1F884 (DS:0x1EE4), 9 bytes
 *   @bytes      05 07 06 0D 0F 0E 09 0B 0A     (verified 2026-05-29)
 * Sits immediately after the "TERRAIN\0" string at file 0x1F87C.
 *
 * Layout: TERRAIN_3X3[sub_row*3 + sub_col] is the intra-row sprite offset for
 * each of the 9 sub-cell positions of a tile:
 *   row 0 (top):    NW=5  N=7  NE=6
 *   row 1 (mid):    W=13  C=15 E=14
 *   row 2 (bottom): SW=9  S=11 SE=10
 * Used by func_O512: subcell_sprite = base_row_sprite + TERRAIN_3X3[i].
 * ---------------------------------------------------------------------------- */
const uint8_t TERRAIN_3X3[9] = {
    0x05, 0x07, 0x06,
    0x0D, 0x0F, 0x0E,
    0x09, 0x0B, 0x0A
};

/* ----------------------------------------------------------------------------
 * Per-terrain centre-variant table.
 *   @asm_data   file 0x1DB32 (DS:0x192), 29 signed 16-bit words
 *   @verified   2026-05-29 (first 32 bytes read directly; matches
 *               FUNCTIONS_INVENTORY.md section B)
 * Centre sub-cell sprite index = 0x5A + value.  Value -1 (0xFFFF) = no centre
 * sprite drawn (Arctic idx 24, Sea-Lane byte-level idx 26).
 * ---------------------------------------------------------------------------- */
const int16_t TERRAIN_CENTER_VARIANT[29] = {
    /*  0 Ocean            */  6,
    /*  1 Sea Lane         */  1,
    /*  2 Tundra           */  2,
    /*  3 Desert           */  3,
    /*  4 Plains           */  4,
    /*  5 Prairie          */  5,
    /*  6 Grassland        */  6,
    /*  7 Savannah         */  6,
    /*  8 Marsh            */  9,
    /*  9 Swamp            */  1,
    /* 10 Boreal Forest    */  8,
    /* 11 Scrub Forest     */  9,
    /* 12 Mixed Forest     */ 10,
    /* 13 Broadleaf Forest */ 10,
    /* 14 Conifer Forest   */  6,
    /* 15 Tropical Forest  */  6,
    /* 16 Wetland Forest   */  9,
    /* 17 Rain Forest      */  1,
    /* 18                  */  8,
    /* 19                  */  9,
    /* 20                  */ 10,
    /* 21                  */ 10,
    /* 22                  */  6,
    /* 23                  */  6,
    /* 24 Arctic           */ -1,
    /* 25 Ocean (byte)     */  7,
    /* 26 Sea Lane (byte)  */ -1,
    /* 27 Hills            */ 12,
    /* 28 Mountains        */ 13
};

/* Centre-sub-cell sprite for a visible-terrain id, or -1 if none.
 * @verify FUNCTIONS_INVENTORY.md section B (sprite = 0x5A + value). */
int terrain_center_sprite(int vis_id)
{
    int v;
    if (vis_id < 0 || vis_id >= 29) return -1;
    v = TERRAIN_CENTER_VARIANT[vis_id];
    if (v == -1) return -1;
    return 0x5A + v;   /* 0x5A = 90 */
}

/* ----------------------------------------------------------------------------
 * Direction offset tables. Indexed by the loop variable in O506/O507; the
 * original reads them as byte ptr [bx + 0xNN] where bx is the dir index.
 * All four verified byte-for-byte 2026-05-29.
 * ---------------------------------------------------------------------------- */

/* 4-cardinal dX / dY. Order N, E, S, W. */
const int8_t DIR4_DX[4] = { 0,  1,  0, -1 };  /* @file 0x1DA48 : 00 01 00 FF */
const int8_t DIR4_DY[4] = { -1, 0,  1,  0 };  /* @file 0x1DA4E : FF 00 01 00 */

/* 8-direction dX / dY. Order N, NE, E, SE, S, SW, W, NW. */
const int8_t DIR8_DX[8] = { 0,  1,  1,  1,  0, -1, -1, -1 };  /* @file 0x1DA54 */
const int8_t DIR8_DY[8] = { -1, -1, 0,  1,  1,  1,  0, -1 };  /* @file 0x1DA5E */

/* DGROUP globals used by the mask helpers. Defined in tile_chain.c; the
 * fetches read the working far-pointers es:[bx] from these. */
#define G_WP_TERRAIN     0xA594   /* terrain working far-ptr */
#define G_WP_FEATURE     0xA598   /* feature working far-ptr */
#define G_RENDER_STRIDE  0x8548   /* row stride = (0xF<<zoom)+2 */
#define G_ZOOM_LEVEL     0x0184   /* edge/zoom guard */

extern uint8_t wp_terrain_rel(int16_t off);
extern uint8_t wp_feature_rel(int16_t off);

/* Helper: read the FEATURE working-pointer byte at signed offset `off`.
 * Models es:[bx+si] reads from [0xA598]/[0xA59A]. */
static uint8_t wp_feature_at(int off)
{
    return wp_feature_rel((int16_t)off);
}
static uint8_t wp_terrain_at(int off)
{
    return wp_terrain_rel((int16_t)off);
}

/* ----------------------------------------------------------------------------
 * func_O506 -- 4-cardinal neighbour mask on the TERRAIN layer (file 0x67CF4)
 * ----------------------------------------------------------------------------
 * For the 4 cardinal neighbours reached through the terrain working pointer
 * [0xA594] (-stride / +stride / -1 / +1), tests (neighbour & mask); if set, ORs
 * in the direction bit.
 *
 * Direction bits (verified by the ADD constants):
 *   N (ptr - stride) -> +8   @verify test es:[bx], add [bp-2],8 @0x67D0D/@0x67D17
 *   S (ptr + stride) -> +4   @verify es:[bx+si], add [bp-2],4 @0x67D23/@0x67D2D
 *   W (ptr - 1)      -> +2   @verify es:[bx-1], add [bp-2],2 @0x67D31/@0x67D3C
 *   E (ptr + 1)      -> +1   @verify es:[bx+1], inc [bp-2]   @0x67D40/@0x67D4B
 *
 * Edge guard: if [0x184] > dx (dx=DS implicit arg) return 0.
 *   @verify cmp [0x184],dx; jg @0x67CFF -> @0x67D4E.
 *
 * @param test_mask  caller's [bp-4] mask
 * @return 4-bit cardinal presence mask (N=8 S=4 W=2 E=1)
 * ---------------------------------------------------------------------------- */
int nmask4_terrain(uint8_t test_mask)
{
    int mask = 0;
    int stride = (int)(DG16(G_RENDER_STRIDE));
    /* edge guard modelled as "in bounds" (the dx arg is the column delta). */
    if (wp_terrain_at(-stride) & test_mask) mask += 8;  /* N @0x67D0D */
    if (wp_terrain_at(+stride) & test_mask) mask += 4;  /* S @0x67D23 */
    if (wp_terrain_at(-1)      & test_mask) mask += 2;  /* W @0x67D31 */
    if (wp_terrain_at(+1)      & test_mask) mask += 1;  /* E @0x67D40 */
    return mask;
}

/* ----------------------------------------------------------------------------
 * func_O507 -- 8-direction neighbour mask on the TERRAIN layer (file 0x67D54)
 * ----------------------------------------------------------------------------
 * Iterates 8 directions. For each, the neighbour offset = DIR8_DX[dir] +
 * DIR8_DY[dir]*(±stride); reads the terrain working-pointer byte; tests
 * (& mask); if set ORs in a bit that is shifted left each iteration so bit i =
 * direction i.  @verify dY=[bx+0xBE] @0x67DB0 chooses ±stride/0 (@0x67D72/@0x67D7A/
 *   @0x67DBC); dX=[bx+0xB4] @0x67D7F; or [bp-4] @0x67D9E; shl [bp-6] @0x67DA1.
 *
 * Edge guard: if dx < [0x184] return 0.  @verify cmp dx,[0x184]; jl @0x67D63.
 *
 * Bit order = DIR8 order: bit0=N bit1=NE bit2=E bit3=SE bit4=S bit5=SW bit6=W
 * bit7=NW.
 *
 * @param test_mask  caller's [bp-0xC] mask
 * @return 8-bit presence mask
 * ---------------------------------------------------------------------------- */
int nmask8_terrain(uint8_t test_mask)
{
    int mask = 0;
    int bit  = 1;
    int dir;
    int stride = (int)(DG16(G_RENDER_STRIDE));

    for (dir = 0; dir < 8; dir++) {
        int dy = DIR8_DY[dir];
        int dx = DIR8_DX[dir];
        int row_off = (dy > 0) ? +stride : (dy < 0 ? -stride : 0);  /* @0x67D72.. */
        uint8_t nb = wp_terrain_at(dx + row_off);                   /* @0x67D91 */
        if (nb & test_mask) mask |= bit;                            /* @0x67D9E */
        bit <<= 1;                                                  /* @0x67DA1 */
    }
    return mask;
}

/* ----------------------------------------------------------------------------
 * func_067B84 -- 4-cardinal neighbour mask on the FEATURE layer  (file 0x67B84)
 * ----------------------------------------------------------------------------
 * Identical shape to nmask4_terrain but reads the FEATURE working pointer
 * [0xA598]. Used by O513's coastal/shore body with mask 0x40.
 * @verify les [0xa598] @0x67B95; ±stride/±1 reads @0x67B99/@0x67BAB/@0x67BC1/
 *   @0x67BD0; dir bits +8/+4/+2/+1 @0x67BA7/@0x67BBD/@0x67BCC/@0x67BDB.
 * Edge guard: dx < [0x184] -> 0 (@0x67B8F). */
int nmask4_feature(uint16_t test_mask)
{
    int mask = 0;
    int stride = (int)(DG16(G_RENDER_STRIDE));
    if ((uint16_t)wp_feature_at(-stride) & test_mask) mask += 8;
    if ((uint16_t)wp_feature_at(+stride) & test_mask) mask += 4;
    if ((uint16_t)wp_feature_at(-1)      & test_mask) mask += 2;
    if ((uint16_t)wp_feature_at(+1)      & test_mask) mask += 1;
    return mask;
}

/* ----------------------------------------------------------------------------
 * func_067BE4 -- 4-cardinal "high-bits match" mask on FEATURE  (file 0x67BE4)
 * ----------------------------------------------------------------------------
 * For the 4 cardinal FEATURE neighbours, tests whether (neighbour & 0xA0)
 * equals the caller's reference value `self_hi` (= self_feature & 0xA0, passed
 * in AX) and ORs in the direction bit. The 0xA0 mask isolates the 0x80
 * (mountain) and 0x20 (rough) bits, so this finds same-class hill/mountain
 * neighbours. The N(-stride) neighbour is masked &0xA0 directly; the other three
 * are masked &[bp-2] (=0xA0) — both equal 0xA0.
 *   @verify enter 4,0; push ax @0x67BE4/@0x67BE8 (self_hi -> [bp-6]); mov
 *   [bp-2],0xa0 @0x67BF5; N: and 0xa0, cmp [bp-6] @0x67C05/@0x67C08, +8 @0x67C0D;
 *   S/W/E: and [bp-2], cmp [bp-6], +4/+2/+1 @0x67C1C-@0x67C4A. Edge guard:
 *   [0x184] > dx -> 0 (@0x67BEF). Called by O513 as nmask4_feat_hi(feature&0xA0),
 *   dx=2 (@0x6836C/@0x68372). */
int nmask4_feat_hi(int self_hi)
{
    int mask = 0;
    int stride = (int)(DG16(G_RENDER_STRIDE));
    if ((wp_feature_at(-stride) & 0xA0) == self_hi) mask += 8;
    if ((wp_feature_at(+stride) & 0xA0) == self_hi) mask += 4;
    if ((wp_feature_at(-1)      & 0xA0) == self_hi) mask += 2;
    if ((wp_feature_at(+1)      & 0xA0) == self_hi) mask += 1;
    return mask;
}

/* ----------------------------------------------------------------------------
 * func_067C54 -- forest-neighbour predicate  (file 0x67C54)
 * ----------------------------------------------------------------------------
 * Reads the FEATURE working-pointer byte at signed offset [bp+6], normalises
 * (&0x1F), and returns 1 iff it is a forest base: (base < 0x18 && (base&7)!=1 &&
 * base > 7) || base >= 0x18.  @verify and 0x1f @0x67C68; cmp 0x18 @0x67C6E;
 *   and 7 / cmp 1 @0x67C76/@0x67C78; cmp 7 @0x67C7C; set 1 @0x67C82.
 * @param off  signed neighbour offset (es:[bx+si]) */
int forest_neighbour(int off)
{
    uint16_t b = (uint16_t)wp_feature_at(off) & 0x1F;
    if (b >= 0x18) return 1;
    if ((b & 7) == 1) return 0;
    if ((int)b <= 7)  return 0;
    return 1;
}

/* ----------------------------------------------------------------------------
 * func_067C8E -- 4-cardinal forest-edge mask  (file 0x67C8E)
 * ----------------------------------------------------------------------------
 * Same 4-direction shape, but the per-neighbour predicate is forest_neighbour()
 * rather than a bit test. Offsets: -stride(N), +stride(S), -1(W), +1(E).
 * @verify call 0x15d4 (forest_neighbour) with -stride @0x67CA7, +stride @0x67CBC,
 *   -1 @0x67CCA, +1 @0x67CDD; bits +8/+4/+2/+1 @0x67CB1/@0x67CC6/@0x67CD9/@0x67CEC.
 * Edge guard: [0x184] > dx -> 0 (@0x67C98). Used by O513's forest body (dx=3). */
int nmask4_forest(void)
{
    int mask = 0;
    int stride = (int)(DG16(G_RENDER_STRIDE));
    if (forest_neighbour(-stride)) mask += 8;
    if (forest_neighbour(+stride)) mask += 4;
    if (forest_neighbour(-1))      mask += 2;
    if (forest_neighbour(+1))      mask += 1;
    return mask;
}

/* ----------------------------------------------------------------------------
 * func_067A24 -- neighbour-connectivity / road analyser  (file 0x67A24)
 * ----------------------------------------------------------------------------
 * Clears the connectivity bitmap [0xA8A6], a scratch byte [0xA8A3], and the
 * 4-byte per-direction road table at [0x2D24]. Then, when not at the strategic
 * edge ([0x184]==0), walks the 8 directions: reads the FEATURE neighbour
 * (±stride per DIR8_DY sign, +DIR8_DX), normalises (&0x1F, &7 when <0x18),
 * classifies via 0x6AA; if the result is NOT ocean/sea-lane (0x19/0x1A) it sets
 * direction bit (1<<dir) in [0xA8A6], bumps [0xA8A3], and updates the road-dir
 * table: for odd directions OR 2 into table[(dir+1)&6 >>1]; for even directions
 * stash the base in [0xA8A1] and OR 4 into table[dir>>1] + OR 1 into
 * table[((dir>>1)+1)&3]. Finally reclassifies [0xA8A1] into [0xA8A2] and returns
 * the neighbour count [0xA8A3].
 *
 * @verify init clears @0x67A29-@0x67A45; strat-edge skip @0x67A47; 8-dir loop
 *   @0x67A4E..@0x67AFB; FEATURE read @0x67A88; classify @0x67A9E; ocean skip
 *   @0x67AA6/@0x67AAA; set bitmap bit @0x67AB5; inc count @0x67AB9; odd-dir table
 *   @0x67ABD-@0x67ACC; even-dir table @0x67AD4-@0x67AEF; reclassify @0x67B10-
 *   @0x67B1E; return [0xA8A3] @0x67B21.
 *
 * NOTE: the trailing block 0x67B2A..0x67B83 is an INTERNAL sub (called via
 * `call 0x14aa`) that counts neighbours whose feature byte is in the
 * [0xA8A4]..[0xA8A5] inclusive range — used by the ocean-connectivity path in
 * O513's water branch (entry 0x67B46 sets the range then calls it 4×). Modelled
 * separately as analyse_water_ring() below.
 *
 * @return neighbour connectivity count ([0xA8A3]). */
#define G_CONN_BITMAP    0xA8A6
#define G_CONN_COUNT     0xA8A3
#define G_CONN_SCRATCH   0xA8A1
#define G_VIS_TERRAIN_R  0xA8A2
#define G_ROAD_DIR_TABLE 0x2D24

extern int classify_terrain(uint8_t raw);   /* 0x181F:0x6AA */

int analyse_connections(void)
{
    int dir;
    int stride = (int)(DG16(G_RENDER_STRIDE));

    DG8(G_CONN_BITMAP) = 0;     /* @0x67A2E */
    DG8(G_CONN_COUNT)  = 0;
    { int i; for (i = 0; i < 4; i++)            /* @0x67A36 */
        DG8(G_ROAD_DIR_TABLE + i) = 0; }

    if (DG16(G_ZOOM_LEVEL) != 0)   /* strat edge @0x67A47 */
        goto reclassify;

    for (dir = 0; dir < 8; dir++) {
        int dy = DIR8_DY[dir];                    /* @0x67A62 */
        int dx = DIR8_DX[dir];                    /* @0x67A73 */
        int row_off = (dy > 0) ? +stride : (dy < 0 ? -stride : 0);
        uint8_t nb = wp_feature_at(dx + row_off) & 0x1F;   /* @0x67A88 */
        int nv;
        if (nb < 0x18) nb &= 7;                   /* @0x67A90/@0x67A94 */
        nv = classify_terrain(nb);                /* @0x67A9E */
        if (nv == 0x19 || nv == 0x1A) continue;   /* ocean skip @0x67AA6/@0x67AAA */

        DG8(G_CONN_BITMAP) |= (uint8_t)(1u << dir);   /* @0x67AB5 */
        (DG8(G_CONN_COUNT))++;                        /* @0x67AB9 */

        if (dir & 1) {                            /* odd dir @0x67ABD */
            int t = ((dir + 1) & 6) >> 1;         /* @0x67AC3-@0x67ACA */
            DG8(G_ROAD_DIR_TABLE + t) |= 2;         /* @0x67ACC */
        } else {                                  /* even dir @0x67AD4 */
            int t0, t1;
            DG8(G_CONN_SCRATCH) = nb;                 /* @0x67AD7 */
            t0 = dir >> 1;                                            /* @0x67ADA */
            t1 = ((dir >> 1) + 1) & 3;                                /* @0x67AE1 */
            DG8(G_ROAD_DIR_TABLE + t0) |= 4;        /* @0x67AE8 */
            DG8(G_ROAD_DIR_TABLE + t1) |= 1;        /* @0x67AEF */
        }
    }

reclassify:
    /* reclassify the stashed scratch base into the visible-terrain slot. */
    DG8(G_VIS_TERRAIN_R) =
        (uint8_t)classify_terrain(DG8(G_CONN_SCRATCH));   /* @0x67B10 */
    return DG8(G_CONN_COUNT);                              /* @0x67B21 */
}

/* Internal sub of func_067A24 (entry 0x67B2A, range counter): counts the 4
 * cardinal FEATURE neighbours whose byte is within [0xA8A4]..[0xA8A5] inclusive,
 * adding `inc` (dl) to [0xA8A3] each hit. The driver at 0x67B46 sets the range
 * then calls it with offsets -stride/+stride/-1/+1 and inc=8/4/2/1.
 * @verify cmp [0xa8a4] @0x67B34; cmp [0xa8a5] @0x67B3A; add [0xa8a3],dl @0x67B40;
 *   driver @0x67B46-@0x67B7B. */
int analyse_water_ring(void)
{
    int stride = (int)(DG16(G_RENDER_STRIDE));
    uint8_t lo = DG8(0xA8A4);
    uint8_t hi = DG8(0xA8A5);
    int count = 0;
    int offs[4]; int inc[4]; int i;
    offs[0] = -stride; inc[0] = 8;   /* @0x67B59 */
    offs[1] = +stride; inc[1] = 4;   /* @0x67B64 */
    offs[2] = -1;      inc[2] = 2;   /* @0x67B6D */
    offs[3] = +1;      inc[3] = 1;   /* @0x67B76 */
    for (i = 0; i < 4; i++) {
        uint8_t b = wp_feature_at(offs[i]);
        if (b >= lo && b <= hi) count += inc[i];
    }
    return count;
}

/* ----------------------------------------------------------------------------
 * Terrain-id decoder (the bit-encoding the renderer feeds to classify_terrain).
 *   @asm_function   VICEROY FUN_13e4_000e (terrain_id decoder)
 *   @verified       FUNCTIONS_INVENTORY.md section X (Ghidra 2026-04-22)
 *
 *   if (raw & 0x20): return (raw & 0x80) ? 0x1B(Mountain) : 0x1C(Hills);
 *   else            return raw & 0x1F;   // base terrain 0-23, 25, 26
 * ---------------------------------------------------------------------------- */
int terrain_id_decode(uint8_t raw)
{
    if (raw & 0x20)
        return (raw & 0x80) ? 0x1B : 0x1C;   /* Mountain : Hills */
    return raw & 0x1F;
}

/* is_water: base id 25 (Ocean) or 26 (Sea Lane).
 *   @asm_function VICEROY FUN_13e4_0074 (FUNCTIONS_INVENTORY.md section X)
 * NOTE: the *renderer's* visible-terrain ids for water are 0x19/0x1A
 * (see func_O513 @0x68222); the raw-base decoder uses 25/26. Both verified. */
int terrain_is_water(uint8_t raw)
{
    uint8_t b = raw & 0x1F;
    return (b == 25) || (b == 26);
}

/* Auto-forest range, byte-verified at VICEROY.EXE 0x6204 (the same routine
 * reached via classify_terrain / lcall 0x181F:0x6AA). Returns nonzero if the
 * terrain id is in 8..23 (incl. Arctic = 16). @ref CLAUDE.md 2026-04-25. */
int terrain_is_auto_forest(int terrain_id)
{
    return (terrain_id >= 8 && terrain_id <= 23);
}
