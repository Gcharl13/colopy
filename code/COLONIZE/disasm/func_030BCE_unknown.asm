; ============================================================================
; func_030BCE_unknown
; Region   : load_image
; Bytes    : file 0x030BCE..0x030C07  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030BCE  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
030BD2  56                    PUSH   si                           ; UNKNOWN
030BD3  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1      ; UNKNOWN
030BD8  8D 46 F4              LEA    ax, [bp - 0xc]               ; UNKNOWN
030BDB  50                    PUSH   ax                           ; UNKNOWN
030BDC  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030BDF  0E                    PUSH   cs                           ; UNKNOWN
030BE0  E8 9F FC              CALL   0x30882                      ; UNKNOWN
030BE3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
030BE6  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
030BE9  0B C0                 OR     ax, ax                       ; UNKNOWN
030BEB  75 03                 JNE    0x30bf0                      ; UNKNOWN
030BED  E9 3C 02              JMP    0x30e2c                      ; UNKNOWN
030BF0  83 F8 01              CMP    ax, 1                        ; UNKNOWN
030BF3  74 03                 JE     0x30bf8                      ; UNKNOWN
030BF5  E9 9F 01              JMP    0x30d97                      ; UNKNOWN
030BF8  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
030BFB  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
030BFF  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
030C02  8B 5E F4              MOV    bx, word ptr [bp - 0xc]      ; UNKNOWN
030C05  8B CB                 MOV    cx, bx                       ; UNKNOWN
