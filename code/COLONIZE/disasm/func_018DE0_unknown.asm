; ============================================================================
; func_018DE0_unknown
; Region   : load_image
; Bytes    : file 0x018DE0..0x018F2D  (333 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

018DE0  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
018DE4  57                    PUSH   di                           ; UNKNOWN
018DE5  56                    PUSH   si                           ; UNKNOWN
018DE6  8A 46 0C              MOV    al, byte ptr [bp + 0xc]      ; UNKNOWN
018DE9  83 E0 01              AND    ax, 1                        ; UNKNOWN
018DEC  75 13                 JNE    0x18e01                      ; UNKNOWN
018DEE  C6 46 FC 0F           MOV    byte ptr [bp - 4], 0xf       ; UNKNOWN
018DF2  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff    ; UNKNOWN
018DF7  C6 46 F4 39           MOV    byte ptr [bp - 0xc], 0x39    ; UNKNOWN
018DFB  C6 46 FE 30           MOV    byte ptr [bp - 2], 0x30      ; UNKNOWN
018DFF  EB 11                 JMP    0x18e12                      ; UNKNOWN
018E01  C6 46 FC 00           MOV    byte ptr [bp - 4], 0         ; UNKNOWN
018E05  C7 46 FA 0F 00        MOV    word ptr [bp - 6], 0xf       ; UNKNOWN
018E0A  C6 46 F4 30           MOV    byte ptr [bp - 0xc], 0x30    ; UNKNOWN
018E0E  C6 46 FE 39           MOV    byte ptr [bp - 2], 0x39      ; UNKNOWN
018E12  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
018E15  50                    PUSH   ax                           ; UNKNOWN
018E16  8D 4E F8              LEA    cx, [bp - 8]                 ; UNKNOWN
018E19  51                    PUSH   cx                           ; UNKNOWN
018E1A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
018E1D  0E                    PUSH   cs                           ; UNKNOWN
018E1E  E8 87 FF              CALL   0x18da8                      ; UNKNOWN
018E21  83 C4 06              ADD    sp, 6                        ; UNKNOWN
018E24  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
018E27  83 C0 03              ADD    ax, 3                        ; UNKNOWN
018E2A  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
018E2D  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
018E30  40                    INC    ax                           ; UNKNOWN
018E31  40                    INC    ax                           ; UNKNOWN
018E32  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
018E35  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
018E39  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
018E3D  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
018E41  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
018E45  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
018E48  50                    PUSH   ax                           ; UNKNOWN
018E49  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
018E4C  8B D0                 MOV    dx, ax                       ; UNKNOWN
018E4E  03 56 F8              ADD    dx, word ptr [bp - 8]        ; UNKNOWN
018E51  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
018E54  03 5E F6              ADD    bx, word ptr [bp - 0xa]      ; UNKNOWN
018E57  4B                    DEC    bx                           ; UNKNOWN
018E58  4A                    DEC    dx                           ; UNKNOWN
018E59  8B F0                 MOV    si, ax                       ; UNKNOWN
018E5B  9A 0A 00 76 5A        LCALL  0x5a76, 0xa                  ; UNKNOWN
018E60  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
018E64  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
018E68  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
018E6C  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
018E70  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
018E73  50                    PUSH   ax                           ; UNKNOWN
018E74  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
018E77  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
018E7A  48                    DEC    ax                           ; UNKNOWN
018E7B  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
018E7E  03 5E F6              ADD    bx, word ptr [bp - 0xa]      ; UNKNOWN
018E81  8D 5F FF              LEA    bx, [bx - 1]                 ; UNKNOWN
018E84  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
018E87  8B FA                 MOV    di, dx                       ; UNKNOWN
018E89  9A 04 00 7D 5A        LCALL  0x5a7d, 4                    ; UNKNOWN
018E8E  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
018E92  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
018E96  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
018E9A  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
018E9E  8A 46 F4              MOV    al, byte ptr [bp - 0xc]      ; UNKNOWN
018EA1  50                    PUSH   ax                           ; UNKNOWN
018EA2  8B DF                 MOV    bx, di                       ; UNKNOWN
018EA4  8B C6                 MOV    ax, si                       ; UNKNOWN
018EA6  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
018EA9  03 56 F8              ADD    dx, word ptr [bp - 8]        ; UNKNOWN
018EAC  4A                    DEC    dx                           ; UNKNOWN
018EAD  9A 0A 00 76 5A        LCALL  0x5a76, 0xa                  ; UNKNOWN
018EB2  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
018EB6  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
018EBA  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
018EBE  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
018EC2  8A 46 F4              MOV    al, byte ptr [bp - 0xc]      ; UNKNOWN
018EC5  50                    PUSH   ax                           ; UNKNOWN
018EC6  8B C6                 MOV    ax, si                       ; UNKNOWN
018EC8  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
018ECB  03 5E F6              ADD    bx, word ptr [bp - 0xa]      ; UNKNOWN
018ECE  4B                    DEC    bx                           ; UNKNOWN
018ECF  8B D7                 MOV    dx, di                       ; UNKNOWN
018ED1  9A 04 00 7D 5A        LCALL  0x5a7d, 4                    ; UNKNOWN
018ED6  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
018EDA  7C 2C                 JL     0x18f08                      ; UNKNOWN
018EDC  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
018EE0  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
018EE4  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
018EE8  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
018EEC  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
018EEF  48                    DEC    ax                           ; UNKNOWN
018EF0  48                    DEC    ax                           ; UNKNOWN
018EF1  50                    PUSH   ax                           ; UNKNOWN
018EF2  8A 46 FA              MOV    al, byte ptr [bp - 6]        ; UNKNOWN
018EF5  50                    PUSH   ax                           ; UNKNOWN
018EF6  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
018EF9  40                    INC    ax                           ; UNKNOWN
018EFA  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
018EFD  4B                    DEC    bx                           ; UNKNOWN
018EFE  4B                    DEC    bx                           ; UNKNOWN
018EFF  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
018F02  42                    INC    dx                           ; UNKNOWN
018F03  9A 08 00 58 5A        LCALL  0x5a58, 8                    ; UNKNOWN
018F08  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
018F0B  2A E4                 SUB    ah, ah                       ; UNKNOWN
018F0D  50                    PUSH   ax                           ; UNKNOWN
018F0E  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
018F11  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
018F14  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
018F17  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
018F1C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
018F1F  52                    PUSH   dx                           ; UNKNOWN
018F20  50                    PUSH   ax                           ; UNKNOWN
018F21  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
018F26  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
018F29  5E                    POP    si                           ; UNKNOWN
018F2A  5F                    POP    di                           ; UNKNOWN
018F2B  C9                    LEAVE                               ; UNKNOWN
018F2C  CB                    RETF                                ; UNKNOWN
