; ============================================================================
; func_067BB8_unknown
; Region   : load_image
; Bytes    : file 0x067BB8..0x067C01  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067BB8  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
067BBC  53                    PUSH   bx                           ; UNKNOWN
067BBD  52                    PUSH   dx                           ; UNKNOWN
067BBE  50                    PUSH   ax                           ; UNKNOWN
067BBF  57                    PUSH   di                           ; UNKNOWN
067BC0  56                    PUSH   si                           ; UNKNOWN
067BC1  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
067BC6  0B D2                 OR     dx, dx                       ; UNKNOWN
067BC8  75 1B                 JNE    0x67be5                      ; UNKNOWN
067BCA  C7 06 F8 CE 0C 00     MOV    word ptr [0xcef8], 0xc       ; UNKNOWN
067BD0  C7 06 FA CE 46 5F     MOV    word ptr [0xcefa], 0x5f46    ; UNKNOWN
067BD6  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
067BD9  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
067BDC  A3 FC CE              MOV    word ptr [0xcefc], ax        ; UNKNOWN
067BDF  89 16 FE CE           MOV    word ptr [0xcefe], dx        ; UNKNOWN
067BE3  EB 1C                 JMP    0x67c01                      ; UNKNOWN
067BE5  C7 06 F8 CE 0E 00     MOV    word ptr [0xcef8], 0xe       ; UNKNOWN
067BEB  C7 06 FA CE 54 5F     MOV    word ptr [0xcefa], 0x5f54    ; UNKNOWN
067BF1  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
067BF4  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
067BF7  0E                    PUSH   cs                           ; UNKNOWN
067BF8  E8 7F FF              CALL   0x67b7a                      ; UNKNOWN
067BFB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
067BFE  A3 04 CF              MOV    word ptr [0xcf04], ax        ; UNKNOWN
