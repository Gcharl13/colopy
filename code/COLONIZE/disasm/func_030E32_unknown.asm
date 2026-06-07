; ============================================================================
; func_030E32_unknown
; Region   : load_image
; Bytes    : file 0x030E32..0x030E5F  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030E32  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
030E36  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
030E3B  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
030E40  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
030E43  0E                    PUSH   cs                           ; UNKNOWN
030E44  E8 87 FD              CALL   0x30bce                      ; UNKNOWN
030E47  83 C4 02              ADD    sp, 2                        ; UNKNOWN
030E4A  0B C0                 OR     ax, ax                       ; UNKNOWN
030E4C  74 03                 JE     0x30e51                      ; UNKNOWN
030E4E  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
030E51  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
030E54  83 7E FC 31           CMP    word ptr [bp - 4], 0x31      ; UNKNOWN
030E58  7C E6                 JL     0x30e40                      ; UNKNOWN
030E5A  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
030E5D  C9                    LEAVE                               ; UNKNOWN
030E5E  CB                    RETF                                ; UNKNOWN
