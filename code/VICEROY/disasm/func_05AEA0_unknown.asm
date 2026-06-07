; ============================================================================
; func_05AEA0_unknown
; Region   : overlay
; Bytes    : file 0x05AEA0..0x05AF2C  (140 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05AEA0  C8 32 00 00           ENTER  0x32, 0 ; PROLOGUE
05AEA4  F1                    INT1                                ; UNKNOWN
05AEA5  34 00                 XOR    al, 0 ; LOGIC
05AEA7  00 BB 34 00           ADD    byte ptr [bp + di + 0x34], bh ; ARITH
05AEAB  00 89 34 00           ADD    byte ptr [bx + di + 0x34], cl ; ARITH
05AEAF  00 3F                 ADD    byte ptr [bx], bh ; ARITH
05AEB1  34 00                 XOR    al, 0 ; LOGIC
05AEB3  00 22                 ADD    byte ptr [bp + si], ah ; ARITH
05AEB5  34 00                 XOR    al, 0 ; LOGIC
05AEB7  00 AE 0E 00           ADD    byte ptr [bp + 0xe], ch ; ARITH
05AEBB  00 05                 ADD    byte ptr [di], al ; ARITH
05AEBD  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
05AEBF  00 EC                 ADD    ah, ch ; ARITH
05AEC1  22 00                 AND    al, byte ptr [bx + si] ; LOGIC
05AEC3  00 56 1C              ADD    byte ptr [bp + 0x1c], dl ; ARITH
05AEC6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AEC8  BB 23 00              MOV    bx, 0x23 ; CONST_LOAD
05AECB  00 F2                 ADD    dl, dh ; ARITH
05AECD  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
05AECF  00 B7 1B 00           ADD    byte ptr [bx + 0x1b], dh ; ARITH
05AED3  00 93 28 00           ADD    byte ptr [bp + di + 0x28], dl ; ARITH
05AED7  00 97 27 00           ADD    byte ptr [bx + 0x27], dl ; ARITH
05AEDB  00 69 26              ADD    byte ptr [bx + di + 0x26], ch ; ARITH
05AEDE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AEE0  FD                    STD ; FLAG
05AEE1  2B 00                 SUB    ax, word ptr [bx + si] ; ARITH
05AEE3  00 E7                 ADD    bh, ah ; ARITH
05AEE5  2B 00                 SUB    ax, word ptr [bx + si] ; ARITH
05AEE7  00 C5                 ADD    ch, al ; ARITH
05AEE9  2D 00 00              SUB    ax, 0 ; ARITH
05AEEC  07                    POP    es ; STACK_POP
05AEED  37                    AAA ; ARITH
05AEEE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AEF0  56                    PUSH   si ; STACK_PUSH
05AEF1  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AEF3  00 CC                 ADD    ah, cl ; ARITH
05AEF5  04 00                 ADD    al, 0 ; ARITH
05AEF7  00 0B                 ADD    byte ptr [bp + di], cl ; ARITH
05AEF9  04 00                 ADD    al, 0 ; ARITH
05AEFB  00 E8                 ADD    al, ch ; ARITH
05AEFD  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
05AEFF  00 AB 1C 00           ADD    byte ptr [bp + di + 0x1c], ch ; ARITH
05AF03  00 8A 24 00           ADD    byte ptr [bp + si + 0x24], cl ; ARITH
05AF07  00 E2                 ADD    dl, ah ; ARITH
05AF09  28 00                 SUB    byte ptr [bx + si], al ; ARITH
05AF0B  00 AB 28 00           ADD    byte ptr [bp + di + 0x28], ch ; ARITH
05AF0F  00 68 2C              ADD    byte ptr [bx + si + 0x2c], ch ; ARITH
05AF12  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF14  59                    POP    cx ; STACK_POP
05AF15  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
05AF17  00 5E 15              ADD    byte ptr [bp + 0x15], bl ; ARITH
05AF1A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF1C  6E                    OUTSB  dx, byte ptr [si] ; IO
05AF1D  0F 00 00              SLDT   word ptr [bx + si]           ; UNKNOWN
05AF20  5F                    POP    di ; STACK_POP
05AF21  2D 00 00              SUB    ax, 0 ; ARITH
05AF24  03 02                 ADD    ax, word ptr [bp + si] ; ARITH
05AF26  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05AF28  2B 20                 SUB    sp, word ptr [bx + si] ; STACK_ALLOC
05AF2A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
