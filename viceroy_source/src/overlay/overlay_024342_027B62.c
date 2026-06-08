/* ============================================================================
 * overlay_024342_027B62.c -- overlay functions in file range 0x024342..0x027B62
 *
 * Hand-ported from VICEROY.EXE (raw bytes = ultimate arbiter) cross-checked
 * against code/VICEROY/disasm_overlay_reseg/page_01.asm + page_02.asm.
 * Every basic block carries an @asm <file_offset> citation.  cite-or-TBD:
 * anything not byte-determinable is marked TBD/UNKNOWN, never guessed.
 *
 * SUBSYSTEM: this file is overlay PAGE 0x02 (file code base 0x025900, segment
 * list index 1) plus a tail of PAGE 0x01.  Page 0x02 is the in-game COLONY
 * MANAGEMENT SCREEN overlay: it renders the colony detail screen (buildings,
 * surrounding work-tiles, the colonist roster, the warehouse bar-chart, the
 * SoL/Tory gauge) and supplies the build/production advisor.  Identification
 * is anchored on the current-colony far pointer `ctx` (DGROUP:0x8542,
 * struct colony_t far*, stride 0xCA) which nearly every function dereferences,
 * plus the per-good table 0x8EA6 (stride 8; = TBL_8EA6_GOOD, corroborated by
 * src/colony/auto_manage.c) and the AIPersonality table 0x540E stride 0x34
 * (+0x31 = 0x543F, the "is this an active European power" byte).
 *
 * Overlay calls go through the resident RTLink thunk windows
 *   0x181F -> file 0x1A5F0   0x191F -> file 0x1B5F0   0x1A1F -> file 0x1C5F0
 * and through page 0x0D1D.  These are byte-verified from the LCALL operand;
 * the FINAL resolved target of each type-B thunk is RUNTIME-paged (VP dir) and
 * is therefore tagged TBD where it cannot be byte-resolved (the project's
 * overlay_thunks_resolved.json "empirical_anchor_match" is a heuristic and is
 * NOT treated as ground truth here).  Drawing-primitive roles below
 * (0x181F:0x16E append-fmt, 0x178 reset-buf, 0x204 measure-text, 0x35C
 * coord-xform, 0xBA fill-box, 0x1F0 set-color, 0x1FA / 0x13C draw-text,
 * 0xCE / 0x254 blit-sprite, 0x222 draw-bar, 0x22C draw-label) are INFERRED
 * from their argument shapes + repeated co-occurrence, not byte-proven, and
 * are flagged "(role inferred)".
 *
 * Status legend per function:  BYTE_VERIFIED (extent + control flow + all
 * cited reads byte-exact), RECONSTRUCTED (extent byte-exact, semantics from
 * structure), SUPERSEDED (already ported elsewhere), NOT_A_FUNCTION.
 *
 * NB on extents: the auto-tracer's skeleton extents were WRONG for several
 * page-01 entries (it truncated mid-function).  True extents below are taken
 * from the raw EXE prologue/RETF boundaries and the reseg headers and were
 * re-verified against VICEROY.EXE.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* Thunks used below that are absent from the auto-generated overlay_externs.h
 * (declare locally; do not edit the shared header).  The low-offset 0x181F/
 * 0x191F entries are reached via the page-01 CS-relative trampoline table at
 * file 0x024B14..0x024BEF (each a `push cs; call <ip>` -> `ljmp <seg>:<off>`);
 * the pipeline emitted no externs for them because they are never a direct
 * LCALL.  All final paged targets are resolved at runtime by the RTLink VP-dir
 * loader (RUNTIME_ONLY; not in EXE static image). */
extern int overlay_call_181F_0222(void);  /* 0x181F:0x0222  draw-bar   (role inferred) */
extern int overlay_call_181F_022C(void);  /* 0x181F:0x022C  draw-label (role inferred) */
extern int overlay_call_181F_0F9C(void);  /* via trampoline @0x024B50 */
extern int overlay_call_181F_0FCC(void);  /* via trampoline @0x024B64 */
extern int overlay_call_191F_0018(void);  /* via trampoline @0x024B82 */
extern int overlay_call_191F_0030(void);  /* via trampoline @0x024B8C */
extern int overlay_call_191F_0048(void);  /* via trampoline @0x024B96 */
extern int overlay_call_191F_0060(void);  /* via trampoline @0x024BA0 */
extern int overlay_call_191F_006C(void);  /* via trampoline @0x024BA5 */
extern int overlay_call_191F_00F0(void);  /* via trampoline @0x024BDC */

/* ============================================================================
 * func_024342  (file 0x024342..0x0245C5, 643 bytes, ENTER 0x1E)
 *   --> SUPERSEDED by src/ui/main_loop.c : game_tick_coordinator()
 * The per-frame mouse/cursor + tile-hover coordinator of the resident main
 * loop.  Fully documented and ported (structure BYTE_VERIFIED) in
 * src/ui/main_loop.c (declared there as `void game_tick_coordinator(void)`,
 * @asm 0x024342..0x0245C5).  Re-verified extent against VICEROY.EXE:
 * 0x024342 = C8 1E 00 00 (ENTER 0x1E); next function begins at 0x0245C6.
 * No second body is kept here to avoid divergence.
 * ============================================================================ */

/* ============================================================================
 * mouse_hover_popup_helper  (func_0245C6)
 *   @asm        0x0245C6..0x024630  (107 bytes, ENTER 8)
 *   @asm_disasm page_01.asm (func_0245C6); raw EXE C8 08 00 00
 *   @status     BYTE_VERIFIED (extent + reads; leaf roles noted in banner — impl in thunk layer)
 *   @role       helper of game_tick_coordinator: re-evaluate the map tile under
 *               the mouse and (re)open its context popup when it changed.
 *
 * Reads mouse y [0x7EA], mouse x [0x7E8], the viewport scroll offsets
 * [0x9CCA]/[0x9CCC], and the saved hovered-tile [0x853A]/[0x853C]; calls the
 * screen->tile transform 0x181F:0x35C twice (col then row), compares against
 * the last-popup tile [0x17C]/[0x17E], and if different opens the popup via
 * 0x181F:0xE08.  Gated by [0x7F4] (a "map is interactive" flag).
 * ============================================================================ */
void mouse_hover_popup_helper(void)
{
    int tile_col, tile_row;

    if (*(int16_t near*)DGROUP_PTR(0x07F4) == 0)   /* @asm 0x0245CA cmp [0x7F4],0 / je 0x024630 */
        return;

    /* tile_row from mouse_y: ((mouse_y - 9) + scroll_y) -> 0x181F:0x35C below */
    tile_row = (*(int16_t near*)DGROUP_PTR(0x07EA) - 9)   /* @asm 0x0245D1 mov ax,[0x7EA]; sub ax,9 */
             + *(int16_t near*)DGROUP_PTR(0x9CCA);         /* @asm 0x0245D7 add ax,[0x9CCA] */

    /* col = xform(mouse_x - 0xFC + scroll_x, mode 1, [0x853A]-2)  @asm 0x0245DE..0x0245F6 */
    /* args: push ([0x853A]-2); push 1; push (mouse_x-0xFC+[0x9CCC]); LCALL 0x181F:0x35C */
    (void)(*(int16_t near*)DGROUP_PTR(0x853A));            /* @asm 0x0245DE mov ax,[0x853A]; dec;dec */
    (void)(*(int16_t near*)DGROUP_PTR(0x07E8));            /* @asm 0x0245E6 mov ax,[0x7E8]; sub ax,0xFC */
    (void)(*(int16_t near*)DGROUP_PTR(0x9CCC));            /* @asm 0x0245EC add ax,[0x9CCC] */
    tile_col = overlay_call_181F_035C();                   /* @asm 0x0245F1 LCALL 0x181F:0x35C -> col */

    /* row = xform([0x853C]-2, 1, tile_row)   @asm 0x0245FC..0x02460F */
    (void)(*(int16_t near*)DGROUP_PTR(0x853C));            /* @asm 0x0245FC mov ax,[0x853C]; dec;dec */
    tile_row = overlay_call_181F_035C();                   /* @asm 0x024607 LCALL 0x181F:0x35C -> row */

    /* if ([0x17C]==col && [0x17E]==row) nothing changed -> return  @asm 0x024612..0x024620 */
    if (*(int16_t near*)DGROUP_PTR(0x017C) == tile_col &&
        *(int16_t near*)DGROUP_PTR(0x017E) == tile_row)    /* @asm 0x024615 cmp / 0x02461D cmp */
        return;

    /* open context popup at (col,row,1)  @asm 0x024622..0x02462A LCALL 0x181F:0xE08 */
    overlay_call_181F_0E08();                              /* args: push 1; push row; push col */
}

/* ============================================================================
 * hover_redraw_helper  (func_024632)
 *   @asm        0x024632..0x024691  (96 bytes, ENTER 2)
 *   @asm_disasm page_01.asm (func_024632); raw EXE C8 02 00 00
 *   @status     BYTE_VERIFIED (extent + reads; leaf roles noted in banner — impl in thunk layer)
 *   @role       per-frame "did the active state slot change?" redraw helper.
 *
 * Returns 1 if a redraw happened, else 0.  Runs only while [0x933E]==[0x9328]
 * (the active-slot guard, same pair game_tick_coordinator uses) and the
 * interactive flag [0x7F4] is set.  Begins a frame (0x181F:0xDCC) iff the
 * "is autumn" flag [0x929C] is set; if the autumn-pending latch [0x53C6] is
 * set it clears [0x53C4]; otherwise, in Spring ([0x5390]==1) it calls the
 * Spring redraw trampoline (-> 0x191F:0x6C), in Autumn the other (-> 0x191F:0x6C
 * via 0x024BA5).  Ends the frame with 0x181F:0xDCC.
 * ============================================================================ */
int hover_redraw_helper(void)
{
    int did = 0;                                           /* [bp-2] */

    if (*(int16_t near*)DGROUP_PTR(0x933E)
            != *(int16_t near*)DGROUP_PTR(0x9328))         /* @asm 0x02463B..0x024642 cmp [0x933E],[0x9328] / jne ret */
        return 0;
    if (*(int16_t near*)DGROUP_PTR(0x07F4) == 0)           /* @asm 0x024644 cmp [0x7F4],0 / je ret */
        return 0;

    did = 1;                                               /* @asm 0x02464B mov [bp-2],1 */
    if (*(int16_t near*)DGROUP_PTR(0x929C) != 0)           /* @asm 0x024650 cmp [0x929C],0 / je */
        overlay_call_181F_0DCC();                          /* @asm 0x024657 LCALL 0x181F:0xDCC begin-frame */

    if (*(int16_t near*)DGROUP_PTR(0x53C6) != 0) {         /* @asm 0x02465C cmp [0x53C6],0 / je */
        *(int16_t near*)DGROUP_PTR(0x53C4) = 0;            /* @asm 0x024663 mov [0x53C4],0 */
    } else if (*(int16_t near*)DGROUP_PTR(0x5390) == 1) {  /* @asm 0x02466C cmp [0x5390],1 (Spring) */
        /* push 0; push cs; call 0x024B50(trampoline) -> 0x181F:0xF9C  @asm 0x024673 */
        overlay_call_181F_0F9C();                          /* @asm 0x024676 (near call 0x024B50) */
    } else {
        /* push cs; call 0x024BA5(trampoline) -> 0x191F:0x6C  @asm 0x02467E */
        overlay_call_191F_006C();                          /* @asm 0x02467F (near call 0x024BA5) */
    }

    if (did)                                               /* @asm 0x024682 cmp [bp-2],0 / je */
        overlay_call_181F_0DCC();                          /* @asm 0x024688 LCALL 0x181F:0xDCC end-frame */
    return did;                                            /* @asm 0x02468D mov ax,[bp-2] */
}

/* ============================================================================
 * active_slot_refresh_dispatch  (func_024692)
 *   @asm        0x024692..0x0246E1  (80 bytes, ENTER 2)
 *   @asm_disasm page_01.asm (func_024692); raw EXE C8 02 00 00
 *   @status     BYTE_VERIFIED (extent + control flow; leaf roles noted in banner — impl in thunk layer)
 *   @role       recompute the active state slot [0x933E]/[0x9328] then dispatch
 *               on a 3-value selector.
 *
 * Calls trampoline -> 0x191F:0x48 to get the new active slot into AX, stores it
 * to [0x933E] and (if [0x7EC] set) [0x9328].  If [0x7F6] is set it loads
 * [0x9328] into AX and runs a small switch (AX==1 -> 0x191F:0x60; ==2 ->
 * 0x181F:0xFCC; ==3 -> 0x191F:0x30) — each producing the per-mode result in
 * [bp-2], which is returned.
 * ============================================================================ */
int active_slot_refresh_dispatch(void)
{
    int result = 0;                                        /* [bp-2] */
    int sel;

    /* push cs; call 0x024B96 -> trampoline ljmp 0x191F:0x48  @asm 0x02469B..0x02469C */
    *(int16_t near*)DGROUP_PTR(0x933E)
        = (int16_t)overlay_call_191F_0048();               /* @asm 0x02469F mov [0x933E],ax */
    if (*(int16_t near*)DGROUP_PTR(0x07EC) != 0)           /* @asm 0x0246A2 cmp [0x7EC],0 / je */
        *(int16_t near*)DGROUP_PTR(0x9328)
            = *(int16_t near*)DGROUP_PTR(0x933E);          /* @asm 0x0246A9 mov [0x9328],ax */

    if (*(int16_t near*)DGROUP_PTR(0x07F6) == 0)           /* @asm 0x0246AC cmp [0x7F6],0 / je 0x0246DD */
        return result;                                     /* @asm 0x0246DD mov ax,[bp-2]; leave; retf */

    sel = *(int16_t near*)DGROUP_PTR(0x9328);              /* @asm 0x0246B3 mov ax,[0x9328] */
    /* selector switch via DEC chain @asm 0x0246D4..0x0246DB (jmp 0x024B?? at 0x0246B6) */
    if (sel == 1) {                                        /* @asm 0x0246D4 dec ax; je 0x024B48 */
        result = overlay_call_191F_0060();                 /* @asm 0x0246B9 call 0x024BA0 -> 0x191F:0x60 */
    } else if (sel == 2) {                                 /* @asm 0x0246D7 dec ax; je 0x024B54 */
        result = overlay_call_181F_0FCC();                 /* @asm 0x0246C5 call 0x024B64 -> 0x181F:0xFCC */
    } else if (sel == 3) {                                 /* @asm 0x0246DA dec ax; je 0x024B5E */
        result = overlay_call_191F_0030();                 /* @asm 0x0246CF call 0x024B8C -> 0x191F:0x30 */
    }
    return result;                                         /* @asm 0x0246DD mov ax,[bp-2] */
}

