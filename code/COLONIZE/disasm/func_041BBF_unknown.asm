; ============================================================================
; func_041BBF_unknown
; Region   : load_image
; Bytes    : file 0x041BBF..0x041C19  (90 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041BBF  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
041BC3  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
041BC8  80 3E 94 0B 00        CMP    byte ptr [0xb94], 0          ; UNKNOWN
041BCD  75 08                 JNE    0x41bd7                      ; UNKNOWN
041BCF  68 7B 27              PUSH   0x277b                       ; UNKNOWN
041BD2  68 7E 27              PUSH   0x277e                       ; UNKNOWN
041BD5  EB 06                 JMP    0x41bdd                      ; UNKNOWN
041BD7  68 8A 27              PUSH   0x278a                       ; UNKNOWN
041BDA  68 8D 27              PUSH   0x278d                       ; UNKNOWN
041BDD  9A A2 03 65 5F        LCALL  0x5f65, 0x3a2                ; UNKNOWN
041BE2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041BE5  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
041BE8  0B C0                 OR     ax, ax                       ; UNKNOWN
041BEA  74 1D                 JE     0x41c09                      ; UNKNOWN
041BEC  C6 06 94 0B 01        MOV    byte ptr [0xb94], 1          ; UNKNOWN
041BF1  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
041BF4  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
041BF7  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
041BFA  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
041BFD  68 99 27              PUSH   0x2799                       ; UNKNOWN
041C00  50                    PUSH   ax                           ; UNKNOWN
041C01  9A B8 03 65 5F        LCALL  0x5f65, 0x3b8                ; UNKNOWN
041C06  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
041C09  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
041C0D  74 08                 JE     0x41c17                      ; UNKNOWN
041C0F  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
041C12  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
041C17  C9                    LEAVE                               ; UNKNOWN
041C18  CB                    RETF                                ; UNKNOWN
