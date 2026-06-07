; ============================================================================
; func_00B8D0_unknown
; Region   : load_image
; Bytes    : file 0x00B8D0..0x00B8FF  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B8D0  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
00B8D4  56                    PUSH   si                           ; UNKNOWN
00B8D5  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
00B8D8  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00B8DB  0E                    PUSH   cs                           ; UNKNOWN
00B8DC  E8 4D FB              CALL   0xb42c                       ; UNKNOWN
00B8DF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00B8E2  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00B8E5  0B C0                 OR     ax, ax                       ; UNKNOWN
00B8E7  7C 10                 JL     0xb8f9                       ; UNKNOWN
00B8E9  A1 C4 8D              MOV    ax, word ptr [0x8dc4]        ; UNKNOWN
00B8EC  8B 76 FC              MOV    si, word ptr [bp - 4]        ; UNKNOWN
00B8EF  D1 E6                 SHL    si, 1                        ; UNKNOWN
00B8F1  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
00B8F5  01 80 9A 00           ADD    word ptr [bx + si + 0x9a], ax ; ARITH
00B8F9  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
00B8FC  5E                    POP    si                           ; UNKNOWN
00B8FD  C9                    LEAVE                               ; UNKNOWN
00B8FE  CB                    RETF                                ; UNKNOWN
