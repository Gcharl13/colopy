; ============================================================================
; func_041476_unknown
; Region   : load_image
; Bytes    : file 0x041476..0x0414E6  (112 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041476  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
04147A  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
04147F  A1 8E 82              MOV    ax, word ptr [0x828e]        ; UNKNOWN
041482  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
041485  8B 0E 8C 82           MOV    cx, word ptr [0x828c]        ; UNKNOWN
041489  89 4E FA              MOV    word ptr [bp - 6], cx        ; UNKNOWN
04148C  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04148F  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
041493  98                    CWDE                                ; UNKNOWN
041494  03 06 8E 82           ADD    ax, word ptr [0x828e]        ; UNKNOWN
041498  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04149B  8B D0                 MOV    dx, ax                       ; UNKNOWN
04149D  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
0414A1  98                    CWDE                                ; UNKNOWN
0414A2  03 C8                 ADD    cx, ax                       ; UNKNOWN
0414A4  89 4E F6              MOV    word ptr [bp - 0xa], cx      ; UNKNOWN
0414A7  51                    PUSH   cx                           ; UNKNOWN
0414A8  52                    PUSH   dx                           ; UNKNOWN
0414A9  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
0414AE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0414B1  0B C0                 OR     ax, ax                       ; UNKNOWN
0414B3  75 03                 JNE    0x414b8                      ; UNKNOWN
0414B5  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0414B8  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
0414BC  74 26                 JE     0x414e4                      ; UNKNOWN
0414BE  6A 01                 PUSH   1                            ; UNKNOWN
0414C0  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
0414C3  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0414C6  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
0414C9  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0414CC  0E                    PUSH   cs                           ; UNKNOWN
0414CD  E8 D9 FE              CALL   0x413a9                      ; UNKNOWN
0414D0  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
0414D3  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
0414D6  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
0414D9  0E                    PUSH   cs                           ; UNKNOWN
0414DA  E8 B9 FC              CALL   0x41196                      ; UNKNOWN
0414DD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0414E0  0E                    PUSH   cs                           ; UNKNOWN
0414E1  E8 D4 FC              CALL   0x411b8                      ; UNKNOWN
0414E4  C9                    LEAVE                               ; UNKNOWN
0414E5  CB                    RETF                                ; UNKNOWN
