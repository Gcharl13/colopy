; ============================================================================
; func_00DD64_unknown
; Region   : load_image
; Bytes    : file 0x00DD64..0x00DD76  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DD64  55                    PUSH   bp ; STACK_PUSH
00DD65  8B EC                 MOV    bp, sp ; MOV
00DD67  57                    PUSH   di ; STACK_PUSH
00DD68  8B FB                 MOV    di, bx ; MOV
00DD6A  8D 5E 06              LEA    bx, [bp + 6] ; ADDR
00DD6D  9A 00 00 91 0C        LCALL  0xc91, 0 ; LCALL
00DD72  8E C2                 MOV    es, dx ; MOV
00DD74  8B D8                 MOV    bx, ax ; MOV
