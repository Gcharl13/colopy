; ============================================================================
; func_030B9F_unknown
; Region   : load_image
; Bytes    : file 0x030B9F..0x030BCE  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030B9F  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
030BA3  56                    PUSH   si                           ; UNKNOWN
030BA4  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
030BA7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
030BAA  0E                    PUSH   cs                           ; UNKNOWN
030BAB  E8 5B FB              CALL   0x30709                      ; UNKNOWN
030BAE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
030BB1  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
030BB4  0B C0                 OR     ax, ax                       ; UNKNOWN
030BB6  7C 10                 JL     0x30bc8                      ; UNKNOWN
030BB8  A1 84 73              MOV    ax, word ptr [0x7384]        ; UNKNOWN
030BBB  8B 76 FC              MOV    si, word ptr [bp - 4]        ; UNKNOWN
030BBE  D1 E6                 SHL    si, 1                        ; UNKNOWN
030BC0  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
030BC4  01 80 9A 00           ADD    word ptr [bx + si + 0x9a], ax ; UNKNOWN
030BC8  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
030BCB  5E                    POP    si                           ; UNKNOWN
030BCC  C9                    LEAVE                               ; UNKNOWN
030BCD  CB                    RETF                                ; UNKNOWN
