; ============================================================================
; func_02034D_unknown
; Region   : load_image
; Bytes    : file 0x02034D..0x0203DE  (145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02034D  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
020351  56                    PUSH   si                           ; UNKNOWN
020352  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
020355  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
02035A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02035D  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
020362  74 03                 JE     0x20367                      ; UNKNOWN
020364  E9 69 01              JMP    0x204d0                      ; UNKNOWN
020367  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
02036A  2A E4                 SUB    ah, ah                       ; UNKNOWN
02036C  C1 E0 03              SHL    ax, 3                        ; UNKNOWN
02036F  83 C0 0A              ADD    ax, 0xa                      ; UNKNOWN
020372  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
020375  81 3E 02 3E 40 06     CMP    word ptr [0x3e02], 0x640     ; UNKNOWN
02037B  7C 05                 JL     0x20382                      ; UNKNOWN
02037D  D1 E0                 SHL    ax, 1                        ; UNKNOWN
02037F  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
020382  81 3E 02 3E A4 06     CMP    word ptr [0x3e02], 0x6a4     ; UNKNOWN
020388  7C 03                 JL     0x2038d                      ; UNKNOWN
02038A  D1 66 FC              SHL    word ptr [bp - 4], 1         ; UNKNOWN
02038D  81 3E 02 3E D6 06     CMP    word ptr [0x3e02], 0x6d6     ; UNKNOWN
020393  7C 03                 JL     0x20398                      ; UNKNOWN
020395  D1 66 FC              SHL    word ptr [bp - 4], 1         ; UNKNOWN
020398  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02039B  99                    CDQ                                 ; UNKNOWN
02039C  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
0203A0  01 47 22              ADD    word ptr [bx + 0x22], ax     ; UNKNOWN
0203A3  11 57 24              ADC    word ptr [bx + 0x24], dx     ; UNKNOWN
0203A6  83 7F 24 00           CMP    word ptr [bx + 0x24], 0      ; UNKNOWN
0203AA  7F 0F                 JG     0x203bb                      ; UNKNOWN
0203AC  7D 03                 JGE    0x203b1                      ; UNKNOWN
0203AE  E9 1F 01              JMP    0x204d0                      ; UNKNOWN
0203B1  81 7F 22 08 07        CMP    word ptr [bx + 0x22], 0x708  ; UNKNOWN
0203B6  73 03                 JAE    0x203bb                      ; UNKNOWN
0203B8  E9 15 01              JMP    0x204d0                      ; UNKNOWN
0203BB  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
0203C0  A1 52 3E              MOV    ax, word ptr [0x3e52]        ; UNKNOWN
0203C3  40                    INC    ax                           ; UNKNOWN
0203C4  40                    INC    ax                           ; UNKNOWN
0203C5  B9 03 00              MOV    cx, 3                        ; UNKNOWN
0203C8  99                    CDQ                                 ; UNKNOWN
0203C9  F7 F9                 IDIV   cx                           ; UNKNOWN
0203CB  3B 06 54 3E           CMP    ax, word ptr [0x3e54]        ; UNKNOWN
0203CF  7E 05                 JLE    0x203d6                      ; UNKNOWN
0203D1  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
0203D6  A1 52 3E              MOV    ax, word ptr [0x3e52]        ; UNKNOWN
0203D9  99                    CDQ                                 ; UNKNOWN
0203DA  33 C2                 XOR    ax, dx                       ; UNKNOWN
0203DC  2B C2                 SUB    ax, dx                       ; UNKNOWN
