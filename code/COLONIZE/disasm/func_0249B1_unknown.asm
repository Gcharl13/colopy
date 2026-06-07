; ============================================================================
; func_0249B1_unknown
; Region   : load_image
; Bytes    : file 0x0249B1..0x024A2F  (126 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0249B1  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
0249B5  83 3E 04 0A 07        CMP    word ptr [0xa04], 7          ; UNKNOWN
0249BA  7E 2C                 JLE    0x249e8                      ; UNKNOWN
0249BC  68 C0 18              PUSH   0x18c0                       ; UNKNOWN
0249BF  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
0249C2  50                    PUSH   ax                           ; UNKNOWN
0249C3  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
0249C8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0249CB  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0249CE  A3 16 0A              MOV    word ptr [0xa16], ax         ; UNKNOWN
0249D1  A3 80 40              MOV    word ptr [0x4080], ax        ; UNKNOWN
0249D4  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
0249D9  05 F0 00              ADD    ax, 0xf0                     ; UNKNOWN
0249DC  83 D2 00              ADC    dx, 0                        ; UNKNOWN
0249DF  A3 82 40              MOV    word ptr [0x4082], ax        ; UNKNOWN
0249E2  89 16 84 40           MOV    word ptr [0x4084], dx        ; UNKNOWN
0249E6  EB 37                 JMP    0x24a1f                      ; UNKNOWN
0249E8  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
0249EC  FF 36 04 0A           PUSH   word ptr [0xa04]             ; UNKNOWN
0249F0  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
0249F5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0249F8  50                    PUSH   ax                           ; UNKNOWN
0249F9  9A A1 00 BA 33        LCALL  0x33ba, 0xa1                 ; UNKNOWN
0249FE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
024A01  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
024A04  68 C5 18              PUSH   0x18c5                       ; UNKNOWN
024A07  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
024A0A  50                    PUSH   ax                           ; UNKNOWN
024A0B  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
024A10  83 C4 04              ADD    sp, 4                        ; UNKNOWN
024A13  A0 04 0A              MOV    al, byte ptr [0xa04]         ; UNKNOWN
024A16  00 46 EF              ADD    byte ptr [bp - 0x11], al     ; UNKNOWN
024A19  8A 46 EA              MOV    al, byte ptr [bp - 0x16]     ; UNKNOWN
024A1C  00 46 F1              ADD    byte ptr [bp - 0xf], al      ; UNKNOWN
024A1F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
024A22  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
024A25  8D 5E EC              LEA    bx, [bp - 0x14]              ; UNKNOWN
024A28  E8 45 FF              CALL   0x24970                      ; UNKNOWN
024A2B  C9                    LEAVE                               ; UNKNOWN
024A2C  C2 04 00              RET    4                            ; UNKNOWN
