; ============================================================================
; func_0204D3_unknown
; Region   : load_image
; Bytes    : file 0x0204D3..0x020544  (113 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0204D3  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
0204D7  56                    PUSH   si                           ; UNKNOWN
0204D8  6A 03                 PUSH   3                            ; UNKNOWN
0204DA  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
0204DF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0204E2  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0       ; UNKNOWN
0204E7  E9 C8 00              JMP    0x205b2                      ; UNKNOWN
0204EA  6B 5E F6 1C           IMUL   bx, word ptr [bp - 0xa], 0x1c ; UNKNOWN
0204EE  C6 87 82 88 07        MOV    byte ptr [bx - 0x777e], 7    ; UNKNOWN
0204F3  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
0204F6  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
0204F9  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
0204FE  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
020501  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
020505  7E 63                 JLE    0x2056a                      ; UNKNOWN
020507  0B C0                 OR     ax, ax                       ; UNKNOWN
020509  7C 5F                 JL     0x2056a                      ; UNKNOWN
02050B  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
02050E  80 BF 82 88 01        CMP    byte ptr [bx - 0x777e], 1    ; UNKNOWN
020513  74 07                 JE     0x2051c                      ; UNKNOWN
020515  80 BF 82 88 04        CMP    byte ptr [bx - 0x777e], 4    ; UNKNOWN
02051A  75 DA                 JNE    0x204f6                      ; UNKNOWN
02051C  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
02051F  80 BF 97 88 15        CMP    byte ptr [bx - 0x7769], 0x15 ; UNKNOWN
020524  75 D0                 JNE    0x204f6                      ; UNKNOWN
020526  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
020529  A1 38 73              MOV    ax, word ptr [0x7338]        ; UNKNOWN
02052C  40                    INC    ax                           ; UNKNOWN
02052D  40                    INC    ax                           ; UNKNOWN
02052E  1E                    PUSH   ds                           ; UNKNOWN
02052F  50                    PUSH   ax                           ; UNKNOWN
020530  6A 00                 PUSH   0                            ; UNKNOWN
020532  8B F3                 MOV    si, bx                       ; UNKNOWN
020534  9A C9 03 97 1B        LCALL  0x1b97, 0x3c9                ; UNKNOWN
020539  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02053C  8A 9C 82 88           MOV    bl, byte ptr [si - 0x777e]   ; UNKNOWN
020540  2A FF                 SUB    bh, bh                       ; UNKNOWN
020542  8B C3                 MOV    ax, bx                       ; UNKNOWN
