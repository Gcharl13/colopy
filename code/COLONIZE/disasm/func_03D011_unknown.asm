; ============================================================================
; func_03D011_unknown
; Region   : load_image
; Bytes    : file 0x03D011..0x03D030  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D011  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03D015  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
03D01A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03D01D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03D020  0E                    PUSH   cs                           ; UNKNOWN
03D021  E8 6E FC              CALL   0x3cc92                      ; UNKNOWN
03D024  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D027  0B C0                 OR     ax, ax                       ; UNKNOWN
03D029  75 05                 JNE    0x3d030                      ; UNKNOWN
03D02B  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03D02E  C9                    LEAVE                               ; UNKNOWN
03D02F  CB                    RETF                                ; UNKNOWN