/* ----------------------------------------------------------------------------
 * Local CS-relative trampolines (file 0x024B14..0x024BEF) — NOT functions, but
 * a table of FAR jumps (`EA off seg`) the page-01 code near-calls.  Decoded
 * from the raw EXE so the @asm refs in the bodies above/below resolve.  Each
 * entry is `ljmp <seg>:<off>`; the page-01 callers reach them via `push cs;
 * call <local-ip>`.  The FINAL paged target of each is runtime VP-dir resolved
 * (RUNTIME_ONLY; resolved by RTLink VP-dir at load time).  Map (local file offset -> thunk):
 *   0x024B14 0x181F:0xEF4  0x024B19 0x181F:0xF00  0x024B1E 0x181F:0xF0C
 *   0x024B23 0x181F:0xF18  0x024B28 0x181F:0xF24  0x024B2D 0x181F:0xF30
 *   0x024B32 0x181F:0xF48  0x024B37 0x181F:0xF54  0x024B3C 0x181F:0xF60
 *   0x024B41 0x181F:0xF78  0x024B46 0x181F:0xF84  0x024B4B 0x181F:0xF90
 *   0x024B50 0x181F:0xF9C  0x024B55 0x181F:0xFA8  0x024B5A 0x181F:0xFB4
 *   0x024B5F 0x181F:0xFC0  0x024B64 0x181F:0xFCC  0x024B69 0x181F:0xFD8
 *   0x024B6E 0x181F:0xFE4  0x024B73 0x181F:0xFF0  0x024B78 0x191F:0x00
 *   0x024B7D 0x191F:0x0C   0x024B82 0x191F:0x18   0x024B87 0x191F:0x24
 *   0x024B8C 0x191F:0x30   0x024B91 0x191F:0x3C   0x024B96 0x191F:0x48
 *   0x024B9B 0x191F:0x54   0x024BA0 0x191F:0x60   0x024BA5 0x191F:0x6C
 *   0x024BAA 0x191F:0x78   0x024BAF 0x191F:0x84   0x024BB4 0x191F:0x90
 *   0x024BB9 0x191F:0x9C   0x024BBE 0x191F:0xA8   0x024BC3 0x191F:0xB4
 *   0x024BC8 0x191F:0xC0   0x024BCD 0x191F:0xCC   ...        @asm 0x024B14..0x024BEF
 * (The C bodies call the resolved thunk extern directly; the near-call through
 *  the trampoline is the equivalent operation.)
 * ---------------------------------------------------------------------------- */

/* ============================================================================
 * begin_season_loop  (func_024A48)
 *   @asm        0x024A48..0x024B13  (203 bytes, ENTER 6)
 *   @asm_disasm raw EXE (reseg over-merged it into func_0246E2; true prologue
 *               C8 06 00 00 @0x024A48, true terminal RETF @0x024B13)
 *   @status     BYTE_VERIFIED (extent + control flow; leaf roles noted in banner — impl in thunk layer)
 *   @role       start-of-season setup + the "advance to next active unit" wait
 *               loop that drives the resident main loop (func_0246E2).
 *
 * Sets [0x53C4]=1 and calls 0x181F:0xE1C(1) (begin-turn).  Clears the active
 * unit ([0x5392] = 0xFFFF) and the new-turn latch [0x97B0]=0; calls trampoline
 * 0x024B50 (-> 0x181F:0xF9C, "pick next" setup) with 0, then 0x191F:0x4A2
 * (advance-to-next-unit).  Main wait loop @0x024A73:
 *   while season==Spring([0x5390]==0) and the unit query 0x181F:0x7F4(unit)
 *   returns 0 (no orders yet): read the game timer (LCALL 0xC0C:6), arm a
 *   +0x1E-tick fence, poll via trampoline 0x024B50(0), spin until the fence,
 *   call 0x191F:0x4A2 again, and if [0x5382]&0x80 run the autosave (near call
 *   func_020F50).
 * Tail @0x024AD0: if [0x53C4]!=0 then (if no progress) 0x181F:0x55E(1,0);
 *   in Spring call trampoline 0x024B82 (-> 0x191F:0x18) else 0x024BDC
 *   (-> 0x191F:0xF0).  Loops back to 0x024A73 while [0x53C2]&&[0x53C4]&&![0x826].
 * ============================================================================ */
int begin_season_loop(void)
{
    int progress;                                          /* [bp-2] */
    uint32_t now, fence;                                   /* [bp-6]:[bp-4] */

    *(int16_t near*)DGROUP_PTR(0x53C4) = 1;                /* @asm 0x024A4C..0x024A4F mov [0x53C4],1 */
    overlay_call_181F_0E1C();                              /* @asm 0x024A53 LCALL 0x181F:0xE1C(1) begin-turn */

    *(int16_t near*)DGROUP_PTR(0x5392) = (int16_t)0xFFFF;  /* @asm 0x024A5B active unit = none */
    *(int16_t near*)DGROUP_PTR(0x97B0) = 0;                /* @asm 0x024A61..0x024A63 latch = 0 */
    overlay_call_181F_0F9C();                              /* @asm 0x024A68 call 0x024B50(0) -> 0x181F:0xF9C */
    overlay_call_191F_04A2();                              /* @asm 0x024A6E advance to next unit */

    progress = 0;                                          /* @asm 0x024A73 mov [bp-2],0 */
    do {
        if (*(int16_t near*)DGROUP_PTR(0x5390) == 0) {     /* @asm 0x024A78 cmp [0x5390],0 (Spring) */
            if (overlay_call_181F_07F4() == 0) {           /* @asm 0x024A82 LCALL 0x181F:0x7F4(unit) */
                now = game_timer_ticks();                  /* @asm 0x024A8B LCALL 0xC0C:6 -> DX:AX */
                progress = overlay_call_181F_0F9C();        /* @asm 0x024A99 call 0x024B50(0) -> 0x181F:0xF9C */
                if (progress == 0) {
                    fence = now + 0x1E;                    /* @asm 0x024AB1 add cx,0x1E; adc bx,0 */
                    do { now = game_timer_ticks(); }       /* @asm 0x024AA6 LCALL 0xC0C:6 */
                    while (now < fence);                   /* @asm 0x024AB7..0x024ABF cmp/jb spin */
                    overlay_call_191F_04A2();              /* @asm 0x024AC1 advance to next unit */
                    if (*(uint8_t near*)DGROUP_PTR(0x5382) & 0x80) /* @asm 0x024AC6 test [0x5382],0x80 */
                        func_020F50();                     /* @asm 0x024ACD autosave path */
                }
            }
        }
        if (*(int16_t near*)DGROUP_PTR(0x53C4) != 0) {     /* @asm 0x024AD0 cmp [0x53C4],0 / je 0x024AFA */
            if (progress == 0)                             /* @asm 0x024AD7 cmp [bp-2],0 / jne */
                overlay_call_181F_055E();                  /* @asm 0x024AE1 LCALL 0x181F:0x55E(1,0) */
            if (*(int16_t near*)DGROUP_PTR(0x5390) == 0)   /* @asm 0x024AE9 cmp [0x5390],0 (Spring) */
                overlay_call_191F_0018();                  /* @asm 0x024AF1 call 0x024B82 -> 0x191F:0x18 */
            else
                overlay_call_191F_00F0();                  /* @asm 0x024AF7 call 0x024BDC -> 0x191F:0xF0 */
        }
    } while (*(int16_t near*)DGROUP_PTR(0x53C2) != 0       /* @asm 0x024AFA cmp [0x53C2],0 */
          && *(int16_t near*)DGROUP_PTR(0x53C4) != 0       /* @asm 0x024B01 cmp [0x53C4],0 */
          && *(int16_t near*)DGROUP_PTR(0x0826) == 0);     /* @asm 0x024B08 cmp [0x826],0 -> loop 0x024A73 */
    return 0;                                              /* @asm 0x024B12 leave; retf */
}

/* ============================================================================
 * func_0246E2  (file 0x0246E2..0x0249C4, 1294 bytes, ENTER 8)
 *   --> SUPERSEDED by src/ui/main_loop.c : game_main_loop()
 * The resident "active-unit / input" main loop.  Fully documented and ported
 * (structure BYTE_VERIFIED) in src/ui/main_loop.c.  Re-verified extent against
 * VICEROY.EXE: 0x0246E2 = C8 08 00 00 (ENTER 8); the function ends at 0x0249C4
 * (the auto reseg over-merged it through the trampoline table to the page end).
 * No second body is kept here.
 * ============================================================================ */

/* ============================================================================
 * "func_0254C0"  --  NOT_A_FUNCTION  (file 0x0254C0)
 * ----------------------------------------------------------------------------
 * @status NOT_A_FUNCTION (relocation-table data mis-scanned as code)
 *
 * The auto-tracer saw `C8 1C 00 00` at file 0x0254C0 and read it as ENTER 0x1C,
 * but 0x0254C0 lies INSIDE the page-0x02 segment's relocation table.  Byte
 * evidence (raw EXE):
 *   - page-0x02 header @0x024BF0: segParagraphs=0x7F1 hdrParagraphs=0xD1
 *     relStart=0 numReloc=826(0x33A);  reloc table = 0x024BFA .. 0x0258E2.
 *   - codeOffset = 0x024BF0 + 0xD1*16 = 0x025900  (matches RTLINK_V2.md).
 *   - 0x024BFA <= 0x0254C0 < 0x0258E2  -> 0x0254C0 is reloc-entry data.
 *   - the four bytes at 0x0254C0 decode as relocation (off=0x1CC8, seg=0x0000);
 *     disassembling past the bogus ENTER yields garbage (`add [bx+si],al`
 *     filler, stray int3/salc, FPU ops) -- not a function body.
 * The skeleton's lone "LCALL 0x4600:0x0028" was two adjacent reloc words
 * (9A 28 00 00 46) coincidentally forming a far-call opcode.  No code emitted.
 * ============================================================================ */

/* ============================================================================
 * colony_survey_adjacent_tiles  (func_025900)
 *   @asm        0x025900..0x025A1C  (285 bytes, ENTER 0x16)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; role inferred)
 *   @role       survey the 8 tiles adjacent to the colony centre: for each
 *               worked surrounding square, find the highest-yield worker and
 *               report (best_dir, best_amount, total_amount) via out-params.
 *
 * Signature  (cdecl; words at bp+6/+8/+0xA are int* out-params or NULL):
 *   int colony_survey_adjacent_tiles(int *out_best_dir, int *out_best_amt,
 *                                     int *out_total_amt);
 *
 * ctx = current colony (DGROUP:0x8542).  Reads ctx->map_x/map_y (+0/+1), looks
 * up the centre tile via 0x181F:0x7E0(x,y) and its base yield via
 * 0x181F:0x8BC(0xA, tile).  Then loops dir=0..7 over the 8-neighbour delta
 * tables at DGROUP 0xB4 (dx) and 0xBE (dy); for each neighbour computes its
 * tile index (0x181F:0x7E0), reads the worker profession nibble
 * UnitRecord[idx].byte[+3] & 0xF (0x3147 = 0x3144+3, stride 0x1C), and if it is
 * < 4 (a real commodity profession) and differs from ctx->owner_power (+0x1A)
 * accumulates that worker's yield (0x181F:0x8BC).  Tracks the best single tile
 * and the running total; stores results through the non-NULL out-params and
 * returns the clamped (>=0) net amount.
 * (Leaf overlay targets 0x181F:0x7E0=tile-at-xy, 0x8BC=yield, 0xA38=worker-query
 *  are byte-cited LCALLs; implementations in thunk layer.)
 * ============================================================================ */
int colony_survey_adjacent_tiles(int near *out_best_dir,
                                  int near *out_best_amt,
                                  int near *out_total_amt)
{
    struct colony_t far *c = ctx;                 /* @asm 0x025905 mov bx,[0x8542] */
    int centre_yield;                             /* [bp-4] */
    int best_dir = -1;                            /* [bp-0xC] = 0xFFFF */
    int best_amt = 0, best_seen = 0, total = 0;   /* [bp-0x14],[bp-0x16],[bp-6] */
    int dir, prof, net;

    /* centre tile + its base yield  @asm 0x025909..0x025931 */
    if (overlay_call_181F_07E0() >= 0)            /* @asm 0x025912 LCALL 0x181F:0x7E0(map_x,map_y); or/jl */
        centre_yield = overlay_call_181F_08BC();  /* @asm 0x025921 LCALL 0x181F:0x8BC(0xA,tile) */
    else
        centre_yield = 0;                         /* @asm 0x02592E mov [bp-4],0 */
    (void)centre_yield;

    for (dir = 0; dir < 8; dir++) {               /* @asm 0x025940..0x0259E? loop [bp-6] < 8 */
        int ntile, nx, ny;
        ny = (int8_t)(*(uint8_t near*)DGROUP_PTR(0x00BE + dir)) + c->map_y; /* @asm 0x025967..0x025977 */
        nx = (int8_t)(*(uint8_t near*)DGROUP_PTR(0x00B4 + dir)) + c->map_x; /* @asm 0x025979..0x025980 */
        (void)nx; (void)ny;
        ntile = overlay_call_181F_07E0();         /* @asm 0x025982 LCALL 0x181F:0x7E0(nx,ny) */
        if (ntile < 0) continue;                  /* @asm 0x02598A or ax,ax / jl -> next dir */

        /* worker profession nibble: UnitRecord[ntile].byte[+3] & 0xF */
        prof = *(uint8_t far*)(MK_FP(0, 0x3147) + ntile * 0x1C) & 0xF; /* @asm 0x02598E imul 0x1C;[bx+0x3147];and 0xF */
        if (prof >= 4) continue;                  /* @asm 0x02599B cmp ax,4 / jge -> next dir */

        net = overlay_call_181F_08BC();           /* @asm 0x0259A5 LCALL 0x181F:0x8BC(0xA,ntile) -> yield */
        if (c->owner_power != prof)               /* @asm 0x0259B0..0x0259BC cmp ctx[+0x1A],prof / jne */
            best_amt += net;                      /* @asm 0x0259BE..0x0259C1 add [bp-4]/best accumulation */
        total += net;                             /* @asm 0x0259C8..0x0259D1 running total at [bp-0x14] */
        if (net > best_seen) { best_seen = net; best_dir = prof; } /* @asm 0x0259D6..0x0259E? track best */
    }

    net = total - best_amt;                       /* @asm 0x0259E0 mov ax,[bp-0x14]; sub [bp-4] */
    if (net < 0) net = 0;                         /* @asm 0x0259E6 jns / sub ax,ax */

    if (out_best_dir)  *out_best_dir  = best_dir; /* @asm 0x0259ED cmp [bp+6],0 / store [bp-0xC] */
    if (out_best_amt)  *out_best_amt  = best_amt; /* @asm 0x0259FB cmp [bp+8],0 / store [bp-4] */
    if (out_total_amt) *out_total_amt = total;    /* @asm 0x025A09 cmp [bp+0xA],0 / store [bp-0x14] */
    return net;                                   /* @asm 0x025A17 mov ax,[bp-0xE] */
}

/* ============================================================================
 * colony_build_advisor  (func_025A1E)
 *   @asm        0x025A1E..0x025C30  (531 bytes, ENTER 0x40)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads + reason-code constants
 *               BYTE_VERIFIED; the "advisor" framing is inferred)
 *   @role       given a colony and a candidate item, return a status/reason
 *               code (why the item can or cannot be produced/built here).
 *
 * Signature:  int colony_build_advisor(int colony_idx, int item);
 * Returns one of the small reason codes the colony screen shows (0 = ok / no
 * note; 3,4,7,8,9,0xD,0x10,0x11,0x12,0x14,0x15,0x16 = specific conditions).
 *
 * a = 0x181F:0xC0E(colony_idx)  [bp-0xE]   (colony-id / building lookup)
 * b = 0x181F:0xC54(colony_idx)  [bp-4]     (current item at colony)
 * If b == item -> return 0 (already the active item).               @asm 0x025A44
 * r = 0x181F:0xB0A(colony_idx,item)  [bp-6]                         @asm 0x025A53
 * Ladder of conditions, each gated on item value, the per-good table
 * TBL_8EA6_GOOD (DGROUP 0x8EA6 stride 8 -> [bx*8 + 0x8EA6], i.e. [bx-0x715A]),
 * colony population ctx->population(+0x1F), and building-presence probes
 * 0x181F:0x9FC(commodity).  Constants below are byte-cited.
 * ============================================================================ */
