; ============================================================================
; func_04DF12_unknown
; Region   : load_image
; Bytes    : file 0x04DF12..0x04DF3F  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04DF12  55                    PUSH   bp                           ; UNKNOWN
04DF13  8B EC                 MOV    bp, sp                       ; UNKNOWN
04DF15  9A 4C 00 1E 5C        LCALL  0x5c1e, 0x4c                 ; UNKNOWN
04DF1A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04DF1D  68 00 A0              PUSH   0xa000                       ; UNKNOWN
04DF20  6A 00                 PUSH   0                            ; UNKNOWN
04DF22  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04DF26  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04DF2A  9A 26 01 57 5E        LCALL  0x5e57, 0x126                ; UNKNOWN
04DF2F  8B E5                 MOV    sp, bp                       ; UNKNOWN
04DF31  83 3E 92 CE 00        CMP    word ptr [0xce92], 0         ; UNKNOWN
04DF36  74 05                 JE     0x4df3d                      ; UNKNOWN
04DF38  9A 07 00 1E 5C        LCALL  0x5c1e, 7                    ; UNKNOWN
04DF3D  C9                    LEAVE                               ; UNKNOWN
04DF3E  CB                    RETF                                ; UNKNOWN
