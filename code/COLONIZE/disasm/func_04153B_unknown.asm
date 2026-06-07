; ============================================================================
; func_04153B_unknown
; Region   : load_image
; Bytes    : file 0x04153B..0x0415A0  (101 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04153B  55                    PUSH   bp                           ; UNKNOWN
04153C  8B EC                 MOV    bp, sp                       ; UNKNOWN
04153E  80 3E C6 0B 00        CMP    byte ptr [0xbc6], 0          ; UNKNOWN
041543  74 0D                 JE     0x41552                      ; UNKNOWN
041545  6A 00                 PUSH   0                            ; UNKNOWN
041547  6A 00                 PUSH   0                            ; UNKNOWN
041549  6A 00                 PUSH   0                            ; UNKNOWN
04154B  9A D0 02 2B 3E        LCALL  0x3e2b, 0x2d0                ; UNKNOWN
041550  EB 33                 JMP    0x41585                      ; UNKNOWN
041552  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
041556  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04155A  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04155E  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
041562  6A 07                 PUSH   7                            ; UNKNOWN
041564  6A 00                 PUSH   0                            ; UNKNOWN
041566  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
041569  99                    CDQ                                 ; UNKNOWN
04156A  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
04156D  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
041572  6A 00                 PUSH   0                            ; UNKNOWN
041574  6A 00                 PUSH   0                            ; UNKNOWN
041576  6A 00                 PUSH   0                            ; UNKNOWN
041578  FF 36 AE 09           PUSH   word ptr [0x9ae]             ; UNKNOWN
04157C  FF 36 AC 09           PUSH   word ptr [0x9ac]             ; UNKNOWN
041580  9A 2A 09 67 18        LCALL  0x1867, 0x92a                ; UNKNOWN
041585  8B E5                 MOV    sp, bp                       ; UNKNOWN
041587  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
04158B  74 11                 JE     0x4159e                      ; UNKNOWN
04158D  6A 00                 PUSH   0                            ; UNKNOWN
04158F  68 40 01              PUSH   0x140                        ; UNKNOWN
041592  6A 07                 PUSH   7                            ; UNKNOWN
041594  2B C0                 SUB    ax, ax                       ; UNKNOWN
041596  99                    CDQ                                 ; UNKNOWN
041597  2B DB                 SUB    bx, bx                       ; UNKNOWN
041599  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
04159E  C9                    LEAVE                               ; UNKNOWN
04159F  CB                    RETF                                ; UNKNOWN
