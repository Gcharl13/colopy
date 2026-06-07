; ============================================================================
; func_0072E2_unknown
; Region   : load_image
; Bytes    : file 0x0072E2..0x00730A  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0072E2  55                    PUSH   bp ; STACK_PUSH
0072E3  8B EC                 MOV    bp, sp ; MOV
0072E5  57                    PUSH   di ; STACK_PUSH
0072E6  56                    PUSH   si ; STACK_PUSH
0072E7  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0072EA  0B F6                 OR     si, si ; LOGIC
0072EC  7C 18                 JL     0x7306 ; CJUMP
0072EE  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
0072F1  8B C7                 MOV    ax, di ; MOV
0072F3  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
0072F6  08 87 47 31           OR     byte ptr [bx + 0x3147], al ; LOGIC
0072FA  8B C6                 MOV    ax, si ; MOV
0072FC  0E                    PUSH   cs ; STACK_PUSH
0072FD  E8 BA F3              CALL   0x66ba ; CALL_NEAR
007300  8B F0                 MOV    si, ax ; MOV
007302  0B F6                 OR     si, si ; LOGIC
007304  7D EB                 JGE    0x72f1 ; CJUMP
007306  5E                    POP    si ; STACK_POP
007307  5F                    POP    di ; STACK_POP
007308  C9                    LEAVE ; EPILOGUE
007309  CB                    RETF ; RETURN
