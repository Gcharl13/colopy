; ============================================================================
; func_035FF7_unknown
; Region   : load_image
; Bytes    : file 0x035FF7..0x036020  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

035FF7  C8 22 00 00           ENTER  0x22, 0                      ; UNKNOWN
035FFB  56                    PUSH   si                           ; UNKNOWN
035FFC  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
036001  83 3E BA 79 08        CMP    word ptr [0x79ba], 8         ; UNKNOWN
036006  75 18                 JNE    0x36020                      ; UNKNOWN
036008  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
03600D  75 03                 JNE    0x36012                      ; UNKNOWN
03600F  E9 B5 02              JMP    0x362c7                      ; UNKNOWN
036012  FF 36 9C 79           PUSH   word ptr [0x799c]            ; UNKNOWN
036016  0E                    PUSH   cs                           ; UNKNOWN
036017  E8 5B F8              CALL   0x35875                      ; UNKNOWN
03601A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03601D  5E                    POP    si                           ; UNKNOWN
03601E  C9                    LEAVE                               ; UNKNOWN
03601F  CB                    RETF                                ; UNKNOWN
