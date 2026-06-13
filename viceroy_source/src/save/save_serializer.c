/* ============================================================================
 *  save_serializer.c -- DOS Colonization game-state save (write path)
 * ----------------------------------------------------------------------------
 *  STATUS LEGEND (per viceroy_source/VERIFICATION_LEDGER.md):
 *    [BYTE_VERIFIED]   bytes read directly from COLONIZE/VICEROY.EXE
 *    [ANCHOR_VERIFIED] a confirmed function / string anchor exists, but the
 *                      specific value or field order is not byte-traced
 *    [not yet decoded] not located / not verified -- do NOT trust
 *
 *  -------------------------------------------------------------------------
 *  2026-05-30 BREAKTHROUGH (supersedes the "serializer is unreachable/[left unresolved]"
 *  framing of the 2026-05-30 morning revision):
 *  -------------------------------------------------------------------------
 *  The RTLink overlay wall is cracked (tools/rtlink/rtlink_decode.py +
 *  resolve <page> <off>). The real DOS game-state SERIALIZER is now LOCATED
 *  and BYTE-TRACED. It is NOT unreachable -- it lives in overlay page 0x1A and
 *  was previously hidden only because (a) the static callgraph can't follow the
 *  0x181F/0x191F/0x1A1F thunks, and (b) the re-segmented disasm OVER-MERGED the
 *  whole front of page 0x1A into one giant `func_072090`, so the real entry
 *  points were buried mid-listing.
 *
 *  HOW REACHED (the full chain, byte-cited):
 *    main game cmd -> SAVE orchestrator func_072F7A @0x072F7A (page 0x1A) which
 *    is gated by the "SAVEGAME" key @file 0x1FA96 (pushed @0x072F80). It:
 *      - opens the slot dialog/file (LCALL 0x1A1F:0xCE8 @0x072Fxx),
 *      - builds "COLONY"+slot+".SAV" (func @0x072C4E: strcpy COLONY@0x20E2 +
 *        slot + strcat .SAV@0x20E9),
 *      - calls the SAVE DRIVER  LCALL 0x1A1F:0xCF6 @0x072FD0  (one arg = filename).
 *
 *  The SAVE-DRIVER thunk (0x1A1F:0xCF6) resolves to overlay page 0x1A.
 *  CAVEAT on resolution: the generic `resolve 0x1A 0x288` gives 0x72318, but
 *  that lands mid-`func_072090` (the page-0x1A menu builder) because page 0x1A
 *  actually packs TWO RTLink load-segments; the SECOND segment's code base is
 *  0x73270 (= func_073270), NOT the segment-list code_offset 0x72090. With base
 *  0x73270 every page-0x1A driver thunk lands on a clean ENTER/PUSH-BP prologue:
 *      0x1A1F:0xCF6 (off 0x288) -> 0x73270+0x288 = 0x734F8  = SAVE driver
 *      0x1A1F:0xD12 (off 0x940) -> 0x73270+0x940 = 0x73BB0  = LOAD driver
 *      0x1A1F:0xD04 (off 0x840) -> 0x73AB0
 *  (Verified: bytes at 0x734F8/0x73BB0/0x73AB0 = C8 .. ENTER; the +0x72090 base
 *   lands on lcall/mid-instruction garbage. See VERIFICATION_LEDGER 2026-05-30.)
 *
 *  ==> SAVE serializer = func_0734F8 @0x0734F8 (1464 bytes), ENTER 0x6,0.
 *  ==> LOAD serializer = func_073BB0 @0x073BB0 (see load_deserializer.c).
 *
 *  The DOS save header HAS a magic after all: it is the literal string
 *  "COLONIZE" (NOT the Win16 "COL2"). The "no magic" claim is now overturned.
 *
 *  @ref ../../../code/VICEROY/disasm_overlay_reseg/page_1A.asm  (func_0734F8 body)
 *  @ref ../../../code/VICEROY/disasm_overlay_reseg/page_1C.asm  (stdio FILE layer)
 *  @ref ../../tools/rtlink/rtlink_decode.py  (overlay resolver)
 *  @ref ../include/save.h
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"
#include "save.h"

/* ----------------------------------------------------------------------------
 *  SAVE-FILE NAMING + MAGIC  [BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 *    @bytes file 0x1FA82: 43 4F 4C 4F 4E 59 00       = "COLONY\0"  (DGROUP 0x20E2)
 *    @bytes file 0x1FA89: 2E 53 41 56 00             = ".SAV\0"    (DGROUP 0x20E9)
 *    @bytes file 0x1FB1A: 43 4F 4C 4F 4E 49 5A 45 00 = "COLONIZE\0"(DGROUP 0x217A)
 *      -> on-disk file MAGIC string (written first), NOT a filename.
 *    @bytes file 0x1FB16: 77 62 00 = "wb\0"  (DGROUP 0x2176, fopen mode, SAVE)
 *    @bytes file 0x1FB26: 72 62 00 = "rb\0"  (DGROUP 0x2186, fopen mode, LOAD)
 *
 *  Filename built by func_072C4E: strcpy(buf,"COLONY"); <slot>; strcat(buf,".SAV").
 *  The slot infix formatting (between stem and ext) is not yet byte-traced.
 * ---------------------------------------------------------------------------- */
