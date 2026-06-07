; ============================================================================
; func_055A76_unknown
; Region   : load_image
; Bytes    : file 0x055A76..0x055A96  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

055A76  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
055A7A  56                    PUSH   si                           ; UNKNOWN
055A7B  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
055A80  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
055A83  0E                    PUSH   cs                           ; UNKNOWN
055A84  E8 EB FF              CALL   0x55a72                      ; UNKNOWN
055A87  83 C4 02              ADD    sp, 2                        ; UNKNOWN
055A8A  0B C0                 OR     ax, ax                       ; UNKNOWN
055A8C  75 03                 JNE    0x55a91                      ; UNKNOWN
055A8E  E9 97 00              JMP    0x55b28                      ; UNKNOWN
055A91  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
055A94  8B C3                 MOV    ax, bx                       ; UNKNOWN
