/* ============================================================================
 *  load_deserializer.c -- DOS Colonization game-state load (read path)
 * ----------------------------------------------------------------------------
 *  STATUS LEGEND (per viceroy_source/VERIFICATION_LEDGER.md):
 *    [BYTE_VERIFIED]   bytes read directly from COLONIZE/VICEROY.EXE
 *    [ANCHOR_VERIFIED] confirmed function/string anchor; value/order not byte-traced
 *    [TBD]             not located / not verified -- do NOT trust
 *
 *  -------------------------------------------------------------------------
 *  2026-05-30 BREAKTHROUGH (supersedes the "deserializer overlay-resident /
 *  [TBD]" framing):
 *  -------------------------------------------------------------------------
 *  The real DOS game-state DESERIALIZER is now LOCATED + BYTE-TRACED via the
 *  RTLink resolver. It is func_073BB0 @0x073BB0 (1901 bytes, ENTER 0x64,0) in
 *  overlay page 0x1A.  It is the exact symmetric counterpart of the SAVE driver
 *  func_0734F8 (see save_serializer.c) -- it replays the identical section
 *  order with fread (0xD1D:0x528) / block-read (0x1A1F:0xCB4).
 *
 *  HOW REACHED (byte-cited chain):
 *    LOAD orchestrator func_073158 @0x073158 (page 0x1A), gated by "LOADGAME"
 *    @file 0x1FABA (DGROUP 0x211A, pushed @0x073163). It builds the filename,
 *    then calls the LOAD DRIVER  LCALL 0x1A1F:0xD12 @0x0731BF  (one arg = name).
 *    0x1A1F:0xD12 resolves to overlay page 0x1A; with the page's SECOND
 *    load-segment code base 0x73270 (NOT the 0x72090 segment-list code_offset --
 *    see save_serializer.c header) offset 0x940 -> 0x73270+0x940 = 0x73BB0 =
 *    func_073BB0, byte-verified ENTER prologue (C8 64 00). [BYTE_VERIFIED]
 *
 *  ==> The CORRECTION about func_011F6E (below) still stands: 0x011F6E is the
 *      RTLink/overlay-EXE record reader (MZ-magic checker), NOT the savegame
 *      loader. The actual loader was the [TBD] overlay routine -- now resolved
 *      to func_073BB0.
 *
 *  DOS save HEADER (now byte-known, overturns "no magic"):
 *    "COLONIZE" + 0x1A (Ctrl-Z)   magic string   (strcmp on load @0x073C00)
 *    u16 version (vs g_save_version @0x81A)        version gate -> LOADOLD
 *    u16 map_width, u16 map_height                 size gate    -> LOADSIZE
 *
 *  LOAD RESULT CODES (set in [bp-0x56], mapped to message keys by func_073158):
 *    0 = LOADGOOD  @0x1FAC3   (success)
 *    1 = (memory/open) -> SAVEMEM @0x1FAA8 family
 *    2 = LOADNOT   @0x1FACC   (open fail OR magic strcmp mismatch @0x073C0C)
 *    3 = LOADOLD   @0x1FAD4   (version word < g_save_version @0x073C38)
 *    4 = LOADSIZE  @0x1FADC   (saved map W*H != current @0x073C7C)
 *    5 = SAVEMEM   @0x1FAA8   (compressed/alt path flag @0x15A set @0x073BCA)
 *
 *  @ref ../../../code/VICEROY/disasm_overlay_reseg/page_1A.asm  (func_073BB0 body)
 *  @ref ../../../code/VICEROY/disasm/func_011F6E_load_game_state.asm  (NOT the loader)
 *  @ref ../include/save.h
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"
#include "save.h"

/* ----------------------------------------------------------------------------
 *  Save-format constants (mirror of save_serializer.c, byte-verified).
 * ---------------------------------------------------------------------------- */
#define SAVE_MAGIC       "COLONIZE"   /* @bytes file 0x1FB1A  [BYTE_VERIFIED] */
#define SAVE_MODE_R      "rb"         /* @bytes file 0x1FB26  [BYTE_VERIFIED] */

