; ============================================================================
; func_01E023_unknown
; Region   : load_image
; Bytes    : file 0x01E023..0x01E074  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01E023  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
01E027  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
01E02C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
01E02F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
01E032  9A 81 03 C9 33        LCALL  0x33c9, 0x381                ; UNKNOWN
01E037  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01E03A  0B C0                 OR     ax, ax                       ; UNKNOWN
01E03C  7C 31                 JL     0x1e06f                      ; UNKNOWN
01E03E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
01E043  EB 24                 JMP    0x1e069                      ; UNKNOWN
01E045  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
01E048  39 06 12 3E           CMP    word ptr [0x3e12], ax        ; UNKNOWN
01E04C  7E 21                 JLE    0x1e06f                      ; UNKNOWN
01E04E  6B D8 12              IMUL   bx, ax, 0x12                 ; UNKNOWN
01E051  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; UNKNOWN
01E054  38 8F DC 79           CMP    byte ptr [bx + 0x79dc], cl   ; UNKNOWN
01E058  75 0C                 JNE    0x1e066                      ; UNKNOWN
01E05A  8A 4E 08              MOV    cl, byte ptr [bp + 8]        ; UNKNOWN
01E05D  38 8F DD 79           CMP    byte ptr [bx + 0x79dd], cl   ; UNKNOWN
01E061  75 03                 JNE    0x1e066                      ; UNKNOWN
01E063  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01E066  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
01E069  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
01E06D  7C D6                 JL     0x1e045                      ; UNKNOWN
01E06F  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
01E072  C9                    LEAVE                               ; UNKNOWN
01E073  CB                    RETF                                ; UNKNOWN
