; ============================================================================
; func_02B496_unknown
; Region   : load_image
; Bytes    : file 0x02B496..0x02B4B1  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B496  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02B49A  56                    PUSH   si                           ; UNKNOWN
02B49B  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
02B49F  7C 10                 JL     0x2b4b1                      ; UNKNOWN
02B4A1  6B 76 06 4E           IMUL   si, word ptr [bp + 6], 0x4e  ; UNKNOWN
02B4A5  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
02B4A8  8A 80 C6 7E           MOV    al, byte ptr [bx + si + 0x7ec6] ; UNKNOWN
02B4AC  2A E4                 SUB    ah, ah                       ; UNKNOWN
02B4AE  5E                    POP    si                           ; UNKNOWN
02B4AF  C9                    LEAVE                               ; UNKNOWN
02B4B0  CB                    RETF                                ; UNKNOWN
