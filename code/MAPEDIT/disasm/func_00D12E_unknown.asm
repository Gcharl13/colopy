; ============================================================================
; func_00D12E_unknown
; Region   : load_image
; Bytes    : file 0x00D12E..0x00D198  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D12E  55                    PUSH   bp ; STACK_PUSH
00D12F  8B EC                 MOV    bp, sp ; MOV
00D131  50                    PUSH   ax ; STACK_PUSH
00D132  8B D0                 MOV    dx, ax ; MOV
00D134  2D 10 01              SUB    ax, 0x110 ; ARITH
00D137  3D 22 00              CMP    ax, 0x22 ; CMP
00D13A  77 4E                 JA     0xd18a ; CJUMP
00D13C  D1 E0                 SHL    ax, 1 ; LOGIC
00D13E  93                    XCHG   bx, ax ; MOV
00D13F  2E FF A7 24 00        JMP    word ptr cs:[bx + 0x24] ; JUMP
00D144  82 00 88              ADD    byte ptr [bx + si], 0x88 ; ARITH
00D147  00 8E 00 94           ADD    byte ptr [bp - 0x6c00], cl ; ARITH
00D14B  00 9C 00 A2           ADD    byte ptr [si - 0x5e00], bl ; ARITH
00D14F  00 A8 00 AE           ADD    byte ptr [bx + si - 0x5200], ch ; ARITH
00D153  00 B4 00 BA           ADD    byte ptr [si - 0x4600], dh ; ARITH
00D157  00 6A 00              ADD    byte ptr [bp + si], ch ; ARITH
00D15A  6A 00                 PUSH   0 ; STACK_PUSH
00D15C  6A 00                 PUSH   0 ; STACK_PUSH
00D15E  6A 00                 PUSH   0 ; STACK_PUSH
00D160  C0 00 C6              ROL    byte ptr [bx + si], 0xc6 ; LOGIC
00D163  00 CC                 ADD    ah, cl ; ARITH
00D165  00 D2                 ADD    dl, dl ; ARITH
00D167  00 D8                 ADD    al, bl ; ARITH
00D169  00 DE                 ADD    dh, bl ; ARITH
00D16B  00 E4                 ADD    ah, ah ; ARITH
00D16D  00 EA                 ADD    dl, ch ; ARITH
00D16F  00 F0                 ADD    al, dh ; ARITH
00D171  00 6A 00              ADD    byte ptr [bp + si], ch ; ARITH
00D174  6A 00                 PUSH   0 ; STACK_PUSH
00D176  6A 00                 PUSH   0 ; STACK_PUSH
00D178  6A 00                 PUSH   0 ; STACK_PUSH
00D17A  6A 00                 PUSH   0 ; STACK_PUSH
00D17C  F6 00 FC              TEST   byte ptr [bx + si], 0xfc ; LOGIC
00D17F  00 02                 ADD    byte ptr [bp + si], al ; ARITH
00D181  01 08                 ADD    word ptr [bx + si], cx ; ARITH
00D183  01 0E 01 14           ADD    word ptr [0x1401], cx ; ARITH
00D187  01 1A                 ADD    word ptr [bp + si], bx ; ARITH
00D189  01 83 FA 61           ADD    word ptr [bp + di + 0x61fa], ax ; ARITH
00D18D  7C 0D                 JL     0xd19c ; CJUMP
00D18F  83 FA 7A              CMP    dx, 0x7a ; CMP
00D192  7F 08                 JG     0xd19c ; CJUMP
00D194  8B C2                 MOV    ax, dx ; MOV
00D196  2D                    DB     0x2D ; DATA_BYTE
00D197  20                    DB     0x20 ; DATA_BYTE
