/* ============================================================================
 * rivers.c -- river / feature-spread pass of the map generator (P4)
 * ----------------------------------------------------------------------------
 * Reconstruction of the feature-spread pass INSIDE func_064A10 @0x064A10
 * (overlay page 0x14, disk image file 0x0633E0).  See generator.c header.
 *
 * DGROUP file base = 0x1D9A0 (BYTE_VERIFIED via @UNFORESTED @ file 0x1FB54 =
 * DS offset 0x21B4).  The neighbour kernel below lives in DGROUP const data.
 *
 * LOCATION (BYTE_VERIFIED): @asm 0x065A88 (re-zero layers 1 & 3) .. 0x065BED
 * (the double row/col loop just before the [bp+6] premade branch at 0x065BF0).
 *
 * WHAT THE PASS DOES (BYTE_VERIFIED control flow):
 *   Pre-step @0x065A88: zero the elevation scratch (layer1) and fog (layer3)
 *     via two lcall 0x181F:0x484 region fills (al=0).
 *   First sweep @0x065ADA..0x065B2F: for the western half (x < W/2) of each
 *     interior land row, stamp feature code 0x20 on the tile
 *     (push 1/push 0x20/lcall 0x181F:0x68C).  Sets the river-source marker.
 *   Main sweep @0x065BE0 (rows) / 0x065BA2 (cols): for every interior LAND tile
 *     (lcall 0x181F:0x768 = is-land test, @0x065BB0) whose flow probe
 *     (lcall 0x181F:0x718, @0x065BC2) does NOT return -1, walk the 20-entry
 *     neighbour kernel:
 *       @asm 0x065B3A  cmp [bp-0x18],0x14          ; 20 kernel entries
 *       @asm 0x065B40  bx = [bp-0x18]              ; k
 *       @asm 0x065B43  al = ds:[bx+0xDE]           ; dy table (signed byte)
 *       @asm 0x065B48  ny = y + dy
 *       @asm 0x065B4F  al = ds:[bx+0xC8]           ; dx table (signed byte)
 *       @asm 0x065B54  nx = x + dx
 *       @asm 0x065B5B  lcall 0x181F:0x302          ; in-bounds(nx,ny)?
 *       @asm 0x065B6D  lcall 0x181F:0x768          ; neighbour is land?
 *     If ALL probed neighbours are land/in-bounds ([bp-2] stays set), stamp
 *     feature code 4 on the centre tile:
 *       @asm 0x065B97  push 1 / push 4 / lcall 0x181F:0x68C
 *
 * THE NEIGHBOUR KERNEL — BYTE_VERIFIED (decoded 2026-05-30 from DGROUP):
 *   dx table @ DS 0xC8 (file 0x1DA68), dy table @ DS 0xDE (file 0x1DA7E),
 *   20 signed bytes each.  The 20 (dx,dy) pairs form an expanding ring:
 *     k0..3  cardinals r1 : (0,-1) (1,0) (0,1) (-1,0)
 *     k4..7  diagonals r1 : (-1,-1) (1,-1) (1,1) (-1,1)
 *     k8..11 cardinals r2 : (0,-2) (2,0) (0,2) (-2,0)
 *     k12..15            : (-1,-2) (1,-2) (-1,2) (1,2)
 *     k16..19            : (-2,-1) (-2,1) (2,-1) (2,1)
 *   raw dx: 00 01 00 ff ff 01 01 ff 00 02 00 fe ff 01 ff 01 fe fe 02 02
 *   raw dy: ff 00 01 00 ff ff 01 01 fe 00 02 00 fe fe 02 02 ff 01 ff 01
 *
 * INTERPRETATION (river network):
 *   Bit 6 (0x40) of the terrain byte is the river flag (MAP_FORMAT.md: forest+
 *   river = 0xC0, plain river = 0x40).  The feature codes 4 and 0x20 passed to
 *   0x181F:0x68C are the feature-layer codes the helper folds into the terrain
 *   river bit + the river-mouth marker on adjacent water.  0x181F:0x718 is the
 *   lowest-neighbour / flow-direction oracle (-1 = no downhill path).
 *
 * BYTE_VERIFIED vs not yet decoded:
 *   BYTE_VERIFIED : the 20-cell kernel CONTENTS (above), the loop bound 0x14,
 *                   the land/in-bounds gating helpers, the feature-stamp calls,
 *                   the -1 "no path" sentinel, the western-half source sweep.
 *   body in thunk page: the internals of helpers 0x181F:0x68C / 0x718 / 0x302 /
 *                   0x768 (overlay-thunk-resident); whether 0x68C sets bit 6
 *                   directly or via the feature layer is genuinely unknown.
 * ============================================================================ */
#include "viceroy_types.h"

extern uint16_t g_map_width;     /* DGROUP:0x853A */
extern uint16_t g_map_height;    /* DGROUP:0x853C */
extern uint8_t *g_layer_terrain; /* [0x15C] */

