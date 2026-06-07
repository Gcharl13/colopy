; ============================================================================
; func_043F25_unknown
; Region   : load_image
; Bytes    : file 0x043F25..0x043F6A  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043F25  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
043F29  8B 0E 1C 0B           MOV    cx, word ptr [0xb1c]         ; UNKNOWN
043F2D  8B 16 1E 0B           MOV    dx, word ptr [0xb1e]         ; UNKNOWN
043F31  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
043F34  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
043F37  83 3E 34 0B 00        CMP    word ptr [0xb34], 0          ; UNKNOWN
043F3C  75 2C                 JNE    0x43f6a                      ; UNKNOWN
043F3E  8A 1E B3 0B           MOV    bl, byte ptr [0xbb3]         ; UNKNOWN
043F42  2A FF                 SUB    bh, bh                       ; UNKNOWN
043F44  03 1E B0 C1           ADD    bx, word ptr [0xc1b0]        ; UNKNOWN
043F48  83 EB 0F              SUB    bx, 0xf                      ; UNKNOWN
043F4B  53                    PUSH   bx                           ; UNKNOWN
043F4C  8A 1E B2 0B           MOV    bl, byte ptr [0xbb2]         ; UNKNOWN
043F50  2A FF                 SUB    bh, bh                       ; UNKNOWN
043F52  03 1E AE C1           ADD    bx, word ptr [0xc1ae]        ; UNKNOWN
043F56  83 EB 08              SUB    bx, 8                        ; UNKNOWN
043F59  53                    PUSH   bx                           ; UNKNOWN
043F5A  68 8A CE              PUSH   0xce8a                       ; UNKNOWN
043F5D  50                    PUSH   ax                           ; UNKNOWN
043F5E  52                    PUSH   dx                           ; UNKNOWN
043F5F  51                    PUSH   cx                           ; UNKNOWN
043F60  9A 43 00 2D 45        LCALL  0x452d, 0x43                 ; UNKNOWN
043F65  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
043F68  C9                    LEAVE                               ; UNKNOWN
043F69  C3                    RET                                 ; UNKNOWN