#define UNIT_STRIDE      0x1C   /* 28  @asm @0x073D3C imul [0x539C],0x1C  [BYTE_VERIFIED] */
#define COLONY_STRIDE    0xCA   /* 202 @asm @0x073D17 imul [0x539E],0xCA  [BYTE_VERIFIED] */
#define POWER_BYTES      0x4F0  /* 1264 @asm @0x073D59 fixed 0x4F0        [BYTE_VERIFIED] */
#define NATIVE_STRIDE    0x12   /* 18  @asm @0x073D7A imul [0x539A],0x12  [BYTE_VERIFIED] */

/* In-memory table bases + counts (DGROUP). [BYTE_VERIFIED] -- same operands as save. */
extern uint8_t  g_unit_table[];    /* 0x3144 */
extern uint8_t  g_colony_table[];  /* 0x5D46 */
extern uint8_t  g_power_table[];   /* 0x8808 */
extern uint8_t  g_native_table[];  /* 0x54EC */
extern uint16_t g_native_count;    /* 0x539A */
extern uint16_t g_unit_count;      /* 0x539C */
extern uint16_t g_colony_count;    /* 0x539E */
extern uint16_t g_map_w;           /* 0x853A */
extern uint16_t g_map_h;           /* 0x853C */
extern uint16_t g_save_version;    /* 0x81A  (version gate; value [TBD]) */
extern void far *g_map_layer[4];   /* 0x15C/0x160/0x164/0x168 */
extern uint32_t  g_map_layer_bytes;/* 0x180:0x182 = W*H */

/* MSC-6.0 buffered C-runtime primitives (resident, window 0xD1D). [BYTE_VERIFIED]:
 *   fopen   0xD1D:0x4DA -> 0x0FAAA   fread  0xD1D:0x528 -> 0x0FAF8
 *   fclose  0xD1D:0x3F4 -> 0x0F9C4   strcmp 0xD1D:0x816 -> 0x0FDE6
 * Header string read helper get_magic 0x1A1F:0xDEE -> 0x0D6C4; block-read
 * (raw DOS read) 0x1A1F:0xCB4 -> resident 0x0D41E. */
typedef void *FILEP;
extern FILEP msc_fopen (const char *mode, const char *path); /* 0xD1D:0x4DA */
extern int   msc_fread (void far *p, int sz, int n, FILEP f);/* 0xD1D:0x528 */
extern int   msc_fclose(FILEP f);                            /* 0xD1D:0x3F4 */
extern int   msc_strcmp(const char far *a, const char far *b);/* 0xD1D:0x816 */
extern int   get_magic_string(FILEP f, char far *buf);       /* 0x1A1F:0xDEE @0xD6C4 */
extern int   blk_read(FILEP f, void far *p, uint32_t nbytes); /* 0x1A1F:0xCB4 (DOS read) */
extern void  free_far(void far *p);                          /* 0x191F:0x1A8 (free) */

/* C-runtime / RTLink record-stream reader -- NOT the savegame loader (see below). */
extern int  rtlink_read_records(int file_handle, int mode, int count, int init_flag);
                                    /* func_011F6E @0x011F6E -- overlay/EXE loader */

/* Block-read result step with the byte-cited "abort to error label" policy. */
#define LOAD_BLOCK(f, ptr, n, errcode)                          \
    do { if (msc_fread((void far *)(ptr), 1, (int)(n), (f)) == 0) \
             { result = (errcode); goto load_done; } } while (0)

