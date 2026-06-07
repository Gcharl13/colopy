; ============================================================================
; func_042B10_unknown
; Region   : overlay
; Bytes    : file 0x042B10..0x042BEF  (223 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042B10  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
042B14  61                    POPAW                               ; UNKNOWN
042B15  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
042B17  00 7D 17              ADD    byte ptr [di + 0x17], bh ; ARITH
042B1A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B1C  A5                    MOVSW  word ptr es:[di], word ptr [si] ; STR
042B1D  01 00                 ADD    word ptr [bx + si], ax ; ARITH
042B1F  00 98 00 00           ADD    byte ptr [bx + si], bl ; ARITH
042B23  00 52 03              ADD    byte ptr [bp + si + 3], dl ; ARITH
042B26  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B28  06                    PUSH   es ; STACK_PUSH
042B29  01 00                 ADD    word ptr [bx + si], ax ; ARITH
042B2B  00 AC 00 00           ADD    byte ptr [si], ch ; ARITH
042B2F  00 0B                 ADD    byte ptr [bp + di], cl ; ARITH
042B31  07                    POP    es ; STACK_POP
042B32  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B34  83 0A 00              OR     word ptr [bp + si], 0 ; LOGIC
042B37  00 0E 0A 00           ADD    byte ptr [0xa], cl ; ARITH
042B3B  00 17                 ADD    byte ptr [bx], dl ; ARITH
042B3D  09 00                 OR     word ptr [bx + si], ax ; LOGIC
042B3F  00 9E 08 00           ADD    byte ptr [bp + 8], bl ; ARITH
042B43  00 8E 0D 00           ADD    byte ptr [bp + 0xd], cl ; ARITH
042B47  00 30                 ADD    byte ptr [bx + si], dh ; ARITH
042B49  0D 00 00              OR     ax, 0 ; LOGIC
042B4C  D5 0C                 AAD    0xc ; ARITH
042B4E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B50  7C 0C                 JL     0x42b5e ; CJUMP
042B52  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B54  46                    INC    si ; ARITH
042B55  15 00 00              ADC    ax, 0 ; ARITH
042B58  17                    POP    ss ; STACK_POP
042B59  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
042B5B  00 F9                 ADD    cl, bh ; ARITH
042B5D  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
042B5F  00 C7                 ADD    bh, al ; ARITH
042B61  0E                    PUSH   cs ; STACK_PUSH
042B62  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B64  43                    INC    bx ; ARITH
042B65  04 00                 ADD    al, 0 ; ARITH
042B67  00 5C 00              ADD    byte ptr [si], bl ; ARITH
042B6A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B6C  3E 01 00              ADD    word ptr ds:[bx + si], ax ; ARITH
042B6F  00 DE                 ADD    dh, bl ; ARITH
042B71  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B73  00 D9                 ADD    cl, bl ; ARITH
042B75  06                    PUSH   es ; STACK_PUSH
042B76  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B78  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
042B79  05 00 00              ADD    ax, 0 ; ARITH
042B7C  EA 04 00 00 0A        LJMP   0xa00:4                      ; UNKNOWN
042B81  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
042B83  00 36 08 00           ADD    byte ptr [8], dh ; ARITH
042B87  00 9A 07 00           ADD    byte ptr [bp + si + 7], bl ; ARITH
042B8B  00 24                 ADD    byte ptr [si], ah ; ARITH
042B8D  0E                    PUSH   cs ; STACK_PUSH
042B8E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B90  BD 0D 00              MOV    bp, 0xd ; CONST_LOAD
042B93  00 64 0D              ADD    byte ptr [si + 0xd], ah ; ARITH
042B96  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B98  04 0D                 ADD    al, 0xd ; ARITH
042B9A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042B9C  AB                    STOSW  word ptr es:[di], ax ; STR
042B9D  0C 00                 OR     al, 0 ; LOGIC
042B9F  00 B4 0B 00           ADD    byte ptr [si + 0xb], dh ; ARITH
042BA3  00 45 12              ADD    byte ptr [di + 0x12], al ; ARITH
042BA6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BA8  D5 11                 AAD    0x11 ; ARITH
042BAA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BAC  A8 11                 TEST   al, 0x11 ; LOGIC
042BAE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BB0  B3 10                 MOV    bl, 0x10 ; CONST_LOAD
042BB2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BB4  00 10                 ADD    byte ptr [bx + si], dl ; ARITH
042BB6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BB8  DE 0E 00 00           FIMUL  word ptr [0]                 ; UNKNOWN
042BBC  DA 15                 FICOM  dword ptr [di]               ; UNKNOWN
042BBE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BC0  AC                    LODSB  al, byte ptr [si] ; STR
042BC1  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
042BC3  00 2C                 ADD    byte ptr [si], ch ; ARITH
042BC5  17                    POP    ss ; STACK_POP
042BC6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BC8  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
042BC9  16                    PUSH   ss ; STACK_PUSH
042BCA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BCC  6C                    INSB   byte ptr es:[di], dx ; IO
042BCD  16                    PUSH   ss ; STACK_PUSH
042BCE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BD0  2F                    DAS ; ARITH
042BD1  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
042BD3  00 5F 0E              ADD    byte ptr [bx + 0xe], bl ; ARITH
042BD6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BD8  14 11                 ADC    al, 0x11 ; ARITH
042BDA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BDC  6A 03                 PUSH   3 ; STACK_PUSH
042BDE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BE0  28 07                 SUB    byte ptr [bx], al ; ARITH
042BE2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BE4  A0 0A 00              MOV    al, byte ptr [0xa] ; GLOBAL_LOAD
042BE7  00 65 04              ADD    byte ptr [di + 4], ah ; ARITH
042BEA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
042BEC  CA 0B 00              RETF   0xb ; RETURN