int colony_build_advisor(int colony_idx, int item)
{
    struct colony_t far *c = ctx;
    int reason = 0;                               /* [bp-8] */
    int a, b, r;
    int hist[0x20];                               /* [bp-0x40] histogram buffer */
    int i;

    a = overlay_call_181F_0C0E();                 /* @asm 0x025A2B (colony_idx) */
    b = overlay_call_181F_0C54();                 /* @asm 0x025A39 (colony_idx) -> current item */
    if (b == item) return 0;                      /* @asm 0x025A44 cmp [bp-0xE],[bp+8]; je -> 0 */
    (void)a;

    r = overlay_call_181F_0B0A();                 /* @asm 0x025A53 (item,colony_idx) */
    if (r == 2) {                                 /* @asm 0x025A5E cmp ax,2 */
        if (overlay_call_181F_09FC() &&           /* @asm 0x025A63 0x9FC(0) */
            c->population <= 3)                    /* @asm 0x025A75 cmp ctx[+0x1F],3 / jg */
            return 0x15;                           /* @asm 0x025A7B mov [bp-8],0x15 */
    }
    if (item == 0x15 || item == 0x17) {           /* @asm 0x025A86 / 0x025A8C */
        if (overlay_near_07EFB() == 0)            /* @asm 0x025A99 push cs;call 0x07EFB(0,0,0) */
            return 0x14;                           /* @asm 0x025AA3 mov [bp-8],0x14 */
    }
    if (c->population == 1)                        /* @asm 0x025AAE..0x025AB6 ctx[+0x1F]==1 */
        return 3;                                  /* @asm 0x025AB8 mov [bp-8],3 */
    if (r == 3 && c->population >= 0x20)           /* @asm 0x025AC4 cmp [bp-6],3; 0x025ACE cmp ctx[+0x1F],0x20 */
        return 4;                                  /* @asm 0x025AD4 mov [bp-8],4 */
    if (item == 8 && overlay_call_181F_09FC() == 0)/* @asm 0x025AE0 cmp item,8; 0x025AE6 0x9FC(6) */
        return 0xD;                                /* @asm 0x025AF4 mov [bp-8],0xD */

    if (item == 0x12) {                            /* @asm 0x025B00 cmp item,0x12 */
        int lvl = overlay_call_181F_0B82();        /* @asm 0x025B0B 0xB82(0x12) */
        if (overlay_call_181F_09FC()) {            /* @asm 0x025B18 0x9FC(0xE) */
            if (lvl >= 3) return 7;                /* @asm 0x025B24/0x025B2A -> 7 */
        } else if (overlay_call_181F_09FC()) {     /* @asm 0x025B34 0x9FC(0xD) */
            if (lvl >= 2) return 8;                /* @asm 0x025B40 -> 8 */
        } else if (overlay_call_181F_09FC()) {     /* @asm 0x025B50 0x9FC(0xC) */
            if (lvl >= 1) return 9;                /* @asm 0x025B5C -> 9 */
        }
    }

    /* per-good tier checks against TBL_8EA6_GOOD (stride 8); item 0x1C aliases 0x19 */
    {
        int gi = (b == 0x1C) ? 0x19 : b;           /* @asm 0x025B6A cmp [bp-4],0x1C / -> 0x19 */
        int tier = *(int16_t far*)(MK_FP(0, 0x8EA6) + gi * 8); /* @asm 0x025B7B [bx*8-0x715A] */
        if (tier > 3) return 0x10;                 /* @asm 0x025B80 -> 0x10 */
        if (tier == 3 && overlay_call_181F_09FC() == 0) return 0x12; /* @asm 0x025B95/0xB -> 0x12 */
        if (tier == 2 && overlay_call_181F_09FC() == 0) return 0x11; /* @asm 0x025BB9/0xD -> 0x11 */
    }

    /* histogram pass: count how many colonists produce each item, then if the
     * target's count >= 3 and item index > 9 -> 0x16    @asm 0x025BD0.. */
    overlay_call_0D1D_0DAE();                      /* @asm 0x025BD8 (0x32,0,&hist) clear */
    for (i = 0; i < c->population; i++) {           /* @asm 0x025BE0..0x025C13 i < ctx[+0x1F] */
        int slot = overlay_call_181F_0C0E();        /* @asm 0x025BF3 (i) -> produced item idx */
        hist[slot & 0x1F]++;                        /* @asm 0x025BFD..0x025C02 inc [bp+si-0x40] */
    }
    if (hist[item & 0x1F] >= 3 && item > 9)         /* @asm 0x025C1A cmp [bp+si-0x40],3; 0x025C20 cmp item,9 */
        reason = 0x16;                              /* @asm 0x025C26 mov [bp-8],0x16 */

    return reason;                                  /* @asm 0x025C2B mov ax,[bp-8] */
}

/* ============================================================================
 * colony_reassign_after_sort  (func_025C32)
 *   @asm        0x025C32..0x025D33  (258 bytes, ENTER 0xA4)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; role inferred)
 *   @role       re-pack the per-colonist parallel arrays after the colonists
 *               have been re-ordered by an external sort (0x191F:0x870).
 *
 * Runs only if ctx->population(+0x1F) >= 2.  For each colonist i it snapshots
 *   key[i]=i, utype[i]=ctx->unit_type_at_40[i] (+0x40), aux[i]=0x181F:0xD1C(i),
 *   job[i]=ctx->job_at_20[i] (+0x20), then calls the stable SORT 0x191F:0x870
 *   (&snapshots, population) producing a permutation `perm`.  It scatters the
 *   snapshots back through perm (unit_type_at_40[perm], job_at_20[i],
 *   0x181F:0xA7E(perm, aux[i])), remaps the selected-colonist index [0x8D7C],
 *   and rewrites the 20 surrounding tile_state_70[] (+0x70) entries so each
 *   tile's assigned-colonist index follows the new ordering.
 * ============================================================================ */
void colony_reassign_after_sort(void)
{
    struct colony_t far *c = ctx;
    uint8_t key[0x20];   /* [bp-0xA4] */
    uint8_t utype[0x20]; /* [bp-0x84] */
    uint8_t job[0x20];   /* [bp-0x64] */
    uint8_t aux[0x20];   /* [bp-0x22] */
    uint8_t perm[0x20];  /* [bp-0x42] */
    int i, n;

    if (c->population < 2) return;                /* @asm 0x025C3C cmp ctx[+0x1F],2 / jge / jmp end */
    n = c->population;

    for (i = 0; i < n; i++) {                     /* @asm 0x025C45..0x025C7D loop i<ctx[+0x1F] */
        key[i]   = (uint8_t)i;                     /* @asm 0x025C4C..0x025C52 */
        utype[i] = c->unit_type_at_40[i];          /* @asm 0x025C56 [bx+si+0x40] */
        aux[i]   = (uint8_t)overlay_call_181F_0D1C(); /* @asm 0x025C5E (i) -> [bp+si-0x22] */
        job[i]   = c->job_at_20[i];                /* @asm 0x025C6D [bx+si+0x20] */
    }

    overlay_call_191F_0870();                     /* @asm 0x025C92 (&snapshots,pop) SORT -> perm */

    for (i = 0; i < n; i++)                        /* @asm 0x025C97..0x025CBD build perm[key[i]] = i */
        perm[ key[i] ] = (uint8_t)i;               /* @asm 0x025CA4..0x025CAC */

    for (i = 0; i < n; i++) {                      /* @asm 0x025CBF..0x025CFA scatter back */
        int p = perm[i];
        c->unit_type_at_40[p] = utype[i];          /* @asm 0x025CD4 [bx+di+0x40] = utype */
        c->job_at_20[i]       = job[i];            /* @asm 0x025CDA [bx+si+0x20] = job */
        overlay_call_181F_0A7E();                  /* @asm 0x025CE4 (perm, aux[i]) apply */
    }

    /* remap selected-colonist index [0x8D7C] through perm  @asm 0x025CFC..0x025D07 */
    *(int16_t near*)DGROUP_PTR(0x8D7C)
        = perm[ *(int16_t near*)DGROUP_PTR(0x8D7C) ];

    /* rewrite the 20 surrounding tile_state assignments  @asm 0x025D08..0x025D2E */
    for (i = 0; i < 0x14; i++) {                    /* loop i < 0x14 (20 tiles) */
        int8_t a = (int8_t)c->tile_state_70[i];     /* @asm 0x025D14 [bx+si+0x70] */
        if (a >= 0)                                 /* @asm 0x025D1A or al,al / jl */
            c->tile_state_70[i] = perm[a];          /* @asm 0x025D21 [bx+si+0x70] = perm[a] */
    }
}

/* ============================================================================
 * colony_draw_random_layout  (func_025D34)
 *   @asm        0x025D34..0x025EAF  (442 bytes, ENTER 0x38)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED, incl. random_int
 *               call site; the precise table identities are inferred)
 *   @role       build a randomized placement map of the colony's producible
 *               goods into display slots, using random_int (0x181F:0x4D4).
 *
 * Confirms the prompt's `random_int 0x181F:0x04D4`: @asm 0x025DE2 LCALL
 * 0x181F:0x4D4 with args (0, count-1).  Steps:
 *   - 0x181F:0xD62 (begin/reset the layout pass).                  @asm 0x025D3A
 *   - clear 15 (0xF) slots in tables 0x8E92 ([bx-0x716E]) and 0x8E82
 *     ([bx-0x717E]) to 0xFF, and 5 word counters at [bp-0xE] to 0.  @asm 0x025D44..0x025D79
 *   - using the (5 x N) config tables at DGROUP 0x224 (count per row) and
 *     0x22A (value per row) it flattens entries into a 0x2A (42) work list at
 *     0x8D62 ([bx-0x729E]).                                        @asm 0x025D7B..0x025E07
 *   - for each of the 42 entries it computes a slot = random_int(0, v-1) + base
 *     (base = table 0x22A[entry]) and, if that slot in 0x8E92 is free (>=0),
 *     claims it (stores the entry index).                          @asm 0x025E09..0x025E5A via 0x181F:0x4D4
 *   - second pass over 42 entries: reads the 12-byte-stride table 0x8F88
 *     ([bx*12-0x7078]) to pick a column, and if 0x181F:0x9FC(entry) says the
 *     good is produced, records it into 0x8E82.                    @asm 0x025E5C..0x025EAA
 * (The tail past RETF @0x025EAF -- the 0x191F:0x87A / 0x181F:0x772 block at
 *  0x025EB0.. -- belongs to the NEXT function and is not part of this body.)
 * ============================================================================ */
void colony_draw_random_layout(void)
{
    int i, row, k;
    int slot_taken[0x10];   /* [bp-0x36] stack scratch: claimed-slot markers */
    int row_used[5];        /* [bp-0xE]  stack scratch: per-row counters */

    overlay_call_181F_0D62();                     /* @asm 0x025D3A begin layout pass */

    for (i = 0; i < 0xF; i++) {                   /* @asm 0x025D44..0x025D61 clear 15 slots */
        *(uint8_t near*)DGROUP_PTR(0x8E92 + i) = 0xFF; /* @asm 0x025D49 [bx-0x716E]=0xFF */
        *(uint8_t near*)DGROUP_PTR(0x8E82 + i) = 0xFF; /* @asm 0x025D4D [bx-0x717E]=0xFF */
        slot_taken[i] = -1;                        /* @asm 0x025D55 word[bp+si-0x36]=0xFFFF */
    }
    for (i = 0; i < 5; i++)                        /* @asm 0x025D63..0x025D79 zero 5 counters */
        row_used[i] = 0;                           /* @asm 0x025D6D word[bp+si-0xE]=0 */

    /* flatten the (5 x N) config at 0x224/0x22A into the 42-entry list 0x8D62 */
    for (row = 0; row < 5; row++) {                /* @asm 0x025D7B..0x025E07 */
        int cnt = *(uint8_t near*)DGROUP_PTR(0x0224 + row); /* @asm 0x025D88 [bx+0x224] */
        for (k = 0; k < cnt; k++) {                 /* @asm 0x025D8E cmp ax,[bp-4]; jle */
            int val = *(uint8_t near*)DGROUP_PTR(0x022A + row); /* @asm 0x025D98 [si+0x22A] */
            *(uint8_t near*)DGROUP_PTR(0x8D62 + k) = (uint8_t)val; /* @asm 0x025DA3 [bx+si-0x729E]=val */
        }
    }

    /* randomized claim pass: slot = random_int(0, val-1) + base  @asm 0x025E09..0x025E5A */
    for (i = 0; i < 0xF; i++) {                    /* loop [bp-0x12] < 0xF */
        int e   = *(uint8_t near*)DGROUP_PTR(0x8D62 + i); /* @asm 0x025DC2 [bx-0x729E] */
        int base= *(uint8_t near*)DGROUP_PTR(0x022A + e); /* @asm 0x025DCB [bx+0x22A] */
        int val = *(uint8_t near*)DGROUP_PTR(0x0224 + e); /* @asm 0x025DD4 [bx+0x224] */
        int slot;
        do {
            slot = overlay_call_181F_04D4()        /* @asm 0x025DE2 LCALL 0x181F:0x4D4 = random_int(0, val-1) */
                 + base;                            /* @asm 0x025DEA add ax,base */
        } while (*(int8_t near*)DGROUP_PTR(0x8E92 + slot) >= 0); /* @asm 0x025DF2 cmp [bx-0x716E],0; jge retry */
        *(uint8_t near*)DGROUP_PTR(0x8E92 + slot) = (uint8_t)i;  /* @asm 0x025DFC claim slot */
        (void)val;
    }

    /* produced-good pass over the 42 entries (stride-12 table 0x8F88) */
    for (i = 0; i < 0x2A; i++) {                   /* @asm 0x025E0E..0x025E5A loop < 0x2A */
        int col = *(int8_t far*)(MK_FP(0,0x8F88) + i*12); /* @asm 0x025E1A [bx*12-0x7078] */
        if (slot_taken[col] < 0)                    /* @asm 0x025E26 cmp word[bp+col-0x36],0 / jge skip */
            slot_taken[col] = row_used[ *(int8_t far*)(MK_FP(0,0x8F87) + i*12) ]++; /* @asm 0x025E2C..0x025E50 */
    }
    for (i = 0; i < 0x2A; i++) {                   /* @asm 0x025E5C..0x025EAA second pass */
        if (overlay_call_181F_09FC()) continue;     /* @asm 0x025E64 0x9FC(i); or/jne */
        /* record produced good index into 0x8E82 via the 0x8F88 column + slot_taken */
        {
            int col = *(int8_t far*)(MK_FP(0,0x8F88) + i*12); /* @asm 0x025E81 [bx*12-0x7078] */
            *(uint8_t near*)DGROUP_PTR(0x8E82 + slot_taken[col]) = (uint8_t)i; /* @asm 0x025E9F [bx-0x717E]=i */
        }
    }
}

