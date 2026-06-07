; ============================================================================
; func_0282E4_unknown
; Region   : load_image
; Bytes    : file 0x0282E4..0x02831C  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0282E4  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0282E8  56                    PUSH   si                           ; UNKNOWN
0282E9  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0282EC  8B C6                 MOV    ax, si                       ; UNKNOWN
0282EE  C1 E6 02              SHL    si, 2                        ; UNKNOWN
0282F1  03 F0                 ADD    si, ax                       ; UNKNOWN
0282F3  D1 E6                 SHL    si, 1                        ; UNKNOWN
0282F5  C4 1E 8A 40           LES    bx, ptr [0x408a]             ; UNKNOWN
0282F9  26 81 78 22 E7 03     CMP    word ptr es:[bx + si + 0x22], 0x3e7 ; UNKNOWN
0282FF  75 1B                 JNE    0x2831c                      ; UNKNOWN
028301  8B 1E 0C 3E           MOV    bx, word ptr [0x3e0c]        ; UNKNOWN
028305  D1 E3                 SHL    bx, 1                        ; UNKNOWN
028307  FF B7 E1 37           PUSH   word ptr [bx + 0x37e1]       ; UNKNOWN
02830B  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
028310  83 C4 02              ADD    sp, 2                        ; UNKNOWN
028313  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
028316  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
028319  5E                    POP    si                           ; UNKNOWN
02831A  C9                    LEAVE                               ; UNKNOWN
02831B  CB                    RETF                                ; UNKNOWN
