; ============================================================================
; func_047797_unknown
; Region   : load_image
; Bytes    : file 0x047797..0x047824  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

047797  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04779B  57                    PUSH   di                           ; UNKNOWN
04779C  56                    PUSH   si                           ; UNKNOWN
04779D  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0477A2  83 7E 08 04           CMP    word ptr [bp + 8], 4         ; UNKNOWN
0477A6  7D 0B                 JGE    0x477b3                      ; UNKNOWN
0477A8  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34  ; UNKNOWN
0477AC  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
0477B1  74 6A                 JE     0x4781d                      ; UNKNOWN
0477B3  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
0477B6  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0477B9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0477BC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0477BF  9A B4 07 D2 14        LCALL  0x14d2, 0x7b4                ; UNKNOWN
0477C4  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0477C7  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0477CA  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0477CD  9A 39 05 5F 24        LCALL  0x245f, 0x539                ; UNKNOWN
0477D2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0477D5  8B C8                 MOV    cx, ax                       ; UNKNOWN
0477D7  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0477DA  8B DA                 MOV    bx, dx                       ; UNKNOWN
0477DC  99                    CDQ                                 ; UNKNOWN
0477DD  2B C8                 SUB    cx, ax                       ; UNKNOWN
0477DF  1B DA                 SBB    bx, dx                       ; UNKNOWN
0477E1  8B F0                 MOV    si, ax                       ; UNKNOWN
0477E3  D1 F8                 SAR    ax, 1                        ; UNKNOWN
0477E5  8B FA                 MOV    di, dx                       ; UNKNOWN
0477E7  99                    CDQ                                 ; UNKNOWN
0477E8  3B DA                 CMP    bx, dx                       ; UNKNOWN
0477EA  7C 31                 JL     0x4781d                      ; UNKNOWN
0477EC  7F 04                 JG     0x477f2                      ; UNKNOWN
0477EE  3B C8                 CMP    cx, ax                       ; UNKNOWN
0477F0  72 2B                 JB     0x4781d                      ; UNKNOWN
0477F2  57                    PUSH   di                           ; UNKNOWN
0477F3  56                    PUSH   si                           ; UNKNOWN
0477F4  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0477F7  9A 8A 05 5F 24        LCALL  0x245f, 0x58a                ; UNKNOWN
0477FC  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0477FF  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
047803  FE 47 05              INC    byte ptr [bx + 5]            ; UNKNOWN
047806  6A 01                 PUSH   1                            ; UNKNOWN
047808  6A 10                 PUSH   0x10                         ; UNKNOWN
04780A  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
04780D  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
047810  9A 53 01 C9 33        LCALL  0x33c9, 0x153                ; UNKNOWN
047815  83 C4 08              ADD    sp, 8                        ; UNKNOWN
047818  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
04781D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
047820  5E                    POP    si                           ; UNKNOWN
047821  5F                    POP    di                           ; UNKNOWN
047822  C9                    LEAVE                               ; UNKNOWN
047823  CB                    RETF                                ; UNKNOWN
