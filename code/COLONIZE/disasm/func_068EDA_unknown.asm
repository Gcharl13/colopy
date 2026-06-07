; ============================================================================
; func_068EDA_unknown
; Region   : load_image
; Bytes    : file 0x068EDA..0x068EF6  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068EDA  55                    PUSH   bp                           ; UNKNOWN
068EDB  8B EC                 MOV    bp, sp                       ; UNKNOWN
068EDD  56                    PUSH   si                           ; UNKNOWN
068EDE  57                    PUSH   di                           ; UNKNOWN
068EDF  B3 01                 MOV    bl, 1                        ; UNKNOWN
068EE1  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
068EE4  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
068EE7  33 D2                 XOR    dx, dx                       ; UNKNOWN
068EE9  83 F9 0A              CMP    cx, 0xa                      ; UNKNOWN
068EEC  75 01                 JNE    0x68eef                      ; UNKNOWN
068EEE  99                    CDQ                                 ; UNKNOWN
068EEF  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
068EF2  E9 1F 1F              JMP    0x6ae14                      ; UNKNOWN
068EF5  00                    DB     0x00                         ; UNKNOWN (raw)
