; ============================================================================
; func_0081A4_unknown
; Region   : load_image
; Bytes    : file 0x0081A4..0x0081C0  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0081A4  55                    PUSH   bp ; STACK_PUSH
0081A5  8B EC                 MOV    bp, sp ; MOV
0081A7  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
0081AC  74 12                 JE     0x81c0 ; CJUMP
0081AE  A1 D2 53              MOV    ax, word ptr [0x53d2] ; GLOBAL_LOAD
0081B1  39 46 06              CMP    word ptr [bp + 6], ax ; CMP
0081B4  75 0A                 JNE    0x81c0 ; CJUMP
0081B6  6B 06 98 53 34        IMUL   ax, word ptr [0x5398], 0x34 ; ARITH
0081BB  05 26 54              ADD    ax, 0x5426 ; ARITH
0081BE  C9                    LEAVE ; EPILOGUE
0081BF  CB                    RETF ; RETURN
