; ============================================================================
; func_06ADC0_unknown
; Region   : load_image
; Bytes    : file 0x06ADC0..0x06AE08  (72 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06ADC0  55                    PUSH   bp                           ; UNKNOWN
06ADC1  8B EC                 MOV    bp, sp                       ; UNKNOWN
06ADC3  56                    PUSH   si                           ; UNKNOWN
06ADC4  57                    PUSH   di                           ; UNKNOWN
06ADC5  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
06ADC8  8B 05                 MOV    ax, word ptr [di]            ; UNKNOWN
06ADCA  8B 5D 02              MOV    bx, word ptr [di + 2]        ; UNKNOWN
06ADCD  8B 4D 04              MOV    cx, word ptr [di + 4]        ; UNKNOWN
06ADD0  8B 55 06              MOV    dx, word ptr [di + 6]        ; UNKNOWN
06ADD3  8B 75 08              MOV    si, word ptr [di + 8]        ; UNKNOWN
06ADD6  8B 7D 0A              MOV    di, word ptr [di + 0xa]      ; UNKNOWN
06ADD9  CD 21                 INT    0x21                         ; UNKNOWN
06ADDB  57                    PUSH   di                           ; UNKNOWN
06ADDC  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
06ADDF  89 05                 MOV    word ptr [di], ax            ; UNKNOWN
06ADE1  89 5D 02              MOV    word ptr [di + 2], bx        ; UNKNOWN
06ADE4  89 4D 04              MOV    word ptr [di + 4], cx        ; UNKNOWN
06ADE7  89 55 06              MOV    word ptr [di + 6], dx        ; UNKNOWN
06ADEA  89 75 08              MOV    word ptr [di + 8], si        ; UNKNOWN
06ADED  8F 45 0A              POP    word ptr [di + 0xa]          ; UNKNOWN
06ADF0  72 04                 JB     0x6adf6                      ; UNKNOWN
06ADF2  33 F6                 XOR    si, si                       ; UNKNOWN
06ADF4  EB 09                 JMP    0x6adff                      ; UNKNOWN
06ADF6  0E                    PUSH   cs                           ; UNKNOWN
06ADF7  E8 84 F0              CALL   0x69e7e                      ; UNKNOWN
06ADFA  BE 01 00              MOV    si, 1                        ; UNKNOWN
06ADFD  8B 05                 MOV    ax, word ptr [di]            ; UNKNOWN
06ADFF  89 75 0C              MOV    word ptr [di + 0xc], si      ; UNKNOWN
06AE02  5F                    POP    di                           ; UNKNOWN
06AE03  5E                    POP    si                           ; UNKNOWN
06AE04  8B E5                 MOV    sp, bp                       ; UNKNOWN
06AE06  5D                    POP    bp                           ; UNKNOWN
06AE07  CB                    RETF                                ; UNKNOWN
