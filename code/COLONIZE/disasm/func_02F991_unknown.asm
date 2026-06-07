; ============================================================================
; func_02F991_unknown
; Region   : load_image
; Bytes    : file 0x02F991..0x02FA13  (130 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02F991  C8 1E 00 00           ENTER  0x1e, 0                      ; UNKNOWN
02F995  56                    PUSH   si                           ; UNKNOWN
02F996  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
02F99B  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02F99F  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02F9A1  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F9A3  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
02F9A6  48                    DEC    ax                           ; UNKNOWN
02F9A7  48                    DEC    ax                           ; UNKNOWN
02F9A8  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02F9AB  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
02F9AE  2A E4                 SUB    ah, ah                       ; UNKNOWN
02F9B0  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
02F9B3  48                    DEC    ax                           ; UNKNOWN
02F9B4  48                    DEC    ax                           ; UNKNOWN
02F9B5  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02F9B8  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02F9BB  48                    DEC    ax                           ; UNKNOWN
02F9BC  48                    DEC    ax                           ; UNKNOWN
02F9BD  0B C0                 OR     ax, ax                       ; UNKNOWN
02F9BF  7F 08                 JG     0x2f9c9                      ; UNKNOWN
02F9C1  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02F9C4  48                    DEC    ax                           ; UNKNOWN
02F9C5  48                    DEC    ax                           ; UNKNOWN
02F9C6  F7 D0                 NOT    ax                           ; UNKNOWN
02F9C8  40                    INC    ax                           ; UNKNOWN
02F9C9  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
02F9CC  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02F9CF  48                    DEC    ax                           ; UNKNOWN
02F9D0  48                    DEC    ax                           ; UNKNOWN
02F9D1  0B C0                 OR     ax, ax                       ; UNKNOWN
02F9D3  7F 08                 JG     0x2f9dd                      ; UNKNOWN
02F9D5  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02F9D8  48                    DEC    ax                           ; UNKNOWN
02F9D9  48                    DEC    ax                           ; UNKNOWN
02F9DA  F7 D0                 NOT    ax                           ; UNKNOWN
02F9DC  40                    INC    ax                           ; UNKNOWN
02F9DD  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
02F9E0  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02F9E3  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02F9E6  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
02F9EB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02F9EE  0B C0                 OR     ax, ax                       ; UNKNOWN
02F9F0  74 17                 JE     0x2fa09                      ; UNKNOWN
02F9F2  0E                    PUSH   cs                           ; UNKNOWN
02F9F3  E8 60 E0              CALL   0x2da56                      ; UNKNOWN
02F9F6  50                    PUSH   ax                           ; UNKNOWN
02F9F7  FF 76 EC              PUSH   word ptr [bp - 0x14]         ; UNKNOWN
02F9FA  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
02F9FD  9A 33 00 C9 33        LCALL  0x33c9, 0x33                 ; UNKNOWN
02FA02  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02FA05  0B C0                 OR     ax, ax                       ; UNKNOWN
02FA07  75 0A                 JNE    0x2fa13                      ; UNKNOWN
02FA09  80 4E FA 10           OR     byte ptr [bp - 6], 0x10      ; UNKNOWN
02FA0D  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02FA10  5E                    POP    si                           ; UNKNOWN
02FA11  C9                    LEAVE                               ; UNKNOWN
02FA12  CB                    RETF                                ; UNKNOWN
