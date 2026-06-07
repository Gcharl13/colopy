; ============================================================================
; func_02E62D_unknown
; Region   : load_image
; Bytes    : file 0x02E62D..0x02E798  (363 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E62D  C8 2C 00 00           ENTER  0x2c, 0                      ; UNKNOWN
02E631  56                    PUSH   si                           ; UNKNOWN
02E632  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0      ; UNKNOWN
02E637  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02E63A  89 46 D4              MOV    word ptr [bp - 0x2c], ax     ; UNKNOWN
02E63D  83 F8 17              CMP    ax, 0x17                     ; UNKNOWN
02E640  75 05                 JNE    0x2e647                      ; UNKNOWN
02E642  C7 46 D4 15 00        MOV    word ptr [bp - 0x2c], 0x15   ; UNKNOWN
02E647  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02E64A  0E                    PUSH   cs                           ; UNKNOWN
02E64B  E8 99 FD              CALL   0x2e3e7                      ; UNKNOWN
02E64E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E651  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
02E654  50                    PUSH   ax                           ; UNKNOWN
02E655  8D 46 D8              LEA    ax, [bp - 0x28]              ; UNKNOWN
02E658  50                    PUSH   ax                           ; UNKNOWN
02E659  0E                    PUSH   cs                           ; UNKNOWN
02E65A  E8 03 FD              CALL   0x2e360                      ; UNKNOWN
02E65D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02E660  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
02E663  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0      ; UNKNOWN
02E668  EB 25                 JMP    0x2e68f                      ; UNKNOWN
02E66A  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; UNKNOWN
02E66E  8A 87 95 88           MOV    al, byte ptr [bx - 0x776b]   ; UNKNOWN
02E672  2A E4                 SUB    ah, ah                       ; UNKNOWN
02E674  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02E677  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02E67A  8B 76 E0              MOV    si, word ptr [bp - 0x20]     ; UNKNOWN
02E67D  D1 E6                 SHL    si, 1                        ; UNKNOWN
02E67F  8B 72 D8              MOV    si, word ptr [bp + si - 0x28] ; UNKNOWN
02E682  D1 E6                 SHL    si, 1                        ; UNKNOWN
02E684  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E688  01 80 9A 00           ADD    word ptr [bx + si + 0x9a], ax ; UNKNOWN
02E68C  FF 46 E0              INC    word ptr [bp - 0x20]         ; UNKNOWN
02E68F  8B 46 DE              MOV    ax, word ptr [bp - 0x22]     ; UNKNOWN
02E692  39 46 E0              CMP    word ptr [bp - 0x20], ax     ; UNKNOWN
02E695  7D 3B                 JGE    0x2e6d2                      ; UNKNOWN
02E697  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E69B  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E69E  98                    CWDE                                ; UNKNOWN
02E69F  2B 46 06              SUB    ax, word ptr [bp + 6]        ; UNKNOWN
02E6A2  F7 D8                 NEG    ax                           ; UNKNOWN
02E6A4  50                    PUSH   ax                           ; UNKNOWN
02E6A5  0E                    PUSH   cs                           ; UNKNOWN
02E6A6  E8 58 F8              CALL   0x2df01                      ; UNKNOWN
02E6A9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E6AC  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
02E6AF  8B 76 E0              MOV    si, word ptr [bp - 0x20]     ; UNKNOWN
02E6B2  D1 E6                 SHL    si, 1                        ; UNKNOWN
02E6B4  8B 42 D8              MOV    ax, word ptr [bp + si - 0x28] ; UNKNOWN
02E6B7  83 F8 0E              CMP    ax, 0xe                      ; UNKNOWN
02E6BA  74 AE                 JE     0x2e66a                      ; UNKNOWN
02E6BC  77 06                 JA     0x2e6c4                      ; UNKNOWN
02E6BE  0A C0                 OR     al, al                       ; UNKNOWN
02E6C0  74 09                 JE     0x2e6cb                      ; UNKNOWN
02E6C2  2C 08                 SUB    al, 8                        ; UNKNOWN
02E6C4  C7 46 FA 32 00        MOV    word ptr [bp - 6], 0x32      ; UNKNOWN
02E6C9  EB AC                 JMP    0x2e677                      ; UNKNOWN
02E6CB  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
02E6D0  EB A5                 JMP    0x2e677                      ; UNKNOWN
02E6D2  6A 10                 PUSH   0x10                         ; UNKNOWN
02E6D4  6A 00                 PUSH   0                            ; UNKNOWN
02E6D6  8D 46 EA              LEA    ax, [bp - 0x16]              ; UNKNOWN
02E6D9  50                    PUSH   ax                           ; UNKNOWN
02E6DA  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
02E6DF  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02E6E2  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E6E6  8B 87 B6 00           MOV    ax, word ptr [bx + 0xb6]     ; UNKNOWN
02E6EA  B9 14 00              MOV    cx, 0x14                     ; UNKNOWN
02E6ED  99                    CDQ                                 ; UNKNOWN
02E6EE  F7 F9                 IDIV   cx                           ; UNKNOWN
02E6F0  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02E6F3  6B C0 14              IMUL   ax, ax, 0x14                 ; UNKNOWN
02E6F6  83 F8 64              CMP    ax, 0x64                     ; UNKNOWN
02E6F9  7E 03                 JLE    0x2e6fe                      ; UNKNOWN
02E6FB  B8 64 00              MOV    ax, 0x64                     ; UNKNOWN
02E6FE  88 46 F8              MOV    byte ptr [bp - 8], al        ; UNKNOWN
02E701  B0 32                 MOV    al, 0x32                     ; UNKNOWN
02E703  88 46 F9              MOV    byte ptr [bp - 7], al        ; UNKNOWN
02E706  88 46 F2              MOV    byte ptr [bp - 0xe], al      ; UNKNOWN
02E709  8B 46 E2              MOV    ax, word ptr [bp - 0x1e]     ; UNKNOWN
02E70C  39 46 08              CMP    word ptr [bp + 8], ax        ; UNKNOWN
02E70F  74 0C                 JE     0x2e71d                      ; UNKNOWN
02E711  6A 00                 PUSH   0                            ; UNKNOWN
02E713  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02E716  0E                    PUSH   cs                           ; UNKNOWN
02E717  E8 76 FB              CALL   0x2e290                      ; UNKNOWN
02E71A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02E71D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02E720  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02E723  0E                    PUSH   cs                           ; UNKNOWN
02E724  E8 8A FE              CALL   0x2e5b1                      ; UNKNOWN
02E727  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02E72A  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02E72D  0B C0                 OR     ax, ax                       ; UNKNOWN
02E72F  75 03                 JNE    0x2e734                      ; UNKNOWN
02E731  E9 B3 00              JMP    0x2e7e7                      ; UNKNOWN
02E734  48                    DEC    ax                           ; UNKNOWN
02E735  75 03                 JNE    0x2e73a                      ; UNKNOWN
02E737  E9 4B 01              JMP    0x2e885                      ; UNKNOWN
02E73A  48                    DEC    ax                           ; UNKNOWN
02E73B  75 03                 JNE    0x2e740                      ; UNKNOWN
02E73D  E9 D0 00              JMP    0x2e810                      ; UNKNOWN
02E740  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E744  80 7F 1F 20           CMP    byte ptr [bx + 0x1f], 0x20   ; UNKNOWN
02E748  7C 03                 JL     0x2e74d                      ; UNKNOWN
02E74A  E9 84 01              JMP    0x2e8d1                      ; UNKNOWN
02E74D  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E750  98                    CWDE                                ; UNKNOWN
02E751  2B 46 06              SUB    ax, word ptr [bp + 6]        ; UNKNOWN
02E754  F7 D8                 NEG    ax                           ; UNKNOWN
02E756  50                    PUSH   ax                           ; UNKNOWN
02E757  0E                    PUSH   cs                           ; UNKNOWN
02E758  E8 A6 F7              CALL   0x2df01                      ; UNKNOWN
02E75B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E75E  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
02E761  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E765  83 87 C6 00 64        ADD    word ptr [bx + 0xc6], 0x64   ; UNKNOWN
02E76A  83 97 C8 00 00        ADC    word ptr [bx + 0xc8], 0      ; UNKNOWN
02E76F  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E772  98                    CWDE                                ; UNKNOWN
02E773  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
02E776  FE 47 1F              INC    byte ptr [bx + 0x1f]         ; UNKNOWN
02E779  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02E77C  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
02E77F  0E                    PUSH   cs                           ; UNKNOWN
02E780  E8 AA FE              CALL   0x2e62d                      ; UNKNOWN
02E783  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02E786  6B 5E E8 1C           IMUL   bx, word ptr [bp - 0x18], 0x1c ; UNKNOWN
02E78A  8A 87 97 88           MOV    al, byte ptr [bx - 0x7769]   ; UNKNOWN
02E78E  98                    CWDE                                ; UNKNOWN
02E78F  50                    PUSH   ax                           ; UNKNOWN
02E790  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
02E793  0E                    PUSH   cs                           ; UNKNOWN
02E794  E8 C2 FC              CALL   0x2e459                      ; UNKNOWN
02E797  83                    DB     0x83                         ; UNKNOWN (raw)
