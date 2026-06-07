; ============================================================================
; func_00903E_unknown
; Region   : load_image
; Bytes    : file 0x00903E..0x009063  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00903E  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
009042  56                    PUSH   si ; STACK_PUSH
009043  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
009048  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00904B  EB 59                 JMP    0x90a6 ; JUMP
00904D  90                    NOP ; NOP
00904E  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
009051  D1 E3                 SHL    bx, 1 ; LOGIC
009053  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
009056  C7 00 0F 00           MOV    word ptr [bx + si], 0xf ; CONST_LOAD
00905A  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
00905D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
009060  5E                    POP    si ; STACK_POP
009061  C9                    LEAVE ; EPILOGUE
009062  CB                    RETF ; RETURN
