; ============================================================================
; func_02DBAE_unknown
; Region   : load_image
; Bytes    : file 0x02DBAE..0x02DBC3  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DBAE  55                    PUSH   bp                           ; UNKNOWN
02DBAF  8B EC                 MOV    bp, sp                       ; UNKNOWN
02DBB1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DBB4  0E                    PUSH   cs                           ; UNKNOWN
02DBB5  E8 71 FF              CALL   0x2db29                      ; UNKNOWN
02DBB8  8B E5                 MOV    sp, bp                       ; UNKNOWN
02DBBA  52                    PUSH   dx                           ; UNKNOWN
02DBBB  50                    PUSH   ax                           ; UNKNOWN
02DBBC  9A 01 02 2B 3E        LCALL  0x3e2b, 0x201                ; UNKNOWN
02DBC1  C9                    LEAVE                               ; UNKNOWN
02DBC2  CB                    RETF                                ; UNKNOWN
