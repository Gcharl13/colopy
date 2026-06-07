; ============================================================================
; func_04F71B_unknown
; Region   : load_image
; Bytes    : file 0x04F71B..0x04F786  (107 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04F71B  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04F71F  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
04F724  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
04F728  74 10                 JE     0x4f73a                      ; UNKNOWN
04F72A  A1 0C 3E              MOV    ax, word ptr [0x3e0c]        ; UNKNOWN
04F72D  83 E8 20              SUB    ax, 0x20                     ; UNKNOWN
04F730  8B D0                 MOV    dx, ax                       ; UNKNOWN
04F732  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
04F737  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04F73A  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
04F73E  7C 3E                 JL     0x4f77e                      ; UNKNOWN
04F740  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c  ; UNKNOWN
04F744  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
04F749  72 23                 JB     0x4f76e                      ; UNKNOWN
04F74B  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
04F750  77 1C                 JA     0x4f76e                      ; UNKNOWN
04F752  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04F755  9A 9C 10 B7 36        LCALL  0x36b7, 0x109c               ; UNKNOWN
04F75A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F75D  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04F760  0E                    PUSH   cs                           ; UNKNOWN
04F761  E8 FB FD              CALL   0x4f55f                      ; UNKNOWN
04F764  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04F767  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
04F76C  EB 10                 JMP    0x4f77e                      ; UNKNOWN
04F76E  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
04F771  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
04F776  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04F779  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
04F77E  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
04F782  7D A0                 JGE    0x4f724                      ; UNKNOWN
04F784  C9                    LEAVE                               ; UNKNOWN
04F785  CB                    RETF                                ; UNKNOWN
