; ============================================================================
; func_06B21F_unknown
; Region   : load_image
; Bytes    : file 0x06B21F..0x06B247  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B21F  55                    PUSH   bp                           ; UNKNOWN
06B220  8B EC                 MOV    bp, sp                       ; UNKNOWN
06B222  56                    PUSH   si                           ; UNKNOWN
06B223  57                    PUSH   di                           ; UNKNOWN
06B224  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; UNKNOWN
06B227  83 F9 E8              CMP    cx, -0x18                    ; UNKNOWN
06B22A  77 12                 JA     0x6b23e                      ; UNKNOWN
06B22C  BB 04 12              MOV    bx, 0x1204                   ; UNKNOWN
06B22F  E8 16 00              CALL   0x6b248                      ; UNKNOWN
06B232  73 0F                 JAE    0x6b243                      ; UNKNOWN
06B234  E8 A1 F7              CALL   0x6a9d8                      ; UNKNOWN
06B237  72 05                 JB     0x6b23e                      ; UNKNOWN
06B239  E8 0C 00              CALL   0x6b248                      ; UNKNOWN
06B23C  73 05                 JAE    0x6b243                      ; UNKNOWN
06B23E  33 C0                 XOR    ax, ax                       ; UNKNOWN
06B240  99                    CDQ                                 ; UNKNOWN
06B241  EB 00                 JMP    0x6b243                      ; UNKNOWN
06B243  5F                    POP    di                           ; UNKNOWN
06B244  5E                    POP    si                           ; UNKNOWN
06B245  5D                    POP    bp                           ; UNKNOWN
06B246  CB                    RETF                                ; UNKNOWN
