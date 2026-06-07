; ============================================================================
; func_01C194_unknown
; Region   : load_image
; Bytes    : file 0x01C194..0x01C1C3  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01C194  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
01C198  81 3E E4 0E 93 00     CMP    word ptr [0xee4], 0x93       ; UNKNOWN
01C19E  7D 07                 JGE    0x1c1a7                      ; UNKNOWN
01C1A0  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
01C1A5  EB 05                 JMP    0x1c1ac                      ; UNKNOWN
01C1A7  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
01C1AC  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
01C1B0  75 1B                 JNE    0x1c1cd                      ; UNKNOWN
01C1B2  6A 47                 PUSH   0x47                         ; UNKNOWN
01C1B4  6A 00                 PUSH   0                            ; UNKNOWN
01C1B6  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
01C1B9  2D 82 00              SUB    ax, 0x82                     ; UNKNOWN
01C1BC  50                    PUSH   ax                           ; UNKNOWN
01C1BD  9A 08 00 C2 44        LCALL  0x44c2, 8                    ; UNKNOWN
01C1C2  83                    DB     0x83                         ; UNKNOWN (raw)
