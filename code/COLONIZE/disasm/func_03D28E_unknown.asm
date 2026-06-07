; ============================================================================
; func_03D28E_unknown
; Region   : load_image
; Bytes    : file 0x03D28E..0x03D2BC  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D28E  55                    PUSH   bp                           ; UNKNOWN
03D28F  8B EC                 MOV    bp, sp                       ; UNKNOWN
03D291  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
03D294  24 1F                 AND    al, 0x1f                     ; UNKNOWN
03D296  2A E4                 SUB    ah, ah                       ; UNKNOWN
03D298  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
03D29B  A1 3E 0B              MOV    ax, word ptr [0xb3e]         ; UNKNOWN
03D29E  EB 2B                 JMP    0x3d2cb                      ; UNKNOWN
03D2A0  83 7E 06 18           CMP    word ptr [bp + 6], 0x18      ; UNKNOWN
03D2A4  7D 2C                 JGE    0x3d2d2                      ; UNKNOWN
03D2A6  83 7E 06 08           CMP    word ptr [bp + 6], 8         ; UNKNOWN
03D2AA  7C 26                 JL     0x3d2d2                      ; UNKNOWN
03D2AC  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
03D2AF  83 E0 07              AND    ax, 7                        ; UNKNOWN
03D2B2  0C 08                 OR     al, 8                        ; UNKNOWN
03D2B4  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
03D2B7  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
03D2BA  C9                    LEAVE                               ; UNKNOWN
03D2BB  CB                    RETF                                ; UNKNOWN
