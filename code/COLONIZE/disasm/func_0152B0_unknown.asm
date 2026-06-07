; ============================================================================
; func_0152B0_unknown
; Region   : load_image
; Bytes    : file 0x0152B0..0x0153E9  (313 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0152B0  C8 24 00 00           ENTER  0x24, 0                      ; UNKNOWN
0152B4  56                    PUSH   si                           ; UNKNOWN
0152B5  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
0152BA  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0152BE  89 5E DC              MOV    word ptr [bp - 0x24], bx     ; UNKNOWN
0152C1  8A 87 8C 88           MOV    al, byte ptr [bx - 0x7774]   ; UNKNOWN
0152C5  2A E4                 SUB    ah, ah                       ; UNKNOWN
0152C7  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0152CA  0B C0                 OR     ax, ax                       ; UNKNOWN
0152CC  7F 03                 JG     0x152d1                      ; UNKNOWN
0152CE  E9 83 00              JMP    0x15354                      ; UNKNOWN
0152D1  8D 46 E6              LEA    ax, [bp - 0x1a]              ; UNKNOWN
0152D4  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
0152D7  8A 46 F4              MOV    al, byte ptr [bp - 0xc]      ; UNKNOWN
0152DA  8B 76 F4              MOV    si, word ptr [bp - 0xc]      ; UNKNOWN
0152DD  88 42 E0              MOV    byte ptr [bp + si - 0x20], al ; UNKNOWN
0152E0  56                    PUSH   si                           ; UNKNOWN
0152E1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0152E4  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
0152E9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0152EC  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0152EF  56                    PUSH   si                           ; UNKNOWN
0152F0  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0152F3  9A DF 2F 5F 24        LCALL  0x245f, 0x2fdf               ; UNKNOWN
0152F8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0152FB  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
0152FE  8B 5E DC              MOV    bx, word ptr [bp - 0x24]     ; UNKNOWN
015301  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
015305  25 0F 00              AND    ax, 0xf                      ; UNKNOWN
015308  8B F0                 MOV    si, ax                       ; UNKNOWN
01530A  C1 E6 04              SHL    si, 4                        ; UNKNOWN
01530D  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
015310  8A 80 68 74           MOV    al, byte ptr [bx + si + 0x7468] ; UNKNOWN
015314  2A E4                 SUB    ah, ah                       ; UNKNOWN
015316  C1 E0 04              SHL    ax, 4                        ; UNKNOWN
015319  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01531C  83 FB 0F              CMP    bx, 0xf                      ; UNKNOWN
01531F  75 05                 JNE    0x15326                      ; UNKNOWN
015321  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
015326  83 FB 0E              CMP    bx, 0xe                      ; UNKNOWN
015329  75 05                 JNE    0x15330                      ; UNKNOWN
01532B  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
015330  83 FB 08              CMP    bx, 8                        ; UNKNOWN
015333  75 05                 JNE    0x1533a                      ; UNKNOWN
015335  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
01533A  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
01533D  F7 6E F2              IMUL   word ptr [bp - 0xe]          ; UNKNOWN
015340  8B 5E DE              MOV    bx, word ptr [bp - 0x22]     ; UNKNOWN
015343  83 46 DE 02           ADD    word ptr [bp - 0x22], 2      ; UNKNOWN
015347  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
015349  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
01534C  FF 46 F4              INC    word ptr [bp - 0xc]          ; UNKNOWN
01534F  39 46 F4              CMP    word ptr [bp - 0xc], ax      ; UNKNOWN
015352  7C 83                 JL     0x152d7                      ; UNKNOWN
015354  8D 46 E0              LEA    ax, [bp - 0x20]              ; UNKNOWN
015357  16                    PUSH   ss                           ; UNKNOWN
015358  50                    PUSH   ax                           ; UNKNOWN
015359  8D 46 E6              LEA    ax, [bp - 0x1a]              ; UNKNOWN
01535C  16                    PUSH   ss                           ; UNKNOWN
01535D  50                    PUSH   ax                           ; UNKNOWN
01535E  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
015361  9A 00 00 DB 5C        LCALL  0x5cdb, 0                    ; UNKNOWN
015366  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
01536B  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
01536F  7E 75                 JLE    0x153e6                      ; UNKNOWN
015371  8B 76 F4              MOV    si, word ptr [bp - 0xc]      ; UNKNOWN
015374  8A 42 E0              MOV    al, byte ptr [bp + si - 0x20] ; UNKNOWN
015377  2A E4                 SUB    ah, ah                       ; UNKNOWN
015379  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01537C  50                    PUSH   ax                           ; UNKNOWN
01537D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
015380  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
015385  83 C4 04              ADD    sp, 4                        ; UNKNOWN
015388  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01538B  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
01538E  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
015391  9A DF 2F 5F 24        LCALL  0x245f, 0x2fdf               ; UNKNOWN
015396  83 C4 04              ADD    sp, 4                        ; UNKNOWN
015399  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01539C  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
0153A0  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
0153A4  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0153A7  3D 64 00              CMP    ax, 0x64                     ; UNKNOWN
0153AA  7C 06                 JL     0x153b2                      ; UNKNOWN
0153AC  B8 17 00              MOV    ax, 0x17                     ; UNKNOWN
0153AF  EB 04                 JMP    0x153b5                      ; UNKNOWN
0153B1  90                    NOP                                 ; UNKNOWN
0153B2  B8 27 00              MOV    ax, 0x27                     ; UNKNOWN
0153B5  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
0153B8  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
0153BC  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
0153BF  8B F0                 MOV    si, ax                       ; UNKNOWN
0153C1  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
0153C6  8B C6                 MOV    ax, si                       ; UNKNOWN
0153C8  D1 E6                 SHL    si, 1                        ; UNKNOWN
0153CA  03 F0                 ADD    si, ax                       ; UNKNOWN
0153CC  C1 E6 02              SHL    si, 2                        ; UNKNOWN
0153CF  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
0153D3  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; UNKNOWN
0153D7  40                    INC    ax                           ; UNKNOWN
0153D8  01 46 08              ADD    word ptr [bp + 8], ax        ; UNKNOWN
0153DB  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0153DE  FF 46 F4              INC    word ptr [bp - 0xc]          ; UNKNOWN
0153E1  39 46 F4              CMP    word ptr [bp - 0xc], ax      ; UNKNOWN
0153E4  7C 8B                 JL     0x15371                      ; UNKNOWN
0153E6  5E                    POP    si                           ; UNKNOWN
0153E7  C9                    LEAVE                               ; UNKNOWN
0153E8  CB                    RETF                                ; UNKNOWN
