; ============================================================================
; func_01844C_unknown
; Region   : load_image
; Bytes    : file 0x01844C..0x018475  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01844C  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
018450  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
018453  8A 87 BA 08           MOV    al, byte ptr [bx + 0x8ba]    ; UNKNOWN
018457  98                    CWDE                                ; UNKNOWN
018458  0B C0                 OR     ax, ax                       ; UNKNOWN
01845A  74 17                 JE     0x18473                      ; UNKNOWN
01845C  FF 36 76 09           PUSH   word ptr [0x976]             ; UNKNOWN
018460  FF 36 74 09           PUSH   word ptr [0x974]             ; UNKNOWN
018464  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
018467  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
01846B  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
01846E  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
018473  C9                    LEAVE                               ; UNKNOWN
018474  CB                    RETF                                ; UNKNOWN
