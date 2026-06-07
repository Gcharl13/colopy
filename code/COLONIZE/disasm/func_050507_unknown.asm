; ============================================================================
; func_050507_unknown
; Region   : load_image
; Bytes    : file 0x050507..0x05051C  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

050507  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
05050B  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
050510  EB 40                 JMP    0x50552                      ; UNKNOWN
050512  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
050516  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
05051A  8B C3                 MOV    ax, bx                       ; UNKNOWN
