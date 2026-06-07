; ============================================================================
; func_0407D1_unknown
; Region   : load_image
; Bytes    : file 0x0407D1..0x0407EE  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0407D1  55                    PUSH   bp                           ; UNKNOWN
0407D2  8B EC                 MOV    bp, sp                       ; UNKNOWN
0407D4  57                    PUSH   di                           ; UNKNOWN
0407D5  56                    PUSH   si                           ; UNKNOWN
0407D6  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0407D9  0B F6                 OR     si, si                       ; UNKNOWN
0407DB  7C 18                 JL     0x407f5                      ; UNKNOWN
0407DD  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
0407E0  8B C7                 MOV    ax, di                       ; UNKNOWN
0407E2  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
0407E5  08 87 83 88           OR     byte ptr [bx - 0x777d], al   ; UNKNOWN
0407E9  8B C6                 MOV    ax, si                       ; UNKNOWN
0407EB  0E                    PUSH   cs                           ; UNKNOWN
0407EC  E8                    DB     0xE8                         ; UNKNOWN (raw)
0407ED  CF                    DB     0xCF                         ; UNKNOWN (raw)
