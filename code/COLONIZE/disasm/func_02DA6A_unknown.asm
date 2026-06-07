; ============================================================================
; func_02DA6A_unknown
; Region   : load_image
; Bytes    : file 0x02DA6A..0x02DA87  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DA6A  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02DA6E  0E                    PUSH   cs                           ; UNKNOWN
02DA6F  E8 E4 FF              CALL   0x2da56                      ; UNKNOWN
02DA72  48                    DEC    ax                           ; UNKNOWN
02DA73  74 08                 JE     0x2da7d                      ; UNKNOWN
02DA75  48                    DEC    ax                           ; UNKNOWN
02DA76  74 0F                 JE     0x2da87                      ; UNKNOWN
02DA78  48                    DEC    ax                           ; UNKNOWN
02DA79  74 16                 JE     0x2da91                      ; UNKNOWN
02DA7B  EB 1E                 JMP    0x2da9b                      ; UNKNOWN
02DA7D  C7 46 FE 04 00        MOV    word ptr [bp - 2], 4         ; UNKNOWN
02DA82  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02DA85  C9                    LEAVE                               ; UNKNOWN
02DA86  CB                    RETF                                ; UNKNOWN
