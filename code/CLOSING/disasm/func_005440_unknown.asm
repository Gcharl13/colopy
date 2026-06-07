; ============================================================================
; func_005440_unknown
; Region   : load_image
; Bytes    : file 0x005440..0x00546C  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005440  55                    PUSH   bp ; STACK_PUSH
005441  8B EC                 MOV    bp, sp ; MOV
005443  56                    PUSH   si ; STACK_PUSH
005444  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
005447  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
00544A  A8 83                 TEST   al, 0x83 ; LOGIC
00544C  74 1B                 JE     0x5469 ; CJUMP
00544E  A8 08                 TEST   al, 8 ; LOGIC
005450  74 17                 JE     0x5469 ; CJUMP
005452  FF 74 04              PUSH   word ptr [si + 4] ; STACK_PUSH
005455  9A 94 24 7D 03        LCALL  0x37d, 0x2494 ; LCALL
00545A  59                    POP    cx ; STACK_POP
00545B  80 64 06 F7           AND    byte ptr [si + 6], 0xf7 ; LOGIC
00545F  33 C0                 XOR    ax, ax ; LOGIC
005461  89 44 04              MOV    word ptr [si + 4], ax ; MOV
005464  89 04                 MOV    word ptr [si], ax ; MOV
005466  89 44 02              MOV    word ptr [si + 2], ax ; MOV
005469  5E                    POP    si ; STACK_POP
00546A  5D                    POP    bp ; STACK_POP
00546B  C3                    RET ; RETURN
