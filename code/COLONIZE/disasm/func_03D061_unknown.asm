; ============================================================================
; func_03D061_unknown
; Region   : load_image
; Bytes    : file 0x03D061..0x03D080  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D061  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03D065  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
03D06A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03D06D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03D070  0E                    PUSH   cs                           ; UNKNOWN
03D071  E8 1E FC              CALL   0x3cc92                      ; UNKNOWN
03D074  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D077  0B C0                 OR     ax, ax                       ; UNKNOWN
03D079  75 05                 JNE    0x3d080                      ; UNKNOWN
03D07B  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03D07E  C9                    LEAVE                               ; UNKNOWN
03D07F  CB                    RETF                                ; UNKNOWN
