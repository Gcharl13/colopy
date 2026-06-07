; ============================================================================
; func_01CDC2_unknown
; Region   : load_image
; Bytes    : file 0x01CDC2..0x01CE0A  (72 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01CDC2  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
01CDC6  56                    PUSH   si                           ; UNKNOWN
01CDC7  83 3E C6 32 07        CMP    word ptr [0x32c6], 7         ; UNKNOWN
01CDCC  75 3C                 JNE    0x1ce0a                      ; UNKNOWN
01CDCE  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
01CDD3  75 03                 JNE    0x1cdd8                      ; UNKNOWN
01CDD5  E9 35 01              JMP    0x1cf0d                      ; UNKNOWN
01CDD8  80 3E EB 32 00        CMP    byte ptr [0x32eb], 0         ; UNKNOWN
01CDDD  74 03                 JE     0x1cde2                      ; UNKNOWN
01CDDF  E9 2B 01              JMP    0x1cf0d                      ; UNKNOWN
01CDE2  FF 36 DD 0A           PUSH   word ptr [0xadd]             ; UNKNOWN
01CDE6  9A 2F 2F 5F 24        LCALL  0x245f, 0x2f2f               ; UNKNOWN
01CDEB  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01CDEE  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01CDF1  9A 0E 00 EF 21        LCALL  0x21ef, 0xe                  ; UNKNOWN
01CDF6  50                    PUSH   ax                           ; UNKNOWN
01CDF7  A0 EC 32              MOV    al, byte ptr [0x32ec]        ; UNKNOWN
01CDFA  2A E4                 SUB    ah, ah                       ; UNKNOWN
01CDFC  50                    PUSH   ax                           ; UNKNOWN
01CDFD  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
01CE00  0E                    PUSH   cs                           ; UNKNOWN
01CE01  E8 B1 EC              CALL   0x1bab5                      ; UNKNOWN
01CE04  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01CE07  5E                    POP    si                           ; UNKNOWN
01CE08  C9                    LEAVE                               ; UNKNOWN
01CE09  CB                    RETF                                ; UNKNOWN
