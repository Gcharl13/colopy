; ============================================================================
; func_0099EE_unknown
; Region   : load_image
; Bytes    : file 0x0099EE..0x009A31  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0099EE  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0099F2  2B C0                 SUB    ax, ax ; ARITH
0099F4  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0099F7  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0099FA  EB 2A                 JMP    0x9a26 ; JUMP
0099FC  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
0099FF  50                    PUSH   ax ; STACK_PUSH
009A00  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
009A03  50                    PUSH   ax ; STACK_PUSH
009A04  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
009A07  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
009A0B  98                    CWDE ; ARITH
009A0C  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
009A0F  50                    PUSH   ax ; STACK_PUSH
009A10  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
009A14  98                    CWDE ; ARITH
009A15  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
009A18  50                    PUSH   ax ; STACK_PUSH
009A19  0E                    PUSH   cs ; STACK_PUSH
009A1A  E8 91 FF              CALL   0x99ae ; CALL_NEAR
009A1D  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
009A20  01 46 FE              ADD    word ptr [bp - 2], ax ; ARITH
009A23  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
009A26  83 7E FC 08           CMP    word ptr [bp - 4], 8 ; CMP
009A2A  7C D0                 JL     0x99fc ; CJUMP
009A2C  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
009A2F  C9                    LEAVE ; EPILOGUE
009A30  CB                    RETF ; RETURN
