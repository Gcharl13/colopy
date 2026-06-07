; ============================================================================
; func_00E9CA_unknown
; Region   : load_image
; Bytes    : file 0x00E9CA..0x00E9FC  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E9CA  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
00E9CE  56                    PUSH   si                           ; UNKNOWN
00E9CF  6A 08                 PUSH   8                            ; UNKNOWN
00E9D1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00E9D4  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
00E9D7  50                    PUSH   ax                           ; UNKNOWN
00E9D8  9A 24 08 65 5F        LCALL  0x5f65, 0x824                ; UNKNOWN
00E9DD  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00E9E0  8D 76 F8              LEA    si, [bp - 8]                 ; UNKNOWN
00E9E3  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
00E9E6  B8 01 53              MOV    ax, 0x5301                   ; UNKNOWN
00E9E9  CD 67                 INT    0x67                         ; UNKNOWN
00E9EB  8A C4                 MOV    al, ah                       ; UNKNOWN
00E9ED  32 E4                 XOR    ah, ah                       ; UNKNOWN
00E9EF  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00E9F2  0B C0                 OR     ax, ax                       ; UNKNOWN
00E9F4  75 06                 JNE    0xe9fc                       ; UNKNOWN
00E9F6  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00E9F9  5E                    POP    si                           ; UNKNOWN
00E9FA  C9                    LEAVE                               ; UNKNOWN
00E9FB  CB                    RETF                                ; UNKNOWN