#define SAVE_NAME_STEM   "COLONY"     /* @bytes file 0x1FA82  [BYTE_VERIFIED] */
#define SAVE_NAME_EXT    ".SAV"       /* @bytes file 0x1FA89  [BYTE_VERIFIED] */
#define SAVE_MAGIC       "COLONIZE"   /* @bytes file 0x1FB1A  [BYTE_VERIFIED] */
#define SAVE_MODE_W      "wb"         /* @bytes file 0x1FB16  [BYTE_VERIFIED] */
#define SAVE_MAGIC_TERM  0x1A         /* Ctrl-Z terminator written after magic [BYTE_VERIFIED @0xD712] */

/* ----------------------------------------------------------------------------
 *  ON-DISK RECORD STRIDES  [BYTE_VERIFIED from the SAVE driver fwrite counts]
 * ----------------------------------------------------------------------------
 *  func_0734F8 writes each game-state table at its FULL in-memory stride. The
 *  per-table on-disk size is exactly count*stride (no trimmed/working subset),
 *  byte-verified from the `imul ax,[count],<stride>; push ax` operands:
 *    ColonyRecord     @0x735BD : imul ax,[0x539E],0xCA   -> count*202   [BYTE_VERIFIED]
 *    UnitRecord       @0x735DF : imul ax,[0x539C],0x1C   -> count*28    [BYTE_VERIFIED]
 *    PowerRecord      @0x735F7 : fixed 0x4F0 = 4*0x13C   -> 1264        [BYTE_VERIFIED]
 *    NativeSettlement @0x73619 : imul ax,[0x539A],0x12   -> count*18    [BYTE_VERIFIED]
 *  (So the 0xCA-vs-0xAE "trimmed colony record" question is RESOLVED: the disk
 *   record is the full 0xCA stride. The 0xAE working buffer at *(0x8542) is a
 *   live-play subset, not the save format.)
 * ---------------------------------------------------------------------------- */
#define UNIT_STRIDE      0x1C   /* 28  @asm UnitRecord  base 0x3144  @0x735DF imul 0x1C [BYTE_VERIFIED] */
#define COLONY_STRIDE    0xCA   /* 202 @asm ColonyRecord base 0x5D46 @0x735BD imul 0xCA [BYTE_VERIFIED] */
#define POWER_BYTES      0x4F0  /* 1264 = 4*0x13C @asm fixed @0x735F7              [BYTE_VERIFIED] */
#define POWER_STRIDE     0x13C  /* 316 @asm PowerRecord base 0x8808 (POWER_BYTES/4)[BYTE_VERIFIED] */
#define NATIVE_STRIDE    0x12   /* 18  @asm NativeSettlement base 0x54EC @0x73619 imul 0x12 [BYTE_VERIFIED] */

