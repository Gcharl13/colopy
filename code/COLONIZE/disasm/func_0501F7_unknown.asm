; ============================================================================
; func_0501F7_unknown
; Region   : load_image
; Bytes    : file 0x0501F7..0x05022B  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0501F7  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0501FB  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
050200  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
050203  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
050206  0E                    PUSH   cs                           ; UNKNOWN
050207  E8 BC FC              CALL   0x4fec6                      ; UNKNOWN
05020A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
05020D  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
050210  83 7E FE 40           CMP    word ptr [bp - 2], 0x40      ; UNKNOWN
050214  7C EA                 JL     0x50200                      ; UNKNOWN
050216  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
05021B  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
05021E  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
050221  03 5E FE              ADD    bx, word ptr [bp - 2]        ; UNKNOWN
050224  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
050227  80                    DB     0x80                         ; UNKNOWN (raw)
050228  BF                    DB     0xBF                         ; UNKNOWN (raw)
050229  3C                    DB     0x3C                         ; UNKNOWN (raw)
05022A  CB                    DB     0xCB                         ; UNKNOWN (raw)