/* ============================================================================
 * colony_draw_label_box  (func_025EEE)
 *   @asm        0x025EEE..0x026021  (308 bytes, ENTER 0x5E)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw roles inferred)
 *   @role       draw a bordered, centred text label box for an item, at (x,y).
 *
 * Signature:  void colony_draw_label_box(int good_id, int x, int y, int kind);
 * Reads the sprite-dimension tables [kind+0x230] (w) and [kind+0x236] (h)
 * (DGROUP 0x230/0x236 indexed by kind).  Builds a formatted label in the local
 * buffer [bp-0x50]: if good_id>=0 and 0x181F:0x9FC(good_id) (good is produced)
 * it appends the good's name string ([good_id*12 + 0x8F82] = [bx-0x707E]) via
 * 0x181F:0x16E; for kind==3 it prepends [0x2EB0], else [0x2EAE].  Measures the
 * text (0x181F:0x204), centres it (0x181F:0x35C coord-xform), fills the box
 * background (0x181F:0xBA), sets colour 0xF (0x181F:0x1F0) and draws the text
 * (0x181F:0x1FA).  The window-string slots [0x89E]/[0x8A0], [0x2DA8..0x2DAE]
 * (resolved colours) and [0x2DAC]/[0x2DAE] are the resident draw context.
 * ============================================================================ */
void colony_draw_label_box(int good_id, int x, int y, int kind)
{
    char buf[0x50];                                /* [bp-0x50] label buffer */
    int w, h, tw, bx0, by0;

    w = *(int8_t far*)(MK_FP(0,0x0230) + kind);    /* @asm 0x025EF5 [bx+0x230] sprite width */
    h = *(int8_t far*)(MK_FP(0,0x0236) + kind);    /* @asm 0x025EFD [bx+0x236] sprite height */
    buf[0] = 0;                                     /* @asm 0x025F05 byte[bp-0x50]=0 */

    if (good_id >= 0 && overlay_call_181F_09FC()) { /* @asm 0x025F09 cmp good_id,0; 0x025F12 0x9FC */
        /* append good name string [good_id*12 + 0x8F82]  @asm 0x025F1E..0x025F37 */
        overlay_call_181F_016E();                   /* @asm 0x025F32 (str,&buf) append-fmt */
    }
    if (kind == 3) {                                /* @asm 0x025F3A cmp kind,3 */
        overlay_call_181F_0178();                   /* @asm 0x025F44 (&buf) reset/term */
        /* push [0x2EB0]; append  @asm 0x025F4C */
        overlay_call_181F_016E();                   /* @asm 0x025F5A append [0x2EB0] */
    } else {
        /* push [0x2EAE]; append  @asm 0x025F52 */
        overlay_call_181F_016E();                   /* @asm 0x025F5A append [0x2EAE] */
    }

    tw = overlay_call_181F_0204() - 1;              /* @asm 0x025F71 measure text -> width-1 [bp-0x5E] */
    (void)tw; (void)w; (void)h;
    bx0 = overlay_call_181F_035C();                 /* @asm 0x025FC6 coord-xform -> centred x [bp-0x52] */
    by0 = y;                                         /* @asm 0x025F93 [bp-0x54] = y, adjusted below */
    (void)by0;
    overlay_call_181F_00BA();                        /* @asm 0x025FEC fill box (colours [0x2DA8..]) */
    overlay_call_181F_01F0();                        /* @asm 0x025FFB set colour 0xF */
    overlay_call_181F_01FA();                        /* @asm 0x02601B draw text at (bx0+1,by0+1) */
}

/* ============================================================================
 * colony_draw_stat_row  (func_026022)
 *   @asm        0x026022..0x026141  (288 bytes, ENTER 0x64)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw roles inferred)
 *   @role       render one labelled stat row (idx) of the colony info panel:
 *               "<label>: <value>" inside a box, at row y = idx*0x13 + 0xA.
 *
 * Signature:  void colony_draw_stat_row(int idx);
 * Builds the label from the string-key table 0x97C0 ([idx*2 + 0x97C0],
 * i.e. [bx-0x6840]) via 0x181F:0x16E/0x178/0x11E, then appends the colony's
 * value ctx->stockpile_9a-area word [ctx + idx*2 + 0x9A] via 0x181F:0x182, and
 * a trailing separator string [0x2E2E] (0x181F:0x16E/0x128).  Measures
 * (0x181F:0x204), positions at x from [0x89E]/[0x8A0] and y = idx*0x13+0xA,
 * fills box (0x181F:0xBA), colour 0xF (0x181F:0x1F0), draws text (0x181F:0x1FA).
 * ============================================================================ */
void colony_draw_stat_row(int idx)
{
    char buf[0x50];                                /* [bp-0x50] */
    int y, tw;

    /* label from string-key table 0x97C0[idx]  @asm 0x02602B..0x026057 */
    overlay_call_181F_016E();                       /* @asm 0x02603A append [idx*2+0x97C0] */
    overlay_call_181F_0178();                       /* @asm 0x026046 reset/term */
    overlay_call_181F_011E();                       /* @asm 0x026052 (label prefix) */

    /* colony value word [ctx + idx*2 + 0x9A]  @asm 0x02605A..0x02606C */
    overlay_call_181F_0182();                       /* @asm 0x026067 append ctx[si+0x9A] */
    overlay_call_181F_0178();                       /* @asm 0x026073 reset/term */
    /* trailing separator [0x2E2E]  @asm 0x02607B */
    overlay_call_181F_016E();                       /* @asm 0x026083 append [0x2E2E] */
    overlay_call_181F_0128();                       /* @asm 0x02608F finalize */

    y  = idx * 0x13 + 0xA;                          /* @asm 0x0260A1 imul idx,0x13; add 0xA [bp-0x5C] */
    tw = overlay_call_181F_0204() - 1;              /* @asm 0x0260C1 measure -> width-1 [bp-0x64] */
    (void)tw; (void)y;
    overlay_call_181F_035C();                        /* @asm 0x0260DD coord-xform -> x [bp-0x56] */
    overlay_call_181F_00BA();                        /* @asm 0x02610C fill box (colours [0x2DA8..],h=7) */
    overlay_call_181F_01F0();                        /* @asm 0x02611B set colour 0xF */
    overlay_call_181F_01FA();                        /* @asm 0x02613A draw text */
}

/* ============================================================================
 * colony_draw_worktile_info  (func_026142)
 *   @asm        0x026142..0x02633D  (507 bytes, ENTER 0x6E)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw roles inferred)
 *   @role       draw the info box for the surrounding work-tile at grid index
 *               `tile_dir`: terrain name + special features + resource bonus.
 *
 * Signature:  void colony_draw_worktile_info(int tile_dir);
 * Returns early if tile_dir<0 or the layout table 0x8DF0 ([row*5+col-0x7210])
 * bit 0x10 is set (tile not shown).  Decomposes tile_dir into row=tile_dir>>3,
 * col=tile_dir&7; computes the world tile from ctx->map_x/map_y + (row-2,col-2)
 * and looks up its terrain id via 0x181F:0x78C (the SAME terrain-id lookup
 * spring_turn_process uses).  If terrain==0x19 (ocean / sea-lane base) it
 * consults 0x181F:0x6B4.  Formats the terrain name (0x181F:0x1E6) or special
 * string (0x181F:0x16E[0x2E0A]).  Tests feature masks via 0x181F:0x72C
 * (bit 0x40 -> "/" road [0x2DB4]/[0x2DB6]; bit 0x80) and 0x181F:0x754
 * (bit 0xA river-mouth -> GAME.TXT key 0xBA9; bit 0x40 special resource ->
 * key 0xBAB + [0x2E60]).  Positions at x=row*0x18+8, y=col*0x18+0xD4, measures
 * (0x181F:0x204), draws box (0x181F:0xBA) + text (0x181F:0x1FA).  String keys
 * 0xBA7/0xBA9/0xBAB are fetched via the GAME.TXT engine (0xD1D:0x7A4).
 * ============================================================================ */
void colony_draw_worktile_info(int tile_dir)
{
    struct colony_t far *c = ctx;
    char buf[0x50];                                /* [bp-0x50] */
    int row, col, wx, wy, terr;

    if (tile_dir < 0) return;                       /* @asm 0x026148 cmp [bp+6],0 / jl -> ret */
    row = tile_dir >> 3;                            /* @asm 0x026154 sar ax,3 [bp-0x56] */
    col = tile_dir & 7;                             /* @asm 0x02615F and si,7 [bp-0x52] */
    if (*(uint8_t far*)(MK_FP(0,0x8DF0) + (col*5) + row) & 0x10) /* @asm 0x02616C [bx+si-0x7210] test 0x10 */
        return;                                     /* @asm 0x026171 je / jmp -> ret */

    wy = c->map_y + row - 2;                        /* @asm 0x02617A ctx[+1]+row; dec;dec [bp-0x5C] */
    wx = c->map_x + col - 2;                        /* @asm 0x02618C ctx[+0]+col; dec;dec [bp-0x5A] */
    terr = overlay_call_181F_078C();                /* @asm 0x026199 LCALL 0x181F:0x78C(wx,wy) terrain id */
    buf[0] = 0;                                     /* @asm 0x026187 byte[bp-0x50]=0 */
    (void)wx; (void)wy;

    if (terr == 0x19) {                             /* @asm 0x0261A4 cmp ax,0x19 (ocean/sea-lane) */
        if (overlay_call_181F_06B4() != 1)          /* @asm 0x0261AF (wx,wy); dec al / je */
            overlay_call_181F_016E();               /* @asm 0x0261C3 append special str [0x2E0A] */
    } else {
        overlay_call_181F_01E6();                   /* @asm 0x0261D1 append terrain name(terr) */
    }

    if (overlay_call_181F_072C() & 0x40) {          /* @asm 0x0261DF (wx,wy); test al,0x40 (road/river) */
        overlay_call_0D1D_07A4();                   /* @asm 0x0261F2 LCALL 0xD1D:0x7A4 GAME.TXT key 0xBA7 */
        if (overlay_call_181F_072C() & 0x80)        /* @asm 0x026200 test al,0x80 */
            overlay_call_181F_016E();               /* @asm 0x02620C append [0x2DB4] "/" */
        else
            overlay_call_181F_016E();               /* @asm 0x02621A append [0x2DB6] */
    }
    /* river-mouth feature  @asm 0x026222..0x02625C */
    if ((overlay_call_181F_0754() & 0xA) || (wx==2 && wy==2)) { /* @asm 0x026230 test al,0xA */
        overlay_call_0D1D_07A4();                   /* @asm 0x026247 GAME.TXT key 0xBA9 */
        overlay_call_181F_016E();                   /* @asm 0x026257 append [0x2DF8] */
    }
    /* special resource feature  @asm 0x02625F..0x02628D */
    if (overlay_call_181F_0754() & 0x40) {          /* @asm 0x02626D test al,0x40 */
        overlay_call_0D1D_07A4();                   /* @asm 0x026278 GAME.TXT key 0xBAB */
        overlay_call_181F_016E();                   /* @asm 0x026288 append [0x2E60] */
    }

    /* position + draw  @asm 0x026290..0x026339 */
    /* x = row*0x18 + 8 [bp-0x58]; y = col*0x18 + 0xD4 [bp-0x54] */
    overlay_call_181F_0204();                        /* @asm 0x0262AB measure text */
    overlay_call_181F_035C();                        /* @asm 0x0262DB coord-xform */
    overlay_call_181F_00BA();                        /* @asm 0x026306 fill box (h=7) */
    overlay_call_181F_01F0();                        /* @asm 0x026315 set colour 0xF */
    overlay_call_181F_01FA();                        /* @asm 0x026334 draw text */
}

/* ============================================================================
 * draw_text_colored  (func_02633E)
 *   @asm        0x02633E..0x026373  (54 bytes, PUSH BP;MOV BP,SP)  page_02.asm
 *   @status     BYTE_VERIFIED (extent + control flow; leaf target impl in thunk layer)
 *   @role       thin wrapper: draw 4-arg text/sprite via 0x181F:0x444 after
 *               pushing the resident palette ([0x839E..0x83A4]) and the four
 *               resolved colour words ([0x2DA8..0x2DAE]).
 *
 * Signature:  int draw_text_colored(int a, int b, int c, int d);
 * ============================================================================ */
int draw_text_colored(int a, int b, int c, int d)
{
    /* push [0x83A4],[0x83A2],[0x83A0],[0x839E]  @asm 0x026341..0x02634D (palette) */
    /* push [0x2DAE],[0x2DAC],[0x2DAA],[0x2DA8]  @asm 0x026351..0x02635D (colours) */
    /* push d; ax=a; dx=b; bx=c; LCALL 0x181F:0x444  @asm 0x026361..0x02636D */
    (void)a; (void)b; (void)c; (void)d;
    return overlay_call_181F_0444();                 /* @asm 0x02636D LCALL 0x181F:0x444 */
}

/* ============================================================================
 * colony_draw_units_panel  (func_026374)
 *   @asm        0x026374..0x0264A7  (308 bytes, ENTER 0xE)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw roles inferred)
 *   @role       render the colony's surrounding-map panel: the centre backdrop
 *               plus every unit standing in/around the colony.
 *
 * Sets the resident "current tile" [0x17C]/[0x17E] = ctx->map_x/map_y.  Calls
 * 0x181F:0xC5E -> a per-colony render-info pointer; primes the sub-render with
 * ctx->owner_power(+0x1A) via 0x191F:0x8A4/0x896/0x888.  Draws the centre
 * backdrop sprite (0x181F:0x510, a 0x50x0x50 tile at screen 8,0xC8).  Then,
 * over the unit count [info+0x329], for each unit i: computes its screen tile
 * from per-unit delta tables [info+0xDE]/[info+0xC8] + ctx->map_x/map_y,
 * bounds-checks (0x181F:0x302), tests the colony occupancy mask via 0x181F:0x74A
 * (1 << owner_power), resolves the unit at that tile (0x181F:0x718), and blits
 * it (0x181F:0x254) at screen ([0x174]/[0x176] + i*0x18 + 0x3C, ...+0xFC).
 * ============================================================================ */
void colony_draw_units_panel(void)
{
    struct colony_t far *c = ctx;
    int count, i;

    *(int16_t near*)DGROUP_PTR(0x017C) = c->map_x;  /* @asm 0x02637D [0x17C]=ctx[+0] */
    *(int16_t near*)DGROUP_PTR(0x017E) = c->map_y;  /* @asm 0x026384 [0x17E]=ctx[+1] */

    overlay_call_181F_0C5E();                        /* @asm 0x02638A -> render-info ptr (dx) */
    overlay_call_191F_08A4();                        /* @asm 0x02639A prime sub-render (owner_power) */
    overlay_call_191F_0896();                        /* @asm 0x02639F */
    overlay_call_191F_0888();                        /* @asm 0x0263A4 */

    overlay_call_181F_0510();                        /* @asm 0x0263D6 centre backdrop sprite @ (8,0xC8) */

    count = *(uint8_t far*)(/*info*/MK_FP(0,0) + 0x329); /* @asm 0x0263E5 [bx+0x329] unit count */
    for (i = 0; i < count; i++) {                    /* @asm 0x0263EE..0x0264A2 loop i, [bp-2] */
        int sx, sy;
        /* sy = info[+0xDE] + ctx->map_y;  sx = info[+0xC8] + ctx->map_x  @asm 0x0263FA..0x026419 */
        sy = /*info[+0xDE]*/0 + c->map_y;
        sx = /*info[+0xC8]*/0 + c->map_x;
        (void)sx; (void)sy;
        if (overlay_call_181F_0302() == 0) continue; /* @asm 0x02641D bounds check; or/je */
        if (c->owner_power < 4) {                    /* @asm 0x02642D cmp ctx[+0x1A],4 / jae */
            int mask = overlay_call_181F_074A();     /* @asm 0x026439 occupancy mask(sx,sy) */
            if ((mask & (0x10 << c->owner_power)) == 0) /* @asm 0x02644A shl 0x10,owner; test */
                continue;                            /* @asm 0x026451 je */
        }
        if (overlay_call_181F_0718() == -1) continue;/* @asm 0x026459 unit-at(sx,sy); inc; je */
        overlay_call_181F_0254();                    /* @asm 0x026492 blit unit sprite at screen pos */
    }
}

