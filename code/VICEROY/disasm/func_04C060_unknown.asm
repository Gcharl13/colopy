; ============================================================================
; func_04C060_unknown
; Region   : overlay
; Bytes    : file 0x04C060..0x04C0F0  (144 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C060  C8 56 00 00           ENTER  0x56, 0 ; PROLOGUE
04C064  15 56 00              ADC    ax, 0x56 ; ARITH
04C067  00 EB                 ADD    bl, ch ; ARITH
04C069  5D                    POP    bp ; STACK_POP
04C06A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C06C  18 62 00              SBB    byte ptr [bp + si], ah ; ARITH
04C06F  00 C4                 ADD    ah, al ; ARITH
04C071  61                    POPAW                               ; UNKNOWN
04C072  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C074  4A                    DEC    dx ; ARITH
04C075  67 00 00              ADD    byte ptr [eax], al ; ARITH
04C078  84 6B 00              TEST   byte ptr [bp + di], ch ; LOGIC
04C07B  00 71 70              ADD    byte ptr [bx + di + 0x70], dh ; ARITH
04C07E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C080  21 07                 AND    word ptr [bx], ax ; LOGIC
04C082  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C084  8F 07                 POP    word ptr [bx] ; STACK_POP
04C086  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C088  67 0C 00              OR     al, 0 ; LOGIC
04C08B  00 DD                 ADD    ch, bl ; ARITH
04C08D  10 00                 ADC    byte ptr [bx + si], al ; ARITH
04C08F  00 6A 10              ADD    byte ptr [bp + si + 0x10], ch ; ARITH
04C092  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C094  5A                    POP    dx ; STACK_POP
04C095  21 00                 AND    word ptr [bx + si], ax ; LOGIC
04C097  00 75 2A              ADD    byte ptr [di + 0x2a], dh ; ARITH
04C09A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C09C  59                    POP    cx ; STACK_POP
04C09D  3A 00                 CMP    al, byte ptr [bx + si] ; CMP
04C09F  00 3E 41 00           ADD    byte ptr [0x41], bh ; ARITH
04C0A3  00 EF                 ADD    bh, ch ; ARITH
04C0A5  4A                    DEC    dx ; ARITH
04C0A6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C0A8  AF                    SCASW  ax, word ptr es:[di] ; STR
04C0A9  51                    PUSH   cx ; STACK_PUSH
04C0AA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C0AC  78 57                 JS     0x4c105 ; CJUMP
04C0AE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C0B0  27                    DAA ; ARITH
04C0B1  57                    PUSH   di ; STACK_PUSH
04C0B2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C0B4  56                    PUSH   si ; STACK_PUSH
04C0B5  5A                    POP    dx ; STACK_POP
04C0B6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C0B8  12 71 00              ADC    dh, byte ptr [bx + di] ; ARITH
04C0BB  00 F8                 ADD    al, bh ; ARITH
04C0BD  5B                    POP    bx ; STACK_POP
04C0BE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C0C0  01 43 00              ADD    word ptr [bp + di], ax ; ARITH
04C0C3  00 6C 69              ADD    byte ptr [si + 0x69], ch ; ARITH
04C0C6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C0C8  AC                    LODSB  al, byte ptr [si] ; STR
04C0C9  3F                    AAS ; ARITH
04C0CA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C0CC  A1 36 00              MOV    ax, word ptr [0x36] ; GLOBAL_LOAD
04C0CF  00 4D 58              ADD    byte ptr [di + 0x58], cl ; ARITH
04C0D2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C0D4  42                    INC    dx ; ARITH
04C0D5  70 00                 JO     0x4c0d7 ; CJUMP
04C0D7  00 36 70 00           ADD    byte ptr [0x70], dh ; ARITH
04C0DB  00 A7 63 00           ADD    byte ptr [bx + 0x63], ah ; ARITH
04C0DF  00 B0 6E 00           ADD    byte ptr [bx + si + 0x6e], dh ; ARITH
04C0E3  00 1D                 ADD    byte ptr [di], bl ; ARITH
04C0E5  6E                    OUTSB  dx, byte ptr [si] ; IO
04C0E6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04C0E8  0A 70 00              OR     dh, byte ptr [bx + si] ; LOGIC
04C0EB  00 E4                 ADD    ah, ah ; ARITH
04C0ED  6F                    OUTSW  dx, word ptr [si] ; IO
04C0EE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
