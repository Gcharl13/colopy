; ============================================================================
; func_068E3E_unknown
; Region   : load_image
; Bytes    : file 0x068E3E..0x068E71  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068E3E  55                    PUSH   bp                           ; UNKNOWN
068E3F  8B EC                 MOV    bp, sp                       ; UNKNOWN
068E41  57                    PUSH   di                           ; UNKNOWN
068E42  56                    PUSH   si                           ; UNKNOWN
068E43  1E                    PUSH   ds                           ; UNKNOWN
068E44  07                    POP    es                           ; UNKNOWN
068E45  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
068E48  8B D7                 MOV    dx, di                       ; UNKNOWN
068E4A  33 C0                 XOR    ax, ax                       ; UNKNOWN
068E4C  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
068E4F  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
068E51  4F                    DEC    di                           ; UNKNOWN
068E52  8B F7                 MOV    si, di                       ; UNKNOWN
068E54  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
068E57  8B DF                 MOV    bx, di                       ; UNKNOWN
068E59  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
068E5C  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
068E5E  75 01                 JNE    0x68e61                      ; UNKNOWN
068E60  41                    INC    cx                           ; UNKNOWN
068E61  2B 4E 0A              SUB    cx, word ptr [bp + 0xa]      ; UNKNOWN
068E64  F7 D9                 NEG    cx                           ; UNKNOWN
068E66  8B FE                 MOV    di, si                       ; UNKNOWN
068E68  8B F3                 MOV    si, bx                       ; UNKNOWN
068E6A  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; UNKNOWN
068E6C  AA                    STOSB  byte ptr es:[di], al         ; UNKNOWN
068E6D  8B C2                 MOV    ax, dx                       ; UNKNOWN
068E6F  5E                    POP    si                           ; UNKNOWN
068E70  5F                    POP    di                           ; UNKNOWN
