; ============================================================================
; func_0391C0_unknown
; Region   : overlay
; Bytes    : file 0x0391C0..0x039217  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0391C0  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0391C4  6A 06                 PUSH   6 ; STACK_PUSH
0391C6  0E                    PUSH   cs ; STACK_PUSH
0391C7  E8 89 0C              CALL   0x39e53 ; CALL_NEAR
0391CA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0391CD  68 90 00              PUSH   0x90 ; PUSH_CONST
0391D0  6A 05                 PUSH   5 ; STACK_PUSH
0391D2  68 40 01              PUSH   0x140 ; PUSH_CONST
0391D5  6A 00                 PUSH   0 ; STACK_PUSH
0391D7  FF 36 20 2E           PUSH   word ptr [0x2e20] ; PUSH_GLOBAL
0391DB  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
0391E0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0391E3  52                    PUSH   dx ; STACK_PUSH
0391E4  50                    PUSH   ax ; STACK_PUSH
0391E5  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
0391EA  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0391ED  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
0391F1  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
0391F4  2A E4                 SUB    ah, ah ; ARITH
0391F6  05 06 00              ADD    ax, 6 ; ARITH
0391F9  68 91 00              PUSH   0x91 ; PUSH_CONST
0391FC  50                    PUSH   ax ; STACK_PUSH
0391FD  68 40 01              PUSH   0x140 ; PUSH_CONST
039200  6A 00                 PUSH   0 ; STACK_PUSH
039202  FF 36 5A 2F           PUSH   word ptr [0x2f5a] ; PUSH_GLOBAL
039206  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
03920B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03920E  52                    PUSH   dx ; STACK_PUSH
03920F  50                    PUSH   ax ; STACK_PUSH
039210  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
039215  C9                    LEAVE ; EPILOGUE
039216  CB                    RETF ; RETURN
