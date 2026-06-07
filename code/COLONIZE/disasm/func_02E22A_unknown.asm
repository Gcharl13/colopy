; ============================================================================
; func_02E22A_unknown
; Region   : load_image
; Bytes    : file 0x02E22A..0x02E24B  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E22A  55                    PUSH   bp                           ; UNKNOWN
02E22B  8B EC                 MOV    bp, sp                       ; UNKNOWN
02E22D  56                    PUSH   si                           ; UNKNOWN
02E22E  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02E231  D1 E6                 SHL    si, 1                        ; UNKNOWN
02E233  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E237  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; UNKNOWN
02E23B  03 84 88 73           ADD    ax, word ptr [si + 0x7388]   ; UNKNOWN
02E23F  3B 84 C9 73           CMP    ax, word ptr [si + 0x73c9]   ; UNKNOWN
02E243  7E 06                 JLE    0x2e24b                      ; UNKNOWN
02E245  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02E248  5E                    POP    si                           ; UNKNOWN
02E249  C9                    LEAVE                               ; UNKNOWN
02E24A  CB                    RETF                                ; UNKNOWN