/* ----------------------------------------------------------------------------
 * Near-call helpers in THIS overlay but OUTSIDE this file's range (page-02
 * tail, file 0x02C9xx..0x02CAxx; reached via `push cs; call <ip>`).  Their file
 * offset = 0x024BF0 + page-relative-IP.  Declared locally (do not edit the
 * shared header); bodies live elsewhere in page 0x02.  Identified by use:
 *   func_02CAC3 (ip 0x7ED3) draw filled panel/frame
 *   func_02CA1E (ip 0x7E2E) draw two-state indicator widget
 *   func_02CA23 (ip 0x7E33) draw colonist roster icon (with assign idx)
 *   func_02CAE1 (ip 0x7EF1) draw colonist roster icon (no assign idx)
 *   func_02CA46 (ip 0x7E56) production-bar metrics (out a,b,c)
 *   func_02CA55 (ip 0x7E65) draw production up-arrow / surplus
 *   func_02C9B5 (ip 0x7DC5) draw production down-arrow / deficit
 *   func_02C9BF (ip 0x7DCF) measure box label
 *   func_02C9?? (ip 0x7EFB) build precondition probe (0,0,0)
 *   func_02C9FC (ip 0x7DFC) misc redraw
 * ---------------------------------------------------------------------------- */
extern int  func_02CAC3(void);   /* ip 0x7ED3 */
extern int  func_02CA1E(void);   /* ip 0x7E2E */
extern int  func_02CA23(void);   /* ip 0x7E33 */
extern int  func_02CAE1(void);   /* ip 0x7EF1 */
extern int  func_02CA46(void);   /* ip 0x7E56 */
extern int  func_02CA55(void);   /* ip 0x7E65 */
extern int  func_02C9B5(void);   /* ip 0x7DC5 */
extern int  func_02C9BF(void);   /* ip 0x7DCF */
extern int  overlay_near_07EFB(void); /* ip 0x7EFB build-precondition probe */

/* ============================================================================
 * colony_draw_workgrid  (func_0264A8)
 *   @asm        0x0264A8..0x0268CD  (1062 bytes, ENTER 0x20)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw roles inferred)
 *   @role       render the colony work-grid: the 5x5 block of surrounding map
 *               squares with their terrain, the colonist working each, and the
 *               yield icon+amount; plus the selected-tile highlight.
 *
 * Signature:  void colony_draw_workgrid(int show_close_button);
 * Draws the map backdrop (0x181F:0x506 at 0x78x0x78 @ (8,0xC8)), the panel
 * frame (func_02CAC3 @ (0xE0,0x20)), and two divider lines (0x181F:0xCE).
 * Double loop over rows r=0..4 ([bp-0x14]) x cols col=0..4 ([bp-0x12]); per
 * cell it reads the layout table 0x8DF0 (stride 5: [r*5+col-0x7210]) -> flags:
 *   bit 0x40  -> draw the cell border (0x181F:0xCE)              @asm 0x02655C
 *   not-0x40 + table 0x8D9E[r*5+col]>=0 -> draw cell tile via 0x181F:0x254 (id 0x6D)  @asm 0x02658D
 *   bit 0x80  -> the cell holds a colonist: world tile from ctx->map_x/map_y +
 *                (col-2,r-2), 0x181F:0x7E0, then scan units whose UnitRecord
 *                type byte[+2] (0x3146, stride 0x1C) maps via the terrain/unit
 *                stat table [type*30 + 0x5236] <= 1, advance via 0x181F:0x2E4,
 *                and draw the colonist (0x181F:0x2BC, id 0x64).  @asm 0x0265C4..0x02663D
 *   bit 8     -> special-resource marker (0x181F:0x236 sprite 0x17 with the
 *                [0xA891]/[0xA893]/[0xA894] palette offsets).   @asm 0x02663E..0x02668F
 * After flags it resolves the worked good (0x181F:0xB3C), draws its bonus
 * sprite (0x181F:0x236), the goods icon (0x181F:0xCE0 -> good id; 0x181F:0x254),
 * and (if produced) the worker pip (0x181F:0xA74/0x24A).  Highlights the
 * selected colonist [0x8D7C]/[0x8D7E] and the cursor cell [0x330]/[0x332] with
 * a coloured border (0x181F:0xCE).  Closes with optional button (0x181F:0xE2).
 * Loop layout: each cell screen pos = (col*0x18+0xC8 [bp-8], r*0x18+8 [bp-0xC]).
 * ============================================================================ */
void colony_draw_workgrid(int show_close_button)
{
    struct colony_t far *c = ctx;
    int r, col, flags;

    *(int16_t near*)DGROUP_PTR(0x0070)
        = *(uint8_t near*)DGROUP_PTR(0x0336);       /* @asm 0x0264AD [0x70]=[0x336] */

    overlay_call_181F_0506();                       /* @asm 0x0264E1 map backdrop (0x78x0x78 @8,0xC8) */
    func_02CAC3();                                  /* @asm 0x0264F3 panel frame @ (0xE0,0x20) */
    overlay_call_181F_00CE();                       /* @asm 0x026517 divider line @ (0x140,7,0x80) */
    overlay_call_181F_00CE();                       /* @asm 0x026539 divider line @ (0x128,0x1F,0x68) */

    for (r = 0; r < 5; r++) {                       /* @asm 0x02653E..0x0268A1 outer rows [bp-0x14] */
        for (col = 0; col < 5; col++) {             /* @asm 0x026546..0x026896 inner cols [bp-0x12] */
            int cell_x, cell_y;
            if (r==0 && col==0) continue;           /* (corner skips per loop guards @0x0267A8..) */
            if (r==4 || col==4) { /* edge handling per @asm 0x0267B4.. */ }

            cell_y = col * 0x18 + 0xC8;             /* @asm 0x026794 [bp-8] */
            cell_x = r   * 0x18 + 8;                /* @asm 0x02679E [bp-0xC] */
            (void)cell_x; (void)cell_y;

            flags = *(uint8_t far*)(MK_FP(0,0x8DF0) + (r*5) + col); /* @asm 0x026553 [bx+si-0x7210] */

            if (flags & 0x40)                       /* @asm 0x02655C test al,0x40 */
                overlay_call_181F_00CE();           /* @asm 0x026584 draw cell border (id 0xC) */
            else if (*(int8_t far*)(MK_FP(0,0x8D9E)+(r*5)+col) >= 0) /* @asm 0x02659C [bx+si-0x7262]>=0 */
                overlay_call_181F_0254();           /* @asm 0x0265BF draw cell tile (id 0x6D) */

            if (flags & 0x80) {                     /* @asm 0x0265C4 test al,0x80 (colonist present) */
                int wy = c->map_y + r - 2;          /* @asm 0x0265CE ctx[+1]+r; dec;dec [bp-0xA] */
                int wx = c->map_x + col - 2;        /* @asm 0x0265DD ctx[+0]+col; dec;dec [bp-6] */
                (void)wx; (void)wy;
                overlay_call_181F_07E0();           /* @asm 0x0265E9 tile-at(wx,wy) */
                /* scan colonists whose UnitRecord type stat <= 1  @asm 0x0265F0..0x02661A */
                /* (UnitRecord[u].byte[+2] @ 0x3146 stride 0x1C -> [type*30 + 0x5236]) */
                while (overlay_call_181F_02E4() >= 0) { /* @asm 0x026610 advance to next unit */
                    /* if its stat byte > 1 stop  @asm 0x026606 cmp [bx+0x5236],1 / ja */
                    break;
                }
                overlay_call_181F_02BC();           /* @asm 0x026639 draw colonist (id 0x64) */
            }

            if (flags & 8) {                        /* @asm 0x02663E test al,8 (special resource) */
                overlay_call_181F_0236();           /* @asm 0x02665D bonus sprite 0x17 ([0xA891] pal) */
                if (*(int8_t near*)DGROUP_PTR(0xA893) >= 0) /* @asm 0x026662 cmp [0xA893],0 / jl */
                    overlay_call_181F_0236();       /* @asm 0x02668A second bonus sprite */
            }

            /* worked-good resolve + draw  @asm 0x02668F..0x02675B */
            overlay_call_181F_0B3C();               /* @asm 0x02669B (1,&[bp-0x10],r,col) -> which good */
            overlay_call_181F_0CE0();               /* @asm 0x0266B5 (r,col) -> good id */
            overlay_call_181F_0C0E();               /* @asm 0x0266D2 (good id) -> sprite base */
            overlay_call_181F_0236();               /* @asm 0x026700 draw good bonus sprite */
            overlay_call_181F_0254();               /* @asm 0x02673E draw goods icon (id from above) */

            if (/*[bp-0x10] worked-tile idx*/ 1 >= 0) { /* @asm 0x02675D cmp [bp-0x10],0 / jl */
                overlay_call_181F_0A74();           /* @asm 0x026768 (3,idx) -> worker pip */
                overlay_call_181F_024A();           /* @asm 0x02677C draw pip */
            }

            if (*(int16_t near*)DGROUP_PTR(0x0B98) == 0) { /* @asm 0x026781 cmp [0xB98],0 / je 0x1BD6 */
                /* selected-colonist highlight  @asm 0x0267C6..0x026815 */
                if (*(int16_t near*)DGROUP_PTR(0x8D7C) == /*idx*/0) /* @asm 0x0267E8 cmp [0x8D7C],ax */
                    overlay_call_181F_00CE();       /* @asm 0x026810 highlight border (id 0xA) */
                /* cursor-cell highlight when [0x330]/[0x332] match (col,r) */
                if (*(int16_t near*)DGROUP_PTR(0x0330) == col && /* @asm 0x026857 cmp [0x330] */
                    *(int16_t near*)DGROUP_PTR(0x0332) == r)      /* @asm 0x026862 cmp [0x332] */
                    overlay_call_181F_00CE();       /* @asm 0x026891 cursor border (id 0xF) */
            }
        }
    }

    *(int16_t near*)DGROUP_PTR(0x0070) = 0;         /* @asm 0x0268AC [0x70]=0 */
    if (show_close_button)                          /* @asm 0x0268B2 cmp [bp+6],0 / je */
        overlay_call_181F_00E2();                   /* @asm 0x0268C6 close button @ (0xC8,8,0x78) */
}

/* ============================================================================
 * colony_draw_header  (func_0268CE)
 *   @asm        0x0268CE..0x026AB1  (483 bytes, ENTER 0x54)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw roles inferred)
 *   @role       build and draw the colony screen header banner:
 *               "<Name>, <fortification> of <Nation>" + population + year line.
 *
 * Signature:  void colony_draw_header(int year_or_flag);
 * Early-out unless this is an active European colony: ctx->owner_power(+0x1A)
 * < 4 AND AIPersonality[owner*0x34 + 0x543F] != 0 (the active-power byte), and
 * neither the "no header" flags [0xB98] nor [0x828] are set.  Then it formats
 * the banner string in [bp-0x50]:
 *   - ctx->byte[+0x1B] (name id) via 0x181F:0x1A0 (number/name to string)  @asm 0x02690F
 *   - 4 name characters ctx->byte[+0x8C..+0x8F] via 0x181F:0x182, with the
 *     2nd char's string-key from table 0x97C0[ctx[+0x8D]] (0x181F:0x16E)  @asm 0x026930..0x026982
 *   - " of " separator [0x2E38] (0x181F:0x16E)                            @asm 0x026984
 *   - colony location string via 0x181F:0x722(map_x,map_y) (0x181F:0x182) @asm 0x0269A0
 *   - fortification level string [owner*0x10 + ctx[+0x1A]*0x10 + 0x9870]
 *     ([bx+si-0x6790]) (0x181F:0x182)                                     @asm 0x0269D2
 * Branch when not-active (label 0x1E08): builds a simpler "<colony at +2>" line
 * via 0xD1D:0x7E4 + nation name table 0x9800[+ [0x538C]] (0x181F:0x16E) and the
 * king/owner string [0x538A].  Both paths finish with the population/era line
 * via 0x181F:0x22(year), 0xD1D:0x11B4 and draw it (0x181F:0xB0 with arg).
 * ============================================================================ */
void colony_draw_header(int year_or_flag)
{
    struct colony_t far *c = ctx;
    char buf[0x50];                                 /* [bp-0x50] */
    int i;

    /* active-European-colony gate  @asm 0x0268D3..0x026902 */
    if (c->owner_power < 4 &&                        /* @asm 0x0268D7 cmp ctx[+0x1A],4 / jae */
        *(uint8_t far*)(MK_FP(0,0x543F) + c->owner_power*0x34) == 0) /* @asm 0x0268E5 cmp [bx+0x543F],0 */
        goto inactive;                               /* @asm 0x0268EB jmp 0x1E08 */
    if (*(int16_t near*)DGROUP_PTR(0x0B98) != 0) goto inactive; /* @asm 0x0268EE cmp [0xB98],0 */
    if (*(uint8_t near*)DGROUP_PTR(0x0828) != 0) goto inactive; /* @asm 0x0268F8 cmp [0x828],0 */

    buf[0] = 0;                                      /* @asm 0x026902 byte[bp-0x50]=0 */
    overlay_call_181F_01A0();                        /* @asm 0x026915 (ctx[+0x1B] name id) -> str */
    overlay_call_181F_0178();                        /* @asm 0x026921 reset/term */
    for (i = 0; i < 4; i++) {                        /* @asm 0x026929..0x026982 4 name chars */
        overlay_call_181F_0182();                    /* @asm 0x026942 append ctx[si+0x8C] */
        overlay_call_181F_0178();                    /* @asm 0x02694E reset/term */
        if (i == 1)                                  /* @asm 0x02695F cmp [bp-0x54],1 */
            overlay_call_181F_016E();                /* @asm 0x02697A append [ctx[+0x8D]*2+0x97C0] */
    }
    overlay_call_181F_016E();                        /* @asm 0x02698C append " of " [0x2E38] */
    overlay_call_181F_0178();                        /* @asm 0x026998 reset/term */
    overlay_call_181F_0722();                        /* @asm 0x0269AD (map_x,map_y) location code */
    overlay_call_181F_0182();                        /* @asm 0x0269BE append location */
    overlay_call_181F_01BE();                        /* @asm 0x0269CA (separator) */
    /* fortification string [owner*0x10 + ctx[+0x1A] base + 0x9870]  @asm 0x0269D2..0x0269F2 */
    overlay_call_181F_0182();                        /* @asm 0x0269ED append fort-level string */
    goto finish;                                     /* @asm 0x0269F5 jmp 0x1E71 */

inactive:
    /* simple "<colony at ctx+2>" path  @asm 0x0269F8..0x026A5E */
    overlay_call_0D1D_07E4();                        /* @asm 0x026A02 (&buf, ctx+2) base name */
    overlay_call_181F_01DC();                        /* @asm 0x026A0E (finalize) */
    overlay_call_181F_0178();                        /* @asm 0x026A1A reset/term */
    overlay_call_181F_016E();                        /* @asm 0x026A30 append nation [ [0x538C]*2 + 0x9800 ] */
    overlay_call_181F_01B4();                        /* @asm 0x026A3C (separator) */
    overlay_call_181F_0182();                        /* @asm 0x026A4D append owner/king [0x538A] */
    overlay_call_181F_01DC();                        /* @asm 0x026A59 finalize */

finish:
    /* population / era / year line  @asm 0x026A61..0x026AAB */
    (void)year_or_flag;
    overlay_call_181F_0022();                        /* @asm 0x026A65 ( [0x93A0] ) -> measured */
    overlay_call_0D1D_11B4();                        /* @asm 0x026A74 format full banner */
    overlay_call_181F_0178();                        /* @asm 0x026A80 reset/term */
    overlay_call_181F_0B1E();                        /* @asm 0x026A96 (ctx[+0x1A]) fort/banner colour */
    overlay_call_181F_00B0();                        /* @asm 0x026AA6 draw banner (arg = year_or_flag) */
}

