; ============================================================================
; func_0698EE_unknown
; Region   : load_image
; Bytes    : file 0x0698EE..0x06990E  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0698EE  55                    PUSH   bp                           ; UNKNOWN
0698EF  8B EC                 MOV    bp, sp                       ; UNKNOWN
0698F1  53                    PUSH   bx                           ; UNKNOWN
0698F2  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0698F5  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0698F8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0698FB  FF 77 02              PUSH   word ptr [bx + 2]            ; UNKNOWN
0698FE  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
069900  0E                    PUSH   cs                           ; UNKNOWN
069901  E8 1E FF              CALL   0x69822                      ; UNKNOWN
069904  89 57 02              MOV    word ptr [bx + 2], dx        ; UNKNOWN
069907  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
069909  5B                    POP    bx                           ; UNKNOWN
06990A  5D                    POP    bp                           ; UNKNOWN
06990B  CA 06 00              RETF   6                            ; UNKNOWN
