; ============================================================================
; func_00EA40_unknown
; Region   : load_image
; Bytes    : file 0x00EA40..0x00EA57  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EA40  55                    PUSH   bp                           ; UNKNOWN
00EA41  8B EC                 MOV    bp, sp                       ; UNKNOWN
00EA43  B4 4C                 MOV    ah, 0x4c                     ; UNKNOWN
00EA45  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
00EA48  CD 67                 INT    0x67                         ; UNKNOWN
00EA4A  8A C4                 MOV    al, ah                       ; UNKNOWN
00EA4C  32 E4                 XOR    ah, ah                       ; UNKNOWN
00EA4E  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00EA51  0B C0                 OR     ax, ax                       ; UNKNOWN
00EA53  75 0D                 JNE    0xea62                       ; UNKNOWN
00EA55  8B C3                 MOV    ax, bx                       ; UNKNOWN
