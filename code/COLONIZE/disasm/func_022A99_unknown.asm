; ============================================================================
; func_022A99_unknown
; Region   : load_image
; Bytes    : file 0x022A99..0x022B2B  (146 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022A99  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
022A9D  57                    PUSH   di                           ; UNKNOWN
022A9E  56                    PUSH   si                           ; UNKNOWN
022A9F  8B F8                 MOV    di, ax                       ; UNKNOWN
022AA1  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
022AA4  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
022AA7  26 8B 47 38           MOV    ax, word ptr es:[bx + 0x38]  ; UNKNOWN
022AAB  26 8B 57 3A           MOV    dx, word ptr es:[bx + 0x3a]  ; UNKNOWN
022AAF  8B F0                 MOV    si, ax                       ; UNKNOWN
022AB1  89 56 F8              MOV    word ptr [bp - 8], dx        ; UNKNOWN
022AB4  2B C0                 SUB    ax, ax                       ; UNKNOWN
022AB6  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
022AB9  26 89 07              MOV    word ptr es:[bx], ax         ; UNKNOWN
022ABC  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
022ABF  8B C7                 MOV    ax, di                       ; UNKNOWN
022AC1  9A 08 00 9D 5B        LCALL  0x5b9d, 8                    ; UNKNOWN
022AC6  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
022AC9  3B C7                 CMP    ax, di                       ; UNKNOWN
022ACB  74 26                 JE     0x22af3                      ; UNKNOWN
022ACD  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
022AD0  0B C6                 OR     ax, si                       ; UNKNOWN
022AD2  74 1F                 JE     0x22af3                      ; UNKNOWN
022AD4  8B 4E FC              MOV    cx, word ptr [bp - 4]        ; UNKNOWN
022AD7  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
022ADA  0B C9                 OR     cx, cx                       ; UNKNOWN
022ADC  75 2E                 JNE    0x22b0c                      ; UNKNOWN
022ADE  8E 46 F8              MOV    es, word ptr [bp - 8]        ; UNKNOWN
022AE1  26 39 5C 08           CMP    word ptr es:[si + 8], bx     ; UNKNOWN
022AE5  75 11                 JNE    0x22af8                      ; UNKNOWN
022AE7  26 F6 44 0C 01        TEST   byte ptr es:[si + 0xc], 1    ; UNKNOWN
022AEC  75 0A                 JNE    0x22af8                      ; UNKNOWN
022AEE  B9 01 00              MOV    cx, 1                        ; UNKNOWN
022AF1  EB 12                 JMP    0x22b05                      ; UNKNOWN
022AF3  8B 4E FC              MOV    cx, word ptr [bp - 4]        ; UNKNOWN
022AF6  EB 14                 JMP    0x22b0c                      ; UNKNOWN
022AF8  26 8B 44 16           MOV    ax, word ptr es:[si + 0x16]  ; UNKNOWN
022AFC  26 8B 54 18           MOV    dx, word ptr es:[si + 0x18]  ; UNKNOWN
022B00  8B F0                 MOV    si, ax                       ; UNKNOWN
022B02  89 56 F8              MOV    word ptr [bp - 8], dx        ; UNKNOWN
022B05  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
022B08  0B C6                 OR     ax, si                       ; UNKNOWN
022B0A  75 CE                 JNE    0x22ada                      ; UNKNOWN
022B0C  8B 7E FA              MOV    di, word ptr [bp - 6]        ; UNKNOWN
022B0F  0B C9                 OR     cx, cx                       ; UNKNOWN
022B11  74 0B                 JE     0x22b1e                      ; UNKNOWN
022B13  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
022B16  56                    PUSH   si                           ; UNKNOWN
022B17  0E                    PUSH   cs                           ; UNKNOWN
022B18  E8 D6 F8              CALL   0x223f1                      ; UNKNOWN
022B1B  BF 01 00              MOV    di, 1                        ; UNKNOWN
022B1E  9A 2F 00 8F 5C        LCALL  0x5c8f, 0x2f                 ; UNKNOWN
022B23  8B C7                 MOV    ax, di                       ; UNKNOWN
022B25  5E                    POP    si                           ; UNKNOWN
022B26  5F                    POP    di                           ; UNKNOWN
022B27  C9                    LEAVE                               ; UNKNOWN
022B28  CA 04 00              RETF   4                            ; UNKNOWN
