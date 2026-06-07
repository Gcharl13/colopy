; ============================================================================
; func_006D24_unknown
; Region   : load_image
; Bytes    : file 0x006D24..0x006DE9  (197 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006D24  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
006D28  57                    PUSH   di ; STACK_PUSH
006D29  56                    PUSH   si ; STACK_PUSH
006D2A  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
006D2D  BE FF FF              MOV    si, 0xffff ; CONST_LOAD
006D30  83 FF 04              CMP    di, 4 ; CMP
006D33  7D 0A                 JGE    0x6d3f ; CJUMP
006D35  6B DF 34              IMUL   bx, di, 0x34 ; ARITH
006D38  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
006D3D  74 0B                 JE     0x6d4a ; CJUMP
006D3F  81 3E 9C 53 24 01     CMP    word ptr [0x539c], 0x124 ; CMP
006D45  7C 03                 JL     0x6d4a ; CJUMP
006D47  E9 44 01              JMP    0x6e8e ; JUMP
006D4A  81 3E 9C 53 2C 01     CMP    word ptr [0x539c], 0x12c ; CMP
006D50  7C 03                 JL     0x6d55 ; CJUMP
006D52  E9 21 01              JMP    0x6e76 ; JUMP
006D55  83 FF 04              CMP    di, 4 ; CMP
006D58  7D 0A                 JGE    0x6d64 ; CJUMP
006D5A  80 BD FC 8C C8        CMP    byte ptr [di - 0x7304], 0xc8 ; CMP
006D5F  76 03                 JBE    0x6d64 ; CJUMP
006D61  E9 12 01              JMP    0x6e76 ; JUMP
006D64  8B 36 9C 53           MOV    si, word ptr [0x539c] ; GLOBAL_LOAD
006D68  FF 06 9C 53           INC    word ptr [0x539c] ; ARITH
006D6C  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
006D6F  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
006D72  89 5E FC              MOV    word ptr [bp - 4], bx ; LOCAL_STORE
006D75  88 87 46 31           MOV    byte ptr [bx + 0x3146], al ; MOV
006D79  8B C7                 MOV    ax, di ; MOV
006D7B  88 87 47 31           MOV    byte ptr [bx + 0x3147], al ; MOV
006D7F  C6 87 49 31 00        MOV    byte ptr [bx + 0x3149], 0 ; MOV
006D84  C6 87 4B 31 58        MOV    byte ptr [bx + 0x314b], 0x58 ; CONST_LOAD
006D89  2A C0                 SUB    al, al ; ARITH
006D8B  88 87 48 31           MOV    byte ptr [bx + 0x3148], al ; MOV
006D8F  88 87 4C 31           MOV    byte ptr [bx + 0x314c], al ; MOV
006D93  88 87 50 31           MOV    byte ptr [bx + 0x3150], al ; MOV
006D97  88 87 5A 31           MOV    byte ptr [bx + 0x315a], al ; MOV
006D9B  88 87 54 31           MOV    byte ptr [bx + 0x3154], al ; MOV
006D9F  88 87 55 31           MOV    byte ptr [bx + 0x3155], al ; MOV
006DA3  C6 87 56 31 FF        MOV    byte ptr [bx + 0x3156], 0xff ; CONST_LOAD
006DA8  83 FF 04              CMP    di, 4 ; CMP
006DAB  7C 0A                 JL     0x6db7 ; CJUMP
006DAD  A1 8E 53              MOV    ax, word ptr [0x538e] ; GLOBAL_LOAD
006DB0  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
006DB3  89 87 56 31           MOV    word ptr [bx + 0x3156], ax ; MOV
006DB7  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
006DBA  C6 87 4A 31 FF        MOV    byte ptr [bx + 0x314a], 0xff ; CONST_LOAD
006DBF  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
006DC2  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
006DC5  9A 76 0A EB 05        LCALL  0x5eb, 0xa76 ; LCALL
006DCA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006DCD  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
006DD0  0B C0                 OR     ax, ax ; LOGIC
006DD2  7C 0A                 JL     0x6dde ; CJUMP
006DD4  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
006DD7  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
006DDA  88 87 4A 31           MOV    byte ptr [bx + 0x314a], al ; MOV
006DDE  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
006DE1  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
006DE5  2A FF                 SUB    bh, bh ; ARITH
006DE7  8B C3                 MOV    ax, bx ; MOV
