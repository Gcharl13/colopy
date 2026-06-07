; ============================================================================
; func_02DC86_unknown
; Region   : load_image
; Bytes    : file 0x02DC86..0x02DCB2  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DC86  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02DC8A  56                    PUSH   si                           ; UNKNOWN
02DC8B  C6 46 FE FF           MOV    byte ptr [bp - 2], 0xff      ; UNKNOWN
02DC8F  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02DC92  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DC95  0E                    PUSH   cs                           ; UNKNOWN
02DC96  E8 2A FF              CALL   0x2dbc3                      ; UNKNOWN
02DC99  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02DC9C  0B C0                 OR     ax, ax                       ; UNKNOWN
02DC9E  7C 0C                 JL     0x2dcac                      ; UNKNOWN
02DCA0  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02DCA4  8B F0                 MOV    si, ax                       ; UNKNOWN
02DCA6  8A 40 70              MOV    al, byte ptr [bx + si + 0x70] ; UNKNOWN
02DCA9  88 46 FE              MOV    byte ptr [bp - 2], al        ; UNKNOWN
02DCAC  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
02DCAF  5E                    POP    si                           ; UNKNOWN
02DCB0  C9                    LEAVE                               ; UNKNOWN
02DCB1  CB                    RETF                                ; UNKNOWN
