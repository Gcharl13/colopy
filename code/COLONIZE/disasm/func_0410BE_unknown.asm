; ============================================================================
; func_0410BE_unknown
; Region   : load_image
; Bytes    : file 0x0410BE..0x0410F0  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0410BE  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0410C2  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
0410C5  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
0410C8  FF 36 8E 0B           PUSH   word ptr [0xb8e]             ; UNKNOWN
0410CC  FF 36 8C 0B           PUSH   word ptr [0xb8c]             ; UNKNOWN
0410D0  FF 36 8A 0B           PUSH   word ptr [0xb8a]             ; UNKNOWN
0410D4  FF 36 88 0B           PUSH   word ptr [0xb88]             ; UNKNOWN
0410D8  6A 04                 PUSH   4                            ; UNKNOWN
0410DA  8A 4E 0A              MOV    cl, byte ptr [bp + 0xa]      ; UNKNOWN
0410DD  51                    PUSH   cx                           ; UNKNOWN
0410DE  8B D0                 MOV    dx, ax                       ; UNKNOWN
0410E0  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0410E3  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
0410E6  BB 04 00              MOV    bx, 4                        ; UNKNOWN
0410E9  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
0410EE  C9                    LEAVE                               ; UNKNOWN
0410EF  CB                    RETF                                ; UNKNOWN
