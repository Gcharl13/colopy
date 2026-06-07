; ============================================================================
; func_04BDA4_unknown
; Region   : overlay
; Bytes    : file 0x04BDA4..0x04BE53  (175 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04BDA4  C8 70 00 00           ENTER  0x70, 0 ; PROLOGUE
04BDA8  6B 0A 00              IMUL   cx, word ptr [bp + si], 0 ; ARITH
04BDAB  00 ED                 ADD    ch, ch ; ARITH
04BDAD  30 00                 XOR    byte ptr [bx + si], al ; LOGIC
04BDAF  00 2A                 ADD    byte ptr [bp + si], ch ; ARITH
04BDB1  5D                    POP    bp ; STACK_POP
04BDB2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BDB4  B7 6D                 MOV    bh, 0x6d ; CONST_LOAD
04BDB6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BDB8  0E                    PUSH   cs ; STACK_PUSH
04BDB9  23 00                 AND    ax, word ptr [bx + si] ; LOGIC
04BDBB  00 F1                 ADD    cl, dh ; ARITH
04BDBD  4F                    DEC    di ; ARITH
04BDBE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BDC0  23 4F 00              AND    cx, word ptr [bx] ; LOGIC
04BDC3  00 1A                 ADD    byte ptr [bp + si], bl ; ARITH
04BDC5  72 00                 JB     0x4bdc7 ; CJUMP
04BDC7  00 0F                 ADD    byte ptr [bx], cl ; ARITH
04BDC9  72 00                 JB     0x4bdcb ; CJUMP
04BDCB  00 97 47 00           ADD    byte ptr [bx + 0x47], dl ; ARITH
04BDCF  00 83 47 00           ADD    byte ptr [bp + di + 0x47], al ; ARITH
04BDD3  00 69 15              ADD    byte ptr [bx + di + 0x15], ch ; ARITH
04BDD6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BDD8  23 33                 AND    si, word ptr [bp + di] ; LOGIC
04BDDA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BDDC  A8 42                 TEST   al, 0x42 ; LOGIC
04BDDE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BDE0  78 42                 JS     0x4be24 ; CJUMP
04BDE2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BDE4  C0 6E 00 00           SHR    byte ptr [bp], 0 ; LOGIC
04BDE8  AD                    LODSW  ax, word ptr [si] ; STR
04BDE9  35 00 00              XOR    ax, 0 ; LOGIC
04BDEC  92                    XCHG   dx, ax ; MOV
04BDED  6B 00 00              IMUL   ax, word ptr [bx + si], 0 ; ARITH
04BDF0  D5 6E                 AAD    0x6e ; ARITH
04BDF2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BDF4  5E                    POP    si ; STACK_POP
04BDF5  28 00                 SUB    byte ptr [bx + si], al ; ARITH
04BDF7  00 FF                 ADD    bh, bh ; ARITH
04BDF9  28 00                 SUB    byte ptr [bx + si], al ; ARITH
04BDFB  00 FA                 ADD    dl, bh ; ARITH
04BDFD  6B 00 00              IMUL   ax, word ptr [bx + si], 0 ; ARITH
04BE00  C9                    LEAVE ; EPILOGUE
04BE01  6D                    INSW   word ptr es:[di], dx ; IO
04BE02  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BE04  EC                    IN     al, dx ; IO
04BE05  5B                    POP    bx ; STACK_POP
04BE06  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BE08  04 0F                 ADD    al, 0xf ; ARITH
04BE0A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BE0C  DA 1C                 FICOMP dword ptr [si]               ; UNKNOWN
04BE0E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BE10  DC 27                 FSUB   qword ptr [bx]               ; UNKNOWN
04BE12  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BE14  DD 26 00 00           FRSTOR dword ptr [0]                ; UNKNOWN
04BE18  60                    PUSHAW                              ; UNKNOWN
04BE19  25 00 00              AND    ax, 0 ; LOGIC
04BE1C  BB 2B 00              MOV    bx, 0x2b ; CONST_LOAD
04BE1F  00 C1                 ADD    cl, al ; ARITH
04BE21  2F                    DAS ; ARITH
04BE22  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BE24  BB 2E 00              MOV    bx, 0x2e ; CONST_LOAD
04BE27  00 E1                 ADD    cl, ah ; ARITH
04BE29  30 00                 XOR    byte ptr [bx + si], al ; LOGIC
04BE2B  00 36 3E 00           ADD    byte ptr [0x3e], dh ; ARITH
04BE2F  00 35                 ADD    byte ptr [di], dh ; ARITH
04BE31  42                    INC    dx ; ARITH
04BE32  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BE34  33 45 00              XOR    ax, word ptr [di] ; LOGIC
04BE37  00 2E 44 00           ADD    byte ptr [0x44], ch ; ARITH
04BE3B  00 CC                 ADD    ah, cl ; ARITH
04BE3D  42                    INC    dx ; ARITH
04BE3E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BE40  04 47                 ADD    al, 0x47 ; ARITH
04BE42  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BE44  A2 4C 00              MOV    byte ptr [0x4c], al ; GLOBAL_LOAD
04BE47  00 D6                 ADD    dh, dl ; ARITH
04BE49  4B                    DEC    bx ; ARITH
04BE4A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04BE4C  35 4A 00              XOR    ax, 0x4a ; LOGIC
04BE4F  00 CA                 ADD    dl, cl ; ARITH
04BE51  50                    PUSH   ax ; STACK_PUSH
04BE52  00                    DB     0x00 ; DATA_BYTE
