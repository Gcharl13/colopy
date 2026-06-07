; ============================================================================
; func_05EC57_unknown
; Region   : load_image
; Bytes    : file 0x05EC57..0x05EC99  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05EC57  C8 C0 01 00           ENTER  0x1c0, 0                     ; UNKNOWN
05EC5B  57                    PUSH   di                           ; UNKNOWN
05EC5C  56                    PUSH   si                           ; UNKNOWN
05EC5D  2B C0                 SUB    ax, ax                       ; UNKNOWN
05EC5F  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
05EC62  89 86 76 FF           MOV    word ptr [bp - 0x8a], ax     ; UNKNOWN
05EC66  89 46 80              MOV    word ptr [bp - 0x80], ax     ; UNKNOWN
05EC69  89 86 70 FF           MOV    word ptr [bp - 0x90], ax     ; UNKNOWN
05EC6D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
05EC70  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
05EC75  83 C4 02              ADD    sp, 2                        ; UNKNOWN
05EC78  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05EC7C  80 3F 2E              CMP    byte ptr [bx], 0x2e          ; UNKNOWN
05EC7F  75 0D                 JNE    0x5ec8e                      ; UNKNOWN
05EC81  80 7F 01 14           CMP    byte ptr [bx + 1], 0x14      ; UNKNOWN
05EC85  75 07                 JNE    0x5ec8e                      ; UNKNOWN
05EC87  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
05EC8C  EB 05                 JMP    0x5ec93                      ; UNKNOWN
05EC8E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
05EC93  6A 02                 PUSH   2                            ; UNKNOWN
05EC95  6A 00                 PUSH   0                            ; UNKNOWN
05EC97  8B C3                 MOV    ax, bx                       ; UNKNOWN
