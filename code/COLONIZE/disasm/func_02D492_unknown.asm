; ============================================================================
; func_02D492_unknown
; Region   : load_image
; Bytes    : file 0x02D492..0x02D4D0  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D492  55                    PUSH   bp                           ; UNKNOWN
02D493  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D495  56                    PUSH   si                           ; UNKNOWN
02D496  8B 76 0A              MOV    si, word ptr [bp + 0xa]      ; UNKNOWN
02D499  6A 00                 PUSH   0                            ; UNKNOWN
02D49B  8A 16 62 09           MOV    dl, byte ptr [0x962]         ; UNKNOWN
02D49F  2A F6                 SUB    dh, dh                       ; UNKNOWN
02D4A1  8A 1E 65 09           MOV    bl, byte ptr [0x965]         ; UNKNOWN
02D4A5  2A FF                 SUB    bh, bh                       ; UNKNOWN
02D4A7  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02D4AA  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
02D4AF  FF 36 22 0C           PUSH   word ptr [0xc22]             ; UNKNOWN
02D4B3  FF 36 20 0C           PUSH   word ptr [0xc20]             ; UNKNOWN
02D4B7  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D4BA  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D4BD  6A 00                 PUSH   0                            ; UNKNOWN
02D4BF  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
02D4C3  8B C6                 MOV    ax, si                       ; UNKNOWN
02D4C5  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
02D4C8  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
02D4CD  5E                    POP    si                           ; UNKNOWN
02D4CE  C9                    LEAVE                               ; UNKNOWN
02D4CF  CB                    RETF                                ; UNKNOWN
