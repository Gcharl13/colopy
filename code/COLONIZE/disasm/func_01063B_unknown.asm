; ============================================================================
; func_01063B_unknown
; Region   : load_image
; Bytes    : file 0x01063B..0x0106A2  (103 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01063B  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
01063F  57                    PUSH   di                           ; UNKNOWN
010640  56                    PUSH   si                           ; UNKNOWN
010641  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
010644  9A 32 00 BA 33        LCALL  0x33ba, 0x32                 ; UNKNOWN
010649  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01064C  6A 00                 PUSH   0                            ; UNKNOWN
01064E  6A 02                 PUSH   2                            ; UNKNOWN
010650  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12  ; UNKNOWN
010654  8A 87 DD 79           MOV    al, byte ptr [bx + 0x79dd]   ; UNKNOWN
010658  2A E4                 SUB    ah, ah                       ; UNKNOWN
01065A  50                    PUSH   ax                           ; UNKNOWN
01065B  8A 87 DC 79           MOV    al, byte ptr [bx + 0x79dc]   ; UNKNOWN
01065F  50                    PUSH   ax                           ; UNKNOWN
010660  9A 53 01 C9 33        LCALL  0x33c9, 0x153                ; UNKNOWN
010665  83 C4 08              ADD    sp, 8                        ; UNKNOWN
010668  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
01066B  48                    DEC    ax                           ; UNKNOWN
01066C  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01066F  EB 14                 JMP    0x10685                      ; UNKNOWN
010671  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
010674  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
010678  38 87 86 88           CMP    byte ptr [bx - 0x777a], al   ; UNKNOWN
01067C  7E 04                 JLE    0x10682                      ; UNKNOWN
01067E  FE 8F 86 88           DEC    byte ptr [bx - 0x777a]       ; UNKNOWN
010682  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
010685  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
010689  7C 24                 JL     0x106af                      ; UNKNOWN
01068B  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
01068F  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
010693  24 0F                 AND    al, 0xf                      ; UNKNOWN
010695  3C 04                 CMP    al, 4                        ; UNKNOWN
010697  72 E9                 JB     0x10682                      ; UNKNOWN
010699  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
01069C  38 87 86 88           CMP    byte ptr [bx - 0x777a], al   ; UNKNOWN
0106A0  75 CF                 JNE    0x10671                      ; UNKNOWN
