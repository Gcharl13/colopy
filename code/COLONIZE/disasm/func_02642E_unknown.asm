; ============================================================================
; func_02642E_unknown
; Region   : load_image
; Bytes    : file 0x02642E..0x02646A  (60 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02642E  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
026432  56                    PUSH   si                           ; UNKNOWN
026433  83 3E 04 0A 07        CMP    word ptr [0xa04], 7          ; UNKNOWN
026438  7E 05                 JLE    0x2643f                      ; UNKNOWN
02643A  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02643D  EB 02                 JMP    0x26441                      ; UNKNOWN
02643F  2B C0                 SUB    ax, ax                       ; UNKNOWN
026441  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
026444  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026447  26 8B 47 6A           MOV    ax, word ptr es:[bx + 0x6a]  ; UNKNOWN
02644B  26 0B 47 68           OR     ax, word ptr es:[bx + 0x68]  ; UNKNOWN
02644F  74 6D                 JE     0x264be                      ; UNKNOWN
026451  26 F6 47 0A 40        TEST   byte ptr es:[bx + 0xa], 0x40 ; UNKNOWN
026456  75 66                 JNE    0x264be                      ; UNKNOWN
026458  26 8B 47 68           MOV    ax, word ptr es:[bx + 0x68]  ; UNKNOWN
02645C  26 8B 57 6A           MOV    dx, word ptr es:[bx + 0x6a]  ; UNKNOWN
026460  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
026463  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
026466  8E C2                 MOV    es, dx                       ; UNKNOWN
026468  8B D8                 MOV    bx, ax                       ; UNKNOWN
