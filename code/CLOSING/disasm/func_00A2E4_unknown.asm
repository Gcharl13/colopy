; ============================================================================
; func_00A2E4_unknown
; Region   : load_image
; Bytes    : file 0x00A2E4..0x00A2F9  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A2E4  55                    PUSH   bp ; STACK_PUSH
00A2E5  8B EC                 MOV    bp, sp ; MOV
00A2E7  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00A2EA  BB 50 50              MOV    bx, 0x5050 ; CONST_LOAD
00A2ED  8B 0E A4 3F           MOV    cx, word ptr [0x3fa4] ; GLOBAL_LOAD
00A2F1  E3 1E                 JCXZ   0xa311 ; CJUMP
00A2F3  8B 07                 MOV    ax, word ptr [bx] ; MOV
00A2F5  3B C2                 CMP    ax, dx ; CMP
00A2F7  74 07                 JE     0xa300 ; CJUMP
