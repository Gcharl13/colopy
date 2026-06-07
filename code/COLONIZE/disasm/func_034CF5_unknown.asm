; ============================================================================
; func_034CF5_unknown
; Region   : load_image
; Bytes    : file 0x034CF5..0x034D4F  (90 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034CF5  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
034CF9  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
034CFC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
034CFF  9A 19 31 5F 24        LCALL  0x245f, 0x3119               ; UNKNOWN
034D04  83 C4 04              ADD    sp, 4                        ; UNKNOWN
034D07  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
034D0A  0B C0                 OR     ax, ax                       ; UNKNOWN
034D0C  7C 3C                 JL     0x34d4a                      ; UNKNOWN
034D0E  A1 84 73              MOV    ax, word ptr [0x7384]        ; UNKNOWN
034D11  3B 46 0A              CMP    ax, word ptr [bp + 0xa]      ; UNKNOWN
034D14  7E 18                 JLE    0x34d2e                      ; UNKNOWN
034D16  2B 46 0A              SUB    ax, word ptr [bp + 0xa]      ; UNKNOWN
034D19  50                    PUSH   ax                           ; UNKNOWN
034D1A  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
034D1D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
034D20  9A 55 30 5F 24        LCALL  0x245f, 0x3055               ; UNKNOWN
034D25  83 C4 06              ADD    sp, 6                        ; UNKNOWN
034D28  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
034D2B  A3 84 73              MOV    word ptr [0x7384], ax        ; UNKNOWN
034D2E  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
034D31  0E                    PUSH   cs                           ; UNKNOWN
034D32  E8 2E E1              CALL   0x32e63                      ; UNKNOWN
034D35  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034D38  F7 2E 84 73           IMUL   word ptr [0x7384]            ; UNKNOWN
034D3C  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
034D3F  FF 36 84 73           PUSH   word ptr [0x7384]            ; UNKNOWN
034D43  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
034D46  0E                    PUSH   cs                           ; UNKNOWN
034D47  E8 9B FE              CALL   0x34be5                      ; UNKNOWN
034D4A  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
034D4D  C9                    LEAVE                               ; UNKNOWN
034D4E  CB                    RETF                                ; UNKNOWN
