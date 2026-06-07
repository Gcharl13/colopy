; ============================================================================
; func_01206E_unknown
; Region   : load_image
; Bytes    : file 0x01206E..0x0120FF  (145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01206E  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
012072  56                    PUSH   si                           ; UNKNOWN
012073  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
012078  EB 1D                 JMP    0x12097                      ; UNKNOWN
01207A  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
01207D  83 7E FC 04           CMP    word ptr [bp - 4], 4         ; UNKNOWN
012081  7D 11                 JGE    0x12094                      ; UNKNOWN
012083  6B 5E EE 27           IMUL   bx, word ptr [bp - 0x12], 0x27 ; UNKNOWN
012087  03 5E FC              ADD    bx, word ptr [bp - 4]        ; UNKNOWN
01208A  D1 E3                 SHL    bx, 1                        ; UNKNOWN
01208C  C7 87 F2 7F 00 00     MOV    word ptr [bx + 0x7ff2], 0    ; UNKNOWN
012092  EB E6                 JMP    0x1207a                      ; UNKNOWN
012094  FF 46 EE              INC    word ptr [bp - 0x12]         ; UNKNOWN
012097  83 7E EE 08           CMP    word ptr [bp - 0x12], 8      ; UNKNOWN
01209B  7D 07                 JGE    0x120a4                      ; UNKNOWN
01209D  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
0120A2  EB D9                 JMP    0x1207d                      ; UNKNOWN
0120A4  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
0120A9  6B 5E F0 4E           IMUL   bx, word ptr [bp - 0x10], 0x4e ; UNKNOWN
0120AD  F6 87 C7 7F 80        TEST   byte ptr [bx + 0x7fc7], 0x80 ; UNKNOWN
0120B2  75 0A                 JNE    0x120be                      ; UNKNOWN
0120B4  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
0120B7  0E                    PUSH   cs                           ; UNKNOWN
0120B8  E8 94 FC              CALL   0x11d4f                      ; UNKNOWN
0120BB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0120BE  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
0120C1  83 7E F0 08           CMP    word ptr [bp - 0x10], 8      ; UNKNOWN
0120C5  7C E2                 JL     0x120a9                      ; UNKNOWN
0120C7  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
0120CC  EB 76                 JMP    0x12144                      ; UNKNOWN
0120CE  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
0120D1  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
0120D4  39 46 F8              CMP    word ptr [bp - 8], ax        ; UNKNOWN
0120D7  7D 68                 JGE    0x12141                      ; UNKNOWN
0120D9  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
0120DC  8A 87 38 09           MOV    al, byte ptr [bx + 0x938]    ; UNKNOWN
0120E0  98                    CWDE                                ; UNKNOWN
0120E1  03 46 F6              ADD    ax, word ptr [bp - 0xa]      ; UNKNOWN
0120E4  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0120E7  8A 87 4D 09           MOV    al, byte ptr [bx + 0x94d]    ; UNKNOWN
0120EB  98                    CWDE                                ; UNKNOWN
0120EC  03 46 F2              ADD    ax, word ptr [bp - 0xe]      ; UNKNOWN
0120EF  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0120F2  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0120F6  8B 76 F8              MOV    si, word ptr [bp - 8]        ; UNKNOWN
0120F9  80 78 70 00           CMP    byte ptr [bx + si + 0x70], 0 ; UNKNOWN
0120FD  7C CF                 JL     0x120ce                      ; UNKNOWN
