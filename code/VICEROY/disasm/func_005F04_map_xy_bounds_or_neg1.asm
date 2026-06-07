; ============================================================================
; func_005F04_map_xy_bounds_or_neg1
; Region   : load_image
; Bytes    : file 0x005F04..0x005F23  (31 bytes)
; Purpose  : Wrapper around `is_xy_in_map_bounds`: returns 0xFFFF (= -1 sentinel) if (x,y) is out of bounds, otherwise returns 0. Used for early-exit branch protection in map-iteration code.
; Args     : [bp+6] = x, [bp+8] = y
; Returns  : AX = -1 if out-of-bounds, 0 if in-bounds
; Callers  : TBD (7 distinct call sites)
; Callees  : is_xy_in_map_bounds at 0x5BFA (near-CALL after PUSH x, y)
; Verified : Boundary verified: ENTER 2 / LEAVE / RETF, 31 bytes.
; Source   : Identified via callgraph; the near-CALL to 0x5BFA is the giveaway.
; ============================================================================

005F04  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame
005F08  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; result_local = -1 (default: out-of-bounds)
005F0D  FF 76 08              PUSH   word ptr [bp + 8]            ; push y
005F10  FF 76 06              PUSH   word ptr [bp + 6]            ; push x
005F13  0E                    PUSH   cs                           ; push CS for the near-CALL
005F14  E8 E3 FC              CALL   0x5bfa                       ; near-call is_xy_in_map_bounds — AX = 1 if in-bounds, 0 if not
005F17  83 C4 04              ADD    sp, 4                        ; pop x, y from the stack
005F1A  0B C0                 OR     ax, ax                       ; test: in-bounds?
005F1C  75 06                 JNE    0x5f24                       ; if in-bounds, branch past the -1 set
005F1E  B8 FF FF              MOV    ax, 0xffff                   ; out-of-bounds → AX = -1
005F21  C9                    LEAVE                               ; teardown frame
005F22  CB                    RETF                                ; far-return: AX = -1 if out-of-bounds, else 0
