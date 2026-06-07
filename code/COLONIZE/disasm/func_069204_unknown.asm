; ============================================================================
; func_069204_unknown
; Region   : load_image
; Bytes    : file 0x069204..0x06922C  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069204  55                    PUSH   bp                           ; UNKNOWN
069205  8B EC                 MOV    bp, sp                       ; UNKNOWN
069207  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
06920A  3B 1E 45 12           CMP    bx, word ptr [0x1245]        ; UNKNOWN
06920E  73 C8                 JAE    0x691d8                      ; UNKNOWN
069210  8B 4E 08              MOV    cx, word ptr [bp + 8]        ; UNKNOWN
069213  3B 0E 45 12           CMP    cx, word ptr [0x1245]        ; UNKNOWN
069217  73 BF                 JAE    0x691d8                      ; UNKNOWN
069219  B4 46                 MOV    ah, 0x46                     ; UNKNOWN
06921B  CD 21                 INT    0x21                         ; UNKNOWN
06921D  72 0A                 JB     0x69229                      ; UNKNOWN
06921F  8A 97 47 12           MOV    dl, byte ptr [bx + 0x1247]   ; UNKNOWN
069223  8B D9                 MOV    bx, cx                       ; UNKNOWN
069225  88 97 47 12           MOV    byte ptr [bx + 0x1247], dl   ; UNKNOWN
069229  E9 30 0C              JMP    0x69e5c                      ; UNKNOWN
