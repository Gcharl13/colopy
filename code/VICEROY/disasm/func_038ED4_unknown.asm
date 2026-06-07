; ============================================================================
; func_038ED4_unknown
; Region   : overlay
; Bytes    : file 0x038ED4..0x038F2B  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

038ED4  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
038ED8  6A 06                 PUSH   6 ; STACK_PUSH
038EDA  0E                    PUSH   cs ; STACK_PUSH
038EDB  E8 75 0F              CALL   0x39e53 ; CALL_NEAR
038EDE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038EE1  68 90 00              PUSH   0x90 ; PUSH_CONST
038EE4  6A 05                 PUSH   5 ; STACK_PUSH
038EE6  68 40 01              PUSH   0x140 ; PUSH_CONST
038EE9  6A 00                 PUSH   0 ; STACK_PUSH
038EEB  FF 36 20 2E           PUSH   word ptr [0x2e20] ; PUSH_GLOBAL
038EEF  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
038EF4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038EF7  52                    PUSH   dx ; STACK_PUSH
038EF8  50                    PUSH   ax ; STACK_PUSH
038EF9  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
038EFE  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
038F01  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
038F05  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
038F08  2A E4                 SUB    ah, ah ; ARITH
038F0A  05 06 00              ADD    ax, 6 ; ARITH
038F0D  68 91 00              PUSH   0x91 ; PUSH_CONST
038F10  50                    PUSH   ax ; STACK_PUSH
038F11  68 40 01              PUSH   0x140 ; PUSH_CONST
038F14  6A 00                 PUSH   0 ; STACK_PUSH
038F16  FF 36 5C 2F           PUSH   word ptr [0x2f5c] ; PUSH_GLOBAL
038F1A  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
038F1F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
038F22  52                    PUSH   dx ; STACK_PUSH
038F23  50                    PUSH   ax ; STACK_PUSH
038F24  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
038F29  C9                    LEAVE ; EPILOGUE
038F2A  CB                    RETF ; RETURN