/* ----------------------------------------------------------------------------
 *  load_savegame -- PORT of func_073BB0 @0x073BB0 (the LOAD driver).
 * ----------------------------------------------------------------------------
 *  BYTE_VERIFIED control flow. `path` = the "COLONY*.SAV" filename. Returns the
 *  result code (0=LOADGOOD .. 5=mem) the orchestrator func_073158 maps to a
 *  message key.
 *
 *  @asm ENTER 0x64,0 @0x073BB0 ; result([bp-0x56])=1; alloc_flag([bp-0x5C])=0  [BYTE_VERIFIED]
 *  @asm if [0x15A] set result=5 @0x073BCA                                       [BYTE_VERIFIED]
 *  @asm fopen("rb",path) 0xD1D:0x4DA @0x073BD5 ; NULL->done @0x073BE4           [BYTE_VERIFIED]
 *  @asm get_magic 0x1A1F:0xDEE @0x073BED ; strcmp vs "COLONIZE"(0x217A) 0xD1D:0x816
 *       @0x073C00 -> mismatch result=2 (LOADNOT)                                [BYTE_VERIFIED]
 *  @asm fread version(2) @0x073C1F ; cmp [0x81A]; if older result=3 (LOADOLD)
 *       @0x073C36                                                               [BYTE_VERIFIED]
 *  @asm fread mapsize(4) @0x073C4B ; vs [0x180:0x182]; mismatch result=4 (LOADSIZE)
 *       @0x073C7C  (when current map size==0, instead ALLOCATES via 0x1A1F:0xC72
 *       and sets alloc_flag) @0x073CA8                                          [BYTE_VERIFIED]
 *  @asm replay all data blocks in SAVE order via fread 0xD1D:0x528             [BYTE_VERIFIED]
 *  @asm replay map layers + tail via block-read 0x1A1F:0xCB4                   [BYTE_VERIFIED]
 *  @asm post-load fixups @0x074249.. (see below) ; result=0 (LOADGOOD)         [BYTE_VERIFIED]
 *  @asm done @0x073E3C: fclose; on (alloc_flag && error) free map bufs + 0 size [BYTE_VERIFIED]
 * ---------------------------------------------------------------------------- */
