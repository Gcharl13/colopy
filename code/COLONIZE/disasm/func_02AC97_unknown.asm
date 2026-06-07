; ============================================================================
; func_02AC97_unknown
; Region   : load_image
; Bytes    : file 0x02AC97..0x02AD08  (113 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AC97  C8 2C 00 00           ENTER  0x2c, 0                      ; UNKNOWN
02AC9B  6B 06 10 3E 34        IMUL   ax, word ptr [0x3e10], 0x34  ; UNKNOWN
02ACA0  05 86 C0              ADD    ax, 0xc086                   ; UNKNOWN
02ACA3  50                    PUSH   ax                           ; UNKNOWN
02ACA4  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
02ACA7  50                    PUSH   ax                           ; UNKNOWN
02ACA8  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
02ACAD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02ACB0  A1 10 3E              MOV    ax, word ptr [0x3e10]        ; UNKNOWN
02ACB3  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
02ACB6  A0 FA 3D              MOV    al, byte ptr [0x3dfa]        ; UNKNOWN
02ACB9  83 E0 01              AND    ax, 1                        ; UNKNOWN
02ACBC  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
02ACBF  A0 FA 3D              MOV    al, byte ptr [0x3dfa]        ; UNKNOWN
02ACC2  83 E0 08              AND    ax, 8                        ; UNKNOWN
02ACC5  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
02ACC8  A1 02 3E              MOV    ax, word ptr [0x3e02]        ; UNKNOWN
02ACCB  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
02ACCE  A1 04 3E              MOV    ax, word ptr [0x3e04]        ; UNKNOWN
02ACD1  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
02ACD4  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
02ACD7  2A E4                 SUB    ah, ah                       ; UNKNOWN
02ACD9  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
02ACDC  6A 00                 PUSH   0                            ; UNKNOWN
02ACDE  0E                    PUSH   cs                           ; UNKNOWN
02ACDF  E8 B0 EB              CALL   0x29892                      ; UNKNOWN
02ACE2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02ACE5  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02ACE8  8D 46 D4              LEA    ax, [bp - 0x2c]              ; UNKNOWN
02ACEB  50                    PUSH   ax                           ; UNKNOWN
02ACEC  6A 01                 PUSH   1                            ; UNKNOWN
02ACEE  0E                    PUSH   cs                           ; UNKNOWN
02ACEF  E8 73 F6              CALL   0x2a365                      ; UNKNOWN
02ACF2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02ACF5  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02ACF8  8B 46 D4              MOV    ax, word ptr [bp - 0x2c]     ; UNKNOWN
02ACFB  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02ACFE  8D 46 D6              LEA    ax, [bp - 0x2a]              ; UNKNOWN
02AD01  50                    PUSH   ax                           ; UNKNOWN
02AD02  0E                    PUSH   cs                           ; UNKNOWN
02AD03  E8 41 FA              CALL   0x2a747                      ; UNKNOWN
02AD06  C9                    LEAVE                               ; UNKNOWN
02AD07  CB                    RETF                                ; UNKNOWN
