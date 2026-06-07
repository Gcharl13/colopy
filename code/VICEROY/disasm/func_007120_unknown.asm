; ============================================================================
; func_007120_unknown
; Region   : load_image
; Bytes    : file 0x007120..0x007165  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007120  55                    PUSH   bp ; STACK_PUSH
007121  8B EC                 MOV    bp, sp ; MOV
007123  57                    PUSH   di ; STACK_PUSH
007124  56                    PUSH   si ; STACK_PUSH
007125  C7 06 FA 8C FF FF     MOV    word ptr [0x8cfa], 0xffff ; GLOBAL_LOAD
00712B  2B F6                 SUB    si, si ; ARITH
00712D  83 FE 08              CMP    si, 8 ; CMP
007130  7D 31                 JGE    0x7163 ; CJUMP
007132  8A 84 BE 00           MOV    al, byte ptr [si + 0xbe] ; MOV
007136  98                    CWDE ; ARITH
007137  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
00713A  50                    PUSH   ax ; STACK_PUSH
00713B  8A 84 B4 00           MOV    al, byte ptr [si + 0xb4] ; MOV
00713F  98                    CWDE ; ARITH
007140  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
007143  50                    PUSH   ax ; STACK_PUSH
007144  9A 14 03 7F 03        LCALL  0x37f, 0x314 ; LCALL
007149  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00714C  8B F8                 MOV    di, ax ; MOV
00714E  0B FF                 OR     di, di ; LOGIC
007150  7C 09                 JL     0x715b ; CJUMP
007152  39 7E 0A              CMP    word ptr [bp + 0xa], di ; CMP
007155  74 04                 JE     0x715b ; CJUMP
007157  89 3E FA 8C           MOV    word ptr [0x8cfa], di ; GLOBAL_LOAD
00715B  46                    INC    si ; ARITH
00715C  83 3E FA 8C 00        CMP    word ptr [0x8cfa], 0 ; CMP
007161  7C CA                 JL     0x712d ; CJUMP
007163  83                    DB     0x83 ; DATA_BYTE
007164  3E                    DB     0x3E ; DATA_BYTE
