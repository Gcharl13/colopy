; ============================================================================
; func_06B842_unknown
; Region   : load_image
; Bytes    : file 0x06B842..0x06B867  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B842  55                    PUSH   bp                           ; UNKNOWN
06B843  8B EC                 MOV    bp, sp                       ; UNKNOWN
06B845  56                    PUSH   si                           ; UNKNOWN
06B846  57                    PUSH   di                           ; UNKNOWN
06B847  1E                    PUSH   ds                           ; UNKNOWN
06B848  1F                    POP    ds                           ; UNKNOWN
06B849  BB FF FF              MOV    bx, 0xffff                   ; UNKNOWN
06B84C  B4 48                 MOV    ah, 0x48                     ; UNKNOWN
06B84E  CD 21                 INT    0x21                         ; UNKNOWN
06B850  3C 07                 CMP    al, 7                        ; UNKNOWN
06B852  74 42                 JE     0x6b896                      ; UNKNOWN
06B854  8B 1E 3E 12           MOV    bx, word ptr [0x123e]        ; UNKNOWN
06B858  8B D3                 MOV    dx, bx                       ; UNKNOWN
06B85A  4B                    DEC    bx                           ; UNKNOWN
06B85B  33 C9                 XOR    cx, cx                       ; UNKNOWN
06B85D  1E                    PUSH   ds                           ; UNKNOWN
06B85E  8E DB                 MOV    ds, bx                       ; UNKNOWN
06B860  A1 01 00              MOV    ax, word ptr [1]             ; UNKNOWN
06B863  3B C2                 CMP    ax, dx                       ; UNKNOWN
06B865  74 06                 JE     0x6b86d                      ; UNKNOWN