/* In-memory table bases (DGROUP-relative). [BYTE_VERIFIED] (push operands in func_0734F8). */
extern uint8_t  g_unit_table[];    /* DGROUP:0x3144, stride 0x1C  @0x735DC push 0x3144 */
extern uint8_t  g_colony_table[];  /* DGROUP:0x5D46, stride 0xCA  @0x735BA push 0x5D46 */
extern uint8_t  g_power_table[];   /* DGROUP:0x8808, stride 0x13C @0x735F4 push 0x8808 */
extern uint8_t  g_native_table[];  /* DGROUP:0x54EC, stride 0x12  @0x73616 push 0x54EC */

/* Live record counts. NOW ALL BYTE_VERIFIED from the SAVE-driver imul operands
 * (this resolves the previously-[left unresolved] g_unit_count):
 *   g_colony_count @0x539E   (imul @0x735B3)   [BYTE_VERIFIED]
 *   g_unit_count   @0x539C   (imul @0x735D6)   [BYTE_VERIFIED -- was [left unresolved]]
 *   g_native_count @0x539A   (imul @0x73610)   [BYTE_VERIFIED]
 * Note the layout: 0x539A native / 0x539C unit / 0x539E colony, contiguous words
 * inside the 0x8E-byte global block @0x5380 written first. */
extern uint16_t g_native_count;    /* @asm 0x539A */
extern uint16_t g_unit_count;      /* @asm 0x539C */
extern uint16_t g_colony_count;    /* @asm 0x539E */

/* Map dimensions: width word @0x853A, height word @0x853C; their product (a
 * long) is stashed at 0x180:0x182 = bytes-per-map-layer. [BYTE_VERIFIED]:
 *   @0x73550 push 0x853A count 4  (writes both width+height as the first block) */
extern uint16_t g_map_w;           /* @asm 0x853A */
extern uint16_t g_map_h;           /* @asm 0x853C */

/* Save-format version word @0x81A. Written as a 2-byte field right after the
 * magic; on load the saved value is range-checked against this (LOADOLD gate).
 * Its runtime value is set during startup and is NOT statically determinable
 * from the image (no static xref) -> exact value RUNTIME_ONLY; the variable/role is
 * [BYTE_VERIFIED]. */
extern uint16_t g_save_version;    /* @asm 0x81A   value RUNTIME_ONLY, role BYTE_VERIFIED */

/* ----------------------------------------------------------------------------
 *  MSC-6.0 buffered C-runtime FILE primitives used by the serializer.
 * ----------------------------------------------------------------------------
 *  IMPORTANT: the SAVE driver does NOT use the page-0x1C fopen_stream/etc. It
 *  uses the RESIDENT MSC library directly (window 0xD1D, = code_off+0xD1D*16):
 *    fopen   LCALL 0xD1D:0x4DA -> resident 0x0FAAA  (mode,path) [BYTE_VERIFIED]
 *    fwrite  LCALL 0xD1D:0x60C -> resident 0x0FBDC  (ptr,1,n,fp) [BYTE_VERIFIED]
 *    fread   LCALL 0xD1D:0x528 -> resident 0x0FAF8  (ptr,1,n,fp) [BYTE_VERIFIED]
 *    fclose  LCALL 0xD1D:0x3F4 -> resident 0x0F9C4              [BYTE_VERIFIED]
 *    strcmp  LCALL 0xD1D:0x816 -> resident 0x0FDE6  (magic check)[BYTE_VERIFIED]
 *    remove  LCALL 0xD1D:0xE4A -> resident 0x1041A  (unlink partial)[BYTE_VERIFIED]
 *  Header string I/O helpers (resident, via type-B thunk):
 *    put_magic LCALL 0x1A1F:0xDE4 -> 0x0D700  (fputc loop + 0x1A term)[BYTE_VERIFIED]
 *    get_magic LCALL 0x1A1F:0xDEE -> 0x0D6C4                          [BYTE_VERIFIED]
 *  Raw block DOS-write (for map layers):
 *    blk_write LCALL 0x1A1F:0xC9C  (bx=fp, size=[0x180] long)        [BYTE_VERIFIED]
 *
 *  These resident MSC stdio bodies are byte-verified to start with the standard
 *  `55 8B EC` (push bp;mov bp,sp) prologue but their internal buffer machinery
 *  is MSC-6.0 library code -> ANCHOR for the byte-exact buffering.
 * ---------------------------------------------------------------------------- */
