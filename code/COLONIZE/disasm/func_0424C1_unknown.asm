; ============================================================================
; func_0424C1_unknown
; Region   : load_image
; Bytes    : file 0x0424C1..0x0424F5  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0424C1  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0424C5  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0424C8  C6 07 00              MOV    byte ptr [bx], 0             ; UNKNOWN
0424CB  FF 36 D5 3C           PUSH   word ptr [0x3cd5]            ; UNKNOWN
0424CF  53                    PUSH   bx                           ; UNKNOWN
0424D0  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
0424D5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0424D8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0424DB  9A 0C 00 13 24        LCALL  0x2413, 0xc                  ; UNKNOWN
0424E0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0424E3  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0424E6  83 E8 18              SUB    ax, 0x18                     ; UNKNOWN
0424E9  50                    PUSH   ax                           ; UNKNOWN
0424EA  1E                    PUSH   ds                           ; UNKNOWN
0424EB  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0424EE  9A 38 01 13 24        LCALL  0x2413, 0x138                ; UNKNOWN
0424F3  C9                    LEAVE                               ; UNKNOWN
0424F4  CB                    RETF                                ; UNKNOWN
