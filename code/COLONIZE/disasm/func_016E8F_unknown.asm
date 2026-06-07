; ============================================================================
; func_016E8F_unknown
; Region   : load_image
; Bytes    : file 0x016E8F..0x016EF7  (104 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016E8F  C8 40 00 00           ENTER  0x40, 0                      ; UNKNOWN
016E93  56                    PUSH   si                           ; UNKNOWN
016E94  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
016E99  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
016E9C  9A F7 0D 5F 24        LCALL  0x245f, 0xdf7                ; UNKNOWN
016EA1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
016EA4  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
016EA7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
016EAA  9A 30 0E 5F 24        LCALL  0x245f, 0xe30                ; UNKNOWN
016EAF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
016EB2  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
016EB5  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
016EB8  39 46 F2              CMP    word ptr [bp - 0xe], ax      ; UNKNOWN
016EBB  75 03                 JNE    0x16ec0                      ; UNKNOWN
016EBD  E9 D6 01              JMP    0x17096                      ; UNKNOWN
016EC0  50                    PUSH   ax                           ; UNKNOWN
016EC1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
016EC4  9A C1 0F 5F 24        LCALL  0x245f, 0xfc1                ; UNKNOWN
016EC9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
016ECC  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
016ECF  83 F8 02              CMP    ax, 2                        ; UNKNOWN
016ED2  75 60                 JNE    0x16f34                      ; UNKNOWN
016ED4  6A 00                 PUSH   0                            ; UNKNOWN
016ED6  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
016EDB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
016EDE  0B C0                 OR     ax, ax                       ; UNKNOWN
016EE0  74 15                 JE     0x16ef7                      ; UNKNOWN
016EE2  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
016EE6  80 7F 1F 03           CMP    byte ptr [bx + 0x1f], 3      ; UNKNOWN
016EEA  7F 0B                 JG     0x16ef7                      ; UNKNOWN
016EEC  C7 46 F8 15 00        MOV    word ptr [bp - 8], 0x15      ; UNKNOWN
016EF1  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
016EF4  5E                    POP    si                           ; UNKNOWN
016EF5  C9                    LEAVE                               ; UNKNOWN
016EF6  CB                    RETF                                ; UNKNOWN
