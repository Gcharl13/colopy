; ============================================================================
; func_0282BE_unknown
; Region   : load_image
; Bytes    : file 0x0282BE..0x0282E4  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0282BE  55                    PUSH   bp                           ; UNKNOWN
0282BF  8B EC                 MOV    bp, sp                       ; UNKNOWN
0282C1  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0282C4  A3 94 40              MOV    word ptr [0x4094], ax        ; UNKNOWN
0282C7  8B C8                 MOV    cx, ax                       ; UNKNOWN
0282C9  C1 E0 02              SHL    ax, 2                        ; UNKNOWN
0282CC  03 C1                 ADD    ax, cx                       ; UNKNOWN
0282CE  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0282D0  03 06 8A 40           ADD    ax, word ptr [0x408a]        ; UNKNOWN
0282D4  8B 16 8C 40           MOV    dx, word ptr [0x408c]        ; UNKNOWN
0282D8  83 C0 22              ADD    ax, 0x22                     ; UNKNOWN
0282DB  A3 8E 40              MOV    word ptr [0x408e], ax        ; UNKNOWN
0282DE  89 16 90 40           MOV    word ptr [0x4090], dx        ; UNKNOWN
0282E2  C9                    LEAVE                               ; UNKNOWN
0282E3  CB                    RETF                                ; UNKNOWN