/* ============================================================================
 * colony_anim_worked_tiles  (func_026AB2)
 *   @asm        0x026AB2..0x026BCB  (282 bytes, ENTER 0x14)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw/sound inferred)
 *   @role       animate the colonist figures on the surrounding worked tiles
 *               (the little working-colonist sprites), iterating the active set.
 *
 * Signature:  void colony_anim_worked_tiles(int x, int y, int phase);
 * Inits an iterator via 0x181F:0x240(0x67, &x, [0x24B], &step, &cnt, 2, phase)
 * -> step [bp-0x12].  Resolves the colony centre tile (ctx->map_x/map_y,
 * 0x181F:0x7E0).  Main loop driven by 0x181F:0x2E4 (next worked-tile index ->
 * [bp-0x14], <0 ends): for each it draws the colonist sprite from the global
 * unit far-array [0x83E]:[0x840] at offset [idx*0xC + 0x40]/[+0x3E] + (x,y)
 * via 0x181F:0xCE (only when [bp-8]==[0x8D7C], the selected one, gets the
 * special colour set [0x2DA8..]).  Per pass it also runs 0x181F:0xB28 (filter),
 * 0x181F:0xB78 (per-unit update, bounded by [0x8D72]), 0x181F:0xC4A,
 * 0x181F:0xA74, 0x181F:0x24A, and re-arms while [0x7EE]==0 / [0x8D54]==0
 * (using the selected-index latch [0x8D7E]).
 * ============================================================================ */
void colony_anim_worked_tiles(int x, int y, int phase)
{
    struct colony_t far *c = ctx;
    int step, idx, n, sel;

    step = overlay_call_181F_0240();                /* @asm 0x026ADF iterator init(0x67,&x,[0x24B],...,phase) */
    (void)phase;
    /* centre tile  @asm 0x026AE7..0x026AF4 */
    overlay_call_181F_07E0();                       /* @asm 0x026AF4 tile-at(ctx->map_x,map_y) */

    for (;;) {
        idx = overlay_call_181F_02E4();             /* @asm 0x026B56 next worked-tile idx [bp-0x14] */
        if (idx < 0) break;                         /* @asm 0x026B5E or ax,ax / jl 0x1FDA -> ret */
        if (overlay_call_181F_0B28() == 0) continue;/* @asm 0x026B63 (idx) filter; or/je */

        n = *(int16_t near*)DGROUP_PTR(0x8D72);     /* @asm 0x026B6F [0x8D72] count bound */
        /* (inner draw of the selected colonist sprite via [0x83E]:[0x840]) */
        sel = *(int16_t near*)DGROUP_PTR(0x8D7C);   /* @asm 0x026AFC [0x8D7C] selected idx */
        if (/*[bp-0xA]*/ sel == sel)                /* @asm 0x026B05 cmp [bp-4],[bp-0xA] (selected match) */
            overlay_call_181F_00CE();               /* @asm 0x026B48 draw sprite from [idx*0xC+0x3E/0x40] */
        (void)n; (void)x; (void)y; (void)c;

        overlay_call_181F_0B78();                   /* @asm 0x026B7D (idx) per-unit update */
        overlay_call_181F_0C4A();                   /* @asm 0x026B8B (idx) */
        overlay_call_181F_0A74();                   /* @asm 0x026B97 (idx) -> sprite */
        overlay_call_181F_024A();                   /* @asm 0x026BAA (7,x,y) draw pip */
        if (*(int16_t near*)DGROUP_PTR(0x07EE) == 0) continue; /* @asm 0x026BAF cmp [0x7EE],0 / jne */
        if (*(int16_t near*)DGROUP_PTR(0x8D54) == 0) continue; /* @asm 0x026BB9 cmp [0x8D54],0 / je */
        /* selected-index latch refresh from [0x8D7E]  @asm 0x026BC3 */
    }
}

/* ============================================================================
 * colony_draw_colonist_at  (func_026BCC)
 *   @asm        0x026BCC..0x026CC1  (246 bytes, ENTER 0xE)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw/sound inferred)
 *   @role       draw the colonists assigned to a specific colony slot, at (x,y),
 *               with the per-kind animation config; a parameterized sibling of
 *               colony_anim_worked_tiles.
 *
 * Signature:  void colony_draw_colonist_at(int slot, int x, int y, int kind);
 * step = 0x181F:0xB82(kind)  [bp-6].  iterator init 0x181F:0x240(slot+0x52,
 * step, [kind+0x248], &x, &y, 2) -> [bp-0xE].  Loops i=0..ctx->population:
 * for each colonist whose 0x181F:0xC0E(i) == slot it resolves the sprite via
 * 0x181F:0xA74(i) and blits from [0x83E]:[0x840] at [idx*0xC+0x40]/[+0x3E] +
 * (x,y) via 0x181F:0xCE (selected gets colours [0x2DA8..]), advancing x by step
 * each draw and re-arming while [0x7EE]==0/[0x8D54]==0.
 * ============================================================================ */
void colony_draw_colonist_at(int slot, int x, int y, int kind)
{
    struct colony_t far *c = ctx;
    int step, i;

    step = overlay_call_181F_0B82();                /* @asm 0x026BD3 (kind) */
    overlay_call_181F_0240();                       /* @asm 0x026C04 iterator init(slot+0x52,...,[kind+0x248]) */
    (void)step; (void)y; (void)kind;

    for (i = 0; i < c->population; i++) {            /* @asm 0x026C0C..0x026C78 i < ctx[+0x1F] */
        if (overlay_call_181F_0C0E() != slot)       /* @asm 0x026C7D (i); cmp [bp+6]; jne */
            continue;
        overlay_call_181F_0A74();                   /* @asm 0x026C8D (i) -> sprite [bp-8] */
        overlay_call_181F_024A();                   /* @asm 0x026CA1 (7,x,y) */
        /* draw selected colonist sprite from [0x83E]:[0x840]  @asm 0x026C1F..0x026C5F */
        if (*(int16_t near*)DGROUP_PTR(0x8D7C) == i)/* @asm 0x026C1A cmp [0x8D7C],[bp-0xA] */
            overlay_call_181F_00CE();               /* @asm 0x026C5F blit @ [idx*0xC+0x40/+0x3E]+(x+1,y) */
        x += step;                                  /* @asm 0x026C67 add [bp+8],step */
        if (*(int16_t near*)DGROUP_PTR(0x07EE) == 0) continue; /* @asm 0x026CA6 */
        if (*(int16_t near*)DGROUP_PTR(0x8D54) == 0) continue; /* @asm 0x026CB0 */
    }
}

/* ============================================================================
 * colony_bar_metrics  (func_026CC2)
 *   @asm        0x026CC2..0x026DD3  (273 bytes, ENTER 0xC)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads + constants BYTE_VERIFIED;
 *               the bar-min/max jump table is byte-decoded)
 *   @role       compute the (min,max,extra) bar range + sprite category for a
 *               colony detail-bar item (warehouse / production gauge).
 *
 * Signature:  int colony_bar_metrics(int item, int *out_min, int *out_max,
 *                                     int *out_extra);
 * item 0x13/0x14 -> uses [0xA892] (misc adj) with max 0x3F;          @asm 0x026CE2
 * item 0x11      -> uses [0x8DD8] (work-points cumulative) max 0x1F;  @asm 0x026CF8
 * else: cat = 0x181F:0xACE(item) (production category) [bp-0xC]; if <0 bail;
 *       0x181F:0xBAA(item) >=0 required; then a jump table cs:[bx*2+0x1472]
 *       (file 0x026D72) over (cat-9) in 0..8 selecting min/max pairs:
 *         default min=cat,max=cat+0x17;  fixed arms ->(0x10,0x37),(0x11,0x39),
 *         (0x12,0x3F).  Sprite category from table 0x8DC8[min] ([bx-0x7238]);
 *         for cat==0x11 it subtracts [0xA892].                       @asm 0x026D2A..0x026DA1
 * Returns the sprite category in AX; writes min/max/extra via out-params.
 * ============================================================================ */
int colony_bar_metrics(int item, int near *out_min, int near *out_max,
                       int near *out_extra)
{
    int mn = -1, mx = 0, extra = 0, cat;           /* [bp-6],[bp-4],[bp-0xA],[bp-2] */
    int sprite = 0;

    if (item == 0x13 || item == 0x14) {            /* @asm 0x026CD6/0x026CDC */
        sprite = *(uint8_t near*)DGROUP_PTR(0xA892);/* @asm 0x026CE2 [0xA892] */
        mx = 0x3F;                                  /* @asm 0x026CEA mov [bp-4],0x3F */
        goto store;                                 /* @asm 0x026CEF jmp 0x21B4 */
    }
    if (item == 0x11) {                            /* @asm 0x026CF2 */
        sprite = *(int16_t near*)DGROUP_PTR(0x8DD8);/* @asm 0x026CF8 [0x8DD8] work-points */
        mx = 0x1F;                                  /* @asm 0x026CFE mov [bp-4],0x1F */
        goto store;                                 /* @asm 0x026D03 jmp 0x21B4 */
    }

    cat = overlay_call_181F_0ACE();                 /* @asm 0x026D09 (item) production category */
    if (cat < 0) goto store;                        /* @asm 0x026D16 or ax,ax / jge / jmp 0x21B4 */
    if (overlay_call_181F_0BAA() < 0) goto store;   /* @asm 0x026D1E (item); or/jl 0x21B4 */

    /* jump table (cat-9) in 0..8: word ptr cs:[bx*2 + 0x1472]  @asm 0x026D62..0x026D88 */
    if ((unsigned)(cat - 9) > 8) {                  /* @asm 0x026D62 sub ax,9; cmp ax,8; ja default */
        mn = cat; mx = cat + 0x17;                  /* @asm 0x026D30 default arm */
    } else {
        switch (cat) {                              /* table arms @asm 0x026D3E..0x026D60 */
            case 0x10: mn = 0x10; mx = 0x37; break; /* @asm 0x026D4E */ /* (cat 0x10 -> arm) */
            case 0x11: mn = 0x11; mx = 0x39; break; /* @asm 0x026D5A */
            case 0x12: mn = 0x12; mx = 0x3F; break; /* @asm 0x026D56 */
            default:   mn = cat;  mx = cat + 0x17; break; /* @asm 0x026D40 */
        }
    }
    sprite = *(int8_t far*)(MK_FP(0,0x8DC8) + mn);  /* @asm 0x026D8F [bx*2-0x7238] sprite cat */
    if (cat == 0x11)                                /* @asm 0x026D96 cmp [bp-0xC],0x11 */
        sprite -= *(uint8_t near*)DGROUP_PTR(0xA892); /* @asm 0x026D9C sub [0xA892] */

store:
    if (out_min)   *out_min   = mn;                 /* @asm 0x026DA4 cmp [bp+8],0 / store [bp-6] */
    if (out_max)   *out_max   = mx;                 /* @asm 0x026DB2 cmp [bp+0xA],0 / store [bp-4] */
    if (out_extra) *out_extra = extra;              /* @asm 0x026DC0 cmp [bp+0xC],0 / store [bp-0xA] */
    return sprite;                                  /* @asm 0x026DCE mov ax,[bp-2] */
}

/* ============================================================================
 * colony_draw_commodity  (func_026DD4)
 *   @asm        0x026DD4..0x026FF0  (541 bytes, ENTER 0x62)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED, incl. ColonyRecord
 *               food/horse stock bytes; draw roles inferred)
 *   @role       draw one commodity's display widget in the colony screen:
 *               its icon, the stacked-goods pile sprite, and the quantity.
 *
 * Signature:  void colony_draw_commodity(int item, int x, int y, int colony_idx);
 * Sets [0x70]=[0x336].  Picks the icon sprite [bp-0x58]: item 0 w/o warehouse
 * (0x9FC(0)==0) -> 0x11; item 0xF/0x11 w/ both 0x9FC(0xF)&&0x9FC(0x11) -> 0x30
 * else 0x2F (Food/Horses specials).  Draws the icon via 0x181F:0x254 (sprite
 * data [0x842]:[0x844]).  Gets the quantity 0x181F:0xACE(item) [bp-0x60].
 * If quantity<0 and item not in {0x11,0x13,0x14} returns.  Else 0x181F:0xBAA
 * gives a tier; func_02CA46(item,&a,&b,&c) -> metrics, draws the pile sprite at
 * [colony+0x24E]/[+0x254]/[+0x25A] via 0x181F:0x236, then for surplus uses
 * func_02CA55, for deficit func_02C9B5 (drawn at [colony+0x23C]/[+0x242]).
 * For item 0xF reads ctx->byte[+0x95] (FOOD stock); for item 0x1E reads
 * ctx->byte[+0x96] (HORSE stock) and, if >1, draws the count number
 * (0xD1D:0x8FA itoa + 0x181F:0x13C) at half-sprite offset.
 * (ColonyRecord +0x95/+0x96 used as food/horse stock here -- the colony.h
 *  header currently marks +0x95 as 'era' and +0x96 as TBD; do not edit it.)
 * ============================================================================ */
void colony_draw_commodity(int item, int x, int y, int colony_idx)
{
    struct colony_t far *c = ctx;
    int icon, qty, count;
    char numbuf[0x14];                              /* [bp-0x54] */

    *(int16_t near*)DGROUP_PTR(0x0070)
        = *(uint8_t near*)DGROUP_PTR(0x0336);       /* @asm 0x026DDD [0x70]=[0x336] */

    icon = item + 1;                                /* @asm 0x026DE5 [bp-0x58] = item+1 */
    if (item == 0 && overlay_call_181F_09FC() == 0) /* @asm 0x026DEC cmp item,0; 0x026DF2 0x9FC(0) */
        icon = 0x11;                                /* @asm 0x026E00 */
    if (item == 0xF || item == 0x11) {              /* @asm 0x026E05/0x026E0B */
        if (overlay_call_181F_09FC() && overlay_call_181F_09FC()) /* @asm 0x026E11 0x9FC(0xF);0x026E1F 0x9FC(0x11) */
            icon = 0x30;                            /* @asm 0x026E2D */
        else
            icon = 0x2F;                            /* @asm 0x026E34 */
    }
    (void)icon; (void)x; (void)y; (void)colony_idx;
    overlay_call_181F_0254();                       /* @asm 0x026E4E draw icon ([0x842]:[0x844]) */

    qty = overlay_call_181F_0ACE();                 /* @asm 0x026E56 (item) quantity [bp-0x60] */
    if (item == 0xF && overlay_call_181F_09FC())    /* @asm 0x026E61 cmp item,0xF; 0x026E67 0x9FC(0x11) */
        item = 0x11;                                /* @asm 0x026E75 remap food->0x11 when horses present */

    if (qty < 0 && item != 0x13 && item != 0x14 && item != 0x11) /* @asm 0x026E7A..0x026E92 */
        goto count_phase;                           /* @asm 0x026E92 jmp 0x2375 */

    {
        int tier = overlay_call_181F_0BAA();        /* @asm 0x026E98 (item) tier [bp-0x5A] */
        func_02CA46();                              /* @asm 0x026EB3 (item,&a,&b,&c) metrics */
        if (item == 0x11) { /* extra=9 @asm 0x026EC2 */ }
        /* draw pile sprite at [colony+0x24E]/[+0x254]/[+0x25A]  @asm 0x026ECB..0x026EFC */
        overlay_call_181F_0236();                   /* @asm 0x026EF7 draw goods-pile sprite */

        if (tier > 0)                               /* @asm 0x026EFC cmp [bp-0x5A],0 / jle */
            func_02CA55();                          /* @asm 0x026F2B surplus arrow @ [+0x23C]/[+0x242] */
        else if (tier < 0 && overlay_call_181F_0A88() == 0) /* @asm 0x026F34 0xA88(item) */
            func_02C9B5();                          /* @asm 0x026F5F deficit arrow @ [+0x23C]/[+0x242] */
    }

count_phase:
    if (item == 0x11 && overlay_call_181F_09FC())   /* @asm 0x026F65 cmp item,0x11; 0x026F6B 0x9FC(0xF) */
        item = 0xF;                                 /* @asm 0x026F79 remap back */
    count = 0;                                       /* @asm 0x026F7E [bp-0x5C]=0 */
    if (item == 0xF)                                 /* @asm 0x026F83 cmp item,0xF */
        count = c->field_at_95;                      /* @asm 0x026F8D ctx->byte[+0x95] drawn as FOOD pile count (field_at_95: open era-vs-food conflict, see colony.h) */
    if (item == 0x1E)                                /* @asm 0x026F96 cmp item,0x1E */
        count = *(uint8_t far*)((uint8_t far*)c + 0x96); /* @asm 0x026FA0 ctx->byte[+0x96] HORSE stock */

    if (count > 1) {                                 /* @asm 0x026FA9 cmp [bp-0x5C],1 / jle */
        overlay_call_0D1D_08FA();                    /* @asm 0x026FB8 itoa(count,&numbuf,0xA) */
        overlay_call_181F_013C();                    /* @asm 0x026FE4 draw count text (half-sprite offset) */
        (void)numbuf;
    }
    *(int16_t near*)DGROUP_PTR(0x0070) = 0;          /* @asm 0x026FE9 [0x70]=0 */
}

