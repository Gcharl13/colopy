; ============================================================================
; func_030932_unknown
; Region   : load_image
; Bytes    : file 0x030932..0x030959  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030932  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
030936  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
03093B  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
03093E  50                    PUSH   ax                           ; UNKNOWN
03093F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030942  0E                    PUSH   cs                           ; UNKNOWN
030943  E8 3C FF              CALL   0x30882                      ; UNKNOWN
030946  83 C4 04              ADD    sp, 4                        ; UNKNOWN
030949  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03094C  48                    DEC    ax                           ; UNKNOWN
03094D  74 05                 JE     0x30954                      ; UNKNOWN
03094F  48                    DEC    ax                           ; UNKNOWN
030950  74 28                 JE     0x3097a                      ; UNKNOWN
030952  EB 6E                 JMP    0x309c2                      ; UNKNOWN
030954  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
030957  8B C3                 MOV    ax, bx                       ; UNKNOWN
