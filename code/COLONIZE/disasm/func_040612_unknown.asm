; ============================================================================
; func_040612_unknown
; Region   : load_image
; Bytes    : file 0x040612..0x040657  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040612  55                    PUSH   bp                           ; UNKNOWN
040613  8B EC                 MOV    bp, sp                       ; UNKNOWN
040615  57                    PUSH   di                           ; UNKNOWN
040616  56                    PUSH   si                           ; UNKNOWN
040617  C7 06 82 C0 FF FF     MOV    word ptr [0xc082], 0xffff    ; UNKNOWN
04061D  2B F6                 SUB    si, si                       ; UNKNOWN
04061F  83 FE 08              CMP    si, 8                        ; UNKNOWN
040622  7D 31                 JGE    0x40655                      ; UNKNOWN
040624  8A 84 2F 09           MOV    al, byte ptr [si + 0x92f]    ; UNKNOWN
040628  98                    CWDE                                ; UNKNOWN
040629  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
04062C  50                    PUSH   ax                           ; UNKNOWN
04062D  8A 84 26 09           MOV    al, byte ptr [si + 0x926]    ; UNKNOWN
040631  98                    CWDE                                ; UNKNOWN
040632  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
040635  50                    PUSH   ax                           ; UNKNOWN
040636  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
04063B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04063E  8B F8                 MOV    di, ax                       ; UNKNOWN
040640  0B FF                 OR     di, di                       ; UNKNOWN
040642  7C 09                 JL     0x4064d                      ; UNKNOWN
040644  39 7E 0A              CMP    word ptr [bp + 0xa], di      ; UNKNOWN
040647  74 04                 JE     0x4064d                      ; UNKNOWN
040649  89 3E 82 C0           MOV    word ptr [0xc082], di        ; UNKNOWN
04064D  46                    INC    si                           ; UNKNOWN
04064E  83 3E 82 C0 00        CMP    word ptr [0xc082], 0         ; UNKNOWN
040653  7C CA                 JL     0x4061f                      ; UNKNOWN
040655  83                    DB     0x83                         ; UNKNOWN (raw)
040656  3E                    DB     0x3E                         ; UNKNOWN (raw)
