; ============================================================================
; func_0334E1_unknown
; Region   : load_image
; Bytes    : file 0x0334E1..0x033534  (83 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0334E1  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
0334E5  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
0334E8  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0334EB  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0334EE  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
0334F1  83 E8 14              SUB    ax, 0x14                     ; UNKNOWN
0334F4  8B D0                 MOV    dx, ax                       ; UNKNOWN
0334F6  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
0334FB  EB 2B                 JMP    0x33528                      ; UNKNOWN
0334FD  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c  ; UNKNOWN
033501  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
033506  72 07                 JB     0x3350f                      ; UNKNOWN
033508  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
03350D  76 11                 JBE    0x33520                      ; UNKNOWN
03350F  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
033512  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
033515  39 46 FA              CMP    word ptr [bp - 6], ax        ; UNKNOWN
033518  75 06                 JNE    0x33520                      ; UNKNOWN
03351A  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
03351D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
033520  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
033523  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
033528  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03352B  0B C0                 OR     ax, ax                       ; UNKNOWN
03352D  7D CE                 JGE    0x334fd                      ; UNKNOWN
03352F  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
033532  C9                    LEAVE                               ; UNKNOWN
033533  CB                    RETF                                ; UNKNOWN
