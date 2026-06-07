; ============================================================================
; func_04087C_unknown
; Region   : load_image
; Bytes    : file 0x04087C..0x040896  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04087C  55                    PUSH   bp                           ; UNKNOWN
04087D  8B EC                 MOV    bp, sp                       ; UNKNOWN
04087F  56                    PUSH   si                           ; UNKNOWN
040880  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
040883  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040886  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
04088A  32 46 08              XOR    al, byte ptr [bp + 8]        ; UNKNOWN
04088D  24 0F                 AND    al, 0xf                      ; UNKNOWN
04088F  30 87 83 88           XOR    byte ptr [bx - 0x777d], al   ; UNKNOWN
040893  5E                    POP    si                           ; UNKNOWN
040894  C9                    LEAVE                               ; UNKNOWN
040895  CB                    RETF                                ; UNKNOWN
