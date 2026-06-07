; ============================================================================
; func_0407F9_unknown
; Region   : load_image
; Bytes    : file 0x0407F9..0x040844  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0407F9  55                    PUSH   bp                           ; UNKNOWN
0407FA  8B EC                 MOV    bp, sp                       ; UNKNOWN
0407FC  57                    PUSH   di                           ; UNKNOWN
0407FD  56                    PUSH   si                           ; UNKNOWN
0407FE  2B FF                 SUB    di, di                       ; UNKNOWN
040800  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4       ; UNKNOWN
040804  7D 15                 JGE    0x4081b                      ; UNKNOWN
040806  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
040809  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04080C  9A F1 01 C9 33        LCALL  0x33c9, 0x1f1                ; UNKNOWN
040811  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040814  8A C8                 MOV    cl, al                       ; UNKNOWN
040816  BF 10 00              MOV    di, 0x10                     ; UNKNOWN
040819  D3 E7                 SHL    di, cl                       ; UNKNOWN
04081B  2B F6                 SUB    si, si                       ; UNKNOWN
04081D  56                    PUSH   si                           ; UNKNOWN
04081E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
040821  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
040824  0E                    PUSH   cs                           ; UNKNOWN
040825  E8 37 FF              CALL   0x4075f                      ; UNKNOWN
040828  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04082B  0B C0                 OR     ax, ax                       ; UNKNOWN
04082D  74 09                 JE     0x40838                      ; UNKNOWN
04082F  8B CE                 MOV    cx, si                       ; UNKNOWN
040831  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
040834  D3 E0                 SHL    ax, cl                       ; UNKNOWN
040836  0B F8                 OR     di, ax                       ; UNKNOWN
040838  46                    INC    si                           ; UNKNOWN
040839  83 FE 04              CMP    si, 4                        ; UNKNOWN
04083C  7C DF                 JL     0x4081d                      ; UNKNOWN
04083E  8B C7                 MOV    ax, di                       ; UNKNOWN
040840  5E                    POP    si                           ; UNKNOWN
040841  5F                    POP    di                           ; UNKNOWN
040842  C9                    LEAVE                               ; UNKNOWN
040843  CB                    RETF                                ; UNKNOWN
