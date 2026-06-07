; ============================================================================
; func_01311B_unknown
; Region   : load_image
; Bytes    : file 0x01311B..0x01315A  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01311B  C8 A2 05 00           ENTER  0x5a2, 0 ; PROLOGUE
01311F  8A CC                 MOV    cl, ah ; MOV
013121  B8 01 00              MOV    ax, 1 ; MOV
013124  D3 E0                 SHL    ax, cl ; LOGIC
013126  A3 08 00              MOV    word ptr [8], ax ; MOV
013129  80 E9 04              SUB    cl, 4 ; ARITH
01312C  B8 01 00              MOV    ax, 1 ; MOV
01312F  D3 E0                 SHL    ax, cl ; LOGIC
013131  A3 0A 00              MOV    word ptr [0xa], ax ; GLOBAL_LOAD
013134  80 E9 04              SUB    cl, 4 ; ARITH
013137  B0 FF                 MOV    al, 0xff ; CONST_LOAD
013139  D2 E0                 SHL    al, cl ; LOGIC
01313B  A2 06 00              MOV    byte ptr [6], al ; MOV
01313E  81 FE 0F 08           CMP    si, 0x80f ; CMP
013142  72 03                 JB     0x13147 ; CJUMP
013144  E8 2D 01              CALL   0x13274 ; CALL_NEAR
013147  AD                    LODSW  ax, word ptr [si] ; STR
013148  8B E8                 MOV    bp, ax ; MOV
01314A  BA 10 00              MOV    dx, 0x10 ; CONST_LOAD
01314D  EB 0B                 JMP    0x1315a ; JUMP
01314F  90                    NOP ; NOP
013150  B8 16 00              MOV    ax, 0x16 ; CONST_LOAD
013153  1F                    POP    ds ; STACK_POP
013154  5F                    POP    di ; STACK_POP
013155  5E                    POP    si ; STACK_POP
013156  C9                    LEAVE ; EPILOGUE
013157  CA 0C 00              RETF   0xc ; RETURN
