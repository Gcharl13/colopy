; ============================================================================
; func_03FFAC_unknown
; Region   : load_image
; Bytes    : file 0x03FFAC..0x03FFCB  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FFAC  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03FFB0  56                    PUSH   si                           ; UNKNOWN
03FFB1  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
03FFB4  0B F6                 OR     si, si                       ; UNKNOWN
03FFB6  7C 24                 JL     0x3ffdc                      ; UNKNOWN
03FFB8  39 76 06              CMP    word ptr [bp + 6], si        ; UNKNOWN
03FFBB  75 13                 JNE    0x3ffd0                      ; UNKNOWN
03FFBD  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
03FFC0  50                    PUSH   ax                           ; UNKNOWN
03FFC1  8D 46 06              LEA    ax, [bp + 6]                 ; UNKNOWN
03FFC4  50                    PUSH   ax                           ; UNKNOWN
03FFC5  9A 25 00 C2 44        LCALL  0x44c2, 0x25                 ; UNKNOWN
03FFCA  83                    DB     0x83                         ; UNKNOWN (raw)