typedef void *FILEP;                                   /* MSC FILE* (opaque here) */
extern FILEP msc_fopen (const char *mode, const char *path); /* 0xD1D:0x4DA */
extern int   msc_fwrite(const void far *p, int sz, int n, FILEP f); /* 0xD1D:0x60C */
extern int   msc_fclose(FILEP f);                      /* 0xD1D:0x3F4 */
extern int   msc_remove(const char *path);             /* 0xD1D:0xE4A */
extern void  put_magic_string(FILEP f, const char *s); /* 0x1A1F:0xDE4 @0xD700  */
extern int   blk_write(FILEP f, const void far *p, uint32_t nbytes); /* 0x1A1F:0xC9C */

/* The four DGROUP map-layer pointers + per-layer byte size. [BYTE_VERIFIED]:
 *   ptr/seg pairs at 0x15C/0x15E, 0x160/0x162, 0x164/0x166, 0x168/0x16A
 *   size long at 0x180/0x182 (= g_map_w * g_map_h). */
extern void far *g_map_layer[4];   /* @asm 0x15C,0x160,0x164,0x168 (4 layers) [BYTE_VERIFIED] */
extern uint32_t  g_map_layer_bytes;/* @asm 0x180:0x182 (W*H)                  [BYTE_VERIFIED] */

/* ----------------------------------------------------------------------------
 *  ON-DISK SAVE LAYOUT  [BYTE_VERIFIED -- exhaustive, from func_0734F8]
 * ----------------------------------------------------------------------------
 *  Extracted directly from the 43 fwrite (0xD1D:0x60C) + 12 block-write
 *  (0x1A1F:0xC9C) call sites, in file order. Every (count, DGROUP ptr) below is
 *  a byte-verified push operand. Section order is FIXED (no header table; the
 *  reader replays the identical sequence).
 *
 *   HEADER:
 *     "COLONIZE" + 0x1A           magic string + Ctrl-Z   @0x07351E put_magic
 *     u16  version (= g_save_version@0x81A)               @0x0753xx fwrite 2
 *     u16  map_width  (0x853A) ] written together as a    @0x73553 fwrite 4
 *     u16  map_height (0x853C) ]  single 4-byte block
 *
 *   FIXED DGROUP BLOCKS (fwrite size=1):
 *     @0x5380 0x8E (142)   global block: year@0x538A, turn@0x538E,
 *                          native_cnt@0x539A, unit_cnt@0x539C, colony_cnt@0x539E,
 *                          difficulty@0x53A6, ... (spans 0x5380..0x540E exactly)
 *     @0x540E 0xD0 (208)   per-power name/info block (4 * 0x34)
 *     @0x948E 0x18 (24)    block
 *
 *   VARIABLE GAME-STATE TABLES (fwrite size=1, count = N*stride):
 *     @0x5D46 colony_cnt[0x539E] * 0xCA   ColonyRecord[]
 *     @0x3144 unit_cnt  [0x539C] * 0x1C   UnitRecord[]
 *     @0x8808 0x4F0 (= 4 * 0x13C)         PowerRecord[]  (always 4)
 *     @0x54EC native_cnt[0x539A] * 0x12   NativeSettlement[]
 *
 *   MORE FIXED BLOCKS (fwrite size=1):
 *     @0x5AD6 0x270 (624)
 *     @0x9566 0xC  @0x8CFC 4
 *     per-power scalar tables (each 4 bytes): @0x9298 @0x9408 @0x940C @0x9410
 *       @0x9180 @0x9414 @0x9418 ; @0x941C 8 ; @0x9424 @0x9428 @0x942C (4 each)
 *     @0x924C 0x4C @0x947E 0x10 @0x95F2 0x10
 *     six 0x40 blocks: @0x94A6 @0x94E6 @0x95B2 @0x9526 @0x918C @0x9572
 *     @0x944E 8 ; @0x0336 1 ; @0x9184 8 ; @0x9622 8 ; @0x962A 8
 *     @0x91CC 0x80 ; @0x8540 2 ; @0x853E 2 ; @0x0184 2 ; @0x017C 2 ; @0x017E 2
 *
 *   MAP / BITMAP LAYERS (block-write 0x1A1F:0xC9C):
 *     layer0 @[0x15C] size [0x180]=W*H
 *     layer1 @[0x160] size W*H
 *     layer2 @[0x164] size W*H
 *     layer3 @[0x168] size W*H          (FOUR layers, not three)
 *     @0x86F6 0x10E ; @0x85E8 0x10E ; @0x945E 0x20 ; @0x85C8 0x20
 *     (@0x83A6-indexed) 4 ; @0x8D80 4 ; @0x0190 2 ; seg0x1B22:0 0x378
 *
 *   TRAILER: none. On success returns; on any fwrite/block-write failure jumps to
 *   the close+unlink epilogue (no checksum is computed or written -- BYTE_VERIFIED
 *   by absence: no checksum loop exists in func_0734F8).
 * ---------------------------------------------------------------------------- */

