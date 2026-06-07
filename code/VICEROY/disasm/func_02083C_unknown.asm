; ============================================================================
; func_02083C_unknown
; Region   : overlay
; Bytes    : file 0x02083C..0x020918  (220 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02083C  C8 1E 00 00           ENTER  0x1e, 0 ; PROLOGUE
020840  AA                    STOSB  byte ptr es:[di], al ; STR
020841  1E                    PUSH   ds ; STACK_PUSH
020842  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020844  5E                    POP    si ; STACK_POP
020845  24 00                 AND    al, 0 ; LOGIC
020847  00 51 08              ADD    byte ptr [bx + di + 8], dl ; ARITH
02084A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02084C  1C 08                 SBB    al, 8 ; ARITH
02084E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020850  EE                    OUT    dx, al ; IO
020851  07                    POP    es ; STACK_POP
020852  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020854  89 10                 MOV    word ptr [bx + si], dx ; MOV
020856  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020858  2F                    DAS ; ARITH
020859  34 00                 XOR    al, 0 ; LOGIC
02085B  00 DA                 ADD    dl, bl ; ARITH
02085D  32 00                 XOR    al, byte ptr [bx + si] ; LOGIC
02085F  00 53 34              ADD    byte ptr [bp + di + 0x34], dl ; ARITH
020862  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020864  D5 29                 AAD    0x29 ; ARITH
020866  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020868  5D                    POP    bp ; STACK_POP
020869  2A 00                 SUB    al, byte ptr [bx + si] ; ARITH
02086B  00 13                 ADD    byte ptr [bp + di], dl ; ARITH
02086D  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
02086F  00 45 18              ADD    byte ptr [di + 0x18], al ; ARITH
020872  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020874  1E                    PUSH   ds ; STACK_PUSH
020875  1D 00 00              SBB    ax, 0 ; ARITH
020878  DC 11                 FCOM   qword ptr [bx + di]          ; UNKNOWN
02087A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02087C  65 2D 00 00           SUB    ax, 0 ; ARITH
020880  8A 19                 MOV    bl, byte ptr [bx + di] ; MOV
020882  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020884  00 1A                 ADD    byte ptr [bp + si], bl ; ARITH
020886  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020888  74 08                 JE     0x20892 ; CJUMP
02088A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
02088C  D8 1A                 FCOMP  dword ptr [bp + si]          ; UNKNOWN
02088E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020890  D5 20                 AAD    0x20 ; ARITH
020892  00 00                 ADD    byte ptr [bx + si], al ; ARITH
020894  B8 27 00              MOV    ax, 0x27 ; CONST_LOAD
020897  00 36 31 00           ADD    byte ptr [0x31], dh ; ARITH
02089B  00 D7                 ADD    bh, dl ; ARITH
02089D  36 00 00              ADD    byte ptr ss:[bx + si], al ; ARITH
0208A0  4D                    DEC    bp ; ARITH
0208A1  37                    AAA ; ARITH
0208A2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0208A4  5B                    POP    bx ; STACK_POP
0208A5  39 00                 CMP    word ptr [bx + si], ax ; CMP
0208A7  00 A2 29 00           ADD    byte ptr [bp + si + 0x29], ah ; ARITH
0208AB  00 1C                 ADD    byte ptr [si], bl ; ARITH
0208AD  28 00                 SUB    byte ptr [bx + si], al ; ARITH
0208AF  00 D5                 ADD    ch, dl ; ARITH
0208B1  1F                    POP    ds ; STACK_POP
0208B2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0208B4  17                    POP    ss ; STACK_POP
0208B5  2A 00                 SUB    al, byte ptr [bx + si] ; ARITH
0208B7  00 0D                 ADD    byte ptr [di], cl ; ARITH
0208B9  1A 00                 SBB    al, byte ptr [bx + si] ; ARITH
0208BB  00 23                 ADD    byte ptr [bp + di], ah ; ARITH
0208BD  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
0208BF  00 29                 ADD    byte ptr [bx + di], ch ; ARITH
0208C1  15 00 00              ADC    ax, 0 ; ARITH
0208C4  3E 13 00              ADC    ax, word ptr ds:[bx + si] ; ARITH
0208C7  00 B5 04 00           ADD    byte ptr [di + 4], dh ; ARITH
0208CB  00 63 11              ADD    byte ptr [bp + di + 0x11], ah ; ARITH
0208CE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0208D0  01 15                 ADD    word ptr [di], dx ; ARITH
0208D2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0208D4  F8                    CLC ; FLAG
0208D5  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
0208D7  00 55 07              ADD    byte ptr [di + 7], dl ; ARITH
0208DA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0208DC  BD 07 00              MOV    bp, 7 ; MOV
0208DF  00 0E 3D 00           ADD    byte ptr [0x3d], cl ; ARITH
0208E3  00 09                 ADD    byte ptr [bx + di], cl ; ARITH
0208E5  3D 00 00              CMP    ax, 0 ; CMP
0208E8  04 3D                 ADD    al, 0x3d ; ARITH
0208EA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0208EC  FF                    DB     0xFF ; DATA_BYTE
0208ED  3C                    DB     0x3C ; DATA_BYTE
0208EE  00                    DB     0x00 ; DATA_BYTE
0208EF  00                    DB     0x00 ; DATA_BYTE
0208F0  FA                    DB     0xFA ; DATA_BYTE
0208F1  3C                    DB     0x3C ; DATA_BYTE
0208F2  00                    DB     0x00 ; DATA_BYTE
0208F3  00                    DB     0x00 ; DATA_BYTE
0208F4  F5                    DB     0xF5 ; DATA_BYTE
0208F5  3C                    DB     0x3C ; DATA_BYTE
0208F6  00                    DB     0x00 ; DATA_BYTE
0208F7  00                    DB     0x00 ; DATA_BYTE
0208F8  F0                    DB     0xF0 ; DATA_BYTE
0208F9  3C                    DB     0x3C ; DATA_BYTE
0208FA  00                    DB     0x00 ; DATA_BYTE
0208FB  00                    DB     0x00 ; DATA_BYTE
0208FC  EB                    DB     0xEB ; DATA_BYTE
0208FD  3C                    DB     0x3C ; DATA_BYTE
0208FE  00                    DB     0x00 ; DATA_BYTE
0208FF  00                    DB     0x00 ; DATA_BYTE
020900  E6                    DB     0xE6 ; DATA_BYTE
020901  3C                    DB     0x3C ; DATA_BYTE
020902  00                    DB     0x00 ; DATA_BYTE
020903  00                    DB     0x00 ; DATA_BYTE
020904  E1                    DB     0xE1 ; DATA_BYTE
020905  3C                    DB     0x3C ; DATA_BYTE
020906  00                    DB     0x00 ; DATA_BYTE
020907  00                    DB     0x00 ; DATA_BYTE
020908  DC                    DB     0xDC ; DATA_BYTE
020909  3C                    DB     0x3C ; DATA_BYTE
02090A  00                    DB     0x00 ; DATA_BYTE
02090B  00                    DB     0x00 ; DATA_BYTE
02090C  D7                    DB     0xD7 ; DATA_BYTE
02090D  3C                    DB     0x3C ; DATA_BYTE
02090E  00                    DB     0x00 ; DATA_BYTE
02090F  00                    DB     0x00 ; DATA_BYTE
020910  D2                    DB     0xD2 ; DATA_BYTE
020911  3C                    DB     0x3C ; DATA_BYTE
020912  00                    DB     0x00 ; DATA_BYTE
020913  00                    DB     0x00 ; DATA_BYTE
020914  CD                    DB     0xCD ; DATA_BYTE
020915  3C                    DB     0x3C ; DATA_BYTE
020916  00                    DB     0x00 ; DATA_BYTE
020917  00                    DB     0x00 ; DATA_BYTE
