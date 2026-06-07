; ============================================================================
; func_0195EB_unknown
; Region   : load_image
; Bytes    : file 0x0195EB..0x019616  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0195EB  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0195EF  6B 46 06 13           IMUL   ax, word ptr [bp + 6], 0x13  ; UNKNOWN
0195F3  40                    INC    ax                           ; UNKNOWN
0195F4  83 3E 10 09 00        CMP    word ptr [0x910], 0          ; UNKNOWN
0195F9  75 25                 JNE    0x19620                      ; UNKNOWN
0195FB  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
0195FF  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
019603  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
019607  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
01960B  68 C7 00              PUSH   0xc7                         ; UNKNOWN
01960E  8A 4E 08              MOV    cl, byte ptr [bp + 8]        ; UNKNOWN
019611  51                    PUSH   cx                           ; UNKNOWN
019612  8B D8                 MOV    bx, ax                       ; UNKNOWN
019614  83                    DB     0x83                         ; UNKNOWN (raw)
019615  C3                    DB     0xC3                         ; UNKNOWN (raw)
