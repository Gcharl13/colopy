; ============================================================================
; func_03B3B8_unknown
; Region   : overlay
; Bytes    : file 0x03B3B8..0x03B777  (959 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03B3B8  C8 01 00 00           ENTER  1, 0 ; PROLOGUE
03B3BC  F7 00 00 00           TEST   word ptr [bx + si], 0 ; LOGIC
03B3C0  99                    CDQ ; ARITH
03B3C1  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B3C3  00 48 00              ADD    byte ptr [bx + si], cl ; ARITH
03B3C6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B3C8  0B 07                 OR     ax, word ptr [bx] ; LOGIC
03B3CA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B3CC  9A 07 00 00 0F        LCALL  0xf00, 7 ; LCALL
03B3D1  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
03B3D3  00 B2 03 00           ADD    byte ptr [bp + si + 3], dh ; ARITH
03B3D7  00 25                 ADD    byte ptr [di], ah ; ARITH
03B3D9  06                    PUSH   es ; STACK_PUSH
03B3DA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B3DC  31 04                 XOR    word ptr [si], ax ; LOGIC
03B3DE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B3E0  59                    POP    cx ; STACK_POP
03B3E1  09 00                 OR     word ptr [bx + si], ax ; LOGIC
03B3E3  00 70 02              ADD    byte ptr [bx + si + 2], dh ; ARITH
03B3E6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B3E8  1C 03                 SBB    al, 3 ; ARITH
03B3EA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B3EC  7F 02                 JG     0x3b3f0 ; CJUMP
03B3EE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B3F0  29 04                 SUB    word ptr [si], ax ; ARITH
03B3F2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B3F4  51                    PUSH   cx ; STACK_PUSH
03B3F5  09 00                 OR     word ptr [bx + si], ax ; LOGIC
03B3F7  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B3F9  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
03B3FB  00 56 01              ADD    byte ptr [bp + 1], dl ; ARITH
03B3FE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B400  77 0A                 JA     0x3b40c ; CJUMP
03B402  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B404  88 05                 MOV    byte ptr [di], al ; MOV
03B406  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B408  2E 05 00 00           ADD    ax, 0 ; ARITH
03B40C  ED                    IN     ax, dx ; IO
03B40D  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
03B40F  00 FF                 ADD    bh, bh ; ARITH
03B411  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
03B413  00 FA                 ADD    dl, bh ; ARITH
03B415  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
03B417  00 F5                 ADD    ch, dh ; ARITH
03B419  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
03B41B  00 02                 ADD    byte ptr [bp + si], al ; ARITH
03B41D  04 00                 ADD    al, 0 ; ARITH
03B41F  00 26 08 00           ADD    byte ptr [8], ah ; ARITH
03B423  00 74 06              ADD    byte ptr [si + 6], dh ; ARITH
03B426  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B428  C9                    LEAVE ; EPILOGUE
03B429  06                    PUSH   es ; STACK_PUSH
03B42A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B42C  38 08                 CMP    byte ptr [bx + si], cl ; CMP
03B42E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B430  38 01                 CMP    byte ptr [bx + di], al ; CMP
03B432  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B434  D5 08                 AAD    8 ; ARITH
03B436  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B438  B9 08 00              MOV    cx, 8 ; MOV
03B43B  00 91 08 00           ADD    byte ptr [bx + di + 8], dl ; ARITH
03B43F  00 A4 0A 00           ADD    byte ptr [si + 0xa], ah ; ARITH
03B443  00 98 0A 00           ADD    byte ptr [bx + si + 0xa], bl ; ARITH
03B447  00 39                 ADD    byte ptr [bx + di], bh ; ARITH
03B449  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
03B44B  00 7D 09              ADD    byte ptr [di + 9], bh ; ARITH
03B44E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B450  27                    DAA ; ARITH
03B451  09 00                 OR     word ptr [bx + si], ax ; LOGIC
03B453  00 53 03              ADD    byte ptr [bp + di + 3], dl ; ARITH
03B456  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B458  E5 06                 IN     ax, 6 ; IO
03B45A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B45C  2B 0A                 SUB    cx, word ptr [bp + si] ; ARITH
03B45E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B460  43                    INC    bx ; ARITH
03B461  01 00                 ADD    word ptr [bx + si], ax ; ARITH
03B463  00 C5                 ADD    ch, al ; ARITH
03B465  08 00                 OR     byte ptr [bx + si], al ; LOGIC
03B467  00 9D 08 00           ADD    byte ptr [di + 8], bl ; ARITH
03B46B  00 DB                 ADD    bl, bl ; ARITH
03B46D  01 00                 ADD    word ptr [bx + si], ax ; ARITH
03B46F  00 17                 ADD    byte ptr [bx], dl ; ARITH
03B471  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
03B473  00 81 03 00           ADD    byte ptr [bx + di + 3], al ; ARITH
03B477  00 F8                 ADD    al, bh ; ARITH
03B479  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
03B47B  00 E2                 ADD    dl, ah ; ARITH
03B47D  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
03B47F  00 10                 ADD    byte ptr [bx + si], dl ; ARITH
03B481  06                    PUSH   es ; STACK_PUSH
03B482  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B484  BF 06 00              MOV    di, 6 ; MOV
03B487  00 66 06              ADD    byte ptr [bp + 6], ah ; ARITH
03B48A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B48C  3C 06                 CMP    al, 6 ; CMP
03B48E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B490  5C                    POP    sp ; STACK_POP
03B491  04 00                 ADD    al, 0 ; ARITH
03B493  00 EE                 ADD    dh, ch ; ARITH
03B495  04 00                 ADD    al, 0 ; ARITH
03B497  00 08                 ADD    byte ptr [bx + si], cl ; ARITH
03B499  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
03B49B  00 14                 ADD    byte ptr [si], dl ; ARITH
03B49D  04 00                 ADD    al, 0 ; ARITH
03B49F  00 A9 08 00           ADD    byte ptr [bx + di + 8], ch ; ARITH
03B4A3  00 E9                 ADD    cl, ch ; ARITH
03B4A5  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
03B4A7  00 14                 ADD    byte ptr [si], dl ; ARITH
03B4A9  05 00 00              ADD    ax, 0 ; ARITH
03B4AC  F9                    STC ; FLAG
03B4AD  08 00                 OR     byte ptr [bx + si], al ; LOGIC
03B4AF  00 B8 02 00           ADD    byte ptr [bx + si + 2], bh ; ARITH
03B4B3  00 27                 ADD    byte ptr [bx], ah ; ARITH
03B4B5  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
03B4B7  00 8A 02 00           ADD    byte ptr [bp + si + 2], cl ; ARITH
03B4BB  00 DE                 ADD    dh, bl ; ARITH
03B4BD  07                    POP    es ; STACK_POP
03B4BE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B4C0  7A 04                 JP     0x3b4c6 ; CJUMP
03B4C2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
03B4C4  3D 03 00              CMP    ax, 3 ; CMP
03B4C7  00 D0                 ADD    al, dl ; ARITH
03B4C9  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
03B4CB  00 12                 ADD    byte ptr [bp + si], dl ; ARITH
03B4CD  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
03B4CF  00 F0                 ADD    al, dh ; ARITH
03B4D1  01 00                 ADD    word ptr [bx + si], ax ; ARITH
03B4D3  00 AF 04 00           ADD    byte ptr [bx + 4], ch ; ARITH
03B4D7  00 95 1F B2           ADD    byte ptr [di - 0x4de1], dl ; ARITH
03B4DB  00 DE                 ADD    dh, bl ; ARITH
03B4DD  24 B2                 AND    al, 0xb2 ; LOGIC
03B4DF  00 E3                 ADD    bl, ah ; ARITH
03B4E1  23 B2 00 04           AND    si, word ptr [bp + si + 0x400] ; LOGIC
03B4E5  22 B2 00 90           AND    dh, byte ptr [bp + si - 0x7000] ; LOGIC
03B4E9  25 B2 00              AND    ax, 0xb2 ; LOGIC
03B4EC  36 25 B2 00           AND    ax, 0xb2 ; LOGIC
03B4F0  34 26                 XOR    al, 0x26 ; LOGIC
03B4F2  B2 00                 MOV    dl, 0 ; MOV
03B4F4  2F                    DAS ; ARITH
03B4F5  26 B2 00              MOV    dl, 0 ; MOV
03B4F8  2A 26 B2 00           SUB    ah, byte ptr [0xb2] ; ARITH
03B4FC  25 26 B2              AND    ax, 0xb226 ; LOGIC
03B4FF  00 20                 ADD    byte ptr [bx + si], ah ; ARITH
03B501  26 B2 00              MOV    dl, 0 ; MOV
03B504  1B 26 B2 00           SBB    sp, word ptr [0xb2] ; ARITH
03B508  16                    PUSH   ss ; STACK_PUSH
03B509  26 B2 00              MOV    dl, 0 ; MOV
03B50C  11 26 B2 00           ADC    word ptr [0xb2], sp ; ARITH
03B510  0C 26                 OR     al, 0x26 ; LOGIC
03B512  B2 00                 MOV    dl, 0 ; MOV
03B514  07                    POP    es ; STACK_POP
03B515  26 B2 00              MOV    dl, 0 ; MOV
03B518  02 26 B2 00           ADD    ah, byte ptr [0xb2] ; ARITH
03B51C  FD                    STD ; FLAG
03B51D  25 B2 00              AND    ax, 0xb2 ; LOGIC
03B520  F8                    CLC ; FLAG
03B521  25 B2 00              AND    ax, 0xb2 ; LOGIC
03B524  F3 25 B2 00           AND    ax, 0xb2 ; LOGIC
03B528  17                    POP    ss ; STACK_POP
03B529  03 B2 00 6D           ADD    si, word ptr [bp + si + 0x6d00] ; ARITH
03B52D  09 B2 00 F3           OR     word ptr [bp + si - 0xd00], si ; LOGIC
03B531  0D B2 00              OR     ax, 0xb2 ; LOGIC
03B534  DC 15                 FCOM   qword ptr [di]               ; UNKNOWN
03B536  B2 00                 MOV    dl, 0 ; MOV
03B538  C8 15 B2 00           ENTER  -0x4deb, 0 ; PROLOGUE
03B53C  65 13 B2 00 DD        ADC    si, word ptr gs:[bp + si - 0x2300] ; ARITH
03B541  1C B2                 SBB    al, 0xb2 ; ARITH
03B543  00 2F                 ADD    byte ptr [bx], ch ; ARITH
03B545  1F                    POP    ds ; STACK_POP
03B546  B2 00                 MOV    dl, 0 ; MOV
03B548  83 1E B2 00 F2        SBB    word ptr [0xb2], -0xe ; ARITH
03B54D  23 B2 00 13           AND    si, word ptr [bp + si + 0x1300] ; LOGIC
03B551  22 B2 00 B0           AND    dh, byte ptr [bp + si - 0x5000] ; LOGIC
03B555  16                    PUSH   ss ; STACK_PUSH
03B556  B2 00                 MOV    dl, 0 ; MOV
03B558  20 1A                 AND    byte ptr [bp + si], bl ; LOGIC
03B55A  B2 00                 MOV    dl, 0 ; MOV
03B55C  4E                    DEC    si ; ARITH
03B55D  06                    PUSH   es ; STACK_PUSH
03B55E  B2 00                 MOV    dl, 0 ; MOV
03B560  2D 16 B2              SUB    ax, 0xb216 ; ARITH
03B563  00 3C                 ADD    byte ptr [si], bh ; ARITH
03B565  16                    PUSH   ss ; STACK_PUSH
03B566  B2 00                 MOV    dl, 0 ; MOV
03B568  FF 19                 LCALL  [bx + di] ; LCALL
03B56A  B2 00                 MOV    dl, 0 ; MOV
03B56C  B1 0C                 MOV    cl, 0xc ; CONST_LOAD
03B56E  B2 00                 MOV    dl, 0 ; MOV
03B570  1B 12                 SBB    dx, word ptr [bp + si] ; ARITH
03B572  B2 00                 MOV    dl, 0 ; MOV
03B574  F2 0C B2              OR     al, 0xb2 ; LOGIC
03B577  00 5D 0C              ADD    byte ptr [di + 0xc], bl ; ARITH
03B57A  B2 00                 MOV    dl, 0 ; MOV
03B57C  C7                    DB     0xC7 ; DATA_BYTE
03B57D  11                    DB     0x11 ; DATA_BYTE
03B57E  B2                    DB     0xB2 ; DATA_BYTE
03B57F  00                    DB     0x00 ; DATA_BYTE
03B580  05                    DB     0x05 ; DATA_BYTE
03B581  0F                    DB     0x0F ; DATA_BYTE
03B582  B2                    DB     0xB2 ; DATA_BYTE
03B583  00                    DB     0x00 ; DATA_BYTE
03B584  BF                    DB     0xBF ; DATA_BYTE
03B585  12                    DB     0x12 ; DATA_BYTE
03B586  B2                    DB     0xB2 ; DATA_BYTE
03B587  00                    DB     0x00 ; DATA_BYTE
03B588  79                    DB     0x79 ; DATA_BYTE
03B589  00                    DB     0x00 ; DATA_BYTE
03B58A  B2                    DB     0xB2 ; DATA_BYTE
03B58B  00                    DB     0x00 ; DATA_BYTE
03B58C  C8                    DB     0xC8 ; DATA_BYTE
03B58D  0D                    DB     0x0D ; DATA_BYTE
03B58E  B2                    DB     0xB2 ; DATA_BYTE
03B58F  00                    DB     0x00 ; DATA_BYTE
03B590  28                    DB     0x28 ; DATA_BYTE
03B591  10                    DB     0x10 ; DATA_BYTE
03B592  B2                    DB     0xB2 ; DATA_BYTE
03B593  00                    DB     0x00 ; DATA_BYTE
03B594  23                    DB     0x23 ; DATA_BYTE
03B595  14                    DB     0x14 ; DATA_BYTE
03B596  B2                    DB     0xB2 ; DATA_BYTE
03B597  00                    DB     0x00 ; DATA_BYTE
03B598  44                    DB     0x44 ; DATA_BYTE
03B599  13                    DB     0x13 ; DATA_BYTE
03B59A  B2                    DB     0xB2 ; DATA_BYTE
03B59B  00                    DB     0x00 ; DATA_BYTE
03B59C  81                    DB     0x81 ; DATA_BYTE
03B59D  06                    DB     0x06 ; DATA_BYTE
03B59E  B2                    DB     0xB2 ; DATA_BYTE
03B59F  00                    DB     0x00 ; DATA_BYTE
03B5A0  6D                    DB     0x6D ; DATA_BYTE
03B5A1  06                    DB     0x06 ; DATA_BYTE
03B5A2  B2                    DB     0xB2 ; DATA_BYTE
03B5A3  00                    DB     0x00 ; DATA_BYTE
03B5A4  93                    DB     0x93 ; DATA_BYTE
03B5A5  23                    DB     0x23 ; DATA_BYTE
03B5A6  B2                    DB     0xB2 ; DATA_BYTE
03B5A7  00                    DB     0x00 ; DATA_BYTE
03B5A8  29                    DB     0x29 ; DATA_BYTE
03B5A9  23                    DB     0x23 ; DATA_BYTE
03B5AA  B2                    DB     0xB2 ; DATA_BYTE
03B5AB  00                    DB     0x00 ; DATA_BYTE
03B5AC  6E                    DB     0x6E ; DATA_BYTE
03B5AD  21                    DB     0x21 ; DATA_BYTE
03B5AE  B2                    DB     0xB2 ; DATA_BYTE
03B5AF  00                    DB     0x00 ; DATA_BYTE
03B5B0  81                    DB     0x81 ; DATA_BYTE
03B5B1  19                    DB     0x19 ; DATA_BYTE
03B5B2  B2                    DB     0xB2 ; DATA_BYTE
03B5B3  00                    DB     0x00 ; DATA_BYTE
03B5B4  3C                    DB     0x3C ; DATA_BYTE
03B5B5  19                    DB     0x19 ; DATA_BYTE
03B5B6  B2                    DB     0xB2 ; DATA_BYTE
03B5B7  00                    DB     0x00 ; DATA_BYTE
03B5B8  04                    DB     0x04 ; DATA_BYTE
03B5B9  03                    DB     0x03 ; DATA_BYTE
03B5BA  B2                    DB     0xB2 ; DATA_BYTE
03B5BB  00                    DB     0x00 ; DATA_BYTE
03B5BC  A8                    DB     0xA8 ; DATA_BYTE
03B5BD  15                    DB     0x15 ; DATA_BYTE
03B5BE  B2                    DB     0xB2 ; DATA_BYTE
03B5BF  00                    DB     0x00 ; DATA_BYTE
03B5C0  98                    DB     0x98 ; DATA_BYTE
03B5C1  15                    DB     0x15 ; DATA_BYTE
03B5C2  B2                    DB     0xB2 ; DATA_BYTE
03B5C3  00                    DB     0x00 ; DATA_BYTE
03B5C4  D7                    DB     0xD7 ; DATA_BYTE
03B5C5  23                    DB     0x23 ; DATA_BYTE
03B5C6  B2                    DB     0xB2 ; DATA_BYTE
03B5C7  00                    DB     0x00 ; DATA_BYTE
03B5C8  F8                    DB     0xF8 ; DATA_BYTE
03B5C9  21                    DB     0x21 ; DATA_BYTE
03B5CA  B2                    DB     0xB2 ; DATA_BYTE
03B5CB  00                    DB     0x00 ; DATA_BYTE
03B5CC  C9                    DB     0xC9 ; DATA_BYTE
03B5CD  25                    DB     0x25 ; DATA_BYTE
03B5CE  B2                    DB     0xB2 ; DATA_BYTE
03B5CF  00                    DB     0x00 ; DATA_BYTE
03B5D0  46                    DB     0x46 ; DATA_BYTE
03B5D1  25                    DB     0x25 ; DATA_BYTE
03B5D2  B2                    DB     0xB2 ; DATA_BYTE
03B5D3  00                    DB     0x00 ; DATA_BYTE
03B5D4  EE                    DB     0xEE ; DATA_BYTE
03B5D5  24                    DB     0x24 ; DATA_BYTE
03B5D6  B2                    DB     0xB2 ; DATA_BYTE
03B5D7  00                    DB     0x00 ; DATA_BYTE
03B5D8  38                    DB     0x38 ; DATA_BYTE
03B5D9  03                    DB     0x03 ; DATA_BYTE
03B5DA  B2                    DB     0xB2 ; DATA_BYTE
03B5DB  00                    DB     0x00 ; DATA_BYTE
03B5DC  22                    DB     0x22 ; DATA_BYTE
03B5DD  03                    DB     0x03 ; DATA_BYTE
03B5DE  B2                    DB     0xB2 ; DATA_BYTE
03B5DF  00                    DB     0x00 ; DATA_BYTE
03B5E0  D8                    DB     0xD8 ; DATA_BYTE
03B5E1  0D                    DB     0x0D ; DATA_BYTE
03B5E2  B2                    DB     0xB2 ; DATA_BYTE
03B5E3  00                    DB     0x00 ; DATA_BYTE
03B5E4  54                    DB     0x54 ; DATA_BYTE
03B5E5  13                    DB     0x13 ; DATA_BYTE
03B5E6  B2                    DB     0xB2 ; DATA_BYTE
03B5E7  00                    DB     0x00 ; DATA_BYTE
03B5E8  B6                    DB     0xB6 ; DATA_BYTE
03B5E9  04                    DB     0x04 ; DATA_BYTE
03B5EA  B2                    DB     0xB2 ; DATA_BYTE
03B5EB  00                    DB     0x00 ; DATA_BYTE
03B5EC  44                    DB     0x44 ; DATA_BYTE
03B5ED  10                    DB     0x10 ; DATA_BYTE
03B5EE  B2                    DB     0xB2 ; DATA_BYTE
03B5EF  00                    DB     0x00 ; DATA_BYTE
03B5F0  46                    DB     0x46 ; DATA_BYTE
03B5F1  14                    DB     0x14 ; DATA_BYTE
03B5F2  B2                    DB     0xB2 ; DATA_BYTE
03B5F3  00                    DB     0x00 ; DATA_BYTE
03B5F4  71                    DB     0x71 ; DATA_BYTE
03B5F5  02                    DB     0x02 ; DATA_BYTE
03B5F6  B2                    DB     0xB2 ; DATA_BYTE
03B5F7  00                    DB     0x00 ; DATA_BYTE
03B5F8  8C                    DB     0x8C ; DATA_BYTE
03B5F9  0A                    DB     0x0A ; DATA_BYTE
03B5FA  B2                    DB     0xB2 ; DATA_BYTE
03B5FB  00                    DB     0x00 ; DATA_BYTE
03B5FC  C0                    DB     0xC0 ; DATA_BYTE
03B5FD  1A                    DB     0x1A ; DATA_BYTE
03B5FE  B2                    DB     0xB2 ; DATA_BYTE
03B5FF  00                    DB     0x00 ; DATA_BYTE
03B600  83                    DB     0x83 ; DATA_BYTE
03B601  22                    DB     0x22 ; DATA_BYTE
03B602  B2                    DB     0xB2 ; DATA_BYTE
03B603  00                    DB     0x00 ; DATA_BYTE
03B604  E8                    DB     0xE8 ; DATA_BYTE
03B605  15                    DB     0x15 ; DATA_BYTE
03B606  B2                    DB     0xB2 ; DATA_BYTE
03B607  00                    DB     0x00 ; DATA_BYTE
03B608  A9                    DB     0xA9 ; DATA_BYTE
03B609  13                    DB     0x13 ; DATA_BYTE
03B60A  B2                    DB     0xB2 ; DATA_BYTE
03B60B  00                    DB     0x00 ; DATA_BYTE
03B60C  81                    DB     0x81 ; DATA_BYTE
03B60D  13                    DB     0x13 ; DATA_BYTE
03B60E  B2                    DB     0xB2 ; DATA_BYTE
03B60F  00                    DB     0x00 ; DATA_BYTE
03B610  45                    DB     0x45 ; DATA_BYTE
03B611  0A                    DB     0x0A ; DATA_BYTE
03B612  B2                    DB     0xB2 ; DATA_BYTE
03B613  00                    DB     0x00 ; DATA_BYTE
03B614  4E                    DB     0x4E ; DATA_BYTE
03B615  0F                    DB     0x0F ; DATA_BYTE
03B616  B2                    DB     0xB2 ; DATA_BYTE
03B617  00                    DB     0x00 ; DATA_BYTE
03B618  EE                    DB     0xEE ; DATA_BYTE
03B619  25                    DB     0x25 ; DATA_BYTE
03B61A  B2                    DB     0xB2 ; DATA_BYTE
03B61B  00                    DB     0x00 ; DATA_BYTE
03B61C  E9                    DB     0xE9 ; DATA_BYTE
03B61D  25                    DB     0x25 ; DATA_BYTE
03B61E  B2                    DB     0xB2 ; DATA_BYTE
03B61F  00                    DB     0x00 ; DATA_BYTE
03B620  F5                    DB     0xF5 ; DATA_BYTE
03B621  02                    DB     0x02 ; DATA_BYTE
03B622  B2                    DB     0xB2 ; DATA_BYTE
03B623  00                    DB     0x00 ; DATA_BYTE
03B624  E2                    DB     0xE2 ; DATA_BYTE
03B625  0D                    DB     0x0D ; DATA_BYTE
03B626  B2                    DB     0xB2 ; DATA_BYTE
03B627  00                    DB     0x00 ; DATA_BYTE
03B628  88                    DB     0x88 ; DATA_BYTE
03B629  15                    DB     0x15 ; DATA_BYTE
03B62A  B2                    DB     0xB2 ; DATA_BYTE
03B62B  00                    DB     0x00 ; DATA_BYTE
03B62C  6D                    DB     0x6D ; DATA_BYTE
03B62D  1A                    DB     0x1A ; DATA_BYTE
03B62E  B2                    DB     0xB2 ; DATA_BYTE
03B62F  00                    DB     0x00 ; DATA_BYTE
03B630  D4                    DB     0xD4 ; DATA_BYTE
03B631  1E                    DB     0x1E ; DATA_BYTE
03B632  B2                    DB     0xB2 ; DATA_BYTE
03B633  00                    DB     0x00 ; DATA_BYTE
03B634  CE                    DB     0xCE ; DATA_BYTE
03B635  24                    DB     0x24 ; DATA_BYTE
03B636  B2                    DB     0xB2 ; DATA_BYTE
03B637  00                    DB     0x00 ; DATA_BYTE
03B638  26                    DB     0x26 ; DATA_BYTE
03B639  25                    DB     0x25 ; DATA_BYTE
03B63A  B2                    DB     0xB2 ; DATA_BYTE
03B63B  00                    DB     0x00 ; DATA_BYTE
03B63C  F1                    DB     0xF1 ; DATA_BYTE
03B63D  18                    DB     0x18 ; DATA_BYTE
03B63E  B2                    DB     0xB2 ; DATA_BYTE
03B63F  00                    DB     0x00 ; DATA_BYTE
03B640  0A                    DB     0x0A ; DATA_BYTE
03B641  05                    DB     0x05 ; DATA_BYTE
03B642  B2                    DB     0xB2 ; DATA_BYTE
03B643  00                    DB     0x00 ; DATA_BYTE
03B644  C9                    DB     0xC9 ; DATA_BYTE
03B645  1C                    DB     0x1C ; DATA_BYTE
03B646  B2                    DB     0xB2 ; DATA_BYTE
03B647  00                    DB     0x00 ; DATA_BYTE
03B648  F9                    DB     0xF9 ; DATA_BYTE
03B649  06                    DB     0x06 ; DATA_BYTE
03B64A  B2                    DB     0xB2 ; DATA_BYTE
03B64B  00                    DB     0x00 ; DATA_BYTE
03B64C  5F                    DB     0x5F ; DATA_BYTE
03B64D  06                    DB     0x06 ; DATA_BYTE
03B64E  B2                    DB     0xB2 ; DATA_BYTE
03B64F  00                    DB     0x00 ; DATA_BYTE
03B650  57                    DB     0x57 ; DATA_BYTE
03B651  0D                    DB     0x0D ; DATA_BYTE
03B652  B2                    DB     0xB2 ; DATA_BYTE
03B653  00                    DB     0x00 ; DATA_BYTE
03B654  24                    DB     0x24 ; DATA_BYTE
03B655  0B                    DB     0x0B ; DATA_BYTE
03B656  B2                    DB     0xB2 ; DATA_BYTE
03B657  00                    DB     0x00 ; DATA_BYTE
03B658  5E                    DB     0x5E ; DATA_BYTE
03B659  12                    DB     0x12 ; DATA_BYTE
03B65A  B2                    DB     0xB2 ; DATA_BYTE
03B65B  00                    DB     0x00 ; DATA_BYTE
03B65C  F4                    DB     0xF4 ; DATA_BYTE
03B65D  1E                    DB     0x1E ; DATA_BYTE
03B65E  B2                    DB     0xB2 ; DATA_BYTE
03B65F  00                    DB     0x00 ; DATA_BYTE
03B660  96                    DB     0x96 ; DATA_BYTE
03B661  10                    DB     0x10 ; DATA_BYTE
03B662  B2                    DB     0xB2 ; DATA_BYTE
03B663  00                    DB     0x00 ; DATA_BYTE
03B664  7F                    DB     0x7F ; DATA_BYTE
03B665  14                    DB     0x14 ; DATA_BYTE
03B666  B2                    DB     0xB2 ; DATA_BYTE
03B667  00                    DB     0x00 ; DATA_BYTE
03B668  AF                    DB     0xAF ; DATA_BYTE
03B669  23                    DB     0x23 ; DATA_BYTE
03B66A  B2                    DB     0xB2 ; DATA_BYTE
03B66B  00                    DB     0x00 ; DATA_BYTE
03B66C  68                    DB     0x68 ; DATA_BYTE
03B66D  23                    DB     0x23 ; DATA_BYTE
03B66E  B2                    DB     0xB2 ; DATA_BYTE
03B66F  00                    DB     0x00 ; DATA_BYTE
03B670  45                    DB     0x45 ; DATA_BYTE
03B671  23                    DB     0x23 ; DATA_BYTE
03B672  B2                    DB     0xB2 ; DATA_BYTE
03B673  00                    DB     0x00 ; DATA_BYTE
03B674  D0                    DB     0xD0 ; DATA_BYTE
03B675  21                    DB     0x21 ; DATA_BYTE
03B676  B2                    DB     0xB2 ; DATA_BYTE
03B677  00                    DB     0x00 ; DATA_BYTE
03B678  AD                    DB     0xAD ; DATA_BYTE
03B679  21                    DB     0x21 ; DATA_BYTE
03B67A  B2                    DB     0xB2 ; DATA_BYTE
03B67B  00                    DB     0x00 ; DATA_BYTE
03B67C  8A                    DB     0x8A ; DATA_BYTE
03B67D  21                    DB     0x21 ; DATA_BYTE
03B67E  B2                    DB     0xB2 ; DATA_BYTE
03B67F  00                    DB     0x00 ; DATA_BYTE
03B680  5C                    DB     0x5C ; DATA_BYTE
03B681  03                    DB     0x03 ; DATA_BYTE
03B682  B2                    DB     0xB2 ; DATA_BYTE
03B683  00                    DB     0x00 ; DATA_BYTE
03B684  1D                    DB     0x1D ; DATA_BYTE
03B685  1C                    DB     0x1C ; DATA_BYTE
03B686  B2                    DB     0xB2 ; DATA_BYTE
03B687  00                    DB     0x00 ; DATA_BYTE
03B688  BA                    DB     0xBA ; DATA_BYTE
03B689  15                    DB     0x15 ; DATA_BYTE
03B68A  B2                    DB     0xB2 ; DATA_BYTE
03B68B  00                    DB     0x00 ; DATA_BYTE
03B68C  50                    DB     0x50 ; DATA_BYTE
03B68D  03                    DB     0x03 ; DATA_BYTE
03B68E  B2                    DB     0xB2 ; DATA_BYTE
03B68F  00                    DB     0x00 ; DATA_BYTE
03B690  FB                    DB     0xFB ; DATA_BYTE
03B691  01                    DB     0x01 ; DATA_BYTE
03B692  B2                    DB     0xB2 ; DATA_BYTE
03B693  00                    DB     0x00 ; DATA_BYTE
03B694  2A                    DB     0x2A ; DATA_BYTE
03B695  05                    DB     0x05 ; DATA_BYTE
03B696  B2                    DB     0xB2 ; DATA_BYTE
03B697  00                    DB     0x00 ; DATA_BYTE
03B698  7A                    DB     0x7A ; DATA_BYTE
03B699  09                    DB     0x09 ; DATA_BYTE
03B69A  B2                    DB     0xB2 ; DATA_BYTE
03B69B  00                    DB     0x00 ; DATA_BYTE
03B69C  00                    DB     0x00 ; DATA_BYTE
03B69D  0E                    DB     0x0E ; DATA_BYTE
03B69E  B2                    DB     0xB2 ; DATA_BYTE
03B69F  00                    DB     0x00 ; DATA_BYTE
03B6A0  00                    DB     0x00 ; DATA_BYTE
03B6A1  16                    DB     0x16 ; DATA_BYTE
03B6A2  B2                    DB     0xB2 ; DATA_BYTE
03B6A3  00                    DB     0x00 ; DATA_BYTE
03B6A4  C1                    DB     0xC1 ; DATA_BYTE
03B6A5  13                    DB     0x13 ; DATA_BYTE
03B6A6  B2                    DB     0xB2 ; DATA_BYTE
03B6A7  00                    DB     0x00 ; DATA_BYTE
03B6A8  EA                    DB     0xEA ; DATA_BYTE
03B6A9  1C                    DB     0x1C ; DATA_BYTE
03B6AA  B2                    DB     0xB2 ; DATA_BYTE
03B6AB  00                    DB     0x00 ; DATA_BYTE
03B6AC  A2                    DB     0xA2 ; DATA_BYTE
03B6AD  1F                    DB     0x1F ; DATA_BYTE
03B6AE  B2                    DB     0xB2 ; DATA_BYTE
03B6AF  00                    DB     0x00 ; DATA_BYTE
03B6B0  C1                    DB     0xC1 ; DATA_BYTE
03B6B1  1E                    DB     0x1E ; DATA_BYTE
03B6B2  B2                    DB     0xB2 ; DATA_BYTE
03B6B3  00                    DB     0x00 ; DATA_BYTE
03B6B4  48                    DB     0x48 ; DATA_BYTE
03B6B5  1E                    DB     0x1E ; DATA_BYTE
03B6B6  B2                    DB     0xB2 ; DATA_BYTE
03B6B7  00                    DB     0x00 ; DATA_BYTE
03B6B8  FF                    DB     0xFF ; DATA_BYTE
03B6B9  23                    DB     0x23 ; DATA_BYTE
03B6BA  B2                    DB     0xB2 ; DATA_BYTE
03B6BB  00                    DB     0x00 ; DATA_BYTE
03B6BC  20                    DB     0x20 ; DATA_BYTE
03B6BD  22                    DB     0x22 ; DATA_BYTE
03B6BE  B2                    DB     0xB2 ; DATA_BYTE
03B6BF  00                    DB     0x00 ; DATA_BYTE
03B6C0  D6                    DB     0xD6 ; DATA_BYTE
03B6C1  25                    DB     0x25 ; DATA_BYTE
03B6C2  B2                    DB     0xB2 ; DATA_BYTE
03B6C3  00                    DB     0x00 ; DATA_BYTE
03B6C4  AB                    DB     0xAB ; DATA_BYTE
03B6C5  25                    DB     0x25 ; DATA_BYTE
03B6C6  B2                    DB     0xB2 ; DATA_BYTE
03B6C7  00                    DB     0x00 ; DATA_BYTE
03B6C8  77                    DB     0x77 ; DATA_BYTE
03B6C9  25                    DB     0x25 ; DATA_BYTE
03B6CA  B2                    DB     0xB2 ; DATA_BYTE
03B6CB  00                    DB     0x00 ; DATA_BYTE
03B6CC  53                    DB     0x53 ; DATA_BYTE
03B6CD  25                    DB     0x25 ; DATA_BYTE
03B6CE  B2                    DB     0xB2 ; DATA_BYTE
03B6CF  00                    DB     0x00 ; DATA_BYTE
03B6D0  0A                    DB     0x0A ; DATA_BYTE
03B6D1  25                    DB     0x25 ; DATA_BYTE
03B6D2  B2                    DB     0xB2 ; DATA_BYTE
03B6D3  00                    DB     0x00 ; DATA_BYTE
03B6D4  1D                    DB     0x1D ; DATA_BYTE
03B6D5  19                    DB     0x19 ; DATA_BYTE
03B6D6  B2                    DB     0xB2 ; DATA_BYTE
03B6D7  00                    DB     0x00 ; DATA_BYTE
03B6D8  51                    DB     0x51 ; DATA_BYTE
03B6D9  00                    DB     0x00 ; DATA_BYTE
03B6DA  B2                    DB     0xB2 ; DATA_BYTE
03B6DB  00                    DB     0x00 ; DATA_BYTE
03B6DC  1A                    DB     0x1A ; DATA_BYTE
03B6DD  10                    DB     0x10 ; DATA_BYTE
03B6DE  B2                    DB     0xB2 ; DATA_BYTE
03B6DF  00                    DB     0x00 ; DATA_BYTE
03B6E0  12                    DB     0x12 ; DATA_BYTE
03B6E1  1D                    DB     0x1D ; DATA_BYTE
03B6E2  B2                    DB     0xB2 ; DATA_BYTE
03B6E3  00                    DB     0x00 ; DATA_BYTE
03B6E4  4D                    DB     0x4D ; DATA_BYTE
03B6E5  1D                    DB     0x1D ; DATA_BYTE
03B6E6  B2                    DB     0xB2 ; DATA_BYTE
03B6E7  00                    DB     0x00 ; DATA_BYTE
03B6E8  37                    DB     0x37 ; DATA_BYTE
03B6E9  1A                    DB     0x1A ; DATA_BYTE
03B6EA  B2                    DB     0xB2 ; DATA_BYTE
03B6EB  00                    DB     0x00 ; DATA_BYTE
03B6EC  2E                    DB     0x2E ; DATA_BYTE
03B6ED  20                    DB     0x20 ; DATA_BYTE
03B6EE  B2                    DB     0xB2 ; DATA_BYTE
03B6EF  00                    DB     0x00 ; DATA_BYTE
03B6F0  9F                    DB     0x9F ; DATA_BYTE
03B6F1  23                    DB     0x23 ; DATA_BYTE
03B6F2  B2                    DB     0xB2 ; DATA_BYTE
03B6F3  00                    DB     0x00 ; DATA_BYTE
03B6F4  35                    DB     0x35 ; DATA_BYTE
03B6F5  23                    DB     0x23 ; DATA_BYTE
03B6F6  B2                    DB     0xB2 ; DATA_BYTE
03B6F7  00                    DB     0x00 ; DATA_BYTE
03B6F8  7A                    DB     0x7A ; DATA_BYTE
03B6F9  21                    DB     0x21 ; DATA_BYTE
03B6FA  B2                    DB     0xB2 ; DATA_BYTE
03B6FB  00                    DB     0x00 ; DATA_BYTE
03B6FC  FA                    DB     0xFA ; DATA_BYTE
03B6FD  19                    DB     0x19 ; DATA_BYTE
03B6FE  B2                    DB     0xB2 ; DATA_BYTE
03B6FF  00                    DB     0x00 ; DATA_BYTE
03B700  89                    DB     0x89 ; DATA_BYTE
03B701  17                    DB     0x17 ; DATA_BYTE
03B702  B2                    DB     0xB2 ; DATA_BYTE
03B703  00                    DB     0x00 ; DATA_BYTE
03B704  79                    DB     0x79 ; DATA_BYTE
03B705  17                    DB     0x17 ; DATA_BYTE
03B706  B2                    DB     0xB2 ; DATA_BYTE
03B707  00                    DB     0x00 ; DATA_BYTE
03B708  A4                    DB     0xA4 ; DATA_BYTE
03B709  16                    DB     0x16 ; DATA_BYTE
03B70A  B2                    DB     0xB2 ; DATA_BYTE
03B70B  00                    DB     0x00 ; DATA_BYTE
03B70C  43                    DB     0x43 ; DATA_BYTE
03B70D  03                    DB     0x03 ; DATA_BYTE
03B70E  B2                    DB     0xB2 ; DATA_BYTE
03B70F  00                    DB     0x00 ; DATA_BYTE
03B710  2D                    DB     0x2D ; DATA_BYTE
03B711  03                    DB     0x03 ; DATA_BYTE
03B712  B2                    DB     0xB2 ; DATA_BYTE
03B713  00                    DB     0x00 ; DATA_BYTE
03B714  EE                    DB     0xEE ; DATA_BYTE
03B715  01                    DB     0x01 ; DATA_BYTE
03B716  B2                    DB     0xB2 ; DATA_BYTE
03B717  00                    DB     0x00 ; DATA_BYTE
03B718  AE                    DB     0xAE ; DATA_BYTE
03B719  05                    DB     0x05 ; DATA_BYTE
03B71A  B2                    DB     0xB2 ; DATA_BYTE
03B71B  00                    DB     0x00 ; DATA_BYTE
03B71C  F3                    DB     0xF3 ; DATA_BYTE
03B71D  15                    DB     0x15 ; DATA_BYTE
03B71E  B2                    DB     0xB2 ; DATA_BYTE
03B71F  00                    DB     0x00 ; DATA_BYTE
03B720  B4                    DB     0xB4 ; DATA_BYTE
03B721  13                    DB     0x13 ; DATA_BYTE
03B722  B2                    DB     0xB2 ; DATA_BYTE
03B723  00                    DB     0x00 ; DATA_BYTE
03B724  8C                    DB     0x8C ; DATA_BYTE
03B725  13                    DB     0x13 ; DATA_BYTE
03B726  B2                    DB     0xB2 ; DATA_BYTE
03B727  00                    DB     0x00 ; DATA_BYTE
03B728  4F                    DB     0x4F ; DATA_BYTE
03B729  1F                    DB     0x1F ; DATA_BYTE
03B72A  B2                    DB     0xB2 ; DATA_BYTE
03B72B  00                    DB     0x00 ; DATA_BYTE
03B72C  B4                    DB     0xB4 ; DATA_BYTE
03B72D  1E                    DB     0x1E ; DATA_BYTE
03B72E  B2                    DB     0xB2 ; DATA_BYTE
03B72F  00                    DB     0x00 ; DATA_BYTE
03B730  A0                    DB     0xA0 ; DATA_BYTE
03B731  1E                    DB     0x1E ; DATA_BYTE
03B732  B2                    DB     0xB2 ; DATA_BYTE
03B733  00                    DB     0x00 ; DATA_BYTE
03B734  3B                    DB     0x3B ; DATA_BYTE
03B735  1E                    DB     0x1E ; DATA_BYTE
03B736  B2                    DB     0xB2 ; DATA_BYTE
03B737  00                    DB     0x00 ; DATA_BYTE
03B738  29                    DB     0x29 ; DATA_BYTE
03B739  01                    DB     0x01 ; DATA_BYTE
03B73A  B2                    DB     0xB2 ; DATA_BYTE
03B73B  00                    DB     0x00 ; DATA_BYTE
03B73C  18                    DB     0x18 ; DATA_BYTE
03B73D  01                    DB     0x01 ; DATA_BYTE
03B73E  B2                    DB     0xB2 ; DATA_BYTE
03B73F  00                    DB     0x00 ; DATA_BYTE
03B740  BF                    DB     0xBF ; DATA_BYTE
03B741  1C                    DB     0x1C ; DATA_BYTE
03B742  B2                    DB     0xB2 ; DATA_BYTE
03B743  00                    DB     0x00 ; DATA_BYTE
03B744  24                    DB     0x24 ; DATA_BYTE
03B745  00                    DB     0x00 ; DATA_BYTE
03B746  B2                    DB     0xB2 ; DATA_BYTE
03B747  00                    DB     0x00 ; DATA_BYTE
03B748  6C                    DB     0x6C ; DATA_BYTE
03B749  04                    DB     0x04 ; DATA_BYTE
03B74A  B2                    DB     0xB2 ; DATA_BYTE
03B74B  00                    DB     0x00 ; DATA_BYTE
03B74C  F1                    DB     0xF1 ; DATA_BYTE
03B74D  09                    DB     0x09 ; DATA_BYTE
03B74E  B2                    DB     0xB2 ; DATA_BYTE
03B74F  00                    DB     0x00 ; DATA_BYTE
03B750  13                    DB     0x13 ; DATA_BYTE
03B751  08                    DB     0x08 ; DATA_BYTE
03B752  B2                    DB     0xB2 ; DATA_BYTE
03B753  00                    DB     0x00 ; DATA_BYTE
03B754  AF                    DB     0xAF ; DATA_BYTE
03B755  07                    DB     0x07 ; DATA_BYTE
03B756  B2                    DB     0xB2 ; DATA_BYTE
03B757  00                    DB     0x00 ; DATA_BYTE
03B758  A2                    DB     0xA2 ; DATA_BYTE
03B759  0B                    DB     0x0B ; DATA_BYTE
03B75A  B2                    DB     0xB2 ; DATA_BYTE
03B75B  00                    DB     0x00 ; DATA_BYTE
03B75C  41                    DB     0x41 ; DATA_BYTE
03B75D  0B                    DB     0x0B ; DATA_BYTE
03B75E  B2                    DB     0xB2 ; DATA_BYTE
03B75F  00                    DB     0x00 ; DATA_BYTE
03B760  B2                    DB     0xB2 ; DATA_BYTE
03B761  11                    DB     0x11 ; DATA_BYTE
03B762  B2                    DB     0xB2 ; DATA_BYTE
03B763  00                    DB     0x00 ; DATA_BYTE
03B764  0C                    DB     0x0C ; DATA_BYTE
03B765  11                    DB     0x11 ; DATA_BYTE
03B766  B2                    DB     0xB2 ; DATA_BYTE
03B767  00                    DB     0x00 ; DATA_BYTE
03B768  42                    DB     0x42 ; DATA_BYTE
03B769  15                    DB     0x15 ; DATA_BYTE
03B76A  B2                    DB     0xB2 ; DATA_BYTE
03B76B  00                    DB     0x00 ; DATA_BYTE
03B76C  B8                    DB     0xB8 ; DATA_BYTE
03B76D  1F                    DB     0x1F ; DATA_BYTE
03B76E  B2                    DB     0xB2 ; DATA_BYTE
03B76F  00                    DB     0x00 ; DATA_BYTE
03B770  50                    DB     0x50 ; DATA_BYTE
03B771  07                    DB     0x07 ; DATA_BYTE
03B772  B2                    DB     0xB2 ; DATA_BYTE
03B773  00                    DB     0x00 ; DATA_BYTE
03B774  C2                    DB     0xC2 ; DATA_BYTE
03B775  05                    DB     0x05 ; DATA_BYTE
03B776  B2                    DB     0xB2 ; DATA_BYTE
