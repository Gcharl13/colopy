; ============================================================================
; func_00EAE8_unknown
; Region   : load_image
; Bytes    : file 0x00EAE8..0x00EB05  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EAE8  55                    PUSH   bp                           ; UNKNOWN
00EAE9  8B EC                 MOV    bp, sp                       ; UNKNOWN
00EAEB  B8 01 58              MOV    ax, 0x5801                   ; UNKNOWN
00EAEE  CD 67                 INT    0x67                         ; UNKNOWN
00EAF0  8A C4                 MOV    al, ah                       ; UNKNOWN
00EAF2  32 E4                 XOR    ah, ah                       ; UNKNOWN
00EAF4  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00EAF7  0B C0                 OR     ax, ax                       ; UNKNOWN
00EAF9  75 0B                 JNE    0xeb06                       ; UNKNOWN
00EAFB  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
00EAFE  89 0F                 MOV    word ptr [bx], cx            ; UNKNOWN
00EB00  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00EB03  C9                    LEAVE                               ; UNKNOWN
00EB04  CB                    RETF                                ; UNKNOWN
