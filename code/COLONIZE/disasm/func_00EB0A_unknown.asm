; ============================================================================
; func_00EB0A_unknown
; Region   : load_image
; Bytes    : file 0x00EB0A..0x00EB27  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EB0A  55                    PUSH   bp                           ; UNKNOWN
00EB0B  8B EC                 MOV    bp, sp                       ; UNKNOWN
00EB0D  57                    PUSH   di                           ; UNKNOWN
00EB0E  B8 00 58              MOV    ax, 0x5800                   ; UNKNOWN
00EB11  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
00EB14  CD 67                 INT    0x67                         ; UNKNOWN
00EB16  8A C4                 MOV    al, ah                       ; UNKNOWN
00EB18  32 E4                 XOR    ah, ah                       ; UNKNOWN
00EB1A  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00EB1D  0B C0                 OR     ax, ax                       ; UNKNOWN
00EB1F  75 07                 JNE    0xeb28                       ; UNKNOWN
00EB21  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00EB24  5F                    POP    di                           ; UNKNOWN
00EB25  C9                    LEAVE                               ; UNKNOWN
00EB26  CB                    RETF                                ; UNKNOWN
