; ============================================================================
; func_016B7A_unknown
; Region   : load_image
; Bytes    : file 0x016B7A..0x016BB9  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016B7A  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
016B7E  9A 0A 00 BB 0D        LCALL  0xdbb, 0xa                   ; UNKNOWN
016B83  8B C8                 MOV    cx, ax                       ; UNKNOWN
016B85  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
016B88  2B 46 06              SUB    ax, word ptr [bp + 6]        ; UNKNOWN
016B8B  40                    INC    ax                           ; UNKNOWN
016B8C  F7 E9                 IMUL   cx                           ; UNKNOWN
016B8E  8A C4                 MOV    al, ah                       ; UNKNOWN
016B90  8A E2                 MOV    ah, dl                       ; UNKNOWN
016B92  8A D6                 MOV    dl, dh                       ; UNKNOWN
016B94  D0 E6                 SHL    dh, 1                        ; UNKNOWN
016B96  1A F6                 SBB    dh, dh                       ; UNKNOWN
016B98  D1 FA                 SAR    dx, 1                        ; UNKNOWN
016B9A  D1 D8                 RCR    ax, 1                        ; UNKNOWN
016B9C  D1 FA                 SAR    dx, 1                        ; UNKNOWN
016B9E  D1 D8                 RCR    ax, 1                        ; UNKNOWN
016BA0  D1 FA                 SAR    dx, 1                        ; UNKNOWN
016BA2  D1 D8                 RCR    ax, 1                        ; UNKNOWN
016BA4  D1 FA                 SAR    dx, 1                        ; UNKNOWN
016BA6  D1 D8                 RCR    ax, 1                        ; UNKNOWN
016BA8  D1 FA                 SAR    dx, 1                        ; UNKNOWN
016BAA  D1 D8                 RCR    ax, 1                        ; UNKNOWN
016BAC  D1 FA                 SAR    dx, 1                        ; UNKNOWN
016BAE  D1 D8                 RCR    ax, 1                        ; UNKNOWN
016BB0  D1 FA                 SAR    dx, 1                        ; UNKNOWN
016BB2  D1 D8                 RCR    ax, 1                        ; UNKNOWN
016BB4  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
016BB7  C9                    LEAVE                               ; UNKNOWN
016BB8  CB                    RETF                                ; UNKNOWN
