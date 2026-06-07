; ============================================================================
; func_0689F2_unknown
; Region   : load_image
; Bytes    : file 0x0689F2..0x068A07  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0689F2  55                    PUSH   bp                           ; UNKNOWN
0689F3  8B EC                 MOV    bp, sp                       ; UNKNOWN
0689F5  2B C0                 SUB    ax, ax                       ; UNKNOWN
0689F7  50                    PUSH   ax                           ; UNKNOWN
0689F8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0689FB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0689FE  9A 76 03 65 5F        LCALL  0x5f65, 0x376                ; UNKNOWN
068A03  8B E5                 MOV    sp, bp                       ; UNKNOWN
068A05  5D                    POP    bp                           ; UNKNOWN
068A06  CB                    RETF                                ; UNKNOWN
