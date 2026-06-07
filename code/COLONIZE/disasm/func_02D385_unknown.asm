; ============================================================================
; func_02D385_unknown
; Region   : load_image
; Bytes    : file 0x02D385..0x02D3BF  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D385  55                    PUSH   bp                           ; UNKNOWN
02D386  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D388  56                    PUSH   si                           ; UNKNOWN
02D389  8B 76 0A              MOV    si, word ptr [bp + 0xa]      ; UNKNOWN
02D38C  6A 00                 PUSH   0                            ; UNKNOWN
02D38E  8A 16 62 09           MOV    dl, byte ptr [0x962]         ; UNKNOWN
02D392  2A F6                 SUB    dh, dh                       ; UNKNOWN
02D394  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02D397  2B DB                 SUB    bx, bx                       ; UNKNOWN
02D399  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
02D39E  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
02D3A2  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
02D3A6  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D3A9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D3AC  6A 00                 PUSH   0                            ; UNKNOWN
02D3AE  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
02D3B2  8B C6                 MOV    ax, si                       ; UNKNOWN
02D3B4  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
02D3B7  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
02D3BC  5E                    POP    si                           ; UNKNOWN
02D3BD  C9                    LEAVE                               ; UNKNOWN
02D3BE  CB                    RETF                                ; UNKNOWN
