; ============================================================================
; func_02E4A0_unknown
; Region   : load_image
; Bytes    : file 0x02E4A0..0x02E4BD  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E4A0  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02E4A4  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02E4A7  0E                    PUSH   cs                           ; UNKNOWN
02E4A8  E8 A5 FD              CALL   0x2e250                      ; UNKNOWN
02E4AB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02E4AE  83 F8 0F              CMP    ax, 0xf                      ; UNKNOWN
02E4B1  7C 0A                 JL     0x2e4bd                      ; UNKNOWN
02E4B3  C7 46 FC 03 00        MOV    word ptr [bp - 4], 3         ; UNKNOWN
02E4B8  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02E4BB  C9                    LEAVE                               ; UNKNOWN
02E4BC  CB                    RETF                                ; UNKNOWN
