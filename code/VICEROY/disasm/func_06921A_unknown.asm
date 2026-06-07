; ============================================================================
; func_06921A_unknown
; Region   : overlay
; Bytes    : file 0x06921A..0x06927B  (97 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06921A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
06921E  56                    PUSH   si ; STACK_PUSH
06921F  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
069222  D1 E3                 SHL    bx, 1 ; LOGIC
069224  C4 36 A6 1E           LES    si, ptr [0x1ea6] ; MOV_FAR
069228  26 FF 30              PUSH   word ptr es:[bx + si] ; STACK_PUSH
06922B  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
069230  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069233  52                    PUSH   dx ; STACK_PUSH
069234  50                    PUSH   ax ; STACK_PUSH
069235  1E                    PUSH   ds ; STACK_PUSH
069236  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
069239  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
06923E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
069241  C4 1E AA 1E           LES    bx, ptr [0x1eaa] ; MOV_FAR
069245  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
069248  26 80 38 02           CMP    byte ptr es:[bx + si], 2 ; CMP
06924C  75 2A                 JNE    0x69278 ; CJUMP
06924E  C4 1E AE 1E           LES    bx, ptr [0x1eae] ; MOV_FAR
069252  26 80 38 08           CMP    byte ptr es:[bx + si], 8 ; CMP
069256  72 20                 JB     0x69278 ; CJUMP
069258  26 80 38 10           CMP    byte ptr es:[bx + si], 0x10 ; CMP
06925C  73 1A                 JAE    0x69278 ; CJUMP
06925E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
069261  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
069266  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069269  FF 36 B0 2D           PUSH   word ptr [0x2db0] ; PUSH_GLOBAL
06926D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
069270  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
069275  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
069278  5E                    POP    si ; STACK_POP
069279  C9                    LEAVE ; EPILOGUE
06927A  CB                    RETF ; RETURN
