; ============================================================================
; func_01B02F_unknown
; Region   : load_image
; Bytes    : file 0x01B02F..0x01B060  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01B02F  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
01B033  0E                    PUSH   cs                           ; UNKNOWN
01B034  E8 AC FE              CALL   0x1aee3                      ; UNKNOWN
01B037  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01B03A  83 3E C6 32 06        CMP    word ptr [0x32c6], 6         ; UNKNOWN
01B03F  75 1F                 JNE    0x1b060                      ; UNKNOWN
01B041  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
01B046  75 03                 JNE    0x1b04b                      ; UNKNOWN
01B048  E9 F3 00              JMP    0x1b13e                      ; UNKNOWN
01B04B  83 3E C8 32 00        CMP    word ptr [0x32c8], 0         ; UNKNOWN
01B050  75 03                 JNE    0x1b055                      ; UNKNOWN
01B052  E9 E9 00              JMP    0x1b13e                      ; UNKNOWN
01B055  6A 00                 PUSH   0                            ; UNKNOWN
01B057  0E                    PUSH   cs                           ; UNKNOWN
01B058  E8 68 F1              CALL   0x1a1c3                      ; UNKNOWN
01B05B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01B05E  C9                    LEAVE                               ; UNKNOWN
01B05F  CB                    RETF                                ; UNKNOWN