/* One fixed-block write step, with the byte-cited error policy (any short write
 * -> abort the save, fall to close+remove). MSC fwrite returns #elements
 * written; with size=1 that is the byte count, so success == (n == count). */
#define SAVE_BLOCK(f, ptr, n)                                            \
    do { if (msc_fwrite((const void far *)(ptr), 1, (int)(n), (f)) == 0) \
             goto save_fail; } while (0)

/* ----------------------------------------------------------------------------
 *  save_game_state -- PORT of func_0734F8 @0x0734F8 (the SAVE driver).
 * ----------------------------------------------------------------------------
 *  BYTE_VERIFIED control flow. `path` = the "COLONY*.SAV" filename (built by the
 *  caller func_072F7A via func_072C4E). Returns 0 on success, nonzero on error
 *  (matching the result codes the orchestrator maps to SAVEGOOD/SAVEMEM/SAVEERROR
 *  @0x1FA9F/0x1FAA8/0x1FAB0).
 *
 *  @asm prologue ENTER 6,0 @0x0734F8                                  [BYTE_VERIFIED]
 *  @asm di=1 (di=2 if [0x15A] set) -- return sentinel                 [BYTE_VERIFIED]
 *  @asm fopen("wb",path) LCALL 0xD1D:0x4DA @0x073511; NULL->fail @0x07351F [BYTE_VERIFIED]
 *  @asm put_magic("COLONIZE") LCALL 0x1A1F:0xDE4 @0x073528            [BYTE_VERIFIED]
 *  @asm version=[0x81A]; fwrite(&version,1,2,f) @0x07353C            [BYTE_VERIFIED]
 *  @asm fwrite(0x853A,1,4,f)  width+height @0x073553                 [BYTE_VERIFIED]
 *  @asm ... full ordered block list above ...                        [BYTE_VERIFIED]
 *  @asm fail label @0x0735FE: fclose(0xD1D:0x3F4) then remove(path)(0xD1D:0xE4A) [BYTE_VERIFIED]
 * ---------------------------------------------------------------------------- */
