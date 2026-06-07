; ============================================================================
; func_056694_unknown
; Region   : overlay
; Bytes    : file 0x056694..0x0569BF  (811 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

056694  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
056698  38 14                 CMP    byte ptr [si], dl ; CMP
05669A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05669C  22 14                 AND    dl, byte ptr [si] ; LOGIC
05669E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566A0  D6                    SALC                                ; UNKNOWN
0566A1  20 00                 AND    byte ptr [bx + si], al ; LOGIC
0566A3  00 14                 ADD    byte ptr [si], dl ; ARITH
0566A5  20 00                 AND    byte ptr [bx + si], al ; LOGIC
0566A7  00 D1                 ADD    cl, dl ; ARITH
0566A9  1F                    POP    ds ; STACK_POP
0566AA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566AC  6D                    INSW   word ptr es:[di], dx ; IO
0566AD  1F                    POP    ds ; STACK_POP
0566AE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566B0  45                    INC    bp ; ARITH
0566B1  24 00                 AND    al, 0 ; LOGIC
0566B3  00 77 22              ADD    byte ptr [bx + 0x22], dh ; ARITH
0566B6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566B8  61                    POPAW                               ; UNKNOWN
0566B9  22 00                 AND    al, byte ptr [bx + si] ; LOGIC
0566BB  00 F6                 ADD    dh, dh ; ARITH
0566BD  26 00 00              ADD    byte ptr es:[bx + si], al ; ARITH
0566C0  E0 26                 LOOPNE 0x566e8 ; CJUMP
0566C2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566C4  41                    INC    cx ; ARITH
0566C5  25 00 00              AND    ax, 0 ; LOGIC
0566C8  2B 25                 SUB    sp, word ptr [di] ; STACK_ALLOC
0566CA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566CC  3D 2A 00              CMP    ax, 0x2a ; CMP
0566CF  00 79 29              ADD    byte ptr [bx + di + 0x29], bh ; ARITH
0566D2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566D4  27                    DAA ; ARITH
0566D5  29 00                 SUB    word ptr [bx + si], ax ; ARITH
0566D7  00 FA                 ADD    dl, bh ; ARITH
0566D9  28 00                 SUB    byte ptr [bx + si], al ; ARITH
0566DB  00 E4                 ADD    ah, ah ; ARITH
0566DD  28 00                 SUB    byte ptr [bx + si], al ; ARITH
0566DF  00 E3                 ADD    bl, ah ; ARITH
0566E1  2F                    DAS ; ARITH
0566E2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566E4  4B                    DEC    bx ; ARITH
0566E5  2F                    DAS ; ARITH
0566E6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566E8  72 2E                 JB     0x56718 ; CJUMP
0566EA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566EC  A5                    MOVSW  word ptr es:[di], word ptr [si] ; STR
0566ED  33 00                 XOR    ax, word ptr [bx + si] ; LOGIC
0566EF  00 81 33 00           ADD    byte ptr [bx + di + 0x33], al ; ARITH
0566F3  00 6B 33              ADD    byte ptr [bp + di + 0x33], ch ; ARITH
0566F6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0566F8  55                    PUSH   bp ; STACK_PUSH
0566F9  33 00                 XOR    ax, word ptr [bx + si] ; LOGIC
0566FB  00 91 30 00           ADD    byte ptr [bx + di + 0x30], dl ; ARITH
0566FF  00 7A 30              ADD    byte ptr [bp + si + 0x30], bh ; ARITH
056702  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056704  7F 35                 JG     0x5673b ; CJUMP
056706  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056708  72 35                 JB     0x5673f ; CJUMP
05670A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05670C  5C                    POP    sp ; STACK_POP
05670D  35 00 00              XOR    ax, 0 ; LOGIC
056710  20 34                 AND    byte ptr [si], dh ; LOGIC
056712  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056714  FC                    CLD ; FLAG
056715  33 00                 XOR    ax, word ptr [bx + si] ; LOGIC
056717  00 E6                 ADD    dh, ah ; ARITH
056719  33 00                 XOR    ax, word ptr [bx + si] ; LOGIC
05671B  00 A5 10 00           ADD    byte ptr [di + 0x10], ah ; ARITH
05671F  00 59 10              ADD    byte ptr [bx + di + 0x10], bl ; ARITH
056722  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056724  FA                    CLI ; FLAG
056725  15 00 00              ADC    ax, 0 ; ARITH
056728  35 15 00              XOR    ax, 0x15 ; LOGIC
05672B  00 5D 20              ADD    byte ptr [di + 0x20], bl ; ARITH
05672E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056730  F4                    HLT ; SYS
056731  25 00 00              AND    ax, 0 ; LOGIC
056734  81 2B 00 00           SUB    word ptr [bp + di], 0 ; ARITH
056738  34 2D                 XOR    al, 0x2d ; LOGIC
05673A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05673C  3C 30                 CMP    al, 0x30 ; CMP
05673E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056740  89 0E 00 00           MOV    word ptr [0], cx ; MOV
056744  B1 06                 MOV    cl, 6 ; MOV
056746  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056748  A2 08 00              MOV    byte ptr [8], al ; MOV
05674B  00 5B 0B              ADD    byte ptr [bp + di + 0xb], bl ; ARITH
05674E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056750  D1 17                 RCL    word ptr [bx] ; LOGIC
056752  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056754  5E                    POP    si ; STACK_POP
056755  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
056757  00 44 1B              ADD    byte ptr [si + 0x1b], al ; ARITH
05675A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05675C  F4                    HLT ; SYS
05675D  34 00                 XOR    al, 0 ; LOGIC
05675F  00 46 32              ADD    byte ptr [bp + 0x32], al ; ARITH
056762  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056764  CD 31                 INT    0x31 ; SYS
056766  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056768  87 36 00 00           XCHG   word ptr [0], si ; MOV
05676C  FC                    CLD ; FLAG
05676D  35 00 00              XOR    ax, 0 ; LOGIC
056770  B7 35                 MOV    bh, 0x35 ; CONST_LOAD
056772  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056774  57                    PUSH   di ; STACK_PUSH
056775  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
056777  00 26 1C 00           ADD    byte ptr [0x1c], ah ; ARITH
05677B  00 C9                 ADD    cl, cl ; ARITH
05677D  2E 00 00              ADD    byte ptr cs:[bx + si], al ; ARITH
056780  A7                    CMPSW  word ptr [si], word ptr es:[di] ; STR
056781  2D 00 00              SUB    ax, 0 ; ARITH
056784  C9                    LEAVE ; EPILOGUE
056785  37                    AAA ; ARITH
056786  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056788  58                    POP    ax ; STACK_POP
056789  23 00                 AND    ax, word ptr [bx + si] ; LOGIC
05678B  00 F6                 ADD    dh, dh ; ARITH
05678D  2B 00                 SUB    ax, word ptr [bx + si] ; ARITH
05678F  00 EC                 ADD    ah, ch ; ARITH
056791  0F 00 00              SLDT   word ptr [bx + si]           ; UNKNOWN
056794  13 19                 ADC    bx, word ptr [bx + di] ; ARITH
056796  00 00                 ADD    byte ptr [bx + si], al ; ARITH
056798  09 1A                 OR     word ptr [bp + si], bx ; LOGIC
05679A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
05679C  83 27 00              AND    word ptr [bx], 0 ; LOGIC
05679F  00 B0 2F 00           ADD    byte ptr [bx + si + 0x2f], dh ; ARITH
0567A3  00 18                 ADD    byte ptr [bx + si], bl ; ARITH
0567A5  2F                    DAS ; ARITH
0567A6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
0567A8  C6                    DB     0xC6 ; DATA_BYTE
0567A9  2C                    DB     0x2C ; DATA_BYTE
0567AA  00                    DB     0x00 ; DATA_BYTE
0567AB  00                    DB     0x00 ; DATA_BYTE
0567AC  E2                    DB     0xE2 ; DATA_BYTE
0567AD  03                    DB     0x03 ; DATA_BYTE
0567AE  00                    DB     0x00 ; DATA_BYTE
0567AF  00                    DB     0x00 ; DATA_BYTE
0567B0  5A                    DB     0x5A ; DATA_BYTE
0567B1  08                    DB     0x08 ; DATA_BYTE
0567B2  00                    DB     0x00 ; DATA_BYTE
0567B3  00                    DB     0x00 ; DATA_BYTE
0567B4  DE                    DB     0xDE ; DATA_BYTE
0567B5  07                    DB     0x07 ; DATA_BYTE
0567B6  00                    DB     0x00 ; DATA_BYTE
0567B7  00                    DB     0x00 ; DATA_BYTE
0567B8  7A                    DB     0x7A ; DATA_BYTE
0567B9  0D                    DB     0x0D ; DATA_BYTE
0567BA  00                    DB     0x00 ; DATA_BYTE
0567BB  00                    DB     0x00 ; DATA_BYTE
0567BC  DF                    DB     0xDF ; DATA_BYTE
0567BD  0F                    DB     0x0F ; DATA_BYTE
0567BE  00                    DB     0x00 ; DATA_BYTE
0567BF  00                    DB     0x00 ; DATA_BYTE
0567C0  84                    DB     0x84 ; DATA_BYTE
0567C1  20                    DB     0x20 ; DATA_BYTE
0567C2  00                    DB     0x00 ; DATA_BYTE
0567C3  00                    DB     0x00 ; DATA_BYTE
0567C4  F3                    DB     0xF3 ; DATA_BYTE
0567C5  1A                    DB     0x1A ; DATA_BYTE
0567C6  00                    DB     0x00 ; DATA_BYTE
0567C7  00                    DB     0x00 ; DATA_BYTE
0567C8  0E                    DB     0x0E ; DATA_BYTE
0567C9  2E                    DB     0x2E ; DATA_BYTE
0567CA  00                    DB     0x00 ; DATA_BYTE
0567CB  00                    DB     0x00 ; DATA_BYTE
0567CC  C4                    DB     0xC4 ; DATA_BYTE
0567CD  0D                    DB     0x0D ; DATA_BYTE
0567CE  00                    DB     0x00 ; DATA_BYTE
0567CF  00                    DB     0x00 ; DATA_BYTE
0567D0  36                    DB     0x36 ; DATA_BYTE
0567D1  16                    DB     0x16 ; DATA_BYTE
0567D2  00                    DB     0x00 ; DATA_BYTE
0567D3  00                    DB     0x00 ; DATA_BYTE
0567D4  CC                    DB     0xCC ; DATA_BYTE
0567D5  04                    DB     0x04 ; DATA_BYTE
0567D6  00                    DB     0x00 ; DATA_BYTE
0567D7  00                    DB     0x00 ; DATA_BYTE
0567D8  25                    DB     0x25 ; DATA_BYTE
0567D9  1B                    DB     0x1B ; DATA_BYTE
0567DA  00                    DB     0x00 ; DATA_BYTE
0567DB  00                    DB     0x00 ; DATA_BYTE
0567DC  E1                    DB     0xE1 ; DATA_BYTE
0567DD  34                    DB     0x34 ; DATA_BYTE
0567DE  00                    DB     0x00 ; DATA_BYTE
0567DF  00                    DB     0x00 ; DATA_BYTE
0567E0  64                    DB     0x64 ; DATA_BYTE
0567E1  04                    DB     0x04 ; DATA_BYTE
0567E2  00                    DB     0x00 ; DATA_BYTE
0567E3  00                    DB     0x00 ; DATA_BYTE
0567E4  1F                    DB     0x1F ; DATA_BYTE
0567E5  01                    DB     0x01 ; DATA_BYTE
0567E6  00                    DB     0x00 ; DATA_BYTE
0567E7  00                    DB     0x00 ; DATA_BYTE
0567E8  78                    DB     0x78 ; DATA_BYTE
0567E9  1A                    DB     0x1A ; DATA_BYTE
0567EA  00                    DB     0x00 ; DATA_BYTE
0567EB  00                    DB     0x00 ; DATA_BYTE
0567EC  72                    DB     0x72 ; DATA_BYTE
0567ED  27                    DB     0x27 ; DATA_BYTE
0567EE  00                    DB     0x00 ; DATA_BYTE
0567EF  00                    DB     0x00 ; DATA_BYTE
0567F0  AA                    DB     0xAA ; DATA_BYTE
0567F1  2F                    DB     0x2F ; DATA_BYTE
0567F2  00                    DB     0x00 ; DATA_BYTE
0567F3  00                    DB     0x00 ; DATA_BYTE
0567F4  89                    DB     0x89 ; DATA_BYTE
0567F5  2F                    DB     0x2F ; DATA_BYTE
0567F6  00                    DB     0x00 ; DATA_BYTE
0567F7  00                    DB     0x00 ; DATA_BYTE
0567F8  12                    DB     0x12 ; DATA_BYTE
0567F9  2F                    DB     0x2F ; DATA_BYTE
0567FA  00                    DB     0x00 ; DATA_BYTE
0567FB  00                    DB     0x00 ; DATA_BYTE
0567FC  F8                    DB     0xF8 ; DATA_BYTE
0567FD  2E                    DB     0x2E ; DATA_BYTE
0567FE  00                    DB     0x00 ; DATA_BYTE
0567FF  00                    DB     0x00 ; DATA_BYTE
056800  BA                    DB     0xBA ; DATA_BYTE
056801  2C                    DB     0x2C ; DATA_BYTE
056802  00                    DB     0x00 ; DATA_BYTE
056803  00                    DB     0x00 ; DATA_BYTE
056804  A8                    DB     0xA8 ; DATA_BYTE
056805  03                    DB     0x03 ; DATA_BYTE
056806  00                    DB     0x00 ; DATA_BYTE
056807  00                    DB     0x00 ; DATA_BYTE
056808  22                    DB     0x22 ; DATA_BYTE
056809  02                    DB     0x02 ; DATA_BYTE
05680A  00                    DB     0x00 ; DATA_BYTE
05680B  00                    DB     0x00 ; DATA_BYTE
05680C  E9                    DB     0xE9 ; DATA_BYTE
05680D  01                    DB     0x01 ; DATA_BYTE
05680E  00                    DB     0x00 ; DATA_BYTE
05680F  00                    DB     0x00 ; DATA_BYTE
056810  07                    DB     0x07 ; DATA_BYTE
056811  04                    DB     0x04 ; DATA_BYTE
056812  00                    DB     0x00 ; DATA_BYTE
056813  00                    DB     0x00 ; DATA_BYTE
056814  37                    DB     0x37 ; DATA_BYTE
056815  09                    DB     0x09 ; DATA_BYTE
056816  00                    DB     0x00 ; DATA_BYTE
056817  00                    DB     0x00 ; DATA_BYTE
056818  65                    DB     0x65 ; DATA_BYTE
056819  07                    DB     0x07 ; DATA_BYTE
05681A  00                    DB     0x00 ; DATA_BYTE
05681B  00                    DB     0x00 ; DATA_BYTE
05681C  57                    DB     0x57 ; DATA_BYTE
05681D  0E                    DB     0x0E ; DATA_BYTE
05681E  00                    DB     0x00 ; DATA_BYTE
05681F  00                    DB     0x00 ; DATA_BYTE
056820  EE                    DB     0xEE ; DATA_BYTE
056821  0C                    DB     0x0C ; DATA_BYTE
056822  00                    DB     0x00 ; DATA_BYTE
056823  00                    DB     0x00 ; DATA_BYTE
056824  43                    DB     0x43 ; DATA_BYTE
056825  0B                    DB     0x0B ; DATA_BYTE
056826  00                    DB     0x00 ; DATA_BYTE
056827  00                    DB     0x00 ; DATA_BYTE
056828  91                    DB     0x91 ; DATA_BYTE
056829  0F                    DB     0x0F ; DATA_BYTE
05682A  00                    DB     0x00 ; DATA_BYTE
05682B  00                    DB     0x00 ; DATA_BYTE
05682C  D4                    DB     0xD4 ; DATA_BYTE
05682D  06                    DB     0x06 ; DATA_BYTE
05682E  00                    DB     0x00 ; DATA_BYTE
05682F  00                    DB     0x00 ; DATA_BYTE
056830  53                    DB     0x53 ; DATA_BYTE
056831  06                    DB     0x06 ; DATA_BYTE
056832  00                    DB     0x00 ; DATA_BYTE
056833  00                    DB     0x00 ; DATA_BYTE
056834  98                    DB     0x98 ; DATA_BYTE
056835  05                    DB     0x05 ; DATA_BYTE
056836  00                    DB     0x00 ; DATA_BYTE
056837  00                    DB     0x00 ; DATA_BYTE
056838  7A                    DB     0x7A ; DATA_BYTE
056839  05                    DB     0x05 ; DATA_BYTE
05683A  00                    DB     0x00 ; DATA_BYTE
05683B  00                    DB     0x00 ; DATA_BYTE
05683C  2E                    DB     0x2E ; DATA_BYTE
05683D  0A                    DB     0x0A ; DATA_BYTE
05683E  00                    DB     0x00 ; DATA_BYTE
05683F  00                    DB     0x00 ; DATA_BYTE
056840  01                    DB     0x01 ; DATA_BYTE
056841  09                    DB     0x09 ; DATA_BYTE
056842  00                    DB     0x00 ; DATA_BYTE
056843  00                    DB     0x00 ; DATA_BYTE
056844  F9                    DB     0xF9 ; DATA_BYTE
056845  07                    DB     0x07 ; DATA_BYTE
056846  00                    DB     0x00 ; DATA_BYTE
056847  00                    DB     0x00 ; DATA_BYTE
056848  27                    DB     0x27 ; DATA_BYTE
056849  0C                    DB     0x0C ; DATA_BYTE
05684A  00                    DB     0x00 ; DATA_BYTE
05684B  00                    DB     0x00 ; DATA_BYTE
05684C  BF                    DB     0xBF ; DATA_BYTE
05684D  0B                    DB     0x0B ; DATA_BYTE
05684E  00                    DB     0x00 ; DATA_BYTE
05684F  00                    DB     0x00 ; DATA_BYTE
056850  3C                    DB     0x3C ; DATA_BYTE
056851  20                    DB     0x20 ; DATA_BYTE
056852  00                    DB     0x00 ; DATA_BYTE
056853  00                    DB     0x00 ; DATA_BYTE
056854  AA                    DB     0xAA ; DATA_BYTE
056855  1D                    DB     0x1D ; DATA_BYTE
056856  00                    DB     0x00 ; DATA_BYTE
056857  00                    DB     0x00 ; DATA_BYTE
056858  35                    DB     0x35 ; DATA_BYTE
056859  22                    DB     0x22 ; DATA_BYTE
05685A  00                    DB     0x00 ; DATA_BYTE
05685B  00                    DB     0x00 ; DATA_BYTE
05685C  E6                    DB     0xE6 ; DATA_BYTE
05685D  21                    DB     0x21 ; DATA_BYTE
05685E  00                    DB     0x00 ; DATA_BYTE
05685F  00                    DB     0x00 ; DATA_BYTE
056860  EA                    DB     0xEA ; DATA_BYTE
056861  2A                    DB     0x2A ; DATA_BYTE
056862  00                    DB     0x00 ; DATA_BYTE
056863  00                    DB     0x00 ; DATA_BYTE
056864  97                    DB     0x97 ; DATA_BYTE
056865  2C                    DB     0x2C ; DATA_BYTE
056866  00                    DB     0x00 ; DATA_BYTE
056867  00                    DB     0x00 ; DATA_BYTE
056868  E6                    DB     0xE6 ; DATA_BYTE
056869  32                    DB     0x32 ; DATA_BYTE
05686A  00                    DB     0x00 ; DATA_BYTE
05686B  00                    DB     0x00 ; DATA_BYTE
05686C  53                    DB     0x53 ; DATA_BYTE
05686D  36                    DB     0x36 ; DATA_BYTE
05686E  00                    DB     0x00 ; DATA_BYTE
05686F  00                    DB     0x00 ; DATA_BYTE
056870  6B                    DB     0x6B ; DATA_BYTE
056871  00                    DB     0x00 ; DATA_BYTE
056872  00                    DB     0x00 ; DATA_BYTE
056873  00                    DB     0x00 ; DATA_BYTE
056874  15                    DB     0x15 ; DATA_BYTE
056875  00                    DB     0x00 ; DATA_BYTE
056876  00                    DB     0x00 ; DATA_BYTE
056877  00                    DB     0x00 ; DATA_BYTE
056878  87                    DB     0x87 ; DATA_BYTE
056879  04                    DB     0x04 ; DATA_BYTE
05687A  00                    DB     0x00 ; DATA_BYTE
05687B  00                    DB     0x00 ; DATA_BYTE
05687C  13                    DB     0x13 ; DATA_BYTE
05687D  0D                    DB     0x0D ; DATA_BYTE
05687E  00                    DB     0x00 ; DATA_BYTE
05687F  00                    DB     0x00 ; DATA_BYTE
056880  64                    DB     0x64 ; DATA_BYTE
056881  36                    DB     0x36 ; DATA_BYTE
056882  00                    DB     0x00 ; DATA_BYTE
056883  00                    DB     0x00 ; DATA_BYTE
056884  80                    DB     0x80 ; DATA_BYTE
056885  03                    DB     0x03 ; DATA_BYTE
056886  00                    DB     0x00 ; DATA_BYTE
056887  00                    DB     0x00 ; DATA_BYTE
056888  56                    DB     0x56 ; DATA_BYTE
056889  07                    DB     0x07 ; DATA_BYTE
05688A  00                    DB     0x00 ; DATA_BYTE
05688B  00                    DB     0x00 ; DATA_BYTE
05688C  D2                    DB     0xD2 ; DATA_BYTE
05688D  09                    DB     0x09 ; DATA_BYTE
05688E  00                    DB     0x00 ; DATA_BYTE
05688F  00                    DB     0x00 ; DATA_BYTE
056890  DF                    DB     0xDF ; DATA_BYTE
056891  0C                    DB     0x0C ; DATA_BYTE
056892  00                    DB     0x00 ; DATA_BYTE
056893  00                    DB     0x00 ; DATA_BYTE
056894  34                    DB     0x34 ; DATA_BYTE
056895  0B                    DB     0x0B ; DATA_BYTE
056896  00                    DB     0x00 ; DATA_BYTE
056897  00                    DB     0x00 ; DATA_BYTE
056898  82                    DB     0x82 ; DATA_BYTE
056899  0F                    DB     0x0F ; DATA_BYTE
05689A  00                    DB     0x00 ; DATA_BYTE
05689B  00                    DB     0x00 ; DATA_BYTE
05689C  9C                    DB     0x9C ; DATA_BYTE
05689D  13                    DB     0x13 ; DATA_BYTE
05689E  00                    DB     0x00 ; DATA_BYTE
05689F  00                    DB     0x00 ; DATA_BYTE
0568A0  E2                    DB     0xE2 ; DATA_BYTE
0568A1  23                    DB     0x23 ; DATA_BYTE
0568A2  00                    DB     0x00 ; DATA_BYTE
0568A3  00                    DB     0x00 ; DATA_BYTE
0568A4  63                    DB     0x63 ; DATA_BYTE
0568A5  2C                    DB     0x2C ; DATA_BYTE
0568A6  00                    DB     0x00 ; DATA_BYTE
0568A7  00                    DB     0x00 ; DATA_BYTE
0568A8  C5                    DB     0xC5 ; DATA_BYTE
0568A9  10                    DB     0x10 ; DATA_BYTE
0568AA  00                    DB     0x00 ; DATA_BYTE
0568AB  00                    DB     0x00 ; DATA_BYTE
0568AC  6B                    DB     0x6B ; DATA_BYTE
0568AD  10                    DB     0x10 ; DATA_BYTE
0568AE  00                    DB     0x00 ; DATA_BYTE
0568AF  00                    DB     0x00 ; DATA_BYTE
0568B0  A0                    DB     0xA0 ; DATA_BYTE
0568B1  21                    DB     0x21 ; DATA_BYTE
0568B2  00                    DB     0x00 ; DATA_BYTE
0568B3  00                    DB     0x00 ; DATA_BYTE
0568B4  91                    DB     0x91 ; DATA_BYTE
0568B5  02                    DB     0x02 ; DATA_BYTE
0568B6  00                    DB     0x00 ; DATA_BYTE
0568B7  00                    DB     0x00 ; DATA_BYTE
0568B8  92                    DB     0x92 ; DATA_BYTE
0568B9  01                    DB     0x01 ; DATA_BYTE
0568BA  00                    DB     0x00 ; DATA_BYTE
0568BB  00                    DB     0x00 ; DATA_BYTE
0568BC  8C                    DB     0x8C ; DATA_BYTE
0568BD  14                    DB     0x14 ; DATA_BYTE
0568BE  00                    DB     0x00 ; DATA_BYTE
0568BF  00                    DB     0x00 ; DATA_BYTE
0568C0  E1                    DB     0xE1 ; DATA_BYTE
0568C1  27                    DB     0x27 ; DATA_BYTE
0568C2  00                    DB     0x00 ; DATA_BYTE
0568C3  00                    DB     0x00 ; DATA_BYTE
0568C4  2C                    DB     0x2C ; DATA_BYTE
0568C5  27                    DB     0x27 ; DATA_BYTE
0568C6  00                    DB     0x00 ; DATA_BYTE
0568C7  00                    DB     0x00 ; DATA_BYTE
0568C8  64                    DB     0x64 ; DATA_BYTE
0568C9  30                    DB     0x30 ; DATA_BYTE
0568CA  00                    DB     0x00 ; DATA_BYTE
0568CB  00                    DB     0x00 ; DATA_BYTE
0568CC  B9                    DB     0xB9 ; DATA_BYTE
0568CD  37                    DB     0x37 ; DATA_BYTE
0568CE  00                    DB     0x00 ; DATA_BYTE
0568CF  00                    DB     0x00 ; DATA_BYTE
0568D0  BA                    DB     0xBA ; DATA_BYTE
0568D1  31                    DB     0x31 ; DATA_BYTE
0568D2  00                    DB     0x00 ; DATA_BYTE
0568D3  00                    DB     0x00 ; DATA_BYTE
0568D4  38                    DB     0x38 ; DATA_BYTE
0568D5  31                    DB     0x31 ; DATA_BYTE
0568D6  00                    DB     0x00 ; DATA_BYTE
0568D7  00                    DB     0x00 ; DATA_BYTE
0568D8  FE                    DB     0xFE ; DATA_BYTE
0568D9  2D                    DB     0x2D ; DATA_BYTE
0568DA  00                    DB     0x00 ; DATA_BYTE
0568DB  00                    DB     0x00 ; DATA_BYTE
0568DC  4A                    DB     0x4A ; DATA_BYTE
0568DD  10                    DB     0x10 ; DATA_BYTE
0568DE  00                    DB     0x00 ; DATA_BYTE
0568DF  00                    DB     0x00 ; DATA_BYTE
0568E0  1D                    DB     0x1D ; DATA_BYTE
0568E1  21                    DB     0x21 ; DATA_BYTE
0568E2  00                    DB     0x00 ; DATA_BYTE
0568E3  00                    DB     0x00 ; DATA_BYTE
0568E4  E7                    DB     0xE7 ; DATA_BYTE
0568E5  1F                    DB     0x1F ; DATA_BYTE
0568E6  00                    DB     0x00 ; DATA_BYTE
0568E7  00                    DB     0x00 ; DATA_BYTE
0568E8  AC                    DB     0xAC ; DATA_BYTE
0568E9  1F                    DB     0x1F ; DATA_BYTE
0568EA  00                    DB     0x00 ; DATA_BYTE
0568EB  00                    DB     0x00 ; DATA_BYTE
0568EC  07                    DB     0x07 ; DATA_BYTE
0568ED  1F                    DB     0x1F ; DATA_BYTE
0568EE  00                    DB     0x00 ; DATA_BYTE
0568EF  00                    DB     0x00 ; DATA_BYTE
0568F0  78                    DB     0x78 ; DATA_BYTE
0568F1  1E                    DB     0x1E ; DATA_BYTE
0568F2  00                    DB     0x00 ; DATA_BYTE
0568F3  00                    DB     0x00 ; DATA_BYTE
0568F4  8D                    DB     0x8D ; DATA_BYTE
0568F5  24                    DB     0x24 ; DATA_BYTE
0568F6  00                    DB     0x00 ; DATA_BYTE
0568F7  00                    DB     0x00 ; DATA_BYTE
0568F8  A9                    DB     0xA9 ; DATA_BYTE
0568F9  22                    DB     0x22 ; DATA_BYTE
0568FA  00                    DB     0x00 ; DATA_BYTE
0568FB  00                    DB     0x00 ; DATA_BYTE
0568FC  2C                    DB     0x2C ; DATA_BYTE
0568FD  28                    DB     0x28 ; DATA_BYTE
0568FE  00                    DB     0x00 ; DATA_BYTE
0568FF  00                    DB     0x00 ; DATA_BYTE
056900  87                    DB     0x87 ; DATA_BYTE
056901  26                    DB     0x26 ; DATA_BYTE
056902  00                    DB     0x00 ; DATA_BYTE
056903  00                    DB     0x00 ; DATA_BYTE
056904  66                    DB     0x66 ; DATA_BYTE
056905  25                    DB     0x25 ; DATA_BYTE
056906  00                    DB     0x00 ; DATA_BYTE
056907  00                    DB     0x00 ; DATA_BYTE
056908  36                    DB     0x36 ; DATA_BYTE
056909  2B                    DB     0x2B ; DATA_BYTE
05690A  00                    DB     0x00 ; DATA_BYTE
05690B  00                    DB     0x00 ; DATA_BYTE
05690C  0A                    DB     0x0A ; DATA_BYTE
05690D  29                    DB     0x29 ; DATA_BYTE
05690E  00                    DB     0x00 ; DATA_BYTE
05690F  00                    DB     0x00 ; DATA_BYTE
056910  52                    DB     0x52 ; DATA_BYTE
056911  09                    DB     0x09 ; DATA_BYTE
056912  00                    DB     0x00 ; DATA_BYTE
056913  00                    DB     0x00 ; DATA_BYTE
056914  68                    DB     0x68 ; DATA_BYTE
056915  03                    DB     0x03 ; DATA_BYTE
056916  00                    DB     0x00 ; DATA_BYTE
056917  00                    DB     0x00 ; DATA_BYTE
056918  7E                    DB     0x7E ; DATA_BYTE
056919  06                    DB     0x06 ; DATA_BYTE
05691A  00                    DB     0x00 ; DATA_BYTE
05691B  00                    DB     0x00 ; DATA_BYTE
05691C  FC                    DB     0xFC ; DATA_BYTE
05691D  01                    DB     0x01 ; DATA_BYTE
05691E  7F                    DB     0x7F ; DATA_BYTE
05691F  03                    DB     0x03 ; DATA_BYTE
056920  02                    DB     0x02 ; DATA_BYTE
056921  03                    DB     0x03 ; DATA_BYTE
056922  7F                    DB     0x7F ; DATA_BYTE
056923  03                    DB     0x03 ; DATA_BYTE
056924  C8                    DB     0xC8 ; DATA_BYTE
056925  03                    DB     0x03 ; DATA_BYTE
056926  7F                    DB     0x7F ; DATA_BYTE
056927  03                    DB     0x03 ; DATA_BYTE
056928  5F                    DB     0x5F ; DATA_BYTE
056929  01                    DB     0x01 ; DATA_BYTE
05692A  7F                    DB     0x7F ; DATA_BYTE
05692B  03                    DB     0x03 ; DATA_BYTE
05692C  E7                    DB     0xE7 ; DATA_BYTE
05692D  05                    DB     0x05 ; DATA_BYTE
05692E  7F                    DB     0x7F ; DATA_BYTE
05692F  03                    DB     0x03 ; DATA_BYTE
056930  D7                    DB     0xD7 ; DATA_BYTE
056931  05                    DB     0x05 ; DATA_BYTE
056932  7F                    DB     0x7F ; DATA_BYTE
056933  03                    DB     0x03 ; DATA_BYTE
056934  B4                    DB     0xB4 ; DATA_BYTE
056935  05                    DB     0x05 ; DATA_BYTE
056936  7F                    DB     0x7F ; DATA_BYTE
056937  03                    DB     0x03 ; DATA_BYTE
056938  88                    DB     0x88 ; DATA_BYTE
056939  05                    DB     0x05 ; DATA_BYTE
05693A  7F                    DB     0x7F ; DATA_BYTE
05693B  03                    DB     0x03 ; DATA_BYTE
05693C  85                    DB     0x85 ; DATA_BYTE
05693D  03                    DB     0x03 ; DATA_BYTE
05693E  7F                    DB     0x7F ; DATA_BYTE
05693F  03                    DB     0x03 ; DATA_BYTE
056940  40                    DB     0x40 ; DATA_BYTE
056941  07                    DB     0x07 ; DATA_BYTE
056942  7F                    DB     0x7F ; DATA_BYTE
056943  03                    DB     0x03 ; DATA_BYTE
056944  3B                    DB     0x3B ; DATA_BYTE
056945  07                    DB     0x07 ; DATA_BYTE
056946  7F                    DB     0x7F ; DATA_BYTE
056947  03                    DB     0x03 ; DATA_BYTE
056948  6C                    DB     0x6C ; DATA_BYTE
056949  02                    DB     0x02 ; DATA_BYTE
05694A  7F                    DB     0x7F ; DATA_BYTE
05694B  03                    DB     0x03 ; DATA_BYTE
05694C  51                    DB     0x51 ; DATA_BYTE
05694D  01                    DB     0x01 ; DATA_BYTE
05694E  7F                    DB     0x7F ; DATA_BYTE
05694F  03                    DB     0x03 ; DATA_BYTE
056950  4A                    DB     0x4A ; DATA_BYTE
056951  00                    DB     0x00 ; DATA_BYTE
056952  7F                    DB     0x7F ; DATA_BYTE
056953  03                    DB     0x03 ; DATA_BYTE
056954  D1                    DB     0xD1 ; DATA_BYTE
056955  00                    DB     0x00 ; DATA_BYTE
056956  7F                    DB     0x7F ; DATA_BYTE
056957  03                    DB     0x03 ; DATA_BYTE
056958  8D                    DB     0x8D ; DATA_BYTE
056959  02                    DB     0x02 ; DATA_BYTE
05695A  7F                    DB     0x7F ; DATA_BYTE
05695B  03                    DB     0x03 ; DATA_BYTE
05695C  F5                    DB     0xF5 ; DATA_BYTE
05695D  05                    DB     0x05 ; DATA_BYTE
05695E  7F                    DB     0x7F ; DATA_BYTE
05695F  03                    DB     0x03 ; DATA_BYTE
056960  0E                    DB     0x0E ; DATA_BYTE
056961  03                    DB     0x03 ; DATA_BYTE
056962  7F                    DB     0x7F ; DATA_BYTE
056963  03                    DB     0x03 ; DATA_BYTE
056964  A9                    DB     0xA9 ; DATA_BYTE
056965  01                    DB     0x01 ; DATA_BYTE
056966  7F                    DB     0x7F ; DATA_BYTE
056967  03                    DB     0x03 ; DATA_BYTE
056968  7B                    DB     0x7B ; DATA_BYTE
056969  01                    DB     0x01 ; DATA_BYTE
05696A  7F                    DB     0x7F ; DATA_BYTE
05696B  03                    DB     0x03 ; DATA_BYTE
05696C  4B                    DB     0x4B ; DATA_BYTE
05696D  02                    DB     0x02 ; DATA_BYTE
05696E  7F                    DB     0x7F ; DATA_BYTE
05696F  03                    DB     0x03 ; DATA_BYTE
056970  17                    DB     0x17 ; DATA_BYTE
056971  04                    DB     0x04 ; DATA_BYTE
056972  7F                    DB     0x7F ; DATA_BYTE
056973  03                    DB     0x03 ; DATA_BYTE
056974  DF                    DB     0xDF ; DATA_BYTE
056975  01                    DB     0x01 ; DATA_BYTE
056976  7F                    DB     0x7F ; DATA_BYTE
056977  03                    DB     0x03 ; DATA_BYTE
056978  13                    DB     0x13 ; DATA_BYTE
056979  06                    DB     0x06 ; DATA_BYTE
05697A  7F                    DB     0x7F ; DATA_BYTE
05697B  03                    DB     0x03 ; DATA_BYTE
05697C  24                    DB     0x24 ; DATA_BYTE
05697D  06                    DB     0x06 ; DATA_BYTE
05697E  7F                    DB     0x7F ; DATA_BYTE
05697F  03                    DB     0x03 ; DATA_BYTE
056980  CC                    DB     0xCC ; DATA_BYTE
056981  02                    DB     0x02 ; DATA_BYTE
056982  7F                    DB     0x7F ; DATA_BYTE
056983  03                    DB     0x03 ; DATA_BYTE
056984  20                    DB     0x20 ; DATA_BYTE
056985  01                    DB     0x01 ; DATA_BYTE
056986  7F                    DB     0x7F ; DATA_BYTE
056987  03                    DB     0x03 ; DATA_BYTE
056988  2F                    DB     0x2F ; DATA_BYTE
056989  03                    DB     0x03 ; DATA_BYTE
05698A  7F                    DB     0x7F ; DATA_BYTE
05698B  03                    DB     0x03 ; DATA_BYTE
05698C  C1                    DB     0xC1 ; DATA_BYTE
05698D  01                    DB     0x01 ; DATA_BYTE
05698E  7F                    DB     0x7F ; DATA_BYTE
05698F  03                    DB     0x03 ; DATA_BYTE
056990  90                    DB     0x90 ; DATA_BYTE
056991  00                    DB     0x00 ; DATA_BYTE
056992  7F                    DB     0x7F ; DATA_BYTE
056993  03                    DB     0x03 ; DATA_BYTE
056994  57                    DB     0x57 ; DATA_BYTE
056995  00                    DB     0x00 ; DATA_BYTE
056996  7F                    DB     0x7F ; DATA_BYTE
056997  03                    DB     0x03 ; DATA_BYTE
056998  2F                    DB     0x2F ; DATA_BYTE
056999  07                    DB     0x07 ; DATA_BYTE
05699A  7F                    DB     0x7F ; DATA_BYTE
05699B  03                    DB     0x03 ; DATA_BYTE
05699C  7F                    DB     0x7F ; DATA_BYTE
05699D  02                    DB     0x02 ; DATA_BYTE
05699E  7F                    DB     0x7F ; DATA_BYTE
05699F  03                    DB     0x03 ; DATA_BYTE
0569A0  93                    DB     0x93 ; DATA_BYTE
0569A1  03                    DB     0x03 ; DATA_BYTE
0569A2  7F                    DB     0x7F ; DATA_BYTE
0569A3  03                    DB     0x03 ; DATA_BYTE
0569A4  1A                    DB     0x1A ; DATA_BYTE
0569A5  03                    DB     0x03 ; DATA_BYTE
0569A6  7F                    DB     0x7F ; DATA_BYTE
0569A7  03                    DB     0x03 ; DATA_BYTE
0569A8  B4                    DB     0xB4 ; DATA_BYTE
0569A9  01                    DB     0x01 ; DATA_BYTE
0569AA  7F                    DB     0x7F ; DATA_BYTE
0569AB  03                    DB     0x03 ; DATA_BYTE
0569AC  86                    DB     0x86 ; DATA_BYTE
0569AD  01                    DB     0x01 ; DATA_BYTE
0569AE  7F                    DB     0x7F ; DATA_BYTE
0569AF  03                    DB     0x03 ; DATA_BYTE
0569B0  C7                    DB     0xC7 ; DATA_BYTE
0569B1  05                    DB     0x05 ; DATA_BYTE
0569B2  7F                    DB     0x7F ; DATA_BYTE
0569B3  03                    DB     0x03 ; DATA_BYTE
0569B4  A4                    DB     0xA4 ; DATA_BYTE
0569B5  05                    DB     0x05 ; DATA_BYTE
0569B6  7F                    DB     0x7F ; DATA_BYTE
0569B7  03                    DB     0x03 ; DATA_BYTE
0569B8  78                    DB     0x78 ; DATA_BYTE
0569B9  05                    DB     0x05 ; DATA_BYTE
0569BA  7F                    DB     0x7F ; DATA_BYTE
0569BB  03                    DB     0x03 ; DATA_BYTE
0569BC  C2                    DB     0xC2 ; DATA_BYTE
0569BD  00                    DB     0x00 ; DATA_BYTE
0569BE  7F                    DB     0x7F ; DATA_BYTE
