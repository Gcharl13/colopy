; ============================================================================
; func_020BE2_unknown
; Region   : load_image
; Bytes    : file 0x020BE2..0x020C27  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020BE2  55                    PUSH   bp                           ; UNKNOWN
020BE3  8B EC                 MOV    bp, sp                       ; UNKNOWN
020BE5  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
020BE8  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
020BEA  3B 06 80 82           CMP    ax, word ptr [0x8280]        ; UNKNOWN
020BEE  7D 03                 JGE    0x20bf3                      ; UNKNOWN
020BF0  A1 80 82              MOV    ax, word ptr [0x8280]        ; UNKNOWN
020BF3  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
020BF5  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
020BF8  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
020BFA  3B 06 86 82           CMP    ax, word ptr [0x8286]        ; UNKNOWN
020BFE  7D 03                 JGE    0x20c03                      ; UNKNOWN
020C00  A1 86 82              MOV    ax, word ptr [0x8286]        ; UNKNOWN
020C03  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
020C05  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
020C08  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
020C0A  3B 06 50 85           CMP    ax, word ptr [0x8550]        ; UNKNOWN
020C0E  7E 03                 JLE    0x20c13                      ; UNKNOWN
020C10  A1 50 85              MOV    ax, word ptr [0x8550]        ; UNKNOWN
020C13  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
020C15  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
020C18  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
020C1A  3B 06 52 85           CMP    ax, word ptr [0x8552]        ; UNKNOWN
020C1E  7E 03                 JLE    0x20c23                      ; UNKNOWN
020C20  A1 52 85              MOV    ax, word ptr [0x8552]        ; UNKNOWN
020C23  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
020C25  C9                    LEAVE                               ; UNKNOWN
020C26  CB                    RETF                                ; UNKNOWN
