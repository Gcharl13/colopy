/* ============================================================================
 * save.h -- Save / load file format + buffered-stdio FILE layer
 * ----------------------------------------------------------------------------
 *  STATUS LEGEND (per viceroy_source/VERIFICATION_LEDGER.md):
 *    [BYTE_VERIFIED]   bytes read directly from COLONIZE/VICEROY.EXE
 *    [ANCHOR_VERIFIED] confirmed function/string anchor; value/order not byte-traced
 *    [not yet decoded] not located / not verified -- do NOT trust
 *
 *  2026-05-30: This header was previously marked ">>> RECONSTRUCTED -- NOT
 *  BYTE-VERIFIED <<<" and documented a `.COL`/'COL2'/version-3 save with a
 *  fixed magic, header, and section table. ALL of that was fabricated or
 *  conflated with the Win16 colonize.exe format. It has been replaced with the
 *  byte-grounded facts (cite-or-left unresolved). In particular the old claim that
 *  "load_game_state @ 0x011F6E is the savegame colony parser" was DISPROVEN
 *  (it is the C-runtime/RTLink record reader that loads VICEROY.EXE's own
 *  overlays -- it MZ-magic-checks each record @0x01207A). See
 *  src/save/load_deserializer.c for the full correction.
 * ============================================================================ */
#ifndef VICEROY_SAVE_H
#define VICEROY_SAVE_H

#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 *  DOS save-file naming  [BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 *    "COLONY\0"  @ file 0x1FA82   |  ".SAV\0"   @ file 0x1FA89
 *    "(EMPTY)\0" @ file 0x1FA8E   (empty-slot label; corrected from 0x1FA8C)
 *  On-disk name = "COLONY" + <slot infix> + ".SAV". The slot infix template is
 *  built at runtime and has not been located -> [not yet decoded]. The Win16 build's
 *  "*.COL"/'COL2'/v3 format is a DIFFERENT file -- do not conflate. The only
 *  ".COL" literal in the DOS EXE is "CONFIG.COL" @0x1F9F9 (a config file).
 * ---------------------------------------------------------------------------- */
#define SAVE_NAME_STEM   "COLONY"   /* @bytes file 0x1FA82 [BYTE_VERIFIED] */
#define SAVE_NAME_EXT    ".SAV"     /* @bytes file 0x1FA89 [BYTE_VERIFIED] */

/* ----------------------------------------------------------------------------
 *  Save/Load UI message keys  [BYTE_VERIFIED locations; key->meaning ANCHOR]
 * ----------------------------------------------------------------------------
 *    SAVEGAME  0x1FA96   LOADGAME  0x1FABA
 *    SAVEGOOD  0x1FA9F   LOADGOOD  0x1FAC3
 *    SAVEMEM   0x1FAA8   LOADNOT   0x1FACC
 *    SAVEERROR 0x1FAB0   LOADOLD   0x1FAD4 / LOADSIZE 0x1FADC
 * ---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
 *  On-disk save layout  [LARGELY body in thunk page -- serializer is overlay-resident]
 * ----------------------------------------------------------------------------
 *  The top-level serializer (gated by SAVEGAME@0x1FA96) is OVERLAY-RESIDENT and
 *  is invoked through the 0x181F/0x191F/0x1A1F thunk tables, so the static
 *  callgraph cannot see it (every page_1C stdio primitive has `callers: None`).
 *  Therefore NO magic, NO header field order, NO section order, and NO checksum
 *  are byte-confirmed for the DOS save. Anything more specific would be
 *  fabrication. What IS known:
 *
 *    - The writer/reader drive the buffered-stdio FILE layer (page 0x1C),
 *      see `struct viceroy_FILE` below.
 *    - The tables that exist in memory (strides BYTE_VERIFIED per RULINGS
 *      2026-05-28), candidates for serialization in an UNCONFIRMED order:
 *        PowerRecord[]      base 0x8808  stride 0x13C (316)
 *        ColonyRecord[]     base 0x5D46  stride 0xCA  (202)   [0xAE working subset]
 *        UnitRecord[]       base 0x3144  stride 0x1C  (28)
 *        NativeSettlement[] base 0x54EC  stride 0x12  (18)
 *        Map layers         3 x 4176 B (= 12528, matches .MP)
 *        Discovery/fog      per-power bitmap, geometry [not yet decoded]
 *
 *  The 174 (0xAE) vs 202 (0xCA) ColonyRecord delta: 0xCA is the in-memory
 *  stride; the 0xAE working buffer at *(0x8542) is a subset; the 28-byte
 *  difference is derived state recomputed on load (mechanism [not yet decoded]).
 *  (NOTE: the 0xAE buffer in func_011F6E is NOT this buffer -- coincidental
 *  size; that function is the overlay/EXE record reader.)
 * ---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
 *  struct viceroy_FILE -- buffered-stdio FILE object (overlay page 0x1C)
 *  [BYTE_VERIFIED field map -- offsets read off func_076E50 stores +
 *   func_077100/func_0775EC loads; see page_1C.asm]
 * ----------------------------------------------------------------------------
 *  This is the MSC-6.0 FILE struct VICEROY uses for ALL file I/O (generic,
 *  not savegame-specific). Offsets are exact; some field *meanings* are MSC-
 *  internal and only ANCHOR-confirmed (marked below).
 * ---------------------------------------------------------------------------- */
