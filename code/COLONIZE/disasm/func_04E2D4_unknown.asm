; ============================================================================
; func_04E2D4_unknown
; Region   : load_image
; Bytes    : file 0x04E2D4..0x04E2EB  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E2D4  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
04E2D8  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04E2DB  99                    CDQ                                 ; UNKNOWN
04E2DC  8A F2                 MOV    dh, dl                       ; UNKNOWN
04E2DE  8A D4                 MOV    dl, ah                       ; UNKNOWN
04E2E0  8A E0                 MOV    ah, al                       ; UNKNOWN
04E2E2  2A C0                 SUB    al, al                       ; UNKNOWN
04E2E4  9A FC 00 4F 00        LCALL  0x4f, 0xfc                   ; UNKNOWN
04E2E9  C9                    LEAVE                               ; UNKNOWN
04E2EA  CB                    RETF                                ; UNKNOWN
