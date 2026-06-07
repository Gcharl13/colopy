; ============================================================================
; func_009654_unknown
; Region   : load_image
; Bytes    : file 0x009654..0x0096F7  (163 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009654  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
009658  2B C0                 SUB    ax, ax                       ; UNKNOWN
00965A  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
00965D  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
009660  E8 E3 FF              CALL   0x9646                       ; UNKNOWN
009663  2B C9                 SUB    cx, cx                       ; UNKNOWN
009665  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
009668  8E C0                 MOV    es, ax                       ; UNKNOWN
00966A  8B D9                 MOV    bx, cx                       ; UNKNOWN
00966C  26 83 7F 03 FF        CMP    word ptr es:[bx + 3], -1     ; UNKNOWN
009671  74 3A                 JE     0x96ad                       ; UNKNOWN
009673  26 80 3F 4D           CMP    byte ptr es:[bx], 0x4d       ; UNKNOWN
009677  74 06                 JE     0x967f                       ; UNKNOWN
009679  26 80 3F 5A           CMP    byte ptr es:[bx], 0x5a       ; UNKNOWN
00967D  75 2E                 JNE    0x96ad                       ; UNKNOWN
00967F  26 83 7F 01 00        CMP    word ptr es:[bx + 1], 0      ; UNKNOWN
009684  75 13                 JNE    0x9699                       ; UNKNOWN
009686  26 8B 47 03           MOV    ax, word ptr es:[bx + 3]     ; UNKNOWN
00968A  01 46 F8              ADD    word ptr [bp - 8], ax        ; UNKNOWN
00968D  3B 46 F6              CMP    ax, word ptr [bp - 0xa]      ; UNKNOWN
009690  76 07                 JBE    0x9699                       ; UNKNOWN
009692  26 8B 47 03           MOV    ax, word ptr es:[bx + 3]     ; UNKNOWN
009696  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
009699  26 8B 47 03           MOV    ax, word ptr es:[bx + 3]     ; UNKNOWN
00969D  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
0096A0  40                    INC    ax                           ; UNKNOWN
0096A1  8E C0                 MOV    es, ax                       ; UNKNOWN
0096A3  8C 46 FC              MOV    word ptr [bp - 4], es        ; UNKNOWN
0096A6  26 83 7F 03 FF        CMP    word ptr es:[bx + 3], -1     ; UNKNOWN
0096AB  75 C6                 JNE    0x9673                       ; UNKNOWN
0096AD  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0096B1  74 1D                 JE     0x96d0                       ; UNKNOWN
0096B3  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
0096B6  2B D2                 SUB    dx, dx                       ; UNKNOWN
0096B8  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0096BA  D1 D2                 RCL    dx, 1                        ; UNKNOWN
0096BC  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0096BE  D1 D2                 RCL    dx, 1                        ; UNKNOWN
0096C0  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0096C2  D1 D2                 RCL    dx, 1                        ; UNKNOWN
0096C4  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0096C6  D1 D2                 RCL    dx, 1                        ; UNKNOWN
0096C8  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0096CB  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0096CD  89 57 02              MOV    word ptr [bx + 2], dx        ; UNKNOWN
0096D0  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
0096D4  74 1D                 JE     0x96f3                       ; UNKNOWN
0096D6  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
0096D9  2B D2                 SUB    dx, dx                       ; UNKNOWN
0096DB  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0096DD  D1 D2                 RCL    dx, 1                        ; UNKNOWN
0096DF  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0096E1  D1 D2                 RCL    dx, 1                        ; UNKNOWN
0096E3  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0096E5  D1 D2                 RCL    dx, 1                        ; UNKNOWN
0096E7  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0096E9  D1 D2                 RCL    dx, 1                        ; UNKNOWN
0096EB  8B 5E 04              MOV    bx, word ptr [bp + 4]        ; UNKNOWN
0096EE  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0096F0  89 57 02              MOV    word ptr [bx + 2], dx        ; UNKNOWN
0096F3  C9                    LEAVE                               ; UNKNOWN
0096F4  C2 04 00              RET    4                            ; UNKNOWN
