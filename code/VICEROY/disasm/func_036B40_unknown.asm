; ============================================================================
; func_036B40_unknown
; Region   : overlay
; Bytes    : file 0x036B40..0x036C21  (225 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

036B40  C8 26 00 00           ENTER  0x26, 0 ; PROLOGUE
036B44  7C 26                 JL     0x36b6c ; CJUMP
036B46  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B48  2E 26 00 00           ADD    byte ptr es:[bx + si], al ; ARITH
036B4C  92                    XCHG   dx, ax ; MOV
036B4D  29 00                 SUB    word ptr [bx + si], ax ; ARITH
036B4F  00 4C 29              ADD    byte ptr [si + 0x29], cl ; ARITH
036B52  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B54  F4                    HLT ; SYS
036B55  13 00                 ADC    ax, word ptr [bx + si] ; ARITH
036B57  00 51 05              ADD    byte ptr [bx + di + 5], dl ; ARITH
036B5A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B5C  37                    AAA ; ARITH
036B5D  05 00 00              ADD    ax, 0 ; ARITH
036B60  67 01 00              ADD    word ptr [eax], ax ; ARITH
036B63  00 CE                 ADD    dh, cl ; ARITH
036B65  15 00 00              ADC    ax, 0 ; ARITH
036B68  2F                    DAS ; ARITH
036B69  16                    PUSH   ss ; STACK_PUSH
036B6A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B6C  CD 09                 INT    9 ; SYS
036B6E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B70  50                    PUSH   ax ; STACK_PUSH
036B71  09 00                 OR     word ptr [bx + si], ax ; LOGIC
036B73  00 0F                 ADD    byte ptr [bx], cl ; ARITH
036B75  1E                    PUSH   ds ; STACK_PUSH
036B76  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B78  08 03                 OR     byte ptr [bp + di], al ; LOGIC
036B7A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B7C  35 20 00              XOR    ax, 0x20 ; LOGIC
036B7F  00 8E 07 00           ADD    byte ptr [bp + 7], cl ; ARITH
036B83  00 5B 0B              ADD    byte ptr [bp + di + 0xb], bl ; ARITH
036B86  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B88  49                    DEC    cx ; ARITH
036B89  2A 00                 SUB    al, byte ptr [bx + si] ; ARITH
036B8B  00 98 05 00           ADD    byte ptr [bx + si + 5], bl ; ARITH
036B8F  00 0F                 ADD    byte ptr [bx], cl ; ARITH
036B91  05 00 00              ADD    ax, 0 ; ARITH
036B94  84 28                 TEST   byte ptr [bx + si], ch ; LOGIC
036B96  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B98  23 28                 AND    bp, word ptr [bx + si] ; LOGIC
036B9A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036B9C  1B 2B                 SBB    bp, word ptr [bp + di] ; ARITH
036B9E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036BA0  16                    PUSH   ss ; STACK_PUSH
036BA1  2B 00                 SUB    ax, word ptr [bx + si] ; ARITH
036BA3  00 11                 ADD    byte ptr [bx + di], dl ; ARITH
036BA5  2B 00                 SUB    ax, word ptr [bx + si] ; ARITH
036BA7  00 0C                 ADD    byte ptr [si], cl ; ARITH
036BA9  2B 00                 SUB    ax, word ptr [bx + si] ; ARITH
036BAB  00 07                 ADD    byte ptr [bx], al ; ARITH
036BAD  2B 00                 SUB    ax, word ptr [bx + si] ; ARITH
036BAF  00 02                 ADD    byte ptr [bp + si], al ; ARITH
036BB1  2B 00                 SUB    ax, word ptr [bx + si] ; ARITH
036BB3  00 FD                 ADD    ch, bh ; ARITH
036BB5  2A 00                 SUB    al, byte ptr [bx + si] ; ARITH
036BB7  00 F8                 ADD    al, bh ; ARITH
036BB9  2A 00                 SUB    al, byte ptr [bx + si] ; ARITH
036BBB  00 F3                 ADD    bl, dh ; ARITH
036BBD  2A 00                 SUB    al, byte ptr [bx + si] ; ARITH
036BBF  00 0A                 ADD    byte ptr [bp + si], cl ; ARITH
036BC1  1F                    POP    ds ; STACK_POP
036BC2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036BC4  46                    INC    si ; ARITH
036BC5  1A 00                 SBB    al, byte ptr [bx + si] ; ARITH
036BC7  00 43 15              ADD    byte ptr [bp + di + 0x15], al ; ARITH
036BCA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036BCC  90                    NOP ; NOP
036BCD  18 00                 SBB    byte ptr [bx + si], al ; ARITH
036BCF  00 FF                 ADD    bh, bh ; ARITH
036BD1  21 00                 AND    word ptr [bx + si], ax ; LOGIC
036BD3  00 CE                 ADD    dh, cl ; ARITH
036BD5  25 00 00              AND    ax, 0 ; LOGIC
036BD8  60                    PUSHAW                              ; UNKNOWN
036BD9  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
036BDB  00 9A 01 00           ADD    byte ptr [bp + si + 1], bl ; ARITH
036BDF  00 74 01              ADD    byte ptr [si + 1], dh ; ARITH
036BE2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036BE4  29 07                 SUB    word ptr [bx], ax ; ARITH
036BE6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036BE8  CD 04                 INT    4 ; SYS
036BEA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036BEC  78 04                 JS     0x36bf2 ; CJUMP
036BEE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036BF0  29 04                 SUB    word ptr [si], ax ; ARITH
036BF2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036BF4  CE                    INTO ; SYS
036BF5  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
036BF7  00 A2 0A 00           ADD    byte ptr [bp + si + 0xa], ah ; ARITH
036BFB  00 86 0A 00           ADD    byte ptr [bp + 0xa], al ; ARITH
036BFF  00 A0 09 00           ADD    byte ptr [bx + si + 9], ah ; ARITH
036C03  00 84 09 00           ADD    byte ptr [si + 9], al ; ARITH
036C07  00 27                 ADD    byte ptr [bx], ah ; ARITH
036C09  09 00                 OR     word ptr [bx + si], ax ; LOGIC
036C0B  00 0B                 ADD    byte ptr [bp + di], cl ; ARITH
036C0D  09 00                 OR     word ptr [bx + si], ax ; LOGIC
036C0F  00 4B 08              ADD    byte ptr [bp + di + 8], cl ; ARITH
036C12  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036C14  B7 07                 MOV    bh, 7 ; MOV
036C16  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036C18  9B                    WAIT ; SYS
036C19  07                    POP    es ; STACK_POP
036C1A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036C1C  6D                    INSW   word ptr es:[di], dx ; IO
036C1D  07                    POP    es ; STACK_POP
036C1E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
036C20  C3                    RET ; RETURN
