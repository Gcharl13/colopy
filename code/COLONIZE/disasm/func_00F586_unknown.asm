; ============================================================================
; func_00F586_unknown
; Region   : load_image
; Bytes    : file 0x00F586..0x00F5DD  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F586  55                    PUSH   bp                           ; UNKNOWN
00F587  8B EC                 MOV    bp, sp                       ; UNKNOWN
00F589  80 3E D8 06 00        CMP    byte ptr [0x6d8], 0          ; UNKNOWN
00F58E  75 2F                 JNE    0xf5bf                       ; UNKNOWN
00F590  68 D2 06              PUSH   0x6d2                        ; UNKNOWN
00F593  9A 04 00 A7 06        LCALL  0x6a7, 4                     ; UNKNOWN
00F598  8B E5                 MOV    sp, bp                       ; UNKNOWN
00F59A  0B C0                 OR     ax, ax                       ; UNKNOWN
00F59C  74 16                 JE     0xf5b4                       ; UNKNOWN
00F59E  68 D2 06              PUSH   0x6d2                        ; UNKNOWN
00F5A1  68 88 32              PUSH   0x3288                       ; UNKNOWN
00F5A4  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
00F5A9  8B E5                 MOV    sp, bp                       ; UNKNOWN
00F5AB  C7 06 86 32 88 32     MOV    word ptr [0x3286], 0x3288    ; UNKNOWN
00F5B1  EB 07                 JMP    0xf5ba                       ; UNKNOWN
00F5B3  90                    NOP                                 ; UNKNOWN
00F5B4  C7 06 86 32 00 00     MOV    word ptr [0x3286], 0         ; UNKNOWN
00F5BA  C6 06 D8 06 01        MOV    byte ptr [0x6d8], 1          ; UNKNOWN
00F5BF  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00F5C2  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
00F5C5  1E                    PUSH   ds                           ; UNKNOWN
00F5C6  FF 36 86 32           PUSH   word ptr [0x3286]            ; UNKNOWN
00F5CA  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
00F5CD  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
00F5D0  9A 04 00 9D 06        LCALL  0x69d, 4                     ; UNKNOWN
00F5D5  8B 46 04              MOV    ax, word ptr [bp + 4]        ; UNKNOWN
00F5D8  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
00F5DB  C9                    LEAVE                               ; UNKNOWN
00F5DC  C3                    RET                                 ; UNKNOWN
