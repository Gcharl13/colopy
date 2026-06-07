; ============================================================================
; func_009816_unknown
; Region   : load_image
; Bytes    : file 0x009816..0x0098AB  (149 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009816  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
00981A  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
00981D  8B 1F                 MOV    bx, word ptr [bx]            ; UNKNOWN
00981F  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
009821  98                    CWDE                                ; UNKNOWN
009822  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
009825  3D 76 00              CMP    ax, 0x76                     ; UNKNOWN
009828  75 03                 JNE    0x982d                       ; UNKNOWN
00982A  E9 37 01              JMP    0x9964                       ; UNKNOWN
00982D  77 10                 JA     0x983f                       ; UNKNOWN
00982F  2C 3F                 SUB    al, 0x3f                     ; UNKNOWN
009831  74 21                 JE     0x9854                       ; UNKNOWN
009833  2C 0D                 SUB    al, 0xd                      ; UNKNOWN
009835  74 25                 JE     0x985c                       ; UNKNOWN
009837  FE C8                 DEC    al                           ; UNKNOWN
009839  74 71                 JE     0x98ac                       ; UNKNOWN
00983B  2C 23                 SUB    al, 0x23                     ; UNKNOWN
00983D  74 75                 JE     0x98b4                       ; UNKNOWN
00983F  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
009842  68 03 03              PUSH   0x303                        ; UNKNOWN
009845  68 88 12              PUSH   0x1288                       ; UNKNOWN
009848  9A B8 03 65 5F        LCALL  0x5f65, 0x3b8                ; UNKNOWN
00984D  83 C4 06              ADD    sp, 6                        ; UNKNOWN
009850  E9 0D 01              JMP    0x9960                       ; UNKNOWN
009853  90                    NOP                                 ; UNKNOWN
009854  0E                    PUSH   cs                           ; UNKNOWN
009855  E8 F2 FE              CALL   0x974a                       ; UNKNOWN
009858  E9 0D 01              JMP    0x9968                       ; UNKNOWN
00985B  90                    NOP                                 ; UNKNOWN
00985C  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
00985F  B0 3A                 MOV    al, 0x3a                     ; UNKNOWN
009861  0E                    PUSH   cs                           ; UNKNOWN
009862  E8 57 FF              CALL   0x97bc                       ; UNKNOWN
009865  0B C0                 OR     ax, ax                       ; UNKNOWN
009867  74 3A                 JE     0x98a3                       ; UNKNOWN
009869  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
00986C  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
00986E  9A 86 08 65 5F        LCALL  0x5f65, 0x886                ; UNKNOWN
009873  83 C4 02              ADD    sp, 2                        ; UNKNOWN
009876  A3 68 00              MOV    word ptr [0x68], ax          ; UNKNOWN
009879  0B C0                 OR     ax, ax                       ; UNKNOWN
00987B  7C 05                 JL     0x9882                       ; UNKNOWN
00987D  3D 03 00              CMP    ax, 3                        ; UNKNOWN
009880  7E 18                 JLE    0x989a                       ; UNKNOWN
009882  68 C4 02              PUSH   0x2c4                        ; UNKNOWN
009885  68 88 12              PUSH   0x1288                       ; UNKNOWN
009888  9A B8 03 65 5F        LCALL  0x5f65, 0x3b8                ; UNKNOWN
00988D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
009890  6A 03                 PUSH   3                            ; UNKNOWN
009892  9A D5 01 65 5F        LCALL  0x5f65, 0x1d5                ; UNKNOWN
009897  83 C4 02              ADD    sp, 2                        ; UNKNOWN
00989A  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
00989D  2A C0                 SUB    al, al                       ; UNKNOWN
00989F  0E                    PUSH   cs                           ; UNKNOWN
0098A0  E8 19 FF              CALL   0x97bc                       ; UNKNOWN
0098A3  C7 06 66 00 01 00     MOV    word ptr [0x66], 1           ; UNKNOWN
0098A9  C9                    LEAVE                               ; UNKNOWN
0098AA  CB                    RETF                                ; UNKNOWN
