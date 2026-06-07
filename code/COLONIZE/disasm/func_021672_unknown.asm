; ============================================================================
; func_021672_unknown
; Region   : load_image
; Bytes    : file 0x021672..0x021685  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021672  55                    PUSH   bp                           ; UNKNOWN
021673  8B EC                 MOV    bp, sp                       ; UNKNOWN
021675  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
021678  26 8A 1F              MOV    bl, byte ptr es:[bx]         ; UNKNOWN
02167B  2A FF                 SUB    bh, bh                       ; UNKNOWN
02167D  83 FB 06              CMP    bx, 6                        ; UNKNOWN
021680  75 01                 JNE    0x21683                      ; UNKNOWN
021682  4B                    DEC    bx                           ; UNKNOWN
021683  8B C3                 MOV    ax, bx                       ; UNKNOWN
