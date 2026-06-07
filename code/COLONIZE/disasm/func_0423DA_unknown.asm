; ============================================================================
; func_0423DA_unknown
; Region   : load_image
; Bytes    : file 0x0423DA..0x0423F2  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0423DA  55                    PUSH   bp                           ; UNKNOWN
0423DB  8B EC                 MOV    bp, sp                       ; UNKNOWN
0423DD  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0423E0  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0423E3  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
0423E8  8B E5                 MOV    sp, bp                       ; UNKNOWN
0423EA  0B C0                 OR     ax, ax                       ; UNKNOWN
0423EC  74 04                 JE     0x423f2                      ; UNKNOWN
0423EE  2B C0                 SUB    ax, ax                       ; UNKNOWN
0423F0  C9                    LEAVE                               ; UNKNOWN
0423F1  CB                    RETF                                ; UNKNOWN
