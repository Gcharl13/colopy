; ============================================================================
; func_063B6C_unknown
; Region   : load_image
; Bytes    : file 0x063B6C..0x063B97  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063B6C  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
063B70  56                    PUSH   si                           ; UNKNOWN
063B71  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
063B74  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
063B77  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
063B7A  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
063B7D  0B C0                 OR     ax, ax                       ; UNKNOWN
063B7F  75 03                 JNE    0x63b84                      ; UNKNOWN
063B81  E9 E8 00              JMP    0x63c6c                      ; UNKNOWN
063B84  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
063B88  75 03                 JNE    0x63b8d                      ; UNKNOWN
063B8A  E9 DF 00              JMP    0x63c6c                      ; UNKNOWN
063B8D  8B 56 1E              MOV    dx, word ptr [bp + 0x1e]     ; UNKNOWN
063B90  8B 46 16              MOV    ax, word ptr [bp + 0x16]     ; UNKNOWN
063B93  2B C2                 SUB    ax, dx                       ; UNKNOWN
063B95  0B C0                 OR     ax, ax                       ; UNKNOWN
