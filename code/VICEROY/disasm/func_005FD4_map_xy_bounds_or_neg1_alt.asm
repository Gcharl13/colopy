; ============================================================================
; func_005FD4_map_xy_bounds_or_neg1_alt
; Region   : load_image
; Bytes    : file 0x005FD4..0x005FF3  (31 bytes)
; Purpose  : Sister of map_xy_bounds_or_neg1 (file 0x5F04). Same logic — wraps is_xy_in_map_bounds, returns -1 on out-of-bounds, 0 otherwise. Probably a parallel entry from a different overlay segment.
; Args     : [bp+6] = x, [bp+8] = y
; Returns  : AX = -1 if out-of-bounds, 0 if in-bounds
; Callers  : TBD (6 distinct call sites)
; Callees  : is_xy_in_map_bounds at 0x5BFA
; Verified : Boundary verified: ENTER 2 / LEAVE / RETF, 31 bytes — identical layout to 0x5F04.
; Source   : Sibling of 0x5F04.
; ============================================================================

005FD4  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame
005FD8  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; result_local = -1 (default)
005FDD  FF 76 08              PUSH   word ptr [bp + 8]            ; push y
005FE0  FF 76 06              PUSH   word ptr [bp + 6]            ; push x
005FE3  0E                    PUSH   cs                           ; push CS for near-CALL
005FE4  E8 13 FC              CALL   0x5bfa                       ; near-call is_xy_in_map_bounds
005FE7  83 C4 04              ADD    sp, 4                        ; pop args
005FEA  0B C0                 OR     ax, ax                       ; in-bounds?
005FEC  75 06                 JNE    0x5ff4                       ; if yes, branch past
005FEE  B8 FF FF              MOV    ax, 0xffff                   ; out-of-bounds → AX = -1
005FF1  C9                    LEAVE                               ; teardown
005FF2  CB                    RETF                                ; far-return
