/* ============================================================================
 *  endgame.c -- End-of-game score/rank screen & Hall of Fame
 * ----------------------------------------------------------------------------
 *  STATUS LEGEND (per viceroy_source/VERIFICATION_LEDGER.md):
 *    [BYTE_VERIFIED]   bytes read directly from COLONIZE/VICEROY.EXE
 *    [ANCHOR_VERIFIED] confirmed function / string anchor, body not byte-traced
 *    [not yet decoded]  not located / not verified -- do NOT trust
 *
 *  Rewritten 2026-05-30 against code/VICEROY/disasm_overlay_reseg/page_05.asm.
 *  This supersedes the 2026-05-29 version, which (a) could not locate the
 *  score/HoF screen and (b) declared the 210-byte HALLFAME.DAT layout to be
 *  "Win16-only / DOS left unresolved". BOTH are now resolved:
 *
 *    * The end-of-game SCORE + RANK screen is func_03A9C0@0x03A9C0 (page 0x05).
 *    * The Hall-of-Fame reader/writer is func_03ADA6@0x03ADA6 (page 0x05).
 *    * The DOS HALLFAME.DAT block IS 0xD2 = 210 bytes (read/written in one
 *      fread/fwrite) = 5 entries x 42 (0x2A) bytes -- the SAME size the prior
 *      file attributed only to Win16. BYTE_VERIFIED from the fread arg below.
 *
 *  The per-power raw score VALUE (0x191F:0x3AA → func_039EE2) is BYTE_VERIFIED
 *  2026-06-08 in compute.c (7 score components + vet_mult; see raw_power_score).
 *  The RANK math that wraps it is byte-verified (see compute.c
 *  score_endgame_rank). No win-flow enum, no timeout year, no CLOSING.EXE
 *  chain are asserted -- none were found in the EXE.
 *
 *  @ref code/VICEROY/disasm_overlay_reseg/page_05.asm  (func_03A9C0, func_03ADA6)
 *  @ref code/VICEROY/strings.json
 *  @ref compute.c  (score_endgame_rank @ func_03A9C0 head)
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"

/* ----------------------------------------------------------------------------
 *  BYTE_VERIFIED endgame string anchors (file offsets; handle+0x1D9A0=file)
 * ----------------------------------------------------------------------------
 *  @bytes "SCORE"        @ file 0x1EB6F (handle 0x11CF) and 0x1EB89 (0x11E9)
 *         "0"            @ file 0x1EB75 (handle 0x11D5)  rank leading-zero pad
 *         "WOODPAN2"     @ file 0x1EB77 (0x11D7)  HoF panel art
 *         "EXPLOITS"     @ file 0x1EB80 (0x11E0)  HoF screen title key
 *         "WOODPANL"     @ file 0x1EB9F (0x11FF)  panel art
 *         "HALLFAME.DAT" @ file 0x1EB92 (0x11F2) and 0x1EBC7 (0x1227)
 *         "rb"           @ file 0x1EB8F (0x11EF)  fopen read mode  (raw 72 62 00)
 *         "wb"           @ file 0x1EBC4 (0x1224)  fopen write mode (raw 77 62 00)
 *         "EXPLOITS"/"INDEPENDENT"/"NAMES"/"--- "/" ---" decorate the screen.
 *  @bytes "VICTORY"@0x1EAE3, "REVOLUTION"@0x1ED1B, "CONTINENTAL"@0x1F566,
 *         "INDEPENDENT"@0x1EBA8 -- win-state title strings (locations only).
 * ---------------------------------------------------------------------------- */
#define HALLFAME_FILENAME  "HALLFAME.DAT"   /* @bytes file 0x1EB92  [BYTE_VERIFIED] */
#define HALLFAME_MODE_READ   "rb"           /* @bytes file 0x1EB8F  [BYTE_VERIFIED] */
#define HALLFAME_MODE_WRITE  "wb"           /* @bytes file 0x1EBC4  [BYTE_VERIFIED] */

/* HALLFAME.DAT on-disk layout (DOS) -- BYTE_VERIFIED from the fread/fwrite. */
#define HOF_BLOCK_BYTES   0xD2   /* 210 -- fread/fwrite count (@asm 0x03ADCF/0x03B2D1) */
#define HOF_ENTRY_BYTES   0x2A   /* 42  -- per-entry stride (imul si,...,0x2A) */
#define HOF_ENTRY_COUNT   5      /* 5 x 42 = 210; a 6th slot is the insert candidate */

