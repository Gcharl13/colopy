; ============================================================================
; func_02DB95_unknown
; Region   : load_image
; Bytes    : file 0x02DB95..0x02DBAE  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DB95  55                    PUSH   bp                           ; UNKNOWN
02DB96  8B EC                 MOV    bp, sp                       ; UNKNOWN
02DB98  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DB9B  0E                    PUSH   cs                           ; UNKNOWN
02DB9C  E8 8A FF              CALL   0x2db29                      ; UNKNOWN
02DB9F  8B E5                 MOV    sp, bp                       ; UNKNOWN
02DBA1  52                    PUSH   dx                           ; UNKNOWN
02DBA2  50                    PUSH   ax                           ; UNKNOWN
02DBA3  1E                    PUSH   ds                           ; UNKNOWN
02DBA4  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02DBA7  9A F1 01 13 24        LCALL  0x2413, 0x1f1                ; UNKNOWN
02DBAC  C9                    LEAVE                               ; UNKNOWN
02DBAD  CB                    RETF                                ; UNKNOWN