typedef struct viceroy_FILE {
    uint16_t is_open;     /* +0x00 0 then 1 on successful open          [BYTE_VERIFIED] */
    uint16_t mode_class;  /* +0x02 1 or 2, derived from mode string     [BYTE_VERIFIED] */
    uint8_t  flags;       /* +0x04 text/binary + unbuffered bits        [BYTE_VERIFIED] */
    uint8_t  _pad05;      /* +0x05                                       [library-implementation-only] */
    uint16_t dos_handle;  /* +0x06 DOS file handle                      [BYTE_VERIFIED] */
                          /*       +0x07 byte = CR/LF xlat mode (fwrite) [BYTE_VERIFIED] */
    uint16_t init_sent;   /* +0x08 0xFFFF init sentinel                 [BYTE_VERIFIED] */
    uint8_t  _gap0A[0x0A];/* +0x0A..+0x13                                [library-implementation-only] */
    uint32_t position;    /* +0x14 buffer/file position (long)          [BYTE_VERIFIED] */
    uint16_t rec_index;   /* +0x18 running element/record index         [BYTE_VERIFIED] */
    uint8_t  fcb[0x0E];   /* +0x1A path/FCB scratch (0xC copied)        [BYTE_VERIFIED] */
    uint16_t elem_count;  /* +0x28 element count                        [BYTE_VERIFIED] */
    uint8_t  open_flag;   /* +0x2A open-mode flag                       [BYTE_VERIFIED] */
    uint8_t  _pad2B;      /* +0x2B (func_07705A writes a byte here)      [BYTE_VERIFIED store] */
    /* +0x2C.. : per-element position table, stride 0x0A (fread @0x07718D)
     *           each entry: +0x00 size word, +0x04 size, +0x30/+0x32-style
     *           position long. MSC-internal layout -> [ANCHOR_VERIFIED]. */
    uint8_t  elem_table[1]; /* +0x2C variable, stride 0x0A              [BYTE_VERIFIED offset] */
} viceroy_FILE;

/* ----------------------------------------------------------------------------
 *  Buffered-stdio primitives (overlay page 0x1C).  [BYTE_VERIFIED structural]
 *  Bodies in src/iolib; declared here because the save/load paths drive them.
 * ---------------------------------------------------------------------------- */
viceroy_FILE far *fopen_stream (const char *path, const char *mode);          /* func_076E50 @0x076E50 (521 B) */
long  fseek_stream (viceroy_FILE far *f, long off, int whence);               /* func_0772FA @0x0772FA (754 B) */
long  fread_stream (viceroy_FILE far *f, uint16_t size, uint16_t count, uint32_t nbytes); /* func_077100 @0x077100 (441 B) */
int   fwrite_records(viceroy_FILE far *f, const void far *buf, uint16_t size, uint16_t count); /* func_0775EC @0x0775EC (263 B) */
int   fclose_stream(viceroy_FILE far *f);                                     /* func_07706C @0x07706C (148 B) */

/* ----------------------------------------------------------------------------
 *  load_game_state -- *NOT* the savegame parser. [BYTE_VERIFIED reclassification]
 * ----------------------------------------------------------------------------
 *  @asm 0x011F6E..0x012101 (403 bytes)
 *  @ref ../code/VICEROY/disasm/func_011F6E_load_game_state.asm
 *
 *  This is the C-runtime / RTLink record-stream reader that loads VICEROY.EXE's
 *  OWN overlay segments. It MZ-magic-checks each 0x18-byte record (@0x01207A:
 *  cmp word,0x4D5A / @0x012081 cmp word,0x5A4D) -- a savegame reader would not.
 *  Its 0xAE alloc is RTLink scratch, NOT the ColonyRecord working buffer.
 *  Caller chain (callgraph.json): 0x0103FC -> 0x011B56 (searchenv open) ->
 *  0x012102 (fopen+search-path) -> 0x011F6E. On failure sets g_errno_27AC=8.
 *
 *  Kept under this name pending relocation to src/iolib/overlay_loader.c.
 * ---------------------------------------------------------------------------- */
int load_game_state(int file_handle, int mode, int count, int init_flag);

/* save_game_state -- the savegame writer (high-level wrapper).
 *  The real serializer that emits Power/Colony/Unit/Native/Map is OVERLAY-
 *  RESIDENT (reached via thunks; invisible to the callgraph) -> section order
 *  [body in thunk page]. The wrapper here drives the verified fopen_stream/fwrite_records/
 *  fclose_stream primitives only.
 */
int save_game_state(const char *path);

/* load_savegame -- high-level "load a COLONY*.SAV slot" entry.
 *  Driven by the open-menu framework func_0759E8 @0x0759E8 (OPENMENU@0x1FCDC,
 *  MAPTOLOAD@0x1FCFC, "*.MP"@0x1FCF7) + the slot lister func_076642 @0x076642
 *  (page 0x1B). The actual deserializer is overlay-resident [body in thunk page].
 */
int load_savegame(const char *path);

#endif /* VICEROY_SAVE_H */
