; ============================================================================
; func_03051F_unknown
; Region   : load_image
; Bytes    : file 0x03051F..0x03054C  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03051F  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
030523  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
030526  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
030529  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03052C  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
030530  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
030532  2A E4                 SUB    ah, ah                       ; UNKNOWN
030534  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
030537  2A F6                 SUB    dh, dh                       ; UNKNOWN
030539  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
03053E  EB 36                 JMP    0x30576                      ; UNKNOWN
030540  6B 5E FA 1C           IMUL   bx, word ptr [bp - 6], 0x1c  ; UNKNOWN
030544  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
030548  2A FF                 SUB    bh, bh                       ; UNKNOWN
03054A  8B C3                 MOV    ax, bx                       ; UNKNOWN
