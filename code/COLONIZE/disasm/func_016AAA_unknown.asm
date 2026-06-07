; ============================================================================
; func_016AAA_unknown
; Region   : load_image
; Bytes    : file 0x016AAA..0x016AF4  (74 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016AAA  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
016AAE  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
016AB3  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
016AB8  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
016ABB  80 BF 32 08 00        CMP    byte ptr [bx + 0x832], 0     ; UNKNOWN
016AC0  74 0C                 JE     0x16ace                      ; UNKNOWN
016AC2  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
016AC5  83 7E FC 04           CMP    word ptr [bp - 4], 4         ; UNKNOWN
016AC9  7C ED                 JL     0x16ab8                      ; UNKNOWN
016ACB  EB 1B                 JMP    0x16ae8                      ; UNKNOWN
016ACD  90                    NOP                                 ; UNKNOWN
016ACE  C6 87 32 08 01        MOV    byte ptr [bx + 0x832], 1     ; UNKNOWN
016AD3  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
016AD6  C7 87 98 D3 01 00     MOV    word ptr [bx - 0x2c68], 1    ; UNKNOWN
016ADC  C7 87 9A D3 00 00     MOV    word ptr [bx - 0x2c66], 0    ; UNKNOWN
016AE2  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
016AE5  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
016AE8  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
016AEB  0E                    PUSH   cs                           ; UNKNOWN
016AEC  E8 49 00              CALL   0x16b38                      ; UNKNOWN
016AEF  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
016AF2  C9                    LEAVE                               ; UNKNOWN
016AF3  CB                    RETF                                ; UNKNOWN
