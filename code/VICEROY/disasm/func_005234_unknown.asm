; ============================================================================
; func_005234_unknown
; Region   : load_image
; Bytes    : file 0x005234..0x005272  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005234  55                    PUSH   bp ; STACK_PUSH
005235  8B EC                 MOV    bp, sp ; MOV
005237  83 3E 2C 08 00        CMP    word ptr [0x82c], 0 ; CMP
00523C  74 34                 JE     0x5272 ; CJUMP
00523E  6A 00                 PUSH   0 ; STACK_PUSH
005240  6A 00                 PUSH   0 ; STACK_PUSH
005242  FF 76 14              PUSH   word ptr [bp + 0x14] ; PUSH_GLOBAL
005245  FF 76 12              PUSH   word ptr [bp + 0x12] ; PUSH_GLOBAL
005248  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
00524B  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
00524E  8B 1E 2C 08           MOV    bx, word ptr [0x82c] ; GLOBAL_LOAD
005252  FF 77 06              PUSH   word ptr [bx + 6] ; STACK_PUSH
005255  FF 77 04              PUSH   word ptr [bx + 4] ; STACK_PUSH
005258  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
00525B  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
00525D  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
005260  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
005263  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005266  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005269  9A 00 00 F5 0B        LCALL  0xbf5, 0 ; LCALL
00526E  8B E5                 MOV    sp, bp ; MOV
005270  C9                    LEAVE ; EPILOGUE
005271  CB                    RETF ; RETURN
