; ============================================================================
; func_068E9C_unknown
; Region   : load_image
; Bytes    : file 0x068E9C..0x068EB7  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068E9C  55                    PUSH   bp                           ; UNKNOWN
068E9D  8B EC                 MOV    bp, sp                       ; UNKNOWN
068E9F  57                    PUSH   di                           ; UNKNOWN
068EA0  56                    PUSH   si                           ; UNKNOWN
068EA1  1E                    PUSH   ds                           ; UNKNOWN
068EA2  07                    POP    es                           ; UNKNOWN
068EA3  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
068EA6  E3 26                 JCXZ   0x68ece                      ; UNKNOWN
068EA8  8B D9                 MOV    bx, cx                       ; UNKNOWN
068EAA  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
068EAD  8B F7                 MOV    si, di                       ; UNKNOWN
068EAF  33 C0                 XOR    ax, ax                       ; UNKNOWN
068EB1  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
068EB3  F7 D9                 NEG    cx                           ; UNKNOWN
068EB5  03 CB                 ADD    cx, bx                       ; UNKNOWN
