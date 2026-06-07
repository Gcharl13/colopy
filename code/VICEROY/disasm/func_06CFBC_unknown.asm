; ============================================================================
; func_06CFBC_unknown
; Region   : overlay
; Bytes    : file 0x06CFBC..0x06CFE7  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06CFBC  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
06CFC0  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
06CFC3  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
06CFC6  83 C1 74              ADD    cx, 0x74 ; ARITH
06CFC9  53                    PUSH   bx ; STACK_PUSH
06CFCA  51                    PUSH   cx ; STACK_PUSH
06CFCB  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06CFCE  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
06CFD1  C4 5E 08              LES    bx, ptr [bp + 8] ; MOV_FAR
06CFD4  26 8B 4F 48           MOV    cx, word ptr es:[bx + 0x48] ; MOV
06CFD8  26 03 4F 2A           ADD    cx, word ptr es:[bx + 0x2a] ; ARITH
06CFDC  03 C1                 ADD    ax, cx ; ARITH
06CFDE  2B DB                 SUB    bx, bx ; ARITH
06CFE0  E8 A5 F3              CALL   0x6c388 ; CALL_NEAR
06CFE3  C9                    LEAVE ; EPILOGUE
06CFE4  C2 08 00              RET    8 ; RETURN
