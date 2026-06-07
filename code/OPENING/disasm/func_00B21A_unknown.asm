; ============================================================================
; func_00B21A_unknown
; Region   : load_image
; Bytes    : file 0x00B21A..0x00B22F  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B21A  55                    PUSH   bp ; STACK_PUSH
00B21B  8B EC                 MOV    bp, sp ; MOV
00B21D  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00B220  BB 8A 5E              MOV    bx, 0x5e8a ; CONST_LOAD
00B223  8B 0E FA 41           MOV    cx, word ptr [0x41fa] ; GLOBAL_LOAD
00B227  E3 1E                 JCXZ   0xb247 ; CJUMP
00B229  8B 07                 MOV    ax, word ptr [bx] ; MOV
00B22B  3B C2                 CMP    ax, dx ; CMP
00B22D  74 07                 JE     0xb236 ; CJUMP
