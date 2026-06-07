; ============================================================================
; func_020F72_unknown
; Region   : load_image
; Bytes    : file 0x020F72..0x020FAC  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

020F72  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
020F76  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
020F7B  83 3E F2 82 00        CMP    word ptr [0x82f2], 0         ; UNKNOWN
020F80  7F 12                 JG     0x20f94                      ; UNKNOWN
020F82  7C 08                 JL     0x20f8c                      ; UNKNOWN
020F84  81 3E F0 82 E0 2E     CMP    word ptr [0x82f0], 0x2ee0    ; UNKNOWN
020F8A  77 08                 JA     0x20f94                      ; UNKNOWN
020F8C  C7 06 0A 0B 00 00     MOV    word ptr [0xb0a], 0          ; UNKNOWN
020F92  EB 06                 JMP    0x20f9a                      ; UNKNOWN
020F94  C7 06 0A 0B 01 00     MOV    word ptr [0xb0a], 1          ; UNKNOWN
020F9A  83 3E 0A 0B 00        CMP    word ptr [0xb0a], 0          ; UNKNOWN
020F9F  74 0B                 JE     0x20fac                      ; UNKNOWN
020FA1  C7 06 08 0B 0F 27     MOV    word ptr [0xb08], 0x270f     ; UNKNOWN
020FA7  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
020FAA  C9                    LEAVE                               ; UNKNOWN
020FAB  CB                    RETF                                ; UNKNOWN
