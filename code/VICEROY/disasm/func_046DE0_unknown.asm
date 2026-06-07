; ============================================================================
; func_046DE0_unknown
; Region   : overlay
; Bytes    : file 0x046DE0..0x046E18  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046DE0  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
046DE4  56                    PUSH   si ; STACK_PUSH
046DE5  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12 ; ARITH
046DE9  8A 87 EE 54           MOV    al, byte ptr [bx + 0x54ee] ; MOV
046DED  2A E4                 SUB    ah, ah ; ARITH
046DEF  2D 04 00              SUB    ax, 4 ; ARITH
046DF2  6B F0 4E              IMUL   si, ax, 0x4e ; ARITH
046DF5  8A 84 D8 5A           MOV    al, byte ptr [si + 0x5ad8] ; MOV
046DF9  2A E4                 SUB    ah, ah ; ARITH
046DFB  8B C8                 MOV    cx, ax ; MOV
046DFD  D1 E0                 SHL    ax, 1 ; LOGIC
046DFF  05 03 00              ADD    ax, 3 ; ARITH
046E02  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
046E05  F6 87 EF 54 04        TEST   byte ptr [bx + 0x54ef], 4 ; LOGIC
046E0A  74 06                 JE     0x46e12 ; CJUMP
046E0C  03 C8                 ADD    cx, ax ; ARITH
046E0E  41                    INC    cx ; ARITH
046E0F  89 4E FE              MOV    word ptr [bp - 2], cx ; LOCAL_STORE
046E12  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
046E15  5E                    POP    si ; STACK_POP
046E16  C9                    LEAVE ; EPILOGUE
046E17  CB                    RETF ; RETURN
