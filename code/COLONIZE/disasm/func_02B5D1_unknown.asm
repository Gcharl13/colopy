; ============================================================================
; func_02B5D1_unknown
; Region   : load_image
; Bytes    : file 0x02B5D1..0x02B624  (83 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B5D1  55                    PUSH   bp                           ; UNKNOWN
02B5D2  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B5D4  56                    PUSH   si                           ; UNKNOWN
02B5D5  83 7E 06 03           CMP    word ptr [bp + 6], 3         ; UNKNOWN
02B5D9  75 32                 JNE    0x2b60d                      ; UNKNOWN
02B5DB  FF 36 42 33           PUSH   word ptr [0x3342]            ; UNKNOWN
02B5DF  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02B5E2  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02B5E7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B5EA  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02B5ED  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
02B5F2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02B5F5  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
02B5F9  75 12                 JNE    0x2b60d                      ; UNKNOWN
02B5FB  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02B5FE  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02B600  98                    CWDE                                ; UNKNOWN
02B601  8B F0                 MOV    si, ax                       ; UNKNOWN
02B603  F6 84 BB 13 01        TEST   byte ptr [si + 0x13bb], 1    ; UNKNOWN
02B608  74 03                 JE     0x2b60d                      ; UNKNOWN
02B60A  80 07 20              ADD    byte ptr [bx], 0x20          ; UNKNOWN
02B60D  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02B610  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02B612  FF B7 2B 38           PUSH   word ptr [bx + 0x382b]       ; UNKNOWN
02B616  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02B619  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
02B61E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B621  5E                    POP    si                           ; UNKNOWN
02B622  C9                    LEAVE                               ; UNKNOWN
02B623  CB                    RETF                                ; UNKNOWN