/* C-runtime helpers (segment 0xD1D = MSC 6.0 resident). The IDs below are
 * inferred from the fopen/fread/fwrite/fclose CALL STRUCTURE (2-arg fopen ->
 * FILE*, 4-arg fread(buf,size,count,fp), fwrite, 1-arg fclose); the helper
 * BODIES were not read, so they are ANCHOR_VERIFIED, not BYTE_VERIFIED. */
extern void far *c_fopen(const char *name, const char *mode);  /* 0xD1D:0x4DA  ANCHOR */
extern int       c_fread(void *buf, int size, int count, void far *fp); /* 0xD1D:0x528 ANCHOR */
extern int       c_fwrite(void *buf, int size, int count, void far *fp);/* 0xD1D:0x60C ANCHOR */
extern int       c_fclose(void far *fp);                       /* 0xD1D:0x3F4  ANCHOR */
extern char near *strcpy_near(char near *dst, const char near *src); /* 0xFDB4 (iolib.h) */
extern char near *strcat_near(char near *dst, const char near *src); /* 0xFD74 (iolib.h) */
extern void      strcat_itoa(char *dst, int n);                /* 0x181F:0x182 BYTE_VERIFIED */

/* DGROUP globals. */
extern uint8_t  g_difficulty;     /* 0x53A6 */
extern uint16_t g_active_power;   /* 0x5398 (power being scored) */

extern int  score_endgame_rank(int raw_score);  /* compute.c (func_03A9C0 head) */
extern int  raw_power_score(int arg);            /* 0x191F:0x3AA → func_039EE2 (file 0x039EE2)
                                                 * BYTE_VERIFIED 2026-06-08: full body traced in
                                                 * compute.c: 7 score components (score_founding,
                                                 * score_ff_pts, score_gold, score_ref, score_sol,
                                                 * score_liberty, score_congress) + vet_mult. */

/* ----------------------------------------------------------------------------
 *  score_screen -- the end-of-game SCORE + RANK panel.
 * ----------------------------------------------------------------------------
 *  @asm func_03A9C0 @0x03A9C0 (page 0x05, 0x03A9C0..0x03ADA5).  [BYTE_VERIFIED
 *  structure; raw-score arithmetic BYTE_VERIFIED in compute.c (func_039EE2)].
 *
 *  Flow (each step cited):
 *    @asm 03A9E5  save+clear scratch word [0x372] (restored at 0x03AD9F)
 *    @asm 03A9F6  raw = raw_power_score(<arg [bp+6]>)   ; call 0x49DA -> 0x191F:0x3AA
 *    @asm 03AA00  if (raw <= 0) return 0;               ; nothing to show
 *    @asm 03AA0A  rank = score_endgame_rank(raw)        ; {factor,(k*k)/3 ladder,clamp 23}
 *                  (see compute.c -- rank in 0..23, or below-threshold)
 *    @asm 03AA9B  draw "SCORE" panel + title key:
 *                   strcpy(buf, "SCORE");               ; @0x03AAB0 0xD1D:0x7E4
 *                   if (rank < 9) strcat(buf, "0");      ; @0x03AAC7 leading-zero pad
 *                   strcat_itoa(buf, rank + 1);          ; @0x03AADA -> "@SCORE01".."@SCORE24"
 *    @asm 03AB07  print the score number (format-int32 0x181F:0x9AE of [bp-2])
 *    @asm 03AB89  iterate the 4 powers, accumulating a y-offset and printing
 *                  each power's name ([0x5398]*0x34+0x5426) -> 3-row block.
 *    @asm 03AD25  if a HoF-rank pointer exists ([bp-0xB6]:[bp-0xB8]) draw the
 *                  rank bar (es:[bx+0x46]/[+0x48] = bar extents).
 *    @asm 03AD51  pick the medallion sprite: rank>=0x17 -> 0x24; rank>6 -> 0x25;
 *                  else 0x21  (0x181F:0x4C0 selects/draws it).
 *    @asm 03AD86  present the panel; wait for key (0x181F:0x3EA(8)); fade.
 *    @asm 03AD9F  restore [0x372]; loop back for the next power.
 *
 *  The raw score and the 4-power name table are byte-verified ACCESS; the score
 *  COMPONENTS are BYTE_VERIFIED in compute.c (func_039EE2 body traced 2026-06-08).
 *  The rank title TEXT lives in GAME.TXT ("@SCORE1".."@SCORE24") -- RUNTIME_ONLY.
 * ---------------------------------------------------------------------------- */
extern void score_screen(int which_power);   /* @asm 0x03A9C0 -- declared; full body cited above */

