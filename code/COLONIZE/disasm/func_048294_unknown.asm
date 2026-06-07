; ============================================================================
; func_048294_unknown
; Region   : load_image
; Bytes    : file 0x048294..0x0482AC  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048294  C8 42 00 00           ENTER  0x42, 0                      ; UNKNOWN
048298  56                    PUSH   si                           ; UNKNOWN
048299  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04829D  80 BF 88 88 02        CMP    byte ptr [bx - 0x7778], 2    ; UNKNOWN
0482A2  74 08                 JE     0x482ac                      ; UNKNOWN
0482A4  C6 87 88 88 00        MOV    byte ptr [bx - 0x7778], 0    ; UNKNOWN
0482A9  5E                    POP    si                           ; UNKNOWN
0482AA  C9                    LEAVE                               ; UNKNOWN
0482AB  CB                    RETF                                ; UNKNOWN
