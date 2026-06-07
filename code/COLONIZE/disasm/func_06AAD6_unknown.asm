; ============================================================================
; func_06AAD6_unknown
; Region   : load_image
; Bytes    : file 0x06AAD6..0x06AB04  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06AAD6  55                    PUSH   bp                           ; UNKNOWN
06AAD7  8B EC                 MOV    bp, sp                       ; UNKNOWN
06AAD9  57                    PUSH   di                           ; UNKNOWN
06AADA  56                    PUSH   si                           ; UNKNOWN
06AADB  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
06AADE  33 C0                 XOR    ax, ax                       ; UNKNOWN
06AAE0  99                    CDQ                                 ; UNKNOWN
06AAE1  33 DB                 XOR    bx, bx                       ; UNKNOWN
06AAE3  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
06AAE4  3C 20                 CMP    al, 0x20                     ; UNKNOWN
06AAE6  74 FB                 JE     0x6aae3                      ; UNKNOWN
06AAE8  3C 09                 CMP    al, 9                        ; UNKNOWN
06AAEA  74 F7                 JE     0x6aae3                      ; UNKNOWN
06AAEC  50                    PUSH   ax                           ; UNKNOWN
06AAED  3C 2D                 CMP    al, 0x2d                     ; UNKNOWN
06AAEF  74 04                 JE     0x6aaf5                      ; UNKNOWN
06AAF1  3C 2B                 CMP    al, 0x2b                     ; UNKNOWN
06AAF3  75 01                 JNE    0x6aaf6                      ; UNKNOWN
06AAF5  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
06AAF6  3C 39                 CMP    al, 0x39                     ; UNKNOWN
06AAF8  77 1F                 JA     0x6ab19                      ; UNKNOWN
06AAFA  2C 30                 SUB    al, 0x30                     ; UNKNOWN
06AAFC  72 1B                 JB     0x6ab19                      ; UNKNOWN
06AAFE  D1 E3                 SHL    bx, 1                        ; UNKNOWN
06AB00  D1 D2                 RCL    dx, 1                        ; UNKNOWN
06AB02  8B CB                 MOV    cx, bx                       ; UNKNOWN