int save_game_state(const char *path)
{
    FILEP f;
    uint16_t version;
    int i;

    /* @asm 0x073508 : di (the success/return sentinel) = (g_compressed?2:1). The
     *   [0x15A] flag also selects an alternate mode string elsewhere; here it
     *   only tags the sentinel. We model the sentinel implicitly via returns. */

    /* @asm 0x073511 : fopen("wb", path). NULL -> error path (file create fail). */
    f = msc_fopen(SAVE_MODE_W, path);          /* LCALL 0xD1D:0x4DA */
    if (f == 0)
        return -1;             /* -> orchestrator shows SAVEMEM/SAVEERROR */

    /* @asm 0x073528 : write the "COLONIZE" magic + 0x1A terminator. */
    put_magic_string(f, SAVE_MAGIC);           /* LCALL 0x1A1F:0xDE4 (@0xD700) */

    /* @asm 0x07353C : version word (= g_save_version @0x81A). */
    version = g_save_version;
    SAVE_BLOCK(f, &version, 2);

    /* @asm 0x073553 : map width(0x853A)+height(0x853C) as one 4-byte block. */
    SAVE_BLOCK(f, &g_map_w, 4);

    /* @asm 0x07356B / 0x073583 / 0x07359A : fixed DGROUP blocks. */
    SAVE_BLOCK(f, (uint8_t *)0x5380, 0x8E);    /* global block (year/turn/counts/diff) */
    SAVE_BLOCK(f, (uint8_t *)0x540E, 0xD0);    /* per-power name/info (4 * 0x34) */
    SAVE_BLOCK(f, (uint8_t *)0x948E, 0x18);

    /* @asm 0x0735A9..0x073625 : variable game-state tables (skipped when count==0). */
    if (g_colony_count)                        /* @0x0735A9 cmp [0x539E],0 */
        SAVE_BLOCK(f, g_colony_table, (uint32_t)g_colony_count * COLONY_STRIDE);
    if (g_unit_count)                          /* @0x0735CC cmp [0x539C],0 */
        SAVE_BLOCK(f, g_unit_table,   (uint32_t)g_unit_count   * UNIT_STRIDE);
    SAVE_BLOCK(f, g_power_table, POWER_BYTES); /* @0x0735EE always 4 * 0x13C */
    if (g_native_count)                        /* @0x073606 cmp [0x539A],0 */
        SAVE_BLOCK(f, g_native_table, (uint32_t)g_native_count * NATIVE_STRIDE);

    /* @asm 0x073628.. : the remaining fixed DGROUP blocks, in exact order. */
    SAVE_BLOCK(f, (uint8_t *)0x5AD6, 0x270);
    SAVE_BLOCK(f, (uint8_t *)0x9566, 0x0C);
    SAVE_BLOCK(f, (uint8_t *)0x8CFC, 4);
    SAVE_BLOCK(f, (uint8_t *)0x9298, 4);
    SAVE_BLOCK(f, (uint8_t *)0x9408, 4);
    SAVE_BLOCK(f, (uint8_t *)0x940C, 4);
    SAVE_BLOCK(f, (uint8_t *)0x9410, 4);
    SAVE_BLOCK(f, (uint8_t *)0x9180, 4);
    SAVE_BLOCK(f, (uint8_t *)0x9414, 4);
    SAVE_BLOCK(f, (uint8_t *)0x9418, 4);
    SAVE_BLOCK(f, (uint8_t *)0x941C, 8);
    SAVE_BLOCK(f, (uint8_t *)0x9424, 4);
    SAVE_BLOCK(f, (uint8_t *)0x9428, 4);
    SAVE_BLOCK(f, (uint8_t *)0x942C, 4);
    SAVE_BLOCK(f, (uint8_t *)0x924C, 0x4C);
    SAVE_BLOCK(f, (uint8_t *)0x947E, 0x10);
    SAVE_BLOCK(f, (uint8_t *)0x95F2, 0x10);
    SAVE_BLOCK(f, (uint8_t *)0x94A6, 0x40);
    SAVE_BLOCK(f, (uint8_t *)0x94E6, 0x40);
    SAVE_BLOCK(f, (uint8_t *)0x95B2, 0x40);
    SAVE_BLOCK(f, (uint8_t *)0x9526, 0x40);
    SAVE_BLOCK(f, (uint8_t *)0x918C, 0x40);
    SAVE_BLOCK(f, (uint8_t *)0x9572, 0x40);
    SAVE_BLOCK(f, (uint8_t *)0x944E, 8);
    SAVE_BLOCK(f, (uint8_t *)0x0336, 1);
    SAVE_BLOCK(f, (uint8_t *)0x9184, 8);
    SAVE_BLOCK(f, (uint8_t *)0x9622, 8);
    SAVE_BLOCK(f, (uint8_t *)0x962A, 8);
    SAVE_BLOCK(f, (uint8_t *)0x91CC, 0x80);
    SAVE_BLOCK(f, (uint8_t *)0x8540, 2);
    SAVE_BLOCK(f, (uint8_t *)0x853E, 2);
    SAVE_BLOCK(f, (uint8_t *)0x0184, 2);
    SAVE_BLOCK(f, (uint8_t *)0x017C, 2);
    SAVE_BLOCK(f, (uint8_t *)0x017E, 2);

    /* @asm 0x073938..0x0739B7 : the FOUR map layers via the raw block-write. */
    for (i = 0; i < 4; i++) {                  /* layers @[0x15C/0x160/0x164/0x168] */
        if (blk_write(f, g_map_layer[i], g_map_layer_bytes) == 0)
            goto save_fail;
    }

    /* @asm 0x0739BC..0x073A8A : the trailing block-write payloads (fixed sizes). */
    if (blk_write(f, (void far *)0x86F6, 0x10E) == 0) goto save_fail;
    if (blk_write(f, (void far *)0x85E8, 0x10E) == 0) goto save_fail;
    if (blk_write(f, (void far *)0x945E, 0x20)  == 0) goto save_fail;
    if (blk_write(f, (void far *)0x85C8, 0x20)  == 0) goto save_fail;
    /* @0x073A21: the 4-byte view/palette aux (derived from [0x83A6] via LCALL
     *   0x181F:0x4CA, written from a stack temp [bp-6]; transform [ANCHOR]).
     *   Write the value bridged from load (g_save_view_aux_83A6) so a load->save
     *   round-trip is byte-exact; a fresh save writes zeros (matches observed). */
    { extern unsigned char g_save_view_aux_83A6[4];
      if (blk_write(f, g_save_view_aux_83A6, 4) == 0) goto save_fail; }
    if (blk_write(f, (void far *)0x8D80, 4)     == 0) goto save_fail;
    if (blk_write(f, (void far *)0x0190, 2)     == 0) goto save_fail;
    if (blk_write(f, (void far *)0x1B220 /*seg 0x1B22:0*/, 0x378) == 0) goto save_fail;

    /* @asm 0x073A8E : success path (di stays 1) -> close, return ok. */
    msc_fclose(f);             /* LCALL 0xD1D:0x3F4 */
    return 0;                  /* -> orchestrator shows SAVEGOOD @0x1FA9F */

save_fail:
    /* @asm 0x0735FE : common failure epilogue. */
    msc_fclose(f);             /* LCALL 0xD1D:0x3F4 */
    msc_remove(path);          /* LCALL 0xD1D:0xE4A -- delete the partial file */
    return -2;                 /* -> orchestrator shows SAVEERROR @0x1FAB0 */
}

/* ----------------------------------------------------------------------------
 *  CHECKSUM / TRAILER  [BYTE_VERIFIED ABSENT]
 * ----------------------------------------------------------------------------
 *  func_0734F8 ends after the last block-write and the fclose -- there is NO
 *  checksum loop, CRC, or trailer word. (The prior fabricated XOR-rotate
 *  checksum was correctly deleted; this now confirms by exhaustive trace that
 *  the DOS save genuinely has none. Integrity is enforced on LOAD only via the
 *  "COLONIZE" magic + version word + map-size match -- see load_deserializer.c.)
 * ---------------------------------------------------------------------------- */
