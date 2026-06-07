; ============================================================================
; func_06757C_unknown
; Region   : load_image
; Bytes    : file 0x06757C..0x0675C0  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06757C  55                    PUSH   bp                           ; UNKNOWN
06757D  8B EC                 MOV    bp, sp                       ; UNKNOWN
06757F  56                    PUSH   si                           ; UNKNOWN
067580  57                    PUSH   di                           ; UNKNOWN
067581  1E                    PUSH   ds                           ; UNKNOWN
067582  33 C0                 XOR    ax, ax                       ; UNKNOWN
067584  8E C0                 MOV    es, ax                       ; UNKNOWN
067586  B0 01                 MOV    al, 1                        ; UNKNOWN
067588  26 A2 40 04           MOV    byte ptr es:[0x440], al      ; UNKNOWN
06758C  26 38 06 40 04        CMP    byte ptr es:[0x440], al      ; UNKNOWN
067591  74 F9                 JE     0x6758c                      ; UNKNOWN
067593  8E 5E 08              MOV    ds, word ptr [bp + 8]        ; UNKNOWN
067596  8E 46 0A              MOV    es, word ptr [bp + 0xa]      ; UNKNOWN
067599  2E 83 3E 08 00 00     CMP    word ptr cs:[8], 0           ; UNKNOWN
06759F  75 03                 JNE    0x675a4                      ; UNKNOWN
0675A1  E8 8A 00              CALL   0x6762e                      ; UNKNOWN
0675A4  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; UNKNOWN
0675A7  E3 47                 JCXZ   0x675f0                      ; UNKNOWN
0675A9  B8 60 22              MOV    ax, 0x2260                   ; UNKNOWN
0675AC  BA 00 00              MOV    dx, 0                        ; UNKNOWN
0675AF  F7 F1                 DIV    cx                           ; UNKNOWN
0675B1  8B D8                 MOV    bx, ax                       ; UNKNOWN
0675B3  0B DB                 OR     bx, bx                       ; UNKNOWN
0675B5  75 03                 JNE    0x675ba                      ; UNKNOWN
0675B7  BB 01 00              MOV    bx, 1                        ; UNKNOWN
0675BA  2E A1 08 00           MOV    ax, word ptr cs:[8]          ; UNKNOWN
0675BE  2B C3                 SUB    ax, bx                       ; UNKNOWN
