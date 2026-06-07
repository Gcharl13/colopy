; ============================================================================
; func_00D2AC_unknown
; Region   : load_image
; Bytes    : file 0x00D2AC..0x00D2E5  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D2AC  55                    PUSH   bp ; STACK_PUSH
00D2AD  8B EC                 MOV    bp, sp ; MOV
00D2AF  50                    PUSH   ax ; STACK_PUSH
00D2B0  8B D0                 MOV    dx, ax ; MOV
00D2B2  2D 10 01              SUB    ax, 0x110 ; ARITH
00D2B5  3D 22 00              CMP    ax, 0x22 ; CMP
00D2B8  77 4E                 JA     0xd308 ; CJUMP
00D2BA  D1 E0                 SHL    ax, 1 ; LOGIC
00D2BC  93                    XCHG   bx, ax ; MOV
00D2BD  2E FF A7 22 00        JMP    word ptr cs:[bx + 0x22] ; JUMP
00D2C2  80 00 86              ADD    byte ptr [bx + si], 0x86 ; ARITH
00D2C5  00 8C 00 92           ADD    byte ptr [si - 0x6e00], cl ; ARITH
00D2C9  00 9A 00 A0           ADD    byte ptr [bp + si - 0x6000], bl ; ARITH
00D2CD  00 A6 00 AC           ADD    byte ptr [bp - 0x5400], ah ; ARITH
00D2D1  00 B2 00 B8           ADD    byte ptr [bp + si - 0x4800], dh ; ARITH
00D2D5  00 68 00              ADD    byte ptr [bx + si], ch ; ARITH
00D2D8  68 00 68              PUSH   0x6800 ; PUSH_CONST
00D2DB  00 68 00              ADD    byte ptr [bx + si], ch ; ARITH
00D2DE  BE 00 C4              MOV    si, 0xc400 ; CONST_LOAD
00D2E1  00 CA                 ADD    dl, cl ; ARITH
00D2E3  00 D0                 ADD    al, dl ; ARITH
