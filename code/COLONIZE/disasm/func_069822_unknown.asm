; ============================================================================
; func_069822_unknown
; Region   : load_image
; Bytes    : file 0x069822..0x0698BC  (154 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069822  55                    PUSH   bp                           ; UNKNOWN
069823  8B EC                 MOV    bp, sp                       ; UNKNOWN
069825  57                    PUSH   di                           ; UNKNOWN
069826  56                    PUSH   si                           ; UNKNOWN
069827  53                    PUSH   bx                           ; UNKNOWN
069828  33 FF                 XOR    di, di                       ; UNKNOWN
06982A  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
06982D  0B C0                 OR     ax, ax                       ; UNKNOWN
06982F  7D 11                 JGE    0x69842                      ; UNKNOWN
069831  47                    INC    di                           ; UNKNOWN
069832  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
069835  F7 D8                 NEG    ax                           ; UNKNOWN
069837  F7 DA                 NEG    dx                           ; UNKNOWN
069839  1D 00 00              SBB    ax, 0                        ; UNKNOWN
06983C  89 46 08              MOV    word ptr [bp + 8], ax        ; UNKNOWN
06983F  89 56 06              MOV    word ptr [bp + 6], dx        ; UNKNOWN
069842  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
069845  0B C0                 OR     ax, ax                       ; UNKNOWN
069847  7D 11                 JGE    0x6985a                      ; UNKNOWN
069849  47                    INC    di                           ; UNKNOWN
06984A  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
06984D  F7 D8                 NEG    ax                           ; UNKNOWN
06984F  F7 DA                 NEG    dx                           ; UNKNOWN
069851  1D 00 00              SBB    ax, 0                        ; UNKNOWN
069854  89 46 0C              MOV    word ptr [bp + 0xc], ax      ; UNKNOWN
069857  89 56 0A              MOV    word ptr [bp + 0xa], dx      ; UNKNOWN
06985A  0B C0                 OR     ax, ax                       ; UNKNOWN
06985C  75 15                 JNE    0x69873                      ; UNKNOWN
06985E  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
069861  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
069864  33 D2                 XOR    dx, dx                       ; UNKNOWN
069866  F7 F1                 DIV    cx                           ; UNKNOWN
069868  8B D8                 MOV    bx, ax                       ; UNKNOWN
06986A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
06986D  F7 F1                 DIV    cx                           ; UNKNOWN
06986F  8B D3                 MOV    dx, bx                       ; UNKNOWN
069871  EB 38                 JMP    0x698ab                      ; UNKNOWN
069873  8B D8                 MOV    bx, ax                       ; UNKNOWN
069875  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
069878  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
06987B  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
06987E  D1 EB                 SHR    bx, 1                        ; UNKNOWN
069880  D1 D9                 RCR    cx, 1                        ; UNKNOWN
069882  D1 EA                 SHR    dx, 1                        ; UNKNOWN
069884  D1 D8                 RCR    ax, 1                        ; UNKNOWN
069886  0B DB                 OR     bx, bx                       ; UNKNOWN
069888  75 F4                 JNE    0x6987e                      ; UNKNOWN
06988A  F7 F1                 DIV    cx                           ; UNKNOWN
06988C  8B F0                 MOV    si, ax                       ; UNKNOWN
06988E  F7 66 0C              MUL    word ptr [bp + 0xc]          ; UNKNOWN
069891  91                    XCHG   cx, ax                       ; UNKNOWN
069892  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
069895  F7 E6                 MUL    si                           ; UNKNOWN
069897  03 D1                 ADD    dx, cx                       ; UNKNOWN
069899  72 0C                 JB     0x698a7                      ; UNKNOWN
06989B  3B 56 08              CMP    dx, word ptr [bp + 8]        ; UNKNOWN
06989E  77 07                 JA     0x698a7                      ; UNKNOWN
0698A0  72 06                 JB     0x698a8                      ; UNKNOWN
0698A2  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
0698A5  76 01                 JBE    0x698a8                      ; UNKNOWN
0698A7  4E                    DEC    si                           ; UNKNOWN
0698A8  33 D2                 XOR    dx, dx                       ; UNKNOWN
0698AA  96                    XCHG   si, ax                       ; UNKNOWN
0698AB  4F                    DEC    di                           ; UNKNOWN
0698AC  75 07                 JNE    0x698b5                      ; UNKNOWN
0698AE  F7 DA                 NEG    dx                           ; UNKNOWN
0698B0  F7 D8                 NEG    ax                           ; UNKNOWN
0698B2  83 DA 00              SBB    dx, 0                        ; UNKNOWN
0698B5  5B                    POP    bx                           ; UNKNOWN
0698B6  5E                    POP    si                           ; UNKNOWN
0698B7  5F                    POP    di                           ; UNKNOWN
0698B8  5D                    POP    bp                           ; UNKNOWN
0698B9  CA 08 00              RETF   8                            ; UNKNOWN
