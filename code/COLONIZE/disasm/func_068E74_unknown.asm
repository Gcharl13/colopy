; ============================================================================
; func_068E74_unknown
; Region   : load_image
; Bytes    : file 0x068E74..0x068E96  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068E74  55                    PUSH   bp                           ; UNKNOWN
068E75  8B EC                 MOV    bp, sp                       ; UNKNOWN
068E77  57                    PUSH   di                           ; UNKNOWN
068E78  56                    PUSH   si                           ; UNKNOWN
068E79  1E                    PUSH   ds                           ; UNKNOWN
068E7A  07                    POP    es                           ; UNKNOWN
068E7B  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
068E7E  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
068E81  8B DF                 MOV    bx, di                       ; UNKNOWN
068E83  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
068E86  E3 0C                 JCXZ   0x68e94                      ; UNKNOWN
068E88  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
068E89  0A C0                 OR     al, al                       ; UNKNOWN
068E8B  74 03                 JE     0x68e90                      ; UNKNOWN
068E8D  AA                    STOSB  byte ptr es:[di], al         ; UNKNOWN
068E8E  E2 F8                 LOOP   0x68e88                      ; UNKNOWN
068E90  32 C0                 XOR    al, al                       ; UNKNOWN
068E92  F3 AA                 REP STOSB byte ptr es:[di], al         ; UNKNOWN
068E94  8B C3                 MOV    ax, bx                       ; UNKNOWN
