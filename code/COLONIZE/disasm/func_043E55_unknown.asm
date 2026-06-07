; ============================================================================
; func_043E55_unknown
; Region   : load_image
; Bytes    : file 0x043E55..0x043EBA  (101 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043E55  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
043E59  50                    PUSH   ax                           ; UNKNOWN
043E5A  56                    PUSH   si                           ; UNKNOWN
043E5B  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
043E60  3B 16 34 0B           CMP    dx, word ptr [0xb34]         ; UNKNOWN
043E64  7C 5B                 JL     0x43ec1                      ; UNKNOWN
043E66  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
043E6B  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
043E70  EB 35                 JMP    0x43ea7                      ; UNKNOWN
043E72  A1 94 82              MOV    ax, word ptr [0x8294]        ; UNKNOWN
043E75  F7 D0                 NOT    ax                           ; UNKNOWN
043E77  40                    INC    ax                           ; UNKNOWN
043E78  EB 02                 JMP    0x43e7c                      ; UNKNOWN
043E7A  2B C0                 SUB    ax, ax                       ; UNKNOWN
043E7C  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
043E7F  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
043E83  98                    CWDE                                ; UNKNOWN
043E84  8B D8                 MOV    bx, ax                       ; UNKNOWN
043E86  03 1E 9E C1           ADD    bx, word ptr [0xc19e]        ; UNKNOWN
043E8A  8E 06 A0 C1           MOV    es, word ptr [0xc1a0]        ; UNKNOWN
043E8E  8B 76 F8              MOV    si, word ptr [bp - 8]        ; UNKNOWN
043E91  26 8A 00              MOV    al, byte ptr es:[bx + si]    ; UNKNOWN
043E94  2A E4                 SUB    ah, ah                       ; UNKNOWN
043E96  85 46 F4              TEST   word ptr [bp - 0xc], ax      ; UNKNOWN
043E99  74 06                 JE     0x43ea1                      ; UNKNOWN
043E9B  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
043E9E  09 46 FC              OR     word ptr [bp - 4], ax        ; UNKNOWN
043EA1  D1 66 FA              SHL    word ptr [bp - 6], 1         ; UNKNOWN
043EA4  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
043EA7  83 7E FE 08           CMP    word ptr [bp - 2], 8         ; UNKNOWN
043EAB  7D 14                 JGE    0x43ec1                      ; UNKNOWN
043EAD  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
043EB0  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
043EB4  0A C0                 OR     al, al                       ; UNKNOWN
043EB6  74 C2                 JE     0x43e7a                      ; UNKNOWN
043EB8  0A C0                 OR     al, al                       ; UNKNOWN
