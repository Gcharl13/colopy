; ============================================================================
; func_0080C8_unknown
; Region   : load_image
; Bytes    : file 0x0080C8..0x0080D6  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0080C8  55                    PUSH   bp ; STACK_PUSH
0080C9  8B EC                 MOV    bp, sp ; MOV
0080CB  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
0080CF  7C 11                 JL     0x80e2 ; CJUMP
0080D1  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0080D4  8B C3                 MOV    ax, bx ; MOV
