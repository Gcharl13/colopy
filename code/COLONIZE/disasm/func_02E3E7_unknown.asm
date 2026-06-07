; ============================================================================
; func_02E3E7_unknown
; Region   : load_image
; Bytes    : file 0x02E3E7..0x02E404  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E3E7  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E3EB  56                    PUSH   si                           ; UNKNOWN
02E3EC  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E3F0  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E3F3  98                    CWDE                                ; UNKNOWN
02E3F4  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
02E3F7  7E 0B                 JLE    0x2e404                      ; UNKNOWN
02E3F9  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02E3FC  8A 40 20              MOV    al, byte ptr [bx + si + 0x20] ; UNKNOWN
02E3FF  2A E4                 SUB    ah, ah                       ; UNKNOWN
02E401  5E                    POP    si                           ; UNKNOWN
02E402  C9                    LEAVE                               ; UNKNOWN
02E403  CB                    RETF                                ; UNKNOWN
