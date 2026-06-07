; ============================================================================
; func_02D3BF_unknown
; Region   : load_image
; Bytes    : file 0x02D3BF..0x02D3F9  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D3BF  55                    PUSH   bp                           ; UNKNOWN
02D3C0  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D3C2  57                    PUSH   di                           ; UNKNOWN
02D3C3  56                    PUSH   si                           ; UNKNOWN
02D3C4  8B 7E 0A              MOV    di, word ptr [bp + 0xa]      ; UNKNOWN
02D3C7  8B 76 0E              MOV    si, word ptr [bp + 0xe]      ; UNKNOWN
02D3CA  56                    PUSH   si                           ; UNKNOWN
02D3CB  8B D6                 MOV    dx, si                       ; UNKNOWN
02D3CD  8B DE                 MOV    bx, si                       ; UNKNOWN
02D3CF  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02D3D2  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
02D3D7  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
02D3DB  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
02D3DF  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D3E2  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D3E5  6A 00                 PUSH   0                            ; UNKNOWN
02D3E7  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
02D3EB  8B C7                 MOV    ax, di                       ; UNKNOWN
02D3ED  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
02D3F0  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
02D3F5  5E                    POP    si                           ; UNKNOWN
02D3F6  5F                    POP    di                           ; UNKNOWN
02D3F7  C9                    LEAVE                               ; UNKNOWN
02D3F8  CB                    RETF                                ; UNKNOWN
