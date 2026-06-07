; ============================================================================
; func_03FF7A_unknown
; Region   : load_image
; Bytes    : file 0x03FF7A..0x03FFAC  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FF7A  55                    PUSH   bp                           ; UNKNOWN
03FF7B  8B EC                 MOV    bp, sp                       ; UNKNOWN
03FF7D  57                    PUSH   di                           ; UNKNOWN
03FF7E  56                    PUSH   si                           ; UNKNOWN
03FF7F  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03FF82  0E                    PUSH   cs                           ; UNKNOWN
03FF83  E8 F2 FB              CALL   0x3fb78                      ; UNKNOWN
03FF86  8B F0                 MOV    si, ax                       ; UNKNOWN
03FF88  0B F6                 OR     si, si                       ; UNKNOWN
03FF8A  7C 1C                 JL     0x3ffa8                      ; UNKNOWN
03FF8C  8B C6                 MOV    ax, si                       ; UNKNOWN
03FF8E  0E                    PUSH   cs                           ; UNKNOWN
03FF8F  E8 2C FC              CALL   0x3fbbe                      ; UNKNOWN
03FF92  8B F8                 MOV    di, ax                       ; UNKNOWN
03FF94  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
03FF97  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03FF9A  56                    PUSH   si                           ; UNKNOWN
03FF9B  0E                    PUSH   cs                           ; UNKNOWN
03FF9C  E8 32 FF              CALL   0x3fed1                      ; UNKNOWN
03FF9F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03FFA2  8B F7                 MOV    si, di                       ; UNKNOWN
03FFA4  0B F6                 OR     si, si                       ; UNKNOWN
03FFA6  7D E4                 JGE    0x3ff8c                      ; UNKNOWN
03FFA8  5E                    POP    si                           ; UNKNOWN
03FFA9  5F                    POP    di                           ; UNKNOWN
03FFAA  C9                    LEAVE                               ; UNKNOWN
03FFAB  CB                    RETF                                ; UNKNOWN
