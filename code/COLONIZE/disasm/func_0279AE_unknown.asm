; ============================================================================
; func_0279AE_unknown
; Region   : load_image
; Bytes    : file 0x0279AE..0x0279C6  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0279AE  55                    PUSH   bp                           ; UNKNOWN
0279AF  8B EC                 MOV    bp, sp                       ; UNKNOWN
0279B1  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0279B4  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
0279B7  A3 1C 0A              MOV    word ptr [0xa1c], ax         ; UNKNOWN
0279BA  89 16 1E 0A           MOV    word ptr [0xa1e], dx         ; UNKNOWN
0279BE  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
0279C1  A3 20 0A              MOV    word ptr [0xa20], ax         ; UNKNOWN
0279C4  C9                    LEAVE                               ; UNKNOWN
0279C5  CB                    RETF                                ; UNKNOWN
