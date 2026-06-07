; ============================================================================
; func_02D4D0_unknown
; Region   : load_image
; Bytes    : file 0x02D4D0..0x02D508  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D4D0  55                    PUSH   bp                           ; UNKNOWN
02D4D1  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D4D3  56                    PUSH   si                           ; UNKNOWN
02D4D4  8B 76 0A              MOV    si, word ptr [bp + 0xa]      ; UNKNOWN
02D4D7  6A 00                 PUSH   0                            ; UNKNOWN
02D4D9  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02D4DC  8B 56 0E              MOV    dx, word ptr [bp + 0xe]      ; UNKNOWN
02D4DF  8B 5E 10              MOV    bx, word ptr [bp + 0x10]     ; UNKNOWN
02D4E2  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
02D4E7  FF 36 22 0C           PUSH   word ptr [0xc22]             ; UNKNOWN
02D4EB  FF 36 20 0C           PUSH   word ptr [0xc20]             ; UNKNOWN
02D4EF  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D4F2  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D4F5  6A 00                 PUSH   0                            ; UNKNOWN
02D4F7  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
02D4FB  8B C6                 MOV    ax, si                       ; UNKNOWN
02D4FD  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
02D500  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
02D505  5E                    POP    si                           ; UNKNOWN
02D506  C9                    LEAVE                               ; UNKNOWN
02D507  CB                    RETF                                ; UNKNOWN
