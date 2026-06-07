; ============================================================================
; func_041D02_unknown
; Region   : load_image
; Bytes    : file 0x041D02..0x041DDB  (217 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041D02  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
041D06  52                    PUSH   dx                           ; UNKNOWN
041D07  50                    PUSH   ax                           ; UNKNOWN
041D08  56                    PUSH   si                           ; UNKNOWN
041D09  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
041D0E  0B D2                 OR     dx, dx                       ; UNKNOWN
041D10  75 03                 JNE    0x41d15                      ; UNKNOWN
041D12  E9 BE 00              JMP    0x41dd3                      ; UNKNOWN
041D15  0B DB                 OR     bx, bx                       ; UNKNOWN
041D17  75 03                 JNE    0x41d1c                      ; UNKNOWN
041D19  E9 B7 00              JMP    0x41dd3                      ; UNKNOWN
041D1C  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
041D1F  C7 07 00 00           MOV    word ptr [bx], 0             ; UNKNOWN
041D23  8B 76 F0              MOV    si, word ptr [bp - 0x10]     ; UNKNOWN
041D26  8B C6                 MOV    ax, si                       ; UNKNOWN
041D28  D1 E6                 SHL    si, 1                        ; UNKNOWN
041D2A  03 F0                 ADD    si, ax                       ; UNKNOWN
041D2C  C1 E6 02              SHL    si, 2                        ; UNKNOWN
041D2F  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
041D33  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; UNKNOWN
041D37  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
041D3A  F6 46 06 02           TEST   byte ptr [bp + 6], 2         ; UNKNOWN
041D3E  74 05                 JE     0x41d45                      ; UNKNOWN
041D40  40                    INC    ax                           ; UNKNOWN
041D41  40                    INC    ax                           ; UNKNOWN
041D42  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
041D45  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
041D48  2B 46 FE              SUB    ax, word ptr [bp - 2]        ; UNKNOWN
041D4B  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
041D4E  83 7E F2 01           CMP    word ptr [bp - 0xe], 1       ; UNKNOWN
041D52  7E 1E                 JLE    0x41d72                      ; UNKNOWN
041D54  8B 4E F2              MOV    cx, word ptr [bp - 0xe]      ; UNKNOWN
041D57  49                    DEC    cx                           ; UNKNOWN
041D58  99                    CDQ                                 ; UNKNOWN
041D59  F7 F9                 IDIV   cx                           ; UNKNOWN
041D5B  8B 4E FE              MOV    cx, word ptr [bp - 2]        ; UNKNOWN
041D5E  41                    INC    cx                           ; UNKNOWN
041D5F  3B C1                 CMP    ax, cx                       ; UNKNOWN
041D61  7E 02                 JLE    0x41d65                      ; UNKNOWN
041D63  8B C1                 MOV    ax, cx                       ; UNKNOWN
041D65  83 F8 01              CMP    ax, 1                        ; UNKNOWN
041D68  7D 03                 JGE    0x41d6d                      ; UNKNOWN
041D6A  B8 01 00              MOV    ax, 1                        ; UNKNOWN
041D6D  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
041D70  EB 05                 JMP    0x41d77                      ; UNKNOWN
041D72  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
041D77  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
041D7A  48                    DEC    ax                           ; UNKNOWN
041D7B  F7 6E F6              IMUL   word ptr [bp - 0xa]          ; UNKNOWN
041D7E  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
041D81  EB 09                 JMP    0x41d8c                      ; UNKNOWN
041D83  FF 07                 INC    word ptr [bx]                ; UNKNOWN
041D85  8A 0F                 MOV    cl, byte ptr [bx]            ; UNKNOWN
041D87  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
041D8A  D3 F8                 SAR    ax, cl                       ; UNKNOWN
041D8C  03 46 FE              ADD    ax, word ptr [bp - 2]        ; UNKNOWN
041D8F  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
041D92  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
041D95  8A 0F                 MOV    cl, byte ptr [bx]            ; UNKNOWN
041D97  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
041D9A  D3 F8                 SAR    ax, cl                       ; UNKNOWN
041D9C  3B 46 F4              CMP    ax, word ptr [bp - 0xc]      ; UNKNOWN
041D9F  7F E2                 JG     0x41d83                      ; UNKNOWN
041DA1  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
041DA4  48                    DEC    ax                           ; UNKNOWN
041DA5  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
041DA8  7E 05                 JLE    0x41daf                      ; UNKNOWN
041DAA  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
041DAD  EB 03                 JMP    0x41db2                      ; UNKNOWN
041DAF  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
041DB2  2B 46 FA              SUB    ax, word ptr [bp - 6]        ; UNKNOWN
041DB5  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
041DB8  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
041DBC  74 05                 JE     0x41dc3                      ; UNKNOWN
041DBE  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
041DC1  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
041DC3  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
041DC7  74 0A                 JE     0x41dd3                      ; UNKNOWN
041DC9  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
041DCC  D1 F8                 SAR    ax, 1                        ; UNKNOWN
041DCE  8B 5E 12              MOV    bx, word ptr [bp + 0x12]     ; UNKNOWN
041DD1  01 07                 ADD    word ptr [bx], ax            ; UNKNOWN
041DD3  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
041DD6  5E                    POP    si                           ; UNKNOWN
041DD7  C9                    LEAVE                               ; UNKNOWN
041DD8  CA 0E 00              RETF   0xe                          ; UNKNOWN
