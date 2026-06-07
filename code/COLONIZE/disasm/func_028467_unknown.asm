; ============================================================================
; func_028467_unknown
; Region   : load_image
; Bytes    : file 0x028467..0x02850D  (166 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028467  C8 68 00 00           ENTER  0x68, 0                      ; UNKNOWN
02846B  56                    PUSH   si                           ; UNKNOWN
02846C  2B C0                 SUB    ax, ax                       ; UNKNOWN
02846E  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
028471  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
028474  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
028477  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02847A  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
02847D  EB 15                 JMP    0x28494                      ; UNKNOWN
02847F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
028482  50                    PUSH   ax                           ; UNKNOWN
028483  0E                    PUSH   cs                           ; UNKNOWN
028484  E8 B0 FE              CALL   0x28337                      ; UNKNOWN
028487  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02848A  0B C0                 OR     ax, ax                       ; UNKNOWN
02848C  74 03                 JE     0x28491                      ; UNKNOWN
02848E  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
028491  FF 46 9C              INC    word ptr [bp - 0x64]         ; UNKNOWN
028494  8B 46 9C              MOV    ax, word ptr [bp - 0x64]     ; UNKNOWN
028497  39 06 16 3E           CMP    word ptr [0x3e16], ax        ; UNKNOWN
02849B  7F E2                 JG     0x2847f                      ; UNKNOWN
02849D  C7 46 A6 01 00        MOV    word ptr [bp - 0x5a], 1      ; UNKNOWN
0284A2  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
0284A7  83 7E FC 0A           CMP    word ptr [bp - 4], 0xa       ; UNKNOWN
0284AB  7E 14                 JLE    0x284c1                      ; UNKNOWN
0284AD  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0284B0  83 C0 09              ADD    ax, 9                        ; UNKNOWN
0284B3  B9 0A 00              MOV    cx, 0xa                      ; UNKNOWN
0284B6  99                    CDQ                                 ; UNKNOWN
0284B7  F7 F9                 IDIV   cx                           ; UNKNOWN
0284B9  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
0284BC  89 4E A0              MOV    word ptr [bp - 0x60], cx     ; UNKNOWN
0284BF  EB 07                 JMP    0x284c8                      ; UNKNOWN
0284C1  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0284C4  40                    INC    ax                           ; UNKNOWN
0284C5  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
0284C8  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0284CC  7C 26                 JL     0x284f4                      ; UNKNOWN
0284CE  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0284D2  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
0284D7  72 11                 JB     0x284ea                      ; UNKNOWN
0284D9  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
0284DE  77 0A                 JA     0x284ea                      ; UNKNOWN
0284E0  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0284E4  8D 06 56 19           LEA    ax, [0x1956]                 ; UNKNOWN
0284E8  EB 12                 JMP    0x284fc                      ; UNKNOWN
0284EA  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0284EE  8D 06 5F 19           LEA    ax, [0x195f]                 ; UNKNOWN
0284F2  EB 08                 JMP    0x284fc                      ; UNKNOWN
0284F4  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0284F8  8D 06 6B 19           LEA    ax, [0x196b]                 ; UNKNOWN
0284FC  2B D2                 SUB    dx, dx                       ; UNKNOWN
0284FE  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
028503  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
028506  89 56 A4              MOV    word ptr [bp - 0x5c], dx     ; UNKNOWN
028509  8B C2                 MOV    ax, dx                       ; UNKNOWN
02850B  0B                    DB     0x0B                         ; UNKNOWN (raw)
02850C  46                    DB     0x46                         ; UNKNOWN (raw)
