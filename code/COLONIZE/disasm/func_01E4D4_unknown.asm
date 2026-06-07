; ============================================================================
; func_01E4D4_unknown
; Region   : load_image
; Bytes    : file 0x01E4D4..0x01E4FC  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01E4D4  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
01E4D8  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01E4DB  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
01E4E0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01E4E3  8B 1E 34 82           MOV    bx, word ptr [0x8234]        ; UNKNOWN
01E4E7  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
01E4EA  2A E4                 SUB    ah, ah                       ; UNKNOWN
01E4EC  50                    PUSH   ax                           ; UNKNOWN
01E4ED  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
01E4EF  50                    PUSH   ax                           ; UNKNOWN
01E4F0  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
01E4F3  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
01E4F6  9A 74 00 C2 44        LCALL  0x44c2, 0x74                 ; UNKNOWN
01E4FB  83                    DB     0x83                         ; UNKNOWN (raw)
