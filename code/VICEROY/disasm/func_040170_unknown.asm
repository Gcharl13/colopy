; ============================================================================
; func_040170_unknown
; Region   : overlay
; Bytes    : file 0x040170..0x0402E1  (369 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040170  C8 01 00 00           ENTER  1, 0 ; PROLOGUE
040174  48                    DEC    ax ; ARITH
040175  05 00 00              ADD    ax, 0 ; ARITH
040178  A6                    CMPSB  byte ptr [si], byte ptr es:[di] ; STR
040179  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
04017B  00 A7 0E 00           ADD    byte ptr [bx + 0xe], ah ; ARITH
04017F  00 23                 ADD    byte ptr [bp + di], ah ; ARITH
040181  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
040183  00 EE                 ADD    dh, ch ; ARITH
040185  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
040187  00 08                 ADD    byte ptr [bx + si], cl ; ARITH
040189  11 00                 ADC    word ptr [bx + si], ax ; ARITH
04018B  00 93 11 00           ADD    byte ptr [bp + di + 0x11], dl ; ARITH
04018F  00 58 13              ADD    byte ptr [bx + si + 0x13], bl ; ARITH
040192  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040194  3B 0D                 CMP    cx, word ptr [di] ; CMP
040196  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040198  87 0E 00 00           XCHG   word ptr [0], cx ; MOV
04019C  25 10 00              AND    ax, 0x10 ; LOGIC
04019F  00 82 12 00           ADD    byte ptr [bp + si + 0x12], al ; ARITH
0401A3  00 6B 13              ADD    byte ptr [bp + di + 0x13], ch ; ARITH
0401A6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0401A8  60                    PUSHAW                              ; UNKNOWN
0401A9  11 00                 ADC    word ptr [bx + si], ax ; ARITH
0401AB  00 12                 ADD    byte ptr [bp + si], dl ; ARITH
0401AD  13 00                 ADC    ax, word ptr [bx + si] ; ARITH
0401AF  00 EA                 ADD    dl, ch ; ARITH
0401B1  11 00                 ADC    word ptr [bx + si], ax ; ARITH
0401B3  00 88 0F 00           ADD    byte ptr [bx + si + 0xf], cl ; ARITH
0401B7  00 2E 09 00           ADD    byte ptr [9], ch ; ARITH
0401BB  00 F5                 ADD    ch, dh ; ARITH
0401BD  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0401BF  00 46 01              ADD    byte ptr [bp + 1], al ; ARITH
0401C2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0401C4  82 06 00 00 36        ADD    byte ptr [0], 0x36 ; ARITH
0401C9  04 00                 ADD    al, 0 ; ARITH
0401CB  00 53 09              ADD    byte ptr [bp + di + 9], dl ; ARITH
0401CE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0401D0  5B                    POP    bx ; STACK_POP
0401D1  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
0401D3  00 0E 0C 00           ADD    byte ptr [0xc], cl ; ARITH
0401D7  00 91 03 00           ADD    byte ptr [bx + di + 3], dl ; ARITH
0401DB  00 A2 01 00           ADD    byte ptr [bp + si + 1], ah ; ARITH
0401DF  00 E0                 ADD    al, ah ; ARITH
0401E1  10 00                 ADC    byte ptr [bx + si], al ; ARITH
0401E3  00 4D 0F              ADD    byte ptr [di + 0xf], cl ; ARITH
0401E6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0401E8  F7 0B 00 00           TEST   word ptr [bp + di], 0 ; LOGIC
0401EC  75 0D                 JNE    0x401fb ; CJUMP
0401EE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0401F0  64 02 00              ADD    al, byte ptr fs:[bx + si] ; ARITH
0401F3  00 91 05 00           ADD    byte ptr [bx + di + 5], dl ; ARITH
0401F7  00 EA                 ADD    dl, ch ; ARITH
0401F9  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
0401FB  00 4E 08              ADD    byte ptr [bp + 8], cl ; ARITH
0401FE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040200  0B 0D                 OR     cx, word ptr [di] ; LOGIC
040202  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040204  7F 0B                 JG     0x40211 ; CJUMP
040206  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040208  58                    POP    ax ; STACK_POP
040209  0F 00 00              SLDT   word ptr [bx + si]           ; UNKNOWN
04020C  00 0D                 ADD    byte ptr [di], cl ; ARITH
04020E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040210  12 03                 ADC    al, byte ptr [bp + di] ; ARITH
040212  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040214  3B 02                 CMP    ax, word ptr [bp + si] ; CMP
040216  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040218  AD                    LODSW  ax, word ptr [si] ; STR
040219  06                    PUSH   es ; STACK_PUSH
04021A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04021C  6A 04                 PUSH   4 ; STACK_PUSH
04021E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040220  9E                    SAHF ; FLAG
040221  09 00                 OR     word ptr [bx + si], ax ; LOGIC
040223  00 9E 00 00           ADD    byte ptr [bp], bl ; ARITH
040227  00 76 00              ADD    byte ptr [bp], dh ; ARITH
04022A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04022C  2E 00 00              ADD    byte ptr cs:[bx + si], al ; ARITH
04022F  00 0D                 ADD    byte ptr [di], cl ; ARITH
040231  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040233  00 FF                 ADD    bh, bh ; ARITH
040235  08 00                 OR     byte ptr [bx + si], al ; LOGIC
040237  00 9F 08 00           ADD    byte ptr [bx + 8], bl ; ARITH
04023B  00 9E 10 00           ADD    byte ptr [bp + 0x10], bl ; ARITH
04023F  00 34                 ADD    byte ptr [si], dh ; ARITH
040241  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
040243  00 66 10              ADD    byte ptr [bp + 0x10], ah ; ARITH
040246  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040248  3D 00 00              CMP    ax, 0 ; CMP
04024B  00 41 10              ADD    byte ptr [bx + di + 0x10], al ; ARITH
04024E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040250  A8 0F                 TEST   al, 0xf ; LOGIC
040252  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040254  16                    PUSH   ss ; STACK_PUSH
040255  0D 00 00              OR     ax, 0 ; LOGIC
040258  AA                    STOSB  byte ptr es:[di], al ; STR
040259  0C 00                 OR     al, 0 ; LOGIC
04025B  00 4A 11              ADD    byte ptr [bp + si + 0x11], cl ; ARITH
04025E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040260  FD                    STD ; FLAG
040261  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
040263  00 23                 ADD    byte ptr [bp + di], ah ; ARITH
040265  0E                    PUSH   cs ; STACK_PUSH
040266  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040268  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
040269  0D 00 00              OR     ax, 0 ; LOGIC
04026C  20 0D                 AND    byte ptr [di], cl ; LOGIC
04026E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040270  70 08                 JO     0x4027a ; CJUMP
040272  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040274  2D 11 00              SUB    ax, 0x11 ; ARITH
040277  00 01                 ADD    byte ptr [bx + di], al ; ARITH
040279  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
04027B  00 6D 05              ADD    byte ptr [di + 5], ch ; ARITH
04027E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040280  53                    PUSH   bx ; STACK_PUSH
040281  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
040283  00 AF 07 00           ADD    byte ptr [bx + 7], ch ; ARITH
040287  00 38                 ADD    byte ptr [bx + si], bh ; ARITH
040289  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
04028B  00 6C 11              ADD    byte ptr [si + 0x11], ch ; ARITH
04028E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
040290  4A                    DEC    dx ; ARITH
040291  13 00                 ADC    ax, word ptr [bx + si] ; ARITH
040293  00 1E 13 00           ADD    byte ptr [0x13], bl ; ARITH
040297  00 76 11              ADD    byte ptr [bp + 0x11], dh ; ARITH
04029A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04029C  54                    PUSH   sp ; STACK_PUSH
04029D  11 00                 ADC    word ptr [bx + si], ax ; ARITH
04029F  00 28                 ADD    byte ptr [bx + si], ch ; ARITH
0402A1  13 00                 ADC    ax, word ptr [bx + si] ; ARITH
0402A3  00 07                 ADD    byte ptr [bx], al ; ARITH
0402A5  13 00                 ADC    ax, word ptr [bx + si] ; ARITH
0402A7  00 DF                 ADD    bh, bl ; ARITH
0402A9  0D 00 00              OR     ax, 0 ; LOGIC
0402AC  59                    POP    cx ; STACK_POP
0402AD  07                    POP    es ; STACK_POP
0402AE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0402B0  11 05                 ADC    word ptr [di], ax ; ARITH
0402B2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0402B4  DF 02                 FILD   word ptr [bp + si]           ; UNKNOWN
0402B6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0402B8  E5 05                 IN     ax, 5 ; IO
0402BA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0402BC  6C                    INSB   byte ptr es:[di], dx ; IO
0402BD  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0402BF  00 4C 09              ADD    byte ptr [si + 9], cl ; ARITH
0402C2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0402C4  2D 01 00              SUB    ax, 1 ; ARITH
0402C7  00 D9                 ADD    cl, bl ; ARITH
0402C9  01 00                 ADD    word ptr [bx + si], ax ; ARITH
0402CB  00 9B 07 00           ADD    byte ptr [bp + di + 7], bl ; ARITH
0402CF  00 02                 ADD    byte ptr [bp + si], al ; ARITH
0402D1  0E                    PUSH   cs ; STACK_PUSH
0402D2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0402D4  BF 0A 00              MOV    di, 0xa ; CONST_LOAD
0402D7  00 1A                 ADD    byte ptr [bp + si], bl ; ARITH
0402D9  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
0402DB  00 DB                 ADD    bl, bl ; ARITH
0402DD  08 00                 OR     byte ptr [bx + si], al ; LOGIC
0402DF  00 CF                 ADD    bh, cl ; ARITH
