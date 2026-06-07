; ============================================================================
; func_00A93E_unknown
; Region   : load_image
; Bytes    : file 0x00A93E..0x00A994  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A93E  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00A942  56                    PUSH   si ; STACK_PUSH
00A943  80 3E 4C 03 00        CMP    byte ptr [0x34c], 0 ; CMP
00A948  75 42                 JNE    0xa98c ; CJUMP
00A94A  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
00A94F  EB 2E                 JMP    0xa97f ; JUMP
00A951  90                    NOP ; NOP
00A952  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
00A955  83 7E FE 05           CMP    word ptr [bp - 2], 5 ; CMP
00A959  7D 21                 JGE    0xa97c ; CJUMP
00A95B  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00A95E  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00A961  0E                    PUSH   cs ; STACK_PUSH
00A962  E8 3D FD              CALL   0xa6a2 ; CALL_NEAR
00A965  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00A968  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
00A96B  8B CE                 MOV    cx, si ; MOV
00A96D  C1 E6 02              SHL    si, 2 ; LOGIC
00A970  03 F1                 ADD    si, cx ; ARITH
00A972  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
00A975  88 80 F0 8D           MOV    byte ptr [bx + si - 0x7210], al ; MOV
00A979  EB D7                 JMP    0xa952 ; JUMP
00A97B  90                    NOP ; NOP
00A97C  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
00A97F  83 7E FC 05           CMP    word ptr [bp - 4], 5 ; CMP
00A983  7D 07                 JGE    0xa98c ; CJUMP
00A985  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00A98A  EB C9                 JMP    0xa955 ; JUMP
00A98C  C6 06 4C 03 01        MOV    byte ptr [0x34c], 1 ; GLOBAL_LOAD
00A991  5E                    POP    si ; STACK_POP
00A992  C9                    LEAVE ; EPILOGUE
00A993  CB                    RETF ; RETURN
