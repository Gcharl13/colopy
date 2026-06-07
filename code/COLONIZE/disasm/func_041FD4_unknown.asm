; ============================================================================
; func_041FD4_unknown
; Region   : load_image
; Bytes    : file 0x041FD4..0x042061  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041FD4  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
041FD8  53                    PUSH   bx                           ; UNKNOWN
041FD9  52                    PUSH   dx                           ; UNKNOWN
041FDA  50                    PUSH   ax                           ; UNKNOWN
041FDB  56                    PUSH   si                           ; UNKNOWN
041FDC  C7 46 F4 FF FF        MOV    word ptr [bp - 0xc], 0xffff  ; UNKNOWN
041FE1  8D 4E 0E              LEA    cx, [bp + 0xe]               ; UNKNOWN
041FE4  51                    PUSH   cx                           ; UNKNOWN
041FE5  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
041FE8  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
041FEB  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
041FEE  6A 00                 PUSH   0                            ; UNKNOWN
041FF0  8D 4E FA              LEA    cx, [bp - 6]                 ; UNKNOWN
041FF3  51                    PUSH   cx                           ; UNKNOWN
041FF4  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
041FF7  0E                    PUSH   cs                           ; UNKNOWN
041FF8  E8 07 FD              CALL   0x41d02                      ; UNKNOWN
041FFB  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
041FFE  0B C0                 OR     ax, ax                       ; UNKNOWN
042000  75 03                 JNE    0x42005                      ; UNKNOWN
042002  E9 80 00              JMP    0x42085                      ; UNKNOWN
042005  8B 76 EE              MOV    si, word ptr [bp - 0x12]     ; UNKNOWN
042008  8B C6                 MOV    ax, si                       ; UNKNOWN
04200A  D1 E6                 SHL    si, 1                        ; UNKNOWN
04200C  03 F0                 ADD    si, ax                       ; UNKNOWN
04200E  C1 E6 02              SHL    si, 2                        ; UNKNOWN
042011  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
042015  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; UNKNOWN
042019  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04201C  F6 46 06 02           TEST   byte ptr [bp + 6], 2         ; UNKNOWN
042020  74 05                 JE     0x42027                      ; UNKNOWN
042022  40                    INC    ax                           ; UNKNOWN
042023  40                    INC    ax                           ; UNKNOWN
042024  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
042027  8B 76 EE              MOV    si, word ptr [bp - 0x12]     ; UNKNOWN
04202A  8B C6                 MOV    ax, si                       ; UNKNOWN
04202C  D1 E6                 SHL    si, 1                        ; UNKNOWN
04202E  03 F0                 ADD    si, ax                       ; UNKNOWN
042030  C1 E6 02              SHL    si, 2                        ; UNKNOWN
042033  26 8B 40 40           MOV    ax, word ptr es:[bx + si + 0x40] ; UNKNOWN
042037  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04203A  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
04203D  48                    DEC    ax                           ; UNKNOWN
04203E  8B C8                 MOV    cx, ax                       ; UNKNOWN
042040  F7 6E F6              IMUL   word ptr [bp - 0xa]          ; UNKNOWN
042043  01 46 0E              ADD    word ptr [bp + 0xe], ax      ; UNKNOWN
042046  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
042049  EB 34                 JMP    0x4207f                      ; UNKNOWN
04204B  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
04204F  7C 34                 JL     0x42085                      ; UNKNOWN
042051  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
042054  03 46 F8              ADD    ax, word ptr [bp - 8]        ; UNKNOWN
042057  50                    PUSH   ax                           ; UNKNOWN
042058  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
04205B  42                    INC    dx                           ; UNKNOWN
04205C  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
04205F  8B C3                 MOV    ax, bx                       ; UNKNOWN
