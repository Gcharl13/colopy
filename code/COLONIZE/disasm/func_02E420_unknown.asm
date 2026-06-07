; ============================================================================
; func_02E420_unknown
; Region   : load_image
; Bytes    : file 0x02E420..0x02E43D  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E420  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E424  56                    PUSH   si                           ; UNKNOWN
02E425  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E429  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E42C  98                    CWDE                                ; UNKNOWN
02E42D  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
02E430  7E 0B                 JLE    0x2e43d                      ; UNKNOWN
02E432  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02E435  8A 40 40              MOV    al, byte ptr [bx + si + 0x40] ; UNKNOWN
02E438  2A E4                 SUB    ah, ah                       ; UNKNOWN
02E43A  5E                    POP    si                           ; UNKNOWN
02E43B  C9                    LEAVE                               ; UNKNOWN
02E43C  CB                    RETF                                ; UNKNOWN
