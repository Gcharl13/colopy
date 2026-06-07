; ============================================================================
; func_03FD76_unknown
; Region   : load_image
; Bytes    : file 0x03FD76..0x03FDAB  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FD76  55                    PUSH   bp                           ; UNKNOWN
03FD77  8B EC                 MOV    bp, sp                       ; UNKNOWN
03FD79  57                    PUSH   di                           ; UNKNOWN
03FD7A  56                    PUSH   si                           ; UNKNOWN
03FD7B  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
03FD7E  2B FF                 SUB    di, di                       ; UNKNOWN
03FD80  8B C6                 MOV    ax, si                       ; UNKNOWN
03FD82  0E                    PUSH   cs                           ; UNKNOWN
03FD83  E8 F2 FD              CALL   0x3fb78                      ; UNKNOWN
03FD86  8B F0                 MOV    si, ax                       ; UNKNOWN
03FD88  0B F6                 OR     si, si                       ; UNKNOWN
03FD8A  7C 19                 JL     0x3fda5                      ; UNKNOWN
03FD8C  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
03FD8F  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
03FD92  38 87 82 88           CMP    byte ptr [bx - 0x777e], al   ; UNKNOWN
03FD96  75 01                 JNE    0x3fd99                      ; UNKNOWN
03FD98  47                    INC    di                           ; UNKNOWN
03FD99  8B C6                 MOV    ax, si                       ; UNKNOWN
03FD9B  0E                    PUSH   cs                           ; UNKNOWN
03FD9C  E8 1F FE              CALL   0x3fbbe                      ; UNKNOWN
03FD9F  8B F0                 MOV    si, ax                       ; UNKNOWN
03FDA1  0B F6                 OR     si, si                       ; UNKNOWN
03FDA3  7D E7                 JGE    0x3fd8c                      ; UNKNOWN
03FDA5  8B C7                 MOV    ax, di                       ; UNKNOWN
03FDA7  5E                    POP    si                           ; UNKNOWN
03FDA8  5F                    POP    di                           ; UNKNOWN
03FDA9  C9                    LEAVE                               ; UNKNOWN
03FDAA  CB                    RETF                                ; UNKNOWN
