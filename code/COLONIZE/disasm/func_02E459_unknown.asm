; ============================================================================
; func_02E459_unknown
; Region   : load_image
; Bytes    : file 0x02E459..0x02E482  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E459  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E45D  56                    PUSH   si                           ; UNKNOWN
02E45E  83 7E 08 17           CMP    word ptr [bp + 8], 0x17      ; UNKNOWN
02E462  75 05                 JNE    0x2e469                      ; UNKNOWN
02E464  C7 46 08 15 00        MOV    word ptr [bp + 8], 0x15      ; UNKNOWN
02E469  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02E46D  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02E470  98                    CWDE                                ; UNKNOWN
02E471  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
02E474  7E 0C                 JLE    0x2e482                      ; UNKNOWN
02E476  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
02E479  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02E47C  88 40 40              MOV    byte ptr [bx + si + 0x40], al ; UNKNOWN
02E47F  5E                    POP    si                           ; UNKNOWN
02E480  C9                    LEAVE                               ; UNKNOWN
02E481  CB                    RETF                                ; UNKNOWN
