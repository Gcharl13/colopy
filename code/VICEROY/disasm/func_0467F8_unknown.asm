; ============================================================================
; func_0467F8_unknown
; Region   : overlay
; Bytes    : file 0x0467F8..0x04694B  (339 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0467F8  C8 0F 00 00           ENTER  0xf, 0 ; PROLOGUE
0467FC  85 11                 TEST   word ptr [bx + di], dx ; LOGIC
0467FE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046800  8A 0D                 MOV    cl, byte ptr [di] ; MOV
046802  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046804  F7 10                 NOT    word ptr [bx + si] ; LOGIC
046806  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046808  58                    POP    ax ; STACK_POP
046809  16                    PUSH   ss ; STACK_PUSH
04680A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04680C  4A                    DEC    dx ; ARITH
04680D  30 00                 XOR    byte ptr [bx + si], al ; LOGIC
04680F  00 4A 35              ADD    byte ptr [bp + si + 0x35], cl ; ARITH
046812  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046814  19 35                 SBB    word ptr [di], si ; ARITH
046816  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046818  A5                    MOVSW  word ptr es:[di], word ptr [si] ; STR
046819  38 00                 CMP    byte ptr [bx + si], al ; CMP
04681B  00 F1                 ADD    cl, dh ; ARITH
04681D  45                    INC    bp ; ARITH
04681E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046820  57                    PUSH   di ; STACK_PUSH
046821  44                    INC    sp ; ARITH
046822  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046824  86 43 00              XCHG   byte ptr [bp + di], al ; MOV
046827  00 36 49 00           ADD    byte ptr [0x49], dh ; ARITH
04682B  00 7D 46              ADD    byte ptr [di + 0x46], bh ; ARITH
04682E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046830  C1 09 00              ROR    word ptr [bx + di], 0 ; LOGIC
046833  00 4E 0C              ADD    byte ptr [bp + 0xc], cl ; ARITH
046836  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046838  C1 01 00              ROL    word ptr [bx + di], 0 ; LOGIC
04683B  00 94 13 00           ADD    byte ptr [si + 0x13], dl ; ARITH
04683F  00 DC                 ADD    ah, bl ; ARITH
046841  18 00                 SBB    byte ptr [bx + si], al ; ARITH
046843  00 B1 20 00           ADD    byte ptr [bx + di + 0x20], dh ; ARITH
046847  00 9A 20 00           ADD    byte ptr [bp + si + 0x20], bl ; ARITH
04684B  00 84 20 00           ADD    byte ptr [si + 0x20], al ; ARITH
04684F  00 40 1E              ADD    byte ptr [bx + si + 0x1e], al ; ARITH
046852  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046854  CC                    INT3 ; SYS
046855  35 00 00              XOR    ax, 0 ; LOGIC
046858  E8 3D 00              CALL   0x46898 ; CALL_NEAR
04685B  00 9D 3D 00           ADD    byte ptr [di + 0x3d], bl ; ARITH
04685F  00 E0                 ADD    al, ah ; ARITH
046861  3C 00                 CMP    al, 0 ; CMP
046863  00 8A 3B 00           ADD    byte ptr [bp + si + 0x3b], cl ; ARITH
046867  00 66 3F              ADD    byte ptr [bp + 0x3f], ah ; ARITH
04686A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04686C  19 46 00              SBB    word ptr [bp], ax ; ARITH
04686F  00 E1                 ADD    cl, ah ; ARITH
046871  44                    INC    sp ; ARITH
046872  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046874  B5 44                 MOV    ch, 0x44 ; CONST_LOAD
046876  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046878  9F                    LAHF ; FLAG
046879  44                    INC    sp ; ARITH
04687A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04687C  EE                    OUT    dx, al ; IO
04687D  42                    INC    dx ; ARITH
04687E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046880  25 4C 00              AND    ax, 0x4c ; LOGIC
046883  00 D1                 ADD    cl, dl ; ARITH
046885  45                    INC    bp ; ARITH
046886  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046888  4B                    DEC    bx ; ARITH
046889  48                    DEC    ax ; ARITH
04688A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04688C  A1 3C 00              MOV    ax, word ptr [0x3c] ; GLOBAL_LOAD
04688F  00 2D                 ADD    byte ptr [di], ch ; ARITH
046891  3C 00                 CMP    al, 0 ; CMP
046893  00 F7                 ADD    bh, dh ; ARITH
046895  4B                    DEC    bx ; ARITH
046896  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046898  08 01                 OR     byte ptr [bx + di], al ; LOGIC
04689A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04689C  CC                    INT3 ; SYS
04689D  04 00                 ADD    al, 0 ; ARITH
04689F  00 DE                 ADD    dh, bl ; ARITH
0468A1  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
0468A3  00 31                 ADD    byte ptr [bx + di], dh ; ARITH
0468A5  0C 00                 OR     al, 0 ; LOGIC
0468A7  00 64 10              ADD    byte ptr [si + 0x10], ah ; ARITH
0468AA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0468AC  8B 29                 MOV    bp, word ptr [bx + di] ; MOV
0468AE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0468B0  0B 43 00              OR     ax, word ptr [bp + di] ; LOGIC
0468B3  00 5C 48              ADD    byte ptr [si + 0x48], bl ; ARITH
0468B6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0468B8  E9 1A 00              JMP    0x468d5 ; JUMP
0468BB  00 8F 47 00           ADD    byte ptr [bx + 0x47], cl ; ARITH
0468BF  00 F3                 ADD    bl, dh ; ARITH
0468C1  29 00                 SUB    word ptr [bx + si], ax ; ARITH
0468C3  00 27                 ADD    byte ptr [bx], ah ; ARITH
0468C5  18 00                 SBB    byte ptr [bx + si], al ; ARITH
0468C7  00 D9                 ADD    cl, bl ; ARITH
0468C9  28 00                 SUB    byte ptr [bx + si], al ; ARITH
0468CB  00 B6 36 00           ADD    byte ptr [bp + 0x36], dh ; ARITH
0468CF  00 2B                 ADD    byte ptr [bp + di], ch ; ARITH
0468D1  39 00                 CMP    word ptr [bx + si], ax ; CMP
0468D3  00 19                 ADD    byte ptr [bx + di], bl ; ARITH
0468D5  38 00                 CMP    byte ptr [bx + si], al ; CMP
0468D7  00 5D 06              ADD    byte ptr [di + 6], bl ; ARITH
0468DA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0468DC  EA 36 00 00 D9        LJMP   0xd900:0x36                  ; UNKNOWN
0468E1  01 00                 ADD    word ptr [bx + si], ax ; ARITH
0468E3  00 AC 13 00           ADD    byte ptr [si + 0x13], ch ; ARITH
0468E7  00 16 21 00           ADD    byte ptr [0x21], dl ; ARITH
0468EB  00 E7                 ADD    bh, ah ; ARITH
0468ED  20 00                 AND    byte ptr [bx + si], al ; LOGIC
0468EF  00 72 1E              ADD    byte ptr [bp + si + 0x1e], dh ; ARITH
0468F2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0468F4  EC                    IN     al, dx ; IO
0468F5  35 00 00              XOR    ax, 0 ; LOGIC
0468F8  3A 3C                 CMP    bh, byte ptr [si] ; CMP
0468FA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0468FC  F9                    STC ; FLAG
0468FD  44                    INC    sp ; ARITH
0468FE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046900  DE 41 00              FIADD  word ptr [bx + di]           ; UNKNOWN
046903  00 18                 ADD    byte ptr [bx + si], bl ; ARITH
046905  15 00 00              ADC    ax, 0 ; ARITH
046908  2A 15                 SUB    dl, byte ptr [di] ; ARITH
04690A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
04690C  F2 14 00              ADC    al, 0 ; ARITH
04690F  00 BE 12 00           ADD    byte ptr [bp + 0x12], bh ; ARITH
046913  00 06 1B 00           ADD    byte ptr [0x1b], al ; ARITH
046917  00 16 4C 00           ADD    byte ptr [0x4c], dl ; ARITH
04691B  00 5D 2A              ADD    byte ptr [di + 0x2a], bl ; ARITH
04691E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
046920  05 4B 00              ADD    ax, 0x4b ; ARITH
046923  00 F1                 ADD    cl, dh ; ARITH
046925  0F 00 00              SLDT   word ptr [bx + si]           ; UNKNOWN
046928  DD                    DB     0xDD ; DATA_BYTE
046929  29                    DB     0x29 ; DATA_BYTE
04692A  00                    DB     0x00 ; DATA_BYTE
04692B  00                    DB     0x00 ; DATA_BYTE
04692C  72                    DB     0x72 ; DATA_BYTE
04692D  02                    DB     0x02 ; DATA_BYTE
04692E  00                    DB     0x00 ; DATA_BYTE
04692F  00                    DB     0x00 ; DATA_BYTE
046930  35                    DB     0x35 ; DATA_BYTE
046931  06                    DB     0x06 ; DATA_BYTE
046932  00                    DB     0x00 ; DATA_BYTE
046933  00                    DB     0x00 ; DATA_BYTE
046934  7D                    DB     0x7D ; DATA_BYTE
046935  1D                    DB     0x1D ; DATA_BYTE
046936  00                    DB     0x00 ; DATA_BYTE
046937  00                    DB     0x00 ; DATA_BYTE
046938  33                    DB     0x33 ; DATA_BYTE
046939  2D                    DB     0x2D ; DATA_BYTE
04693A  00                    DB     0x00 ; DATA_BYTE
04693B  00                    DB     0x00 ; DATA_BYTE
04693C  6F                    DB     0x6F ; DATA_BYTE
04693D  33                    DB     0x33 ; DATA_BYTE
04693E  00                    DB     0x00 ; DATA_BYTE
04693F  00                    DB     0x00 ; DATA_BYTE
046940  B8                    DB     0xB8 ; DATA_BYTE
046941  39                    DB     0x39 ; DATA_BYTE
046942  00                    DB     0x00 ; DATA_BYTE
046943  00                    DB     0x00 ; DATA_BYTE
046944  96                    DB     0x96 ; DATA_BYTE
046945  39                    DB     0x39 ; DATA_BYTE
046946  00                    DB     0x00 ; DATA_BYTE
046947  00                    DB     0x00 ; DATA_BYTE
046948  CA                    DB     0xCA ; DATA_BYTE
046949  38                    DB     0x38 ; DATA_BYTE
04694A  00                    DB     0x00 ; DATA_BYTE
