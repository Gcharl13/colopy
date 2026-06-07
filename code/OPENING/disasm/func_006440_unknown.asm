; ============================================================================
; func_006440_unknown
; Region   : load_image
; Bytes    : file 0x006440..0x00646C  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006440  55                    PUSH   bp ; STACK_PUSH
006441  8B EC                 MOV    bp, sp ; MOV
006443  56                    PUSH   si ; STACK_PUSH
006444  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
006447  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
00644A  A8 83                 TEST   al, 0x83 ; LOGIC
00644C  74 1B                 JE     0x6469 ; CJUMP
00644E  A8 08                 TEST   al, 8 ; LOGIC
006450  74 17                 JE     0x6469 ; CJUMP
006452  FF 74 04              PUSH   word ptr [si + 4] ; STACK_PUSH
006455  9A 36 25 52 04        LCALL  0x452, 0x2536 ; LCALL
00645A  59                    POP    cx ; STACK_POP
00645B  80 64 06 F7           AND    byte ptr [si + 6], 0xf7 ; LOGIC
00645F  33 C0                 XOR    ax, ax ; LOGIC
006461  89 44 04              MOV    word ptr [si + 4], ax ; MOV
006464  89 04                 MOV    word ptr [si], ax ; MOV
006466  89 44 02              MOV    word ptr [si + 2], ax ; MOV
006469  5E                    POP    si ; STACK_POP
00646A  5D                    POP    bp ; STACK_POP
00646B  C3                    RET ; RETURN
