; ============================================================================
; func_0482DE_unknown
; Region   : overlay
; Bytes    : file 0x0482DE..0x0482FF  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0482DE  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0482E2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0482E5  0E                    PUSH   cs ; STACK_PUSH
0482E6  E8 32 37              CALL   0x4ba1b ; CALL_NEAR
0482E9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0482EC  3D 08 00              CMP    ax, 8 ; CMP
0482EF  74 0F                 JE     0x48300 ; CJUMP
0482F1  50                    PUSH   ax ; STACK_PUSH
0482F2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0482F5  9A 50 01 1F 1A        LCALL  0x1a1f, 0x150 ; THUNK -> 0x0000:0x0C1E (thunk @file 0x01C740 type A) overlay @file 0x02651E
0482FA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0482FD  C9                    LEAVE ; EPILOGUE
0482FE  CB                    RETF ; RETURN
