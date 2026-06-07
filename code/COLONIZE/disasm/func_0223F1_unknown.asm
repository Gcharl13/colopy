; ============================================================================
; func_0223F1_unknown
; Region   : load_image
; Bytes    : file 0x0223F1..0x02241E  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0223F1  C8 3C 00 00           ENTER  0x3c, 0                      ; UNKNOWN
0223F5  56                    PUSH   si                           ; UNKNOWN
0223F6  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0      ; UNKNOWN
0223FB  2B C0                 SUB    ax, ax                       ; UNKNOWN
0223FD  89 46 D8              MOV    word ptr [bp - 0x28], ax     ; UNKNOWN
022400  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
022403  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
022406  26 8B 47 12           MOV    ax, word ptr es:[bx + 0x12]  ; UNKNOWN
02240A  26 8B 57 14           MOV    dx, word ptr es:[bx + 0x14]  ; UNKNOWN
02240E  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
022411  89 56 F4              MOV    word ptr [bp - 0xc], dx      ; UNKNOWN
022414  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
022419  BB 40 00              MOV    bx, 0x40                     ; UNKNOWN
02241C  8E C3                 MOV    es, bx                       ; UNKNOWN
