; ============================================================================
; func_0637D4_unknown
; Region   : load_image
; Bytes    : file 0x0637D4..0x0637EC  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0637D4  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
0637D8  53                    PUSH   bx                           ; UNKNOWN
0637D9  52                    PUSH   dx                           ; UNKNOWN
0637DA  50                    PUSH   ax                           ; UNKNOWN
0637DB  57                    PUSH   di                           ; UNKNOWN
0637DC  0B C0                 OR     ax, ax                       ; UNKNOWN
0637DE  7C 5A                 JL     0x6383a                      ; UNKNOWN
0637E0  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
0637E3  39 46 F4              CMP    word ptr [bp - 0xc], ax      ; UNKNOWN
0637E6  7D 52                 JGE    0x6383a                      ; UNKNOWN
0637E8  8B C2                 MOV    ax, dx                       ; UNKNOWN
0637EA  0B C0                 OR     ax, ax                       ; UNKNOWN