/* ============================================================================
 * colony_draw_pile_if  (func_026FF2)
 *   @asm        0x026FF2..0x02701B  (41 bytes, ENTER 2)   page_02.asm
 *   @status     BYTE_VERIFIED (extent + control flow); draw role inferred
 *   @role       conditionally blit a goods-pile sprite for `kind` at (a,b).
 *
 * Signature:  void colony_draw_pile_if(int a, int b, int kind);
 * If the per-kind flag table [kind+0x260] is nonzero, blits the sprite at
 * ([0x842]:[0x844]) to (a,b) via 0x181F:0x254 (colours [0x2DA8..]).
 * ============================================================================ */
void colony_draw_pile_if(int a, int b, int kind)
{
    if (*(int8_t far*)(MK_FP(0,0x0260) + kind) != 0) /* @asm 0x026FF6 [bx+0x260]; or/je */
        overlay_call_181F_0254();                    /* @asm 0x027014 blit ([0x842]:[0x844]) at (a,b) */
    (void)a; (void)b;
}

/* ============================================================================
 * colony_draw_roster_strip  (func_02701C)
 *   @asm        0x02701C..0x0270CF  (180 bytes, ENTER 0xA)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw roles inferred)
 *   @role       draw the colonist roster strip along the bottom of the colony
 *               screen: a frame plus up to 15 colonist icons.
 *
 * Signature:  void colony_draw_roster_strip(int show_button);
 * Draws the strip background (0x181F:0xCE @ (0xC7,7,0x80)) and frame
 * (0x181F:0x4FC @ (0x78,0xC7,8)).  Loops i=0..14 ([bp-8]): for each occupied
 * slot it reads the screen-position pair [i*4 + 0x266]/[+0x268] (DGROUP 0x266),
 * the assignment byte 0x8D62[i] ([bx-0x729E]) and the secondary 0x8E82[i]
 * ([bx-0x717E]); if 0x8E82[i] >= 0 it draws the colonist icon via func_02CA23
 * (assigned), else func_02CAE1 (unassigned).  Optional button (0x181F:0xE2).
 * ============================================================================ */
void colony_draw_roster_strip(int show_button)
{
    int i;

    overlay_call_181F_00CE();                        /* @asm 0x02703F strip bg @ (0xC7,7,0x80) */
    overlay_call_181F_04FC();                        /* @asm 0x02705F frame @ (0x78,0xC7,8) */

    for (i = 0; i < 0xF; i++) {                      /* @asm 0x027067..0x02707F loop [bp-8] < 0xF */
        int sx = *(int16_t far*)(MK_FP(0,0x0266) + i*4); /* @asm 0x027087 [bx+0x266] */
        int sy = *(int16_t far*)(MK_FP(0,0x0268) + i*4) + 8; /* @asm 0x02708B [bx+0x268]; add 8 */
        int slot = *(int8_t far*)(MK_FP(0,0x8D62) + i);  /* @asm 0x027095 [bx-0x729E] */
        int sec  = *(int8_t far*)(MK_FP(0,0x8E82) + i);  /* @asm 0x02709D [bx-0x717E] */
        (void)sx; (void)sy; (void)slot;
        if (sec >= 0)                                /* @asm 0x0270A2 or ax,ax / jl 0x247E */
            func_02CA23();                           /* @asm 0x0270AB assigned colonist icon */
        else
            func_02CAE1();                           /* @asm 0x027072 unassigned colonist icon */
    }

    if (show_button)                                 /* @asm 0x0270B4 cmp [bp+6],0 / je */
        overlay_call_181F_00E2();                    /* @asm 0x0270C8 button @ (0x78,0xC7,8) */
}

/* ============================================================================
 * colony_screen_render  (func_0270D0)
 *   @asm        0x0270D0..0x0275CD  (1278 bytes, ENTER 0x7E)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads + difficulty/AIPersonality reads
 *               BYTE_VERIFIED; draw + SoL/Tory layout roles inferred)
 *   @role       the colony screen layout + render entry: place every colonist
 *               sprite (with overlap-avoidance), draw the warehouse bar-chart
 *               and the SoL/Tory percentage display.
 *
 * Signature:  void colony_screen_render(int show_close_button);
 * Backdrop via func_02CAC3 @ (0x82,0x78,0x30).  Counts colonists
 * (ctx->population + [0x8D72]) and pre-sums their sprite widths via
 * 0x181F:0xC0E/0x181F:0xA74 + the unit far-array [0x83E]:[0x840][idx*0xC+0x3E].
 * Sets layout mode [0xA890]=2 and spreads the colonist sprites across the row
 * so they do not overlap (the collision loop at @0x027186..0x0272C0), drawing
 * each via 0x181F:0xCE and 0x181F:0x254 and highlighting the selected
 * [0x8D7E]/[0x8D7C].  Then the WAREHOUSE bars from x=0xA3 down: per-commodity
 * stock [0x8DC8] vs capacity [0x8E0A]/[0xA895], surplus [0x8E32], bells
 * [0x8DEA], crosses [0x8DEC] via 0x181F:0x222 (draw-bar) + 0x181F:0x22C
 * (labels).  Finally the SoL/Tory gauge: SoL% = 0x181F:0xC86; Tory% = 100-SoL;
 * colour tiers picked from difficulty [0x53A6] and AIPersonality
 * [owner*0x34 + 0x543F]; both formatted via 0xD1D:0x8FA + 0x181F:0x10A/0x178/
 * 0x11E/0x182/0x128/0x13C and drawn.  Optional close button (0x181F:0xE2).
 * ============================================================================ */
void colony_screen_render(int show_close_button)
{
    struct colony_t far *c = ctx;
    int count, i, sol, tory;

    func_02CAC3();                                  /* @asm 0x0270E0 backdrop @ (0x82,0x78,0x30) */

    count = c->population + *(int16_t near*)DGROUP_PTR(0x8D72); /* @asm 0x0270E6 ctx[+0x1F]+[0x8D72] */
    for (i = 0; i < count; i++) {                   /* @asm 0x027107..0x027141 pre-sum widths */
        overlay_call_181F_0C0E();                   /* @asm 0x02710B (i) colonist->building */
        overlay_call_181F_0A74();                   /* @asm 0x027119 (i) -> sprite; sum [idx*0xC+0x3E] */
    }

    *(uint8_t near*)DGROUP_PTR(0xA890) = 2;         /* @asm 0x027143 [0xA890]=2 layout mode */
    /* colonist spread/draw loop with overlap-avoidance  @asm 0x027148..0x0272ED */
    for (i = 0; i < count; i++) {                   /* @asm 0x0272B0..0x0272B9 i, [bp-0x6E] */
        overlay_call_181F_0C0E();                   /* @asm 0x0272BC (i) */
        overlay_call_181F_0A74();                   /* @asm 0x0272CA (i) -> sprite [bp-0x66] */
        if (*(int16_t near*)DGROUP_PTR(0x8D7E) == i &&  /* @asm 0x0271F4 cmp [0x8D7E] (selected) */
            *(int16_t near*)DGROUP_PTR(0x07EE) != 0)
            overlay_call_181F_00CE();               /* @asm 0x02724B selected highlight (id 0xF) */
        overlay_call_181F_0254();                   /* @asm 0x0272E7 blit colonist sprite */
        (void)c;
    }

    /* WAREHOUSE bars  @asm 0x02731E..0x0273DB */
    *(int16_t near*)DGROUP_PTR(0x0070)
        = *(uint8_t near*)DGROUP_PTR(0x0336);       /* @asm 0x02731E [0x70]=[0x336] */
    overlay_call_181F_0218();                       /* @asm 0x02732B newline/advance */
    /* stock [0x8DC8] vs cap [0x8E0A]/[0xA895] (yellow 0x4017)  @asm 0x027330..0x0273A1 */
    overlay_call_181F_0222();                       /* @asm 0x02736E draw-bar stock */
    overlay_call_181F_0222();                       /* @asm 0x027388 draw-bar overflow */
    if (*(int16_t near*)DGROUP_PTR(0x8E32) != 0)    /* @asm 0x02738D cmp [0x8E32],0 / je */
        overlay_call_181F_0222();                   /* @asm 0x02739D draw-bar surplus (0x8017) */
    if (*(int16_t near*)DGROUP_PTR(0x8DEA) != 0)    /* @asm 0x0273A2 cmp [0x8DEA],0 / je (bells) */
        overlay_call_181F_0222();                   /* @asm 0x0273B2 draw-bar bells (id 0x39) */
    if (*(int16_t near*)DGROUP_PTR(0x8DEC) != 0)    /* @asm 0x0273B7 cmp [0x8DEC],0 / je (crosses) */
        overlay_call_181F_0222();                   /* @asm 0x0273C7 draw-bar crosses (id 0x3F) */
    overlay_call_181F_022C();                       /* @asm 0x0273D7 draw-label (4,...,0x76) */

    /* SoL / Tory gauge  @asm 0x0273DC..0x0275AB */
    sol  = overlay_call_181F_0C86();                /* @asm 0x0273DC SoL% [bp-0x70] */
    tory = 100 - sol;                               /* @asm 0x0273E4 sub 0x64; neg [bp-0x7A] */
    /* SoL count = ctx->population*sol/100 [bp-0x5E]  @asm 0x0273EC..0x027409 */
    /* colour tier from difficulty [0x53A6]: base = (0x53A6-0xA)*-1, or 0x32 for
     * non-active powers (AIPersonality [owner*0x34+0x543F]==0)  @asm 0x027416..0x027449 */
    {
        int thresh = -((int)*(uint8_t near*)DGROUP_PTR(0x53A6) - 0xA); /* @asm 0x027416 [0x53A6] difficulty */
        if (!(c->owner_power < 4 &&
              *(uint8_t far*)(MK_FP(0,0x543F) + c->owner_power*0x34) != 0)) /* @asm 0x027423/0x027431 */
            thresh = 0x32;                          /* @asm 0x027437 non-active -> 0x32 */
        (void)thresh;
    }
    if (sol > 0) {                                  /* @asm 0x02745D cmp [bp-0x70],0 / je */
        overlay_call_181F_0254();                   /* @asm 0x02747B SoL face sprite (id 0x7C) */
        overlay_call_0D1D_08FA();                   /* @asm 0x027497 itoa(SoL%) */
        overlay_call_181F_010A();                   /* @asm 0x0274A3 */
        overlay_call_181F_0178();                   /* @asm 0x0274BF reset/term */
        overlay_call_181F_011E();                   /* @asm 0x0274CB */
        overlay_call_181F_0182();                   /* @asm 0x0274DB append count */
        overlay_call_181F_0128();                   /* @asm 0x0274E7 */
        overlay_call_181F_013C();                   /* @asm 0x0274FF draw "% Rebel" */
    }
    if (tory > 0) {                                 /* @asm 0x027507 cmp [bp-0x7A],0 / je */
        overlay_call_0D1D_08FA();                   /* @asm 0x027509 itoa(Tory%) */
        overlay_call_181F_010A();                   /* @asm 0x027515 */
        overlay_call_181F_0178();                   /* @asm 0x027521 */
        overlay_call_181F_011E();                   /* @asm 0x02752D */
        overlay_call_181F_0182();                   /* @asm 0x02753D append SoL count */
        overlay_call_181F_0128();                   /* @asm 0x027549 */
        overlay_call_181F_0204();                   /* @asm 0x027579 measure */
        overlay_call_181F_013C();                   /* @asm 0x027589 draw "% Tory" */
        overlay_call_181F_0254();                   /* @asm 0x0275A6 Tory face sprite (id 0x7D) */
    }

    *(int16_t near*)DGROUP_PTR(0x0070) = 0;         /* @asm 0x0275AB [0x70]=0 */
    if (show_close_button)                          /* @asm 0x0275B1 cmp [bp+6],0 / je */
        overlay_call_181F_00E2();                   /* @asm 0x0275C5 close button @ (0x82,0x78,0x30) */
}

/* ============================================================================
 * colony_draw_warehouse_bars  (func_0275CE)
 *   @asm        0x0275CE..0x027745  (376 bytes, ENTER 8)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw roles inferred)
 *   @role       draw the colony warehouse stockpile bar chart: one bar per
 *               commodity (16 goods) plus the food/bells/crosses gauges.
 *
 * Signature:  void colony_draw_warehouse_bars(void);
 * Sets [0x70]=[0x336].  Row 1 (y=[bp-4]=0x86): for commodity 0..7, if the stock
 * table 0x8DC8[g] ([bx-0x7238]) is nonzero (and g!=0,!=5) draws a bar via
 * 0x181F:0x222 sized by stock + the delta table 0x8E32 ([bx-0x71CE]); labels
 * with 0x181F:0x22C.  Row 2 (y+=0xE): commodities 8..0xF with the secondary
 * capacity table 0x8E5A[ config 0x2A2[g] ] ([bx-0x71A6]).  Then individual
 * gauges: [0x8DD2]/[0x8E14] (food vs capacity, id 0x17/0x4017), [0x8E3C]
 * (id 0x8017), [0x8E64]/[0x8DE8] (bells/crosses, id 0x37/0x8037), each via
 * 0x181F:0x222 with a 0x181F:0x22C(4,...) label row.  Clears [0x70]=0.
 * ============================================================================ */
