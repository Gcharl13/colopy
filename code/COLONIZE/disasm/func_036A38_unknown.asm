; ============================================================================
; func_036A38_unknown
; Region   : load_image
; Bytes    : file 0x036A38..0x036A83  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

036A38  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
036A3C  56                    PUSH   si                           ; UNKNOWN
036A3D  83 3E BA 79 0A        CMP    word ptr [0x79ba], 0xa       ; UNKNOWN
036A42  75 5A                 JNE    0x36a9e                      ; UNKNOWN
036A44  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
036A49  75 03                 JNE    0x36a4e                      ; UNKNOWN
036A4B  E9 28 01              JMP    0x36b76                      ; UNKNOWN
036A4E  83 3E A2 79 00        CMP    word ptr [0x79a2], 0         ; UNKNOWN
036A53  74 03                 JE     0x36a58                      ; UNKNOWN
036A55  E9 1E 01              JMP    0x36b76                      ; UNKNOWN
036A58  FF 36 A4 79           PUSH   word ptr [0x79a4]            ; UNKNOWN
036A5C  0E                    PUSH   cs                           ; UNKNOWN
036A5D  E8 A7 C9              CALL   0x33407                      ; UNKNOWN
036A60  83 C4 02              ADD    sp, 2                        ; UNKNOWN
036A63  0B C0                 OR     ax, ax                       ; UNKNOWN
036A65  74 12                 JE     0x36a79                      ; UNKNOWN
036A67  FF 36 A4 79           PUSH   word ptr [0x79a4]            ; UNKNOWN
036A6B  0E                    PUSH   cs                           ; UNKNOWN
036A6C  E8 6A F1              CALL   0x35bd9                      ; UNKNOWN
036A6F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
036A72  0B C0                 OR     ax, ax                       ; UNKNOWN
036A74  75 03                 JNE    0x36a79                      ; UNKNOWN
036A76  E9 FD 00              JMP    0x36b76                      ; UNKNOWN
036A79  FF 36 9C 79           PUSH   word ptr [0x799c]            ; UNKNOWN
036A7D  0E                    PUSH   cs                           ; UNKNOWN
036A7E  E8 02 CA              CALL   0x33483                      ; UNKNOWN
036A81  83                    DB     0x83                         ; UNKNOWN (raw)
036A82  C4                    DB     0xC4                         ; UNKNOWN (raw)
