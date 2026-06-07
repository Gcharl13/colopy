; ============================================================================
; func_043FE5_unknown
; Region   : load_image
; Bytes    : file 0x043FE5..0x04402A  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043FE5  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
043FE9  8B 0E 1C 0B           MOV    cx, word ptr [0xb1c]         ; UNKNOWN
043FED  8B 16 1E 0B           MOV    dx, word ptr [0xb1e]         ; UNKNOWN
043FF1  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
043FF4  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
043FF7  83 3E 34 0B 00        CMP    word ptr [0xb34], 0          ; UNKNOWN
043FFC  75 2C                 JNE    0x4402a                      ; UNKNOWN
043FFE  8A 1E B3 0B           MOV    bl, byte ptr [0xbb3]         ; UNKNOWN
044002  2A FF                 SUB    bh, bh                       ; UNKNOWN
044004  03 1E B0 C1           ADD    bx, word ptr [0xc1b0]        ; UNKNOWN
044008  83 EB 0F              SUB    bx, 0xf                      ; UNKNOWN
04400B  53                    PUSH   bx                           ; UNKNOWN
04400C  8A 1E B2 0B           MOV    bl, byte ptr [0xbb2]         ; UNKNOWN
044010  2A FF                 SUB    bh, bh                       ; UNKNOWN
044012  03 1E AE C1           ADD    bx, word ptr [0xc1ae]        ; UNKNOWN
044016  83 EB 08              SUB    bx, 8                        ; UNKNOWN
044019  53                    PUSH   bx                           ; UNKNOWN
04401A  68 8A CE              PUSH   0xce8a                       ; UNKNOWN
04401D  50                    PUSH   ax                           ; UNKNOWN
04401E  52                    PUSH   dx                           ; UNKNOWN
04401F  51                    PUSH   cx                           ; UNKNOWN
044020  9A A6 00 2D 45        LCALL  0x452d, 0xa6                 ; UNKNOWN
044025  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
044028  C9                    LEAVE                               ; UNKNOWN
044029  C3                    RET                                 ; UNKNOWN
