; ============================================================================
; func_00DD80_unknown
; Region   : load_image
; Bytes    : file 0x00DD80..0x00DD8F  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DD80  55                    PUSH   bp ; STACK_PUSH
00DD81  8B EC                 MOV    bp, sp ; MOV
00DD83  8D 5E 06              LEA    bx, [bp + 6] ; ADDR
00DD86  9A 00 00 91 0C        LCALL  0xc91, 0 ; LCALL
00DD8B  8E C2                 MOV    es, dx ; MOV
00DD8D  8B D8                 MOV    bx, ax ; MOV