int load_savegame(const char *path)
{
    FILEP f;
    char  magic_buf[16];      /* [bp-0x50] header scratch */
    uint16_t saved_version;   /* [bp-0x5E] */
    uint32_t saved_mapsize;   /* [bp-0x5A] (long) */
    int   result = 1;         /* [bp-0x56] -- default error (memory/open) */
    int   alloc_flag = 0;     /* [bp-0x5C] -- set if this load allocated the map bufs */
    int   i;

    /* @asm 0x073BC3 : compressed/alt-path flag gate. */
    if (/* [0x15A] */ 0)
        result = 5;           /* -> SAVEMEM (compressed save unsupported here) */

    /* @asm 0x073BD5 : fopen("rb", path). NULL -> done (result stays 1). */
    f = msc_fopen(SAVE_MODE_R, path);
    if (f == 0)
        goto load_done;       /* -> LOADNOT (no such save) via orchestrator */

    /* @asm 0x073BED : read magic header string, then strcmp vs "COLONIZE". */
    get_magic_string(f, magic_buf);                 /* 0x1A1F:0xDEE */
    if (msc_strcmp((const char far *)magic_buf, (const char far *)SAVE_MAGIC) != 0) {
        result = 2;           /* @0x073C0C : not a COLONIZE save -> LOADNOT */
        goto load_done;
    }

    /* @asm 0x073C1F : version word; @0x073C31 cmp [0x81A]; saved<current -> LOADOLD. */
    LOAD_BLOCK(f, &saved_version, 2, 1);
    if (saved_version < g_save_version) {           /* @0x073C36 jge ok else: */
        result = 3;           /* LOADOLD */
        goto load_done;
    }

    /* @asm 0x073C4B : map size (long); @0x073C66 compare with current [0x180:0x182].
     *   If current map size is 0 (fresh), ALLOCATE the map buffers instead of a
     *   mismatch (alloc path @0x073CA8, sets alloc_flag). Otherwise mismatch->LOADSIZE. */
    LOAD_BLOCK(f, &saved_mapsize, 4, 1);
    if (g_map_layer_bytes == 0) {
        /* @0x073C84 : allocate map buffers sized to saved_mapsize (0x1A1F:0xC72).
         *   Allocation failure -> result=1; success sets alloc_flag. [ANCHOR body] */
        alloc_flag = 1;       /* @0x073CA8 */
        g_map_layer_bytes = saved_mapsize;
    } else if (saved_mapsize != g_map_layer_bytes) {
        result = 4;           /* @0x073C7C : LOADSIZE */
        goto load_done;
    }

    /* @asm 0x073CAD : map width/height (4) re-read into [0x853A] (the convert
     *   helper 0xD1D:0xD82 normalizes the long), then the fixed blocks. */
    LOAD_BLOCK(f, &g_map_w, 4, 1);                   /* width+height */
    LOAD_BLOCK(f, (uint8_t *)0x5380, 0x8E, 1);       /* global block */
    LOAD_BLOCK(f, (uint8_t *)0x540E, 0xD0, 1);       /* per-power names */
    LOAD_BLOCK(f, (uint8_t *)0x948E, 0x18, 1);

    /* @asm 0x073D0B.. : variable tables (counts come from the 0x5380 block just read). */
    if (g_colony_count)                              /* @0x073D0B cmp [0x539E],0 */
        LOAD_BLOCK(f, g_colony_table, (uint32_t)g_colony_count * COLONY_STRIDE, 1);
    if (g_unit_count)                                /* @0x073D30 cmp [0x539C],0 */
        LOAD_BLOCK(f, g_unit_table,   (uint32_t)g_unit_count   * UNIT_STRIDE, 1);
    LOAD_BLOCK(f, g_power_table, POWER_BYTES, 1);    /* @0x073D54 always 4*0x13C */
    if (g_native_count)                              /* @0x073D6E cmp [0x539A],0 */
        LOAD_BLOCK(f, g_native_table, (uint32_t)g_native_count * NATIVE_STRIDE, 1);

    /* @asm 0x073D92.. : the remaining fixed blocks, identical order to save. */
    LOAD_BLOCK(f, (uint8_t *)0x5AD6, 0x270, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9566, 0x0C, 1);
    LOAD_BLOCK(f, (uint8_t *)0x8CFC, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9298, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9408, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x940C, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9410, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9180, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9414, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9418, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x941C, 8, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9424, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9428, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x942C, 4, 1);
    LOAD_BLOCK(f, (uint8_t *)0x924C, 0x4C, 1);
    LOAD_BLOCK(f, (uint8_t *)0x947E, 0x10, 1);
    LOAD_BLOCK(f, (uint8_t *)0x95F2, 0x10, 1);
    LOAD_BLOCK(f, (uint8_t *)0x94A6, 0x40, 1);
    LOAD_BLOCK(f, (uint8_t *)0x94E6, 0x40, 1);
    LOAD_BLOCK(f, (uint8_t *)0x95B2, 0x40, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9526, 0x40, 1);
    LOAD_BLOCK(f, (uint8_t *)0x918C, 0x40, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9572, 0x40, 1);
    LOAD_BLOCK(f, (uint8_t *)0x944E, 8, 1);
    LOAD_BLOCK(f, (uint8_t *)0x0336, 1, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9184, 8, 1);
    LOAD_BLOCK(f, (uint8_t *)0x9622, 8, 1);
    LOAD_BLOCK(f, (uint8_t *)0x962A, 8, 1);
    LOAD_BLOCK(f, (uint8_t *)0x91CC, 0x80, 1);
    LOAD_BLOCK(f, (uint8_t *)0x8540, 2, 1);
    LOAD_BLOCK(f, (uint8_t *)0x853E, 2, 1);
    LOAD_BLOCK(f, (uint8_t *)0x0184, 2, 1);
    LOAD_BLOCK(f, (uint8_t *)0x017C, 2, 1);
    LOAD_BLOCK(f, (uint8_t *)0x017E, 2, 1);

    /* @asm 0x07407x.. : the FOUR map layers via the raw block-read 0x1A1F:0xCB4. */
    for (i = 0; i < 4; i++) {
        if (blk_read(f, g_map_layer[i], g_map_layer_bytes) == 0) { result = 1; goto load_done; }
    }

    /* @asm 0x074172..0x07423D : trailing block-read payloads (fixed sizes). */
    if (blk_read(f, (void far *)0x86F6, 0x10E) == 0) { result = 1; goto load_done; }
    if (blk_read(f, (void far *)0x85E8, 0x10E) == 0) { result = 1; goto load_done; }
    if (blk_read(f, (void far *)0x945E, 0x20)  == 0) { result = 1; goto load_done; }
    if (blk_read(f, (void far *)0x85C8, 0x20)  == 0) { result = 1; goto load_done; }
    /* @0x0741DA : 4 bytes into a stack temp [bp-0x62] (consumed by post-load) */
    if (blk_read(f, (void far *)0x8D80, 4)     == 0) { result = 1; goto load_done; }
    if (blk_read(f, (void far *)0x0190, 2)     == 0) { result = 1; goto load_done; }
    if (blk_read(f, (void far *)0x1B220 /*seg 0x1B22:0*/, 0x378) == 0) { result = 1; goto load_done; }

    /* ------------------------------------------------------------------ */
    /* POST-LOAD FIXUPS  [BYTE_VERIFIED control flow; helper bodies ANCHOR] */
    /*   @0x074249 : decode option byte [0x5386] bits 2/4/8 into [0xA2]/[0xA0]/  */
    /*               [0xA4]; if all set call 0x181F:0x4DE.                       */
    /*   @0x07427E : LCALL 0x181F:0x4CA with [0x83A6] -- palette/view re-setup    */
    /*               (the same call the SAVE driver makes to read it back).      */
    /*   @0x07428A : if (byte[0x5382] & 1) LCALL 0x1A1F:0xD2 else 0x1A1F:0xE0     */
    /*               -- two alternate "rebuild view/caches" entry points.        */
    /*   @0x07429D : if (handle [0x896:0x898] valid) LCALL 0x191F:0x45C with a   */
    /*               flag derived from (byte[0x5383] & 0x2000) -- a display/blit  */
    /*               refresh keyed to the loaded game.                           */
    /*   These are the DOS analogue of "recompute derived colony/production      */
    /*   state on load"; the precise rebuilds are in the called overlays (the    */
    /*   28-byte ColonyRecord 0xCA-vs-0xAE delta is recomputed, not loaded --    */
    /*   mechanism inside 0x1A1F:0xD2/0xE0, [ANCHOR]).                           */
    /* ------------------------------------------------------------------ */
    result = 0;               /* @0x074237 : LOADGOOD */

load_done:
    /* @asm 0x073E3C : close the file if open. */
    if (f /* [bp-0x64] */)
        msc_fclose(f);        /* 0xD1D:0x3F4 */
    /* @asm 0x073E4D : if (alloc_flag && error) free the map buffers we allocated,
     *   then zero the size long. Prevents a half-loaded map from being used. */
    if (alloc_flag && result != 0) {
        free_far(g_map_layer[0]);   /* 0x191F:0x1A8 */
        free_far(g_map_layer[1]);
        free_far(g_map_layer[2]);
        g_map_layer_bytes = 0;      /* [0x180:0x182]=0 */
    }
    return result;            /* [bp-0x56] */
}

