; ============================================================================
; func_03F90E_unknown
; Region   : overlay
; Bytes    : file 0x03F90E..0x03F940  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03F90E  55                    PUSH   bp ; STACK_PUSH
03F90F  8B EC                 MOV    bp, sp ; MOV
03F911  56                    PUSH   si ; STACK_PUSH
03F912  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
03F915  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
03F919  98                    CWDE ; ARITH
03F91A  6B 76 06 1C           IMUL   si, word ptr [bp + 6], 0x1c ; ARITH
03F91E  8A 8C 45 31           MOV    cl, byte ptr [si + 0x3145] ; MOV
03F922  2A ED                 SUB    ch, ch ; ARITH
03F924  03 C1                 ADD    ax, cx ; ARITH
03F926  50                    PUSH   ax ; STACK_PUSH
03F927  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
03F92B  98                    CWDE ; ARITH
03F92C  8A 8C 44 31           MOV    cl, byte ptr [si + 0x3144] ; MOV
03F930  03 C8                 ADD    cx, ax ; ARITH
03F932  51                    PUSH   cx ; STACK_PUSH
03F933  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03F936  0E                    PUSH   cs ; STACK_PUSH
03F937  E8 06 00              CALL   0x3f940 ; CALL_NEAR
03F93A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03F93D  5E                    POP    si ; STACK_POP
03F93E  C9                    LEAVE ; EPILOGUE
03F93F  CB                    RETF ; RETURN
