; ============================================================================
; func_040B3C_unknown
; Region   : load_image
; Bytes    : file 0x040B3C..0x040B66  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040B3C  55                    PUSH   bp                           ; UNKNOWN
040B3D  8B EC                 MOV    bp, sp                       ; UNKNOWN
040B3F  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
040B43  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
040B47  2A FF                 SUB    bh, bh                       ; UNKNOWN
040B49  83 FB 01              CMP    bx, 1                        ; UNKNOWN
040B4C  74 18                 JE     0x40b66                      ; UNKNOWN
040B4E  83 FB 04              CMP    bx, 4                        ; UNKNOWN
040B51  74 13                 JE     0x40b66                      ; UNKNOWN
040B53  83 FB 0B              CMP    bx, 0xb                      ; UNKNOWN
040B56  74 0E                 JE     0x40b66                      ; UNKNOWN
040B58  83 FB 14              CMP    bx, 0x14                     ; UNKNOWN
040B5B  74 09                 JE     0x40b66                      ; UNKNOWN
040B5D  83 FB 16              CMP    bx, 0x16                     ; UNKNOWN
040B60  74 04                 JE     0x40b66                      ; UNKNOWN
040B62  2B C0                 SUB    ax, ax                       ; UNKNOWN
040B64  C9                    LEAVE                               ; UNKNOWN
040B65  CB                    RETF                                ; UNKNOWN
