; ============================================================================
; func_064CD7_unknown
; Region   : load_image
; Bytes    : file 0x064CD7..0x064CE9  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064CD7  55                    PUSH   bp                           ; UNKNOWN
064CD8  8B EC                 MOV    bp, sp                       ; UNKNOWN
064CDA  56                    PUSH   si                           ; UNKNOWN
064CDB  8B D8                 MOV    bx, ax                       ; UNKNOWN
064CDD  C4 76 06              LES    si, ptr [bp + 6]             ; UNKNOWN
064CE0  26 88 5C 2B           MOV    byte ptr es:[si + 0x2b], bl  ; UNKNOWN
064CE4  5E                    POP    si                           ; UNKNOWN
064CE5  C9                    LEAVE                               ; UNKNOWN
064CE6  CA 04 00              RETF   4                            ; UNKNOWN
