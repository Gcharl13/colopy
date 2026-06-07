; ============================================================================
; func_03A232_unknown
; Region   : load_image
; Bytes    : file 0x03A232..0x03A298  (102 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03A232  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
03A236  2B C0                 SUB    ax, ax                       ; UNKNOWN
03A238  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03A23B  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03A23E  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
03A241  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
03A244  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03A247  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03A24B  2A E4                 SUB    ah, ah                       ; UNKNOWN
03A24D  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
03A250  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
03A254  2A ED                 SUB    ch, ch                       ; UNKNOWN
03A256  89 4E F0              MOV    word ptr [bp - 0x10], cx     ; UNKNOWN
03A259  51                    PUSH   cx                           ; UNKNOWN
03A25A  50                    PUSH   ax                           ; UNKNOWN
03A25B  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
03A260  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A263  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
03A266  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
03A269  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
03A26C  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
03A271  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A274  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
03A277  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
03A27A  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
03A27D  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
03A282  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A285  A8 40                 TEST   al, 0x40                     ; UNKNOWN
03A287  74 0F                 JE     0x3a298                      ; UNKNOWN
03A289  6A 03                 PUSH   3                            ; UNKNOWN
03A28B  68 72 22              PUSH   0x2272                       ; UNKNOWN
03A28E  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
03A293  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A296  C9                    LEAVE                               ; UNKNOWN
03A297  CB                    RETF                                ; UNKNOWN
