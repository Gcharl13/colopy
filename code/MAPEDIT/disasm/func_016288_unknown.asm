; ============================================================================
; func_016288_unknown
; Region   : load_image
; Bytes    : file 0x016288..0x0162B4  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016288  55                    PUSH   bp ; STACK_PUSH
016289  8B EC                 MOV    bp, sp ; MOV
01628B  56                    PUSH   si ; STACK_PUSH
01628C  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
01628F  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
016292  A8 83                 TEST   al, 0x83 ; LOGIC
016294  74 1B                 JE     0x162b1 ; CJUMP
016296  A8 08                 TEST   al, 8 ; LOGIC
016298  74 17                 JE     0x162b1 ; CJUMP
01629A  FF 74 04              PUSH   word ptr [si + 4] ; STACK_PUSH
01629D  9A F8 23 88 13        LCALL  0x1388, 0x23f8 ; LCALL
0162A2  59                    POP    cx ; STACK_POP
0162A3  80 64 06 F7           AND    byte ptr [si + 6], 0xf7 ; LOGIC
0162A7  33 C0                 XOR    ax, ax ; LOGIC
0162A9  89 44 04              MOV    word ptr [si + 4], ax ; MOV
0162AC  89 04                 MOV    word ptr [si], ax ; MOV
0162AE  89 44 02              MOV    word ptr [si + 2], ax ; MOV
0162B1  5E                    POP    si ; STACK_POP
0162B2  5D                    POP    bp ; STACK_POP
0162B3  C3                    RET ; RETURN
