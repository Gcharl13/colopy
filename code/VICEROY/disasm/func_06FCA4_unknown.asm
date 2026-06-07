; ============================================================================
; func_06FCA4_unknown
; Region   : overlay
; Bytes    : file 0x06FCA4..0x06FD67  (195 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06FCA4  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
06FCA8  8B 09                 MOV    cx, word ptr [bx + di] ; MOV
06FCAA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FCAC  F6 07 00              TEST   byte ptr [bx], 0 ; LOGIC
06FCAF  00 45 0E              ADD    byte ptr [di + 0xe], al ; ARITH
06FCB2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FCB4  98                    CWDE ; ARITH
06FCB5  0C 00                 OR     al, 0 ; LOGIC
06FCB7  00 F6                 ADD    dh, dh ; ARITH
06FCB9  05 00 00              ADD    ax, 0 ; ARITH
06FCBC  85 0A                 TEST   word ptr [bp + si], cx ; LOGIC
06FCBE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FCC0  15 03 00              ADC    ax, 3 ; ARITH
06FCC3  00 56 08              ADD    byte ptr [bp + 8], dl ; ARITH
06FCC6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FCC8  F8                    CLC ; FLAG
06FCC9  0C 00                 OR     al, 0 ; LOGIC
06FCCB  00 14                 ADD    byte ptr [si], dl ; ARITH
06FCCD  07                    POP    es ; STACK_POP
06FCCE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FCD0  F1                    INT1                                ; UNKNOWN
06FCD1  06                    PUSH   es ; STACK_PUSH
06FCD2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FCD4  AD                    LODSW  ax, word ptr [si] ; STR
06FCD5  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
06FCD7  00 8A 0B 00           ADD    byte ptr [bp + si + 0xb], cl ; ARITH
06FCDB  00 F8                 ADD    al, bh ; ARITH
06FCDD  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FCDF  00 05                 ADD    byte ptr [di], al ; ARITH
06FCE1  06                    PUSH   es ; STACK_PUSH
06FCE2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FCE4  94                    XCHG   sp, ax ; MOV
06FCE5  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
06FCE7  00 0A                 ADD    byte ptr [bp + si], cl ; ARITH
06FCE9  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
06FCEB  00 4B 08              ADD    byte ptr [bp + di + 8], cl ; ARITH
06FCEE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FCF0  ED                    IN     ax, dx ; IO
06FCF1  0C 00                 OR     al, 0 ; LOGIC
06FCF3  00 1E 03 00           ADD    byte ptr [3], bl ; ARITH
06FCF7  00 5F 08              ADD    byte ptr [bx + 8], bl ; ARITH
06FCFA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FCFC  01 0D                 ADD    word ptr [di], cx ; ARITH
06FCFE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
06FD00  36 02 E7              ADD    ah, bh ; ARITH
06FD03  00 20                 ADD    byte ptr [bx + si], ah ; ARITH
06FD05  02 E7                 ADD    ah, bh ; ARITH
06FD07  00 0A                 ADD    byte ptr [bp + si], cl ; ARITH
06FD09  02 E7                 ADD    ah, bh ; ARITH
06FD0B  00 F4                 ADD    ah, dh ; ARITH
06FD0D  01 E7                 ADD    di, sp ; ARITH
06FD0F  00 DE                 ADD    dh, bl ; ARITH
06FD11  01 E7                 ADD    di, sp ; ARITH
06FD13  00 C8                 ADD    al, cl ; ARITH
06FD15  01 E7                 ADD    di, sp ; ARITH
06FD17  00 AF 01 E7           ADD    byte ptr [bx - 0x18ff], ch ; ARITH
06FD1B  00 3E 03 E7           ADD    byte ptr [0xe703], bh ; ARITH
06FD1F  00 39                 ADD    byte ptr [bx + di], bh ; ARITH
06FD21  03 E7                 ADD    sp, di ; STACK_CLEANUP
06FD23  00 34                 ADD    byte ptr [si], dh ; ARITH
06FD25  03 E7                 ADD    sp, di ; STACK_CLEANUP
06FD27  00 2F                 ADD    byte ptr [bx], ch ; ARITH
06FD29  03 E7                 ADD    sp, di ; STACK_CLEANUP
06FD2B  00 73 02              ADD    byte ptr [bp + di + 2], dh ; ARITH
06FD2E  E7 00                 OUT    0, ax ; IO
06FD30  52                    PUSH   dx ; STACK_PUSH
06FD31  02 E7                 ADD    ah, bh ; ARITH
06FD33  00 47 02              ADD    byte ptr [bx + 2], al ; ARITH
06FD36  E7 00                 OUT    0, ax ; IO
06FD38  95                    XCHG   bp, ax ; MOV
06FD39  01 E7                 ADD    di, sp ; ARITH
06FD3B  00 92 02 E7           ADD    byte ptr [bp + si - 0x18fe], dl ; ARITH
06FD3F  00 83 02 E7           ADD    byte ptr [bp + di - 0x18fe], al ; ARITH
06FD43  00 07                 ADD    byte ptr [bx], al ; ARITH
06FD45  03 E7                 ADD    sp, di ; STACK_CLEANUP
06FD47  00 10                 ADD    byte ptr [bx + si], dl ; ARITH
06FD49  01 E7                 ADD    di, sp ; ARITH
06FD4B  00 DA                 ADD    dl, bl ; ARITH
06FD4D  00 E7                 ADD    bh, ah ; ARITH
06FD4F  00 22                 ADD    byte ptr [bp + si], ah ; ARITH
06FD51  03 E7                 ADD    sp, di ; STACK_CLEANUP
06FD53  00 0F                 ADD    byte ptr [bx], cl ; ARITH
06FD55  03 E7                 ADD    sp, di ; STACK_CLEANUP
06FD57  00 6E 02              ADD    byte ptr [bp + 2], ch ; ARITH
06FD5A  E7 00                 OUT    0, ax ; IO
06FD5C  2B 01                 SUB    ax, word ptr [bx + di] ; ARITH
06FD5E  E7 00                 OUT    0, ax ; IO
06FD60  EC                    IN     al, dx ; IO
06FD61  02 E7                 ADD    ah, bh ; ARITH
06FD63  00 CA                 ADD    dl, cl ; ARITH
06FD65  01 1B                 ADD    word ptr [bp + di], bx ; ARITH
