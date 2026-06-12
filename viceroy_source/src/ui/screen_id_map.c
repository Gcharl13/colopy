/* ============================================================================
 * screen_id_map.c — E3 screen-id map closure  (ROUTE_B_PLAN § 3.4)
 * ----------------------------------------------------------------------------
 * ROUTE_B E3 inventory: "Screen-entry map (enter_screen_view(id) call sites)".
 * Six `mov bx,<id>; lcall 0x181F:0x772` sites exist in the EXE.  They were
 * originally catalogued as "enter_screen_view" sites, but byte analysis of
 * 0x181F:0x772 (thunk → overlay page 29 +0x3CE = file 0x77D5E) PROVES this
 * thunk resolves to func_077D5E_fatal_error_report_xy — the DIAGNOSTIC / FATAL
 * ERROR REPORTER (formats "Error \"<N>\" in module \"...\" data: ..." with DS
 * strings @0x24CF/0x24D7/0x24E5 [V @0x077B2D/0x077B48/0x077B67]).
 *
 * ALL SIX ids are DIAGNOSTIC ERROR CODES, not screen-view selectors.
 * The two "full screen" ids (0x2B = Europe, 0x2C = Colony) are in their
 * respective screen-entry functions but are also calls to this same reporter.
 * The function entered BEFORE the reporter call is the actual screen body.
 *
 * ── E3 ID MAP (ALL SIX, CLOSED) ─────────────────────────────────────────────
 *
 *  id   @asm file    enclosing function                  identity
 *  ───  ──────────   ──────────────────────────────────  ─────────────────────
 *  0x28  0x450AE     func_044FA4_window_measure          GUI WINDOW MEASURER
 *                    [BYTE_VERIFIED overlay_04458A_04694B.c @0x044FA4..0x0450B9]
 *                    Asserts: if the computed dialog box origin is negative
 *                    (would fall off-screen), raise error 0xFFB0 priority 2.
 *                    The bx=0x28 value is the diagnostic error code.
 *
 *  0x29  0x6D5AA     func_06D316_panel_finalize_geometry MENU PANEL GEOMETRY
 *                    [BYTE_VERIFIED overlay_06C220_06D938.c @0x06D316..0x06D886]
 *                    Asserts: if panel origin (PANEL[+0x10]/[+0x12]) is negative
 *                    after clamping to 0x140×0xC8, raise error 0xFFAF priority 2.
 *                    The bx=0x29 value is the diagnostic error code.
 *
 *  0x2A  0x7661F     func_076594_terrain_layer_load3     TERRAIN LAYER LOADER
 *                    [DONE overlay_0745F0_077A6A.c @0x076594..0x076638]
 *                    Asserts: if the terrain-layer load sequence leaves [0x23CE]
 *                    < 3 (fewer than 3 layers loaded), raise error 0xFFAE
 *                    priority 2. The bx=0x2A value is the diagnostic error code.
 *
 *  0x2D  0x05E63     func_005E18_op_sz_120               MAP TILE POWER-WRITE
 *                    [BYTE_VERIFIED load_image_005DF0_006939.c @0x005E18..0x005E8F]
 *                    After repainting a tile (0x181F:0x077E) and bumping the
 *                    animation counter (0x181F:0x05B6), raises error 0xFFAC
 *                    priority 1 to post the tile-ownership change status message.
 *                    The bx=0x2D value is the diagnostic error code.
 *
 *  0x2B  0x030DEB    func_030DBC (Europe screen entry)   EUROPE SCREEN ENTRY
 *                    [BYTE_VERIFIED europe_screen.c @0x030DEB]  → screened per
 *                    src/ui/europe_screen.c (already ported / wired).
 *
 *  0x2C  0x025EE5    (Colony screen entry stub)          COLONY SCREEN ENTRY
 *                    [BYTE_VERIFIED colony_screen.c @0x025EE5]  → screened per
 *                    src/ui/colony_screen.c (already ported / wired).
 *
 * ── WIRING ───────────────────────────────────────────────────────────────────
 *
 * The generic stub overlay_call_181F_0772() (weak, linkfloor_stubs.c:314) is
 * overridden here with a strong definition.  In the modern build the diagnostic
 * reporter is a no-op: the original function formats a diagnostic string for
 * the DOS VICEROY.LOG logger which has no equivalent in the host build.  The
 * VERBOSITY THRESHOLD check in the original body (@0x077D70 cmp [0x2476],dx;
 * jl skip) would suppress ALL four of these calls at runtime (threshold is 0 in
 * the DGROUP init image and none of the callers set it higher), so the no-op
 * is byte-faithful in observable behaviour.
 *
 * Call signature from each site (stack args + register args before retf 8):
 *   push (int32) coord_a  ; 4 words (y and x sign-extended or two far ptrs)
 *   push (int32) coord_b
 *   mov  ax, <error_hi>   ; negative sentinel (0xFFB0/0xFFAF/0xFFAE/0xFFAC)
 *   mov  dx, <priority>   ; 1 or 2
 *   mov  bx, <error_code> ; 0x28/0x29/0x2A/0x2D
 *   lcall 0x181F:0x772    ; -> func_077D5E_fatal_error_report_xy (retf 8)
 * The C stub takes no explicit args; the pushed words are on the stack but the
 * callee C function uses no stack args (void sig), matching the stub usage.
 *
 * BYTE VERIFICATION:
 *   0x450AE: BB 28 00 9A 72 07 1F 18   mov bx,0x28; lcall 0x181F:0x0772 [V]
 *   0x6D5AA: BB 29 00 9A 72 07 1F 18   mov bx,0x29; lcall 0x181F:0x0772 [V]
 *   0x7661F: BB 2A 00 9A 72 07 1F 18   mov bx,0x2A; lcall 0x181F:0x0772 [V]
 *   0x05E63: BB 2D 00 9A 72 07 1F 18   mov bx,0x2D; lcall 0x181F:0x0772 [V]
 *
 * thunk resolution: 0x181F:0x0772 → overlay page 29 +0x3CE → file 0x77D5E
 *   = func_077D5E_fatal_error_report_xy  [whois.py verified]
 *   function body: ENTER 0x6A; push bx→di; push ax→si; cmp [0x2476],dx; jl skip
 *                  (threshold gate suppresses all four at runtime) [@0x077D62..0x077DF5]
 * ============================================================================ */
#ifdef _VICEROY_MODERN

/* Strong definition overrides the weak stub in linkfloor_stubs.c:314.
 * This is a NO-OP in the modern build; see banner for rationale.
 * The calling convention leaves 8 bytes of pushed coords on the stack;
 * func_077D5E_fatal_error_report_xy uses RETF 8 (@0x077DF3) to clean them up.
 * In C we simulate the cleanup by taking a dummy int arg (the four pushed words
 * in the original are two int32 pairs; declaring void matches the stub callers
 * since they push before the C call and the args are simply ignored here). */
void overlay_call_181F_0772(void)
{
    /* @asm 0x077D70 cmp [0x2476], dx; jl 0x077DF0  -- threshold gate.
     * In the modern build the diagnostic infrastructure (DOS log, VICEROY.LOG
     * file handle, string table) is absent.  Return immediately; the RETF 8
     * cleanup is handled by the caller's add-sp or the frame convention.
     * (Observable behaviour is identical: the threshold suppresses output.) */
    return; /* @asm 0x077DF0 -> pop si; pop di; leave; retf 8 */
}

#endif /* _VICEROY_MODERN */