/* ----------------------------------------------------------------------------
 *  hall_of_fame -- read HALLFAME.DAT, insert the candidate, write it back.
 * ----------------------------------------------------------------------------
 *  @asm func_03ADA6 @0x03ADA6 (page 0x05, ENTER 0x160,0).  [BYTE_VERIFIED
 *  structure + file I/O sizes; field semantics decoded from usage below].
 *
 *  BYTE_VERIFIED structure:
 *    @asm 03ADB1  fp = fopen("HALLFAME.DAT", "rb");      ; 0x11EF="rb", 0x11F2=name, 0xD1D:0x4DA
 *    @asm 03ADCF  if (fp) fread(buf, 0xD2, 1, fp);        ; ONE 210-byte block, 0xD1D:0x528
 *    @asm 03ADEA  fclose(fp);                             ; 0xD1D:0x3F4
 *    @asm 03ADF8  for (i = 0; i < 6; i++)                 ; init/normalize 6 slots
 *                   if (file-absent || i==5) zero entry[i] (name[0]=0, fields=-1/0)
 *                                                          ; entry stride 0x2A
 *    @asm 03AE4B  if (candidate [bp+6]) {                  ; a new score to insert
 *                   find insert position by entry+0x26 (score) descending;
 *                   shift entries down (rep movsw 0x15 words = 42 bytes each);
 *                   copy candidate into the slot; record its index [bp-0x154].
 *                 }
 *    @asm 03AEEE  render the table (EXPLOITS title; per-row name@+0x00, a number
 *                   @+0x1E via itoa, a flag @+0x1A, a [bx-0x7C6C]-indexed word
 *                   @+0x22, the score @+0x24, year/turn @+0x26); 5 rows + the
 *                   highlighted new row; "--- / ---" separators.
 *    @asm 03B2B8  fp = fopen("HALLFAME.DAT", "wb");        ; 0x1224="wb", 0x1227=name
 *    @asm 03B2D1  if (fp) fwrite(buf, 0xD2, 1, fp);        ; ONE 210-byte block, 0xD1D:0x60C
 *    @asm 03B2EC  fclose(fp);                              ; 0xD1D:0x3F4
 *
 *  ENTRY LAYOUT (42 bytes; offsets within an entry; semantics from usage):
 *    +0x00  name string (the strcpy/itoa target; bounded by stride)
 *    +0x18  word  -- displayed value (printed by 0x181F:0x65E formatter)
 *    +0x1A  word  -- flag (non-zero -> extra " ---" decoration / "*")
 *    +0x1C  word  -- present-flag (the row-visible test @0x03B11D)
 *    +0x1E  word  -- a count/number (itoa'd into the name area)
 *    +0x20  word  -- (cleared on init)
 *    +0x22  word  -- index*2 into table [bx-0x7C6C] (a name/string table)
 *    +0x24  word  -- score number (itoa'd; the visible SCORE column)
 *    +0x26  word  -- SORT KEY (insertion sort compares this descending)
 *  (5 entries x these 42 bytes = 210 = HOF_BLOCK_BYTES.) Bytes within each
 *  42-byte entry beyond +0x27 are RUNTIME_ONLY / padding (not read or written).
 *
 *  NOTE: this matches colowin/engine/hallfame_format.py's 210-byte Win16 layout
 *  in SIZE and entry count (5x42). The prior file's claim that the DOS layout
 *  differs from Win16 is WITHDRAWN -- the DOS fread is exactly 0xD2 bytes.
 *  (A trailing checksum/decoration, if any, would have to live OUTSIDE the
 *   210-byte block; none is read here; structure complete at 210 bytes.)
 * ---------------------------------------------------------------------------- */
extern void hall_of_fame(void *candidate_entry);   /* @asm 0x03ADA6 -- declared; full body cited above */

/* ----------------------------------------------------------------------------
 *  GAME-OVER CONDITIONS  (partially located)
 * ----------------------------------------------------------------------------
 *  No "year >= 1850" timeout exists in the EXE (the prior 1850 was fabricated).
 *  Year comparisons that DO exist (g_year @0x538A): 0x640/0x672/0x6A4/0x6D6
 *  (1600/1650/1700/1750) gate era/event logic, NOT a confirmed game-end. The
 *  actual end-of-game trigger set (revolution won, defeated, time limit) is
 *  not yet byte-traced from the turn loop. The score/HoF screen above is the
 *  PRESENTATION; the turn-loop dispatch that invokes it is not yet located.
 *
 *  chain_to_closing: the prior "CLOSING.EXE" chain was fabricated (no such
 *  string in the EXE) and stays removed. The AH=4Bh child-EXE loader that
 *  exists is dos_exec_load_overlay_4B3@0x01287A; what (if anything) the endgame
 *  chains to is not yet byte-traced.
 * ---------------------------------------------------------------------------- */
