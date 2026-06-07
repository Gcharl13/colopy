; ============================================================================
; func_033778_unknown
; Region   : overlay
; Bytes    : file 0x033778..0x0337A1  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033778  C8 22 00 00           ENTER  0x22, 0 ; PROLOGUE
03377C  56                    PUSH   si ; STACK_PUSH
03377D  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
033782  83 3E 3A 9E 08        CMP    word ptr [0x9e3a], 8 ; CMP
033787  75 19                 JNE    0x337a2 ; CJUMP
033789  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
03378E  75 03                 JNE    0x33793 ; CJUMP
033790  E9 BC 02              JMP    0x33a4f ; JUMP
033793  FF 36 1C 9E           PUSH   word ptr [0x9e1c] ; PUSH_GLOBAL
033797  0E                    PUSH   cs ; STACK_PUSH
033798  E8 B4 30              CALL   0x3684f ; CALL_NEAR
03379B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03379E  5E                    POP    si ; STACK_POP
03379F  C9                    LEAVE ; EPILOGUE
0337A0  CB                    RETF ; RETURN
