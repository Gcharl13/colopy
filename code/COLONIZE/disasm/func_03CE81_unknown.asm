; ============================================================================
; func_03CE81_unknown
; Region   : load_image
; Bytes    : file 0x03CE81..0x03CEA9  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CE81  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03CE85  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CE88  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CE8B  0E                    PUSH   cs                           ; UNKNOWN
03CE8C  E8 A0 FF              CALL   0x3ce2f                      ; UNKNOWN
03CE8F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03CE92  C0 E8 04              SHR    al, 4                        ; UNKNOWN
03CE95  2A E4                 SUB    ah, ah                       ; UNKNOWN
03CE97  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03CE9A  83 F8 0F              CMP    ax, 0xf                      ; UNKNOWN
03CE9D  75 05                 JNE    0x3cea4                      ; UNKNOWN
03CE9F  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
03CEA4  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
03CEA7  C9                    LEAVE                               ; UNKNOWN
03CEA8  CB                    RETF                                ; UNKNOWN
