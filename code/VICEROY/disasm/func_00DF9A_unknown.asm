; ============================================================================
; func_00DF9A_unknown
; Region   : load_image
; Bytes    : file 0x00DF9A..0x00DFAC  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DF9A  55                    PUSH   bp ; STACK_PUSH
00DF9B  8B EC                 MOV    bp, sp ; MOV
00DF9D  57                    PUSH   di ; STACK_PUSH
00DF9E  8B FB                 MOV    di, bx ; MOV
00DFA0  8D 5E 06              LEA    bx, [bp + 6] ; ADDR
00DFA3  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
00DFA8  8E C2                 MOV    es, dx ; MOV
00DFAA  8B D8                 MOV    bx, ax ; MOV
