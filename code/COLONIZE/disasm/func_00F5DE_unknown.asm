; ============================================================================
; func_00F5DE_unknown
; Region   : load_image
; Bytes    : file 0x00F5DE..0x00F5FF  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F5DE  55                    PUSH   bp                           ; UNKNOWN
00F5DF  8B EC                 MOV    bp, sp                       ; UNKNOWN
00F5E1  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
00F5E5  74 16                 JE     0xf5fd                       ; UNKNOWN
00F5E7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00F5EA  68 88 32              PUSH   0x3288                       ; UNKNOWN
00F5ED  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00F5F2  C7 06 86 32 88 32     MOV    word ptr [0x3286], 0x3288    ; UNKNOWN
00F5F8  C6 06 D8 06 01        MOV    byte ptr [0x6d8], 1          ; UNKNOWN
00F5FD  C9                    LEAVE                               ; UNKNOWN
00F5FE  CB                    RETF                                ; UNKNOWN