/* ----------------------------------------------------------------------------
 *  load_game_state -- *NOT* the savegame loader.  [BYTE_VERIFIED reclassification]
 * ----------------------------------------------------------------------------
 *  @asm 0x011F6E..0x012101 (403 bytes)
 *  Kept for the historical correction record: 0x011F6E is the MSC/RTLink
 *  record-stream reader that loads VICEROY.EXE's OWN overlay segments. It
 *  MZ-magic-checks each 0x18-byte record (@0x01207A cmp word,0x4D5A /
 *  @0x012081 cmp word,0x5A4D) and counts executable records -- a savegame reader
 *  has no reason to. Its 0xAE alloc is RTLink scratch (NOT the ColonyRecord
 *  working buffer; that identification was the original bug). The genuine
 *  game-state deserializer is func_073BB0 above (now byte-traced), NOT this.
 *
 *  Should be RELOCATED to src/iolib/overlay_loader.c (kept here only to host the
 *  correction note; not moved, to honor one-feature-per-change).
 * ---------------------------------------------------------------------------- */
int load_game_state(int file_handle, int mode, int count, int init_flag)
{
    return rtlink_read_records(file_handle, mode, count, init_flag);
}

/* ----------------------------------------------------------------------------
 *  list_save_slots -- enumerate COLONY*.SAV files for the load menu.
 * ----------------------------------------------------------------------------
 *  @asm func_076642 @0x076642..0x076AEB (page 0x1B). The directory/glob lister
 *  that fills the "(EMPTY)"/named save-slot list. Unchanged from the prior
 *  verified analysis; it is what "SAVEGAME"@0x1FA96 / "(EMPTY)"@0x1FA8E xref.
 *  The slot-record struct written into the list is MSC dir-API internal -> [TBD];
 *  the glob/prefix logic + string xrefs remain [BYTE_VERIFIED].
 * ---------------------------------------------------------------------------- */
/* (Signature intentionally omitted -- slot-record struct still [TBD].) */
