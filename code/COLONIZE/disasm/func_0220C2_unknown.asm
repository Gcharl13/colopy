; ============================================================================
; func_0220C2_unknown
; Region   : load_image
; Bytes    : file 0x0220C2..0x02212D  (107 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0220C2  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
0220C6  57                    PUSH   di                           ; UNKNOWN
0220C7  56                    PUSH   si                           ; UNKNOWN
0220C8  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0220CB  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
0220CE  26 8B 44 02           MOV    ax, word ptr es:[si + 2]     ; UNKNOWN
0220D2  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
0220D5  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0220D7  8C C0                 MOV    ax, es                       ; UNKNOWN
0220D9  26 C4 5C 12           LES    bx, ptr es:[si + 0x12]       ; UNKNOWN
0220DD  89 5E EE              MOV    word ptr [bp - 0x12], bx     ; UNKNOWN
0220E0  8C 46 F0              MOV    word ptr [bp - 0x10], es     ; UNKNOWN
0220E3  26 FF 77 2A           PUSH   word ptr es:[bx + 0x2a]      ; UNKNOWN
0220E7  26 FF 77 28           PUSH   word ptr es:[bx + 0x28]      ; UNKNOWN
0220EB  8B F8                 MOV    di, ax                       ; UNKNOWN
0220ED  E8 82 F5              CALL   0x21672                      ; UNKNOWN
0220F0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0220F3  C4 5E EE              LES    bx, ptr [bp - 0x12]          ; UNKNOWN
0220F6  26 03 47 04           ADD    ax, word ptr es:[bx + 4]     ; UNKNOWN
0220FA  83 C0 03              ADD    ax, 3                        ; UNKNOWN
0220FD  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
022100  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
022102  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
022107  8E C7                 MOV    es, di                       ; UNKNOWN
022109  26 8B 44 1E           MOV    ax, word ptr es:[si + 0x1e]  ; UNKNOWN
02210D  26 8B 54 20           MOV    dx, word ptr es:[si + 0x20]  ; UNKNOWN
022111  89 56 F8              MOV    word ptr [bp - 8], dx        ; UNKNOWN
022114  0B D0                 OR     dx, ax                       ; UNKNOWN
022116  74 1F                 JE     0x22137                      ; UNKNOWN
022118  8B D8                 MOV    bx, ax                       ; UNKNOWN
02211A  8B 4E FA              MOV    cx, word ptr [bp - 6]        ; UNKNOWN
02211D  8E 5E F8              MOV    ds, word ptr [bp - 8]        ; UNKNOWN
022120  F6 07 02              TEST   byte ptr [bx], 2             ; UNKNOWN
022123  75 01                 JNE    0x22126                      ; UNKNOWN
022125  41                    INC    cx                           ; UNKNOWN
022126  C5 5F 0E              LDS    bx, ptr [bx + 0xe]           ; UNKNOWN
022129  8C D8                 MOV    ax, ds                       ; UNKNOWN
02212B  0B C3                 OR     ax, bx                       ; UNKNOWN
