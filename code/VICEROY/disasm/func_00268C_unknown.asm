; ============================================================================
; func_00268C_unknown
; Region   : load_image
; Bytes    : file 0x00268C..0x0026B2  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00268C  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
002690  C6 46 EC 00           MOV    byte ptr [bp - 0x14], 0      ; LOCAL_STORE
002694  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
002697  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00269A  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
00269D  16                    PUSH   ss                           ; UNKNOWN
00269E  50                    PUSH   ax                           ; UNKNOWN
00269F  9A E8 01 4B 00        LCALL  0x4b, 0x1e8                  ; UNKNOWN
0026A4  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0026A7  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
0026AA  16                    PUSH   ss                           ; UNKNOWN
0026AB  50                    PUSH   ax                           ; UNKNOWN
0026AC  0E                    PUSH   cs                           ; UNKNOWN
0026AD  E8 5E FF              CALL   0x260e                       ; UNKNOWN
0026B0  C9                    LEAVE                               ; UNKNOWN
0026B1  CB                    RETF                                ; UNKNOWN
