; ============================================================================
; func_01C2DE_unknown
; Region   : load_image
; Bytes    : file 0x01C2DE..0x01C2FE  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01C2DE  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
01C2E2  56                    PUSH   si                           ; UNKNOWN
01C2E3  83 3E DB 0A 00        CMP    word ptr [0xadb], 0          ; UNKNOWN
01C2E8  75 03                 JNE    0x1c2ed                      ; UNKNOWN
01C2EA  E9 E0 00              JMP    0x1c3cd                      ; UNKNOWN
01C2ED  6A 47                 PUSH   0x47                         ; UNKNOWN
01C2EF  6A 00                 PUSH   0                            ; UNKNOWN
01C2F1  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
01C2F4  83 E8 7F              SUB    ax, 0x7f                     ; UNKNOWN
01C2F7  50                    PUSH   ax                           ; UNKNOWN
01C2F8  9A 08 00 C2 44        LCALL  0x44c2, 8                    ; UNKNOWN
01C2FD  83                    DB     0x83                         ; UNKNOWN (raw)
