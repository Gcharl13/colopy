; ============================================================================
; func_0051D2_unknown
; Region   : load_image
; Bytes    : file 0x0051D2..0x005210  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0051D2  55                    PUSH   bp ; STACK_PUSH
0051D3  8B EC                 MOV    bp, sp ; MOV
0051D5  83 3E 2E 08 00        CMP    word ptr [0x82e], 0 ; CMP
0051DA  74 34                 JE     0x5210 ; CJUMP
0051DC  6A 00                 PUSH   0 ; STACK_PUSH
0051DE  6A 00                 PUSH   0 ; STACK_PUSH
0051E0  FF 76 14              PUSH   word ptr [bp + 0x14] ; PUSH_GLOBAL
0051E3  FF 76 12              PUSH   word ptr [bp + 0x12] ; PUSH_GLOBAL
0051E6  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
0051E9  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
0051EC  8B 1E 2E 08           MOV    bx, word ptr [0x82e] ; GLOBAL_LOAD
0051F0  FF 77 06              PUSH   word ptr [bx + 6] ; STACK_PUSH
0051F3  FF 77 04              PUSH   word ptr [bx + 4] ; STACK_PUSH
0051F6  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
0051F9  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
0051FB  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0051FE  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
005201  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005204  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005207  9A 00 00 F5 0B        LCALL  0xbf5, 0 ; LCALL
00520C  8B E5                 MOV    sp, bp ; MOV
00520E  C9                    LEAVE ; EPILOGUE
00520F  CB                    RETF ; RETURN
