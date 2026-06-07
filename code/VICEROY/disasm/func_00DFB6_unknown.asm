; ============================================================================
; func_00DFB6_unknown
; Region   : load_image
; Bytes    : file 0x00DFB6..0x00DFC5  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DFB6  55                    PUSH   bp ; STACK_PUSH
00DFB7  8B EC                 MOV    bp, sp ; MOV
00DFB9  8D 5E 06              LEA    bx, [bp + 6] ; ADDR
00DFBC  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
00DFC1  8E C2                 MOV    es, dx ; MOV
00DFC3  8B D8                 MOV    bx, ax ; MOV
