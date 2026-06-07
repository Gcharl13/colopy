; ============================================================================
; func_06978B_unknown
; Region   : load_image
; Bytes    : file 0x06978B..0x0697B1  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06978B  55                    PUSH   bp                           ; UNKNOWN
06978C  8B EC                 MOV    bp, sp                       ; UNKNOWN
06978E  1E                    PUSH   ds                           ; UNKNOWN
06978F  B0 4E                 MOV    al, 0x4e                     ; UNKNOWN
069791  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
069794  B4 2F                 MOV    ah, 0x2f                     ; UNKNOWN
069796  CD 21                 INT    0x21                         ; UNKNOWN
069798  B4 1A                 MOV    ah, 0x1a                     ; UNKNOWN
06979A  CD 21                 INT    0x21                         ; UNKNOWN
06979C  3C 4E                 CMP    al, 0x4e                     ; UNKNOWN
06979E  75 06                 JNE    0x697a6                      ; UNKNOWN
0697A0  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
0697A3  8B 4E 08              MOV    cx, word ptr [bp + 8]        ; UNKNOWN
0697A6  8A E0                 MOV    ah, al                       ; UNKNOWN
0697A8  CD 21                 INT    0x21                         ; UNKNOWN
0697AA  50                    PUSH   ax                           ; UNKNOWN
0697AB  9F                    LAHF                                ; UNKNOWN
0697AC  50                    PUSH   ax                           ; UNKNOWN
0697AD  8C C2                 MOV    dx, es                       ; UNKNOWN
0697AF  8E DA                 MOV    ds, dx                       ; UNKNOWN
