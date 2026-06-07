; ============================================================================
; func_037D01_unknown
; Region   : load_image
; Bytes    : file 0x037D01..0x037D63  (98 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

037D01  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
037D05  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
037D0A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
037D0D  83 F8 52              CMP    ax, 0x52                     ; UNKNOWN
037D10  75 03                 JNE    0x37d15                      ; UNKNOWN
037D12  E9 97 02              JMP    0x37fac                      ; UNKNOWN
037D15  7E 03                 JLE    0x37d1a                      ; UNKNOWN
037D17  E9 D3 02              JMP    0x37fed                      ; UNKNOWN
037D1A  83 F8 50              CMP    ax, 0x50                     ; UNKNOWN
037D1D  75 03                 JNE    0x37d22                      ; UNKNOWN
037D1F  E9 98 02              JMP    0x37fba                      ; UNKNOWN
037D22  76 03                 JBE    0x37d27                      ; UNKNOWN
037D24  E9 BE 02              JMP    0x37fe5                      ; UNKNOWN
037D27  3C 31                 CMP    al, 0x31                     ; UNKNOWN
037D29  75 03                 JNE    0x37d2e                      ; UNKNOWN
037D2B  E9 7E 02              JMP    0x37fac                      ; UNKNOWN
037D2E  7E 03                 JLE    0x37d33                      ; UNKNOWN
037D30  E9 95 02              JMP    0x37fc8                      ; UNKNOWN
037D33  2C 09                 SUB    al, 9                        ; UNKNOWN
037D35  75 03                 JNE    0x37d3a                      ; UNKNOWN
037D37  E9 4A 01              JMP    0x37e84                      ; UNKNOWN
037D3A  2C 12                 SUB    al, 0x12                     ; UNKNOWN
037D3C  74 11                 JE     0x37d4f                      ; UNKNOWN
037D3E  2C 10                 SUB    al, 0x10                     ; UNKNOWN
037D40  75 03                 JNE    0x37d45                      ; UNKNOWN
037D42  E9 F6 01              JMP    0x37f3b                      ; UNKNOWN
037D45  2C 02                 SUB    al, 2                        ; UNKNOWN
037D47  75 03                 JNE    0x37d4c                      ; UNKNOWN
037D49  E9 99 01              JMP    0x37ee5                      ; UNKNOWN
037D4C  E9 96 02              JMP    0x37fe5                      ; UNKNOWN
037D4F  2B C0                 SUB    ax, ax                       ; UNKNOWN
037D51  A3 B8 79              MOV    word ptr [0x79b8], ax        ; UNKNOWN
037D54  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
037D57  83 7E F6 00           CMP    word ptr [bp - 0xa], 0       ; UNKNOWN
037D5B  74 04                 JE     0x37d61                      ; UNKNOWN
037D5D  0E                    PUSH   cs                           ; UNKNOWN
037D5E  E8 39 CA              CALL   0x3479a                      ; UNKNOWN
037D61  F6                    DB     0xF6                         ; UNKNOWN (raw)
037D62  06                    DB     0x06                         ; UNKNOWN (raw)