/* Overlay helpers used by the feature pass (BYTE_VERIFIED roles; body in thunk page). */
extern int  tile_in_bounds(int x, int y);                     /* lcall 0x181F:0x302 */
extern int  tile_is_land  (int x, int y);                     /* lcall 0x181F:0x768 */
extern void tile_set_feature(int x, int y, int code, int on); /* lcall 0x181F:0x68C (push on,code,y,x) */
extern int  tile_flow_probe(int x, int y);                    /* lcall 0x181F:0x718 (-1 = no path) */

/* modelled flat-layer terrain accessors (defined at end of this TU) */
uint8_t tile_read_terrain(int x, int y);
void    tile_write_terrain(int x, int y, uint8_t v);

#define FLAG_RIVER 0x40   /* terrain bit 6 (MAP_FORMAT.md river flag) */

/* The 20-entry neighbour kernel — BYTE_VERIFIED (DGROUP 0xC8 / 0xDE).
 * dx[k]/dy[k] are the column/row deltas of the k-th probed neighbour. */
#define RIVER_KERNEL_LEN 0x14   /* @asm 0x065B3A cmp [bp-0x18],0x14 */

static const signed char k_river_dx[RIVER_KERNEL_LEN] = {
    /* DS 0xC8: */  0, +1,  0, -1,  -1, +1, +1, -1,
                    0, +2,  0, -2,  -1, +1, -1, +1,
                   -2, -2, +2, +2
};
static const signed char k_river_dy[RIVER_KERNEL_LEN] = {
    /* DS 0xDE: */ -1,  0, +1,  0,  -1, -1, +1, +1,
                   -2,  0, +2,  0,  -2, -2, +2, +2,
                   -1, +1, -1, +1
};

/* ---------------------------------------------------------------------------
 * trace_all_rivers — the feature-spread pass (P4 of func_064A10).
 *
 * Byte-verified replay: for each interior land tile whose flow probe finds a
 * downhill path, probe all 20 kernel neighbours; if every probed neighbour is
 * land/in-bounds (the [bp-2] "all surrounded" flag survives), stamp the river
 * feature (code 4) on the centre tile and let the helper fold the 0x40 bit and
 * the adjacent river-mouth marker.  The helper internals are library-implementation-only (body in thunk page).
 * ------------------------------------------------------------------------- */
void trace_all_rivers(void)
{
    int x, y, k;

    /* @asm 0x065BE0 outer row loop / 0x065BA2 inner col loop (interior) */
    for (y = 0; y < (int)g_map_height; y++) {
        for (x = 0; x < (int)g_map_width; x++) {

            /* centre must be land (@asm 0x065BB0 lcall 0x181F:0x768) */
            if (!tile_is_land(x, y))
                continue;

            /* flow probe: inc ax / je -> skip when it returned -1
             * (@asm 0x065BC2 lcall 0x181F:0x718 ; 0x065BCA inc ax ; je) */
            if (tile_flow_probe(x, y) == -1)
                continue;

            /* walk the 20-cell kernel.  [bp-2] starts 0 and is set to 1 if any
             * probed neighbour is out-of-bounds-or-water; the centre is stamped
             * only when [bp-2] stays 0 (i.e. fully land-surrounded).
             * @asm 0x065B3A..0x065B85 / test at 0x065B87. */
            {
                int blocked = 0;
                for (k = 0; k < RIVER_KERNEL_LEN; k++) {
                    int nx = x + k_river_dx[k];      /* @0x065B54 add [bp-0x1e] */
                    int ny = y + k_river_dy[k];      /* @0x065B48 add [bp-0x24] */
                    /* @0x065B5B in-bounds AND @0x065B6D is-land; if not -> blocked */
                    if (!tile_in_bounds(nx, ny) || !tile_is_land(nx, ny)) {
                        blocked = 1;                 /* @0x065B79 mov [bp-2],1 */
                        break;
                    }
                }

                if (!blocked) {
                    /* stamp river feature on the centre tile.
                     * @asm 0x065B97 push 1 / push 4 / lcall 0x181F:0x68C */
                    tile_set_feature(x, y, 4, 1);

                    /* reflect MAP_FORMAT.md's 0x40 flag in the modelled layer. */
                    {
                        uint8_t t = tile_read_terrain(x, y);
                        tile_write_terrain(x, y, (uint8_t)(t | FLAG_RIVER));
                    }
                }
            }
        }
    }
}

/* thin shims so this TU compiles against the modelled flat layer */
extern uint8_t tile_read (uint8_t *layer, int x, int y);
extern void    tile_write(uint8_t *layer, int x, int y, uint8_t v);
uint8_t tile_read_terrain(int x, int y)            { return tile_read(g_layer_terrain, x, y); }
void    tile_write_terrain(int x, int y, uint8_t v){ tile_write(g_layer_terrain, x, y, v); }