void colony_draw_warehouse_bars(void)
{
    int g, y;

    *(int16_t near*)DGROUP_PTR(0x0070)
        = *(uint8_t near*)DGROUP_PTR(0x0336);       /* @asm 0x0275D3 [0x70]=[0x336] */
    y = 0x86;                                        /* @asm 0x0275DB [bp-4]=0x86 */
    overlay_call_181F_0218();                        /* @asm 0x0275E0 newline */

    for (g = 0; g < 8; g++) {                        /* @asm 0x0275E5..0x02761E row-1 goods 0..7 */
        int stock = *(int16_t far*)(MK_FP(0,0x8DC8) + g*2); /* @asm 0x0275F1 [bx-0x7238] */
        if (stock == 0 || g == 5 || g == 0) continue; /* @asm 0x0275F6/0x0275F8/0x0275FD guards */
        /* bar from stock + delta [0x8E32]  @asm 0x027601..0x027616 */
        overlay_call_181F_0222();                    /* @asm 0x027612 draw-bar (g, stock) */
    }
    overlay_call_181F_022C();                        /* @asm 0x02762B label row (id 0xD5,y) */
    y += 0xE;                                         /* @asm 0x027630 add [bp-4],0xE */
    overlay_call_181F_0218();                         /* @asm 0x027634 newline */

    for (g = 8; g < 0xF; g++) {                       /* @asm 0x027639..0x027694 row-2 goods 8..0xE */
        int cfg = *(int8_t far*)(MK_FP(0,0x02A2) + g); /* @asm 0x027646 [bx+0x2A2] */
        int cap = (cfg >= 0) ? *(int16_t far*)(MK_FP(0,0x8E5A) + cfg*2) : 0; /* @asm 0x02764D [bx-0x71A6] */
        int stock = *(int16_t far*)(MK_FP(0,0x8DC8) + g*2); /* @asm 0x027662 [bx-0x7238] */
        if (stock == 0 && cap == 0) continue;         /* @asm 0x027667/0x027669 guards */
        overlay_call_181F_0222();                     /* @asm 0x027688 draw-bar (g, max(stock,cap)) */
        (void)cap;
    }
    overlay_call_181F_022C();                         /* @asm 0x0276A1 label row */
    y += 0xE;                                          /* @asm 0x0276A6 add [bp-4],0xE */
    overlay_call_181F_0218();                          /* @asm 0x0276AA newline */

    /* food gauge [0x8DD2] vs cap [0x8E14]  @asm 0x0276AF..0x0276FE */
    if (*(int16_t near*)DGROUP_PTR(0x8E14) >= *(int16_t near*)DGROUP_PTR(0x8DD2)) { /* @asm 0x0276B2 */
        if (*(int16_t near*)DGROUP_PTR(0x8E14) != 0) overlay_call_181F_0222(); /* @asm 0x0276D8 (id 0x1C) */
        overlay_call_181F_0222();                     /* @asm 0x0276E5 surplus part (0x4017) */
    } else {
        if (*(int16_t near*)DGROUP_PTR(0x8E14) != 0) overlay_call_181F_0222(); /* @asm 0x0276F5 */
    }
    if (*(int16_t near*)DGROUP_PTR(0x8E3C) != 0)      /* @asm 0x0276EA cmp [0x8E3C],0 / je */
        overlay_call_181F_0222();                     /* @asm 0x0276FA draw-bar (0x8017) */

    /* bells/crosses [0x8E64] vs [0x8DE8]  @asm 0x0276FF..0x027728 */
    if (*(int16_t near*)DGROUP_PTR(0x8DE8) != *(int16_t near*)DGROUP_PTR(0x8E64)) /* @asm 0x027702 */
        overlay_call_181F_0222();                     /* @asm 0x027713 draw-bar (id 0x37) */
    if (*(int16_t near*)DGROUP_PTR(0x8E64) != 0)      /* @asm 0x027718 cmp [0x8E64],0 / je */
        overlay_call_181F_0222();                     /* @asm 0x027728 draw-bar (id 0x8037) */

    overlay_call_181F_022C();                          /* @asm 0x027738 label row (4,id 0xD5,y) */
    *(int16_t near*)DGROUP_PTR(0x0070) = 0;            /* @asm 0x02773D [0x70]=0 */
    (void)y;
}

/* ============================================================================
 * colony_draw_buildings_panel  (func_027746)
 *   @asm        0x027746..0x027953  (526 bytes, ENTER 0x76)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED, incl. ColonyRecord
 *               +0x94 current-build, UnitRecord type, terrain stat table;
 *               draw roles inferred)
 *   @role       draw the colony buildings/professions panel: the current build
 *               header plus the colonists working each building (3 columns).
 *
 * Signature:  void colony_draw_buildings_panel(void);
 * If the "show production header" flag [0xB98] is set, reads ctx->byte[+0x94]
 * (the current-build / selected item), gets its data via 0x181F:0xAC4 and a
 * 32-bit value via 0x181F:0xD4E, formats the header via 0xD1D:0x11B4, and draws
 * it (0x181F:0x100) at box (0xD3,0x5B,0x84,0x39).  Else draws the default header
 * from string [0x939A] (0x181F:0x22 + 0x181F:0x100).  Then the colonists list
 * in up to 3 columns (col0 x=0x9E, col1 0x98, col2 0x90; y starts 0xD5, row
 * pitch 0x12/0x11): iterates units via 0x181F:0x2DA / 0x181F:0x2F8, drawing each
 * colonist whose UnitRecord type byte[+2] (0x3146, stride 0x1C) indexes the
 * terrain/unit-stat table [type*14 + 0x5237] == 0 (a real colonist), drawing
 * the profession sprite (0x181F:0xCE, highlighting the selected [0x8D7A] when
 * [0x7EE]!=0 && [0x8D54]==4) and the building icon (0x181F:0x2BC, id 0x64).
 * ============================================================================ */
void colony_draw_buildings_panel(void)
{
    struct colony_t far *c = ctx;
    char hdr[0x60];                                 /* [bp-0x60] header buffer */
    int u, colnum;

    if (*(int16_t near*)DGROUP_PTR(0x0B98) != 0) {  /* @asm 0x02774A cmp [0xB98],0 / je 0x2BBC */
        hdr[0] = 0;                                  /* @asm 0x027751 byte[bp-0x60]=0 */
        overlay_call_181F_0AC4();                    /* @asm 0x027763 (ctx->byte[+0x94]) */
        /* 32-bit value of current build  @asm 0x02776E..0x027786 */
        if (overlay_call_181F_0D4E() != 0)           /* @asm 0x027778 (ctx->byte[+0x94]) -> DX:AX; or */
            overlay_call_0D1D_11B4();                /* @asm 0x027793 format header */
        /* draw header @ box (0xD3,0x5B,0x84,0x39)  @asm 0x02779B..0x0277C9 */
        overlay_call_181F_0100();                    /* @asm 0x0277C4 draw header text */
    } else {
        /* default header from string [0x939A]  @asm 0x0277AC..0x0277C9 */
        overlay_call_181F_0022();                    /* @asm 0x0277BA ([0x939A]) */
        overlay_call_181F_0100();                    /* @asm 0x0277C4 draw header text */
    }

    /* colonists list, up to 3 columns  @asm 0x0277CC..0x02794F */
    colnum = 0;                                      /* [bp-0x68] column index 0..2 */
    overlay_call_181F_07E0();                        /* @asm 0x027808 tile-at(ctx->map_x,map_y) */
    for (u = overlay_call_181F_02E4(); u >= 0;       /* @asm 0x02790B next unit [bp-0x72]; or/jl end */
         u = overlay_call_181F_02E4()) {
        int utype = *(uint8_t far*)(MK_FP(0,0x3146) + u*0x1C); /* @asm 0x027912 UnitRecord type [+2] */
        if (*(uint8_t far*)(MK_FP(0,0x5237) + utype*14) != 0)  /* @asm 0x027927 [type*14+0x5237]!=0 / jne next */
            continue;
        /* draw profession sprite + selected highlight  @asm 0x027814..0x0278AA */
        overlay_call_181F_02DA();                    /* @asm 0x027829 (advance/sprite) */
        overlay_call_181F_02F8();                    /* @asm 0x02783A (draw colonist) */
        if (*(int16_t near*)DGROUP_PTR(0x8D7A) == /*[bp-0x66]*/0 && /* @asm 0x027842 cmp [0x8D7A] */
            *(int16_t near*)DGROUP_PTR(0x07EE) != 0 &&               /* @asm 0x02784C cmp [0x7EE],0 */
            *(int16_t near*)DGROUP_PTR(0x8D54) == 4)                 /* @asm 0x027853 cmp [0x8D54],4 */
            overlay_call_181F_00CE();                /* @asm 0x0278AA highlight (id 0xA/0xF) */
        /* per-column placement: col0 x=0x9E; col1 0x98; col2 0x90  @asm 0x0278D7..0x027908 */
        overlay_call_181F_02BC();                    /* @asm 0x02794A draw building icon (id 0x64) */
        (void)c; (void)colnum;
    }
}

/* ============================================================================
 * draw_bevel_button  (func_027954)
 *   @asm        0x027954..0x02798B  (56 bytes, ENTER 4)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; layout helper)
 *   @role       compute the (x,y) text-origin for a roster/label string and
 *               return it via two out-params.
 *
 * Signature:  void draw_bevel_button(int str_id, int *out_x, int *out_y);
 * Gets the string pointer for str_id (0x181F:0x22), measures it (0x181F:0x114)
 * -> width [bp-2]; reads the first glyph from the far string [0x89E]:[0x8A0],
 * and returns *out_x = width+6, *out_y = (firstglyph-1)+4.
 * ============================================================================ */
void draw_bevel_button(int str_id, int near *out_x, int near *out_y)
{
    int width, first;

    overlay_call_181F_0022();                        /* @asm 0x02795B (str_id) -> DX:AX string ptr */
    width = overlay_call_181F_0114();                /* @asm 0x027965 measure width [bp-2] */
    first = *(uint8_t far*)(*(uint32_t near*)DGROUP_PTR(0x089E)); /* @asm 0x02796D les bx,[0x89E]; es:[bx] */
    if (out_x) *out_x = width + 6;                   /* @asm 0x02797A add cx,6; store [bp+8] */
    if (out_y) *out_y = (first - 1) + 4;             /* @asm 0x027982 dec ax; add 4; store [bp+0xA] */
    (void)str_id;
}

/* ============================================================================
 * draw_3d_box_label  (func_02798C)
 *   @asm        0x02798C..0x027AD9  (334 bytes, ENTER 0x10)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads + colour constants BYTE_VERIFIED;
 *               draw roles inferred)
 *   @role       draw a raised/sunken 3D button box with a centred text label.
 *
 * Signature:  void draw_3d_box_label(int str_id, int x, int y, int style);
 * style&1 selects the light/dark colour scheme (raised: hi=0xF lo=0x39 fill
 * 0x30; sunken: hi=0 lo=0x30 fill 0x39 -- byte-cited @0x02799A/0x0279AE).
 * Measures the label (func_02C9BF) -> (w,h) at [bp-8]/[bp-0xA].  Draws the four
 * bevel edges with 0x191F:0x8BC (horizontal) and 0x191F:0x8B2 (vertical) using
 * the hi/lo colours, fills the interior (0x181F:0xBA), and draws the centred
 * label text via 0x181F:0x22 + 0x181F:0x13C at (x+3, y+2).
 * ============================================================================ */
void draw_3d_box_label(int str_id, int x, int y, int style)
{
    int hi, lo, fill, w, h, tx, ty;

    if (style & 1) {                                /* @asm 0x027992 mov al,[bp+0xC]; and 1; jne */
        fill = 0; lo = 0xFFFF; hi = 0x39; /* sunken: fill=0,? */ /* @asm 0x0279BE..0x0279CB */
    } else {
        fill = 0xF; lo = 0; hi = 0x30; /* raised */  /* @asm 0x02799A..0x0279A7 */
    }
    (void)hi; (void)lo; (void)fill; (void)str_id;

    func_02C9BF();                                  /* @asm 0x0279CB measure label -> (w@[bp-8],h@[bp-0xA]) */
    tx = x + 3;                                      /* @asm 0x0279D1 [bp-0xE] */
    ty = y + 2;                                      /* @asm 0x0279DA [bp-0x10] */
    w = 0; h = 0; (void)w; (void)h; (void)tx; (void)ty;

    overlay_call_191F_08BC();                        /* @asm 0x027A08 top edge (hi) */
    overlay_call_191F_08B2();                        /* @asm 0x027A36 left edge (hi) */
    overlay_call_191F_08BC();                        /* @asm 0x027A5A bottom edge (lo) */
    overlay_call_191F_08B2();                        /* @asm 0x027A7E right edge (lo) */
    if (/*[bp-6] != -1*/ 1)                          /* @asm 0x027A83 cmp [bp-6],0 / jl */
        overlay_call_181F_00BA();                    /* @asm 0x027AB0 fill interior */
    overlay_call_181F_0022();                        /* @asm 0x027AC4 (str_id) string ptr */
    overlay_call_181F_013C();                        /* @asm 0x027ACE draw label text @ (tx,ty) */
}

/* ============================================================================
 * colony_draw_queue_arrows  (func_027ADA)
 *   @asm        0x027ADA..0x027B61  (136 bytes, ENTER 2)   page_02.asm
 *   @status     RECONSTRUCTED (extent + reads BYTE_VERIFIED; draw roles inferred)
 *   @role       draw the two production-queue / colony-nav arrow buttons on the
 *               right of the colony screen and their enabled/disabled state.
 *
 * Signature:  void colony_draw_queue_arrows(void);
 * Sel = ([0x7EE]!=0 && [0x8D54]==4) ? [0x342] : -1.  Draws two backdrop tiles
 * via func_02CAC3 @ (0xD8,0x8A,0x1E,9) and @ (0x10E,0x8A,0x1E,9).  If
 * ctx->byte[+0x94] >= 0 (a build is selected) draws the upper arrow's state
 * (func_02CA1E with [0x93A2], enabled = (sel==1)) @ (0xD8,0x8A); always draws
 * the lower arrow (func_02CA1E with [0x93A4], enabled = (sel==1)) @ (0x10E,0x8A).
 * (NB: this is the LAST function in this file's range; it ends with RETF at
 *  0x027B61, and 0x027B62 begins the next function -- outside this file.)
 * ============================================================================ */
void colony_draw_queue_arrows(void)
{
    struct colony_t far *c = ctx;
    int sel = -1;                                    /* [bp-2] = 0xFFFF */

    if (*(int16_t near*)DGROUP_PTR(0x07EE) != 0 &&  /* @asm 0x027AE3 cmp [0x7EE],0 / je */
        *(int16_t near*)DGROUP_PTR(0x8D54) == 4)    /* @asm 0x027AEA cmp [0x8D54],4 / jne */
        sel = *(int16_t near*)DGROUP_PTR(0x0342);   /* @asm 0x027AF1 [0x342] */

    func_02CAC3();                                  /* @asm 0x027B02 backdrop @ (0xD8,0x8A,0x1E,9) */
    func_02CAC3();                                  /* @asm 0x027B13 backdrop @ (0x10E,0x8A,0x1E,9) */

    if ((int8_t)*((uint8_t far*)c + 0x94) >= 0) {   /* @asm 0x027B1D cmp ctx->byte[+0x94],0 / jl (current-build) */
        /* upper arrow enabled = (sel==1)  @asm 0x027B24..0x027B3E */
        func_02CA1E();                              /* @asm 0x027B3B draw upper arrow ([0x93A2]) */
    }
    /* lower arrow enabled = (sel==1)  @asm 0x027B41..0x027B5D */
    func_02CA1E();                                  /* @asm 0x027B5D draw lower arrow ([0x93A4]) */
}
