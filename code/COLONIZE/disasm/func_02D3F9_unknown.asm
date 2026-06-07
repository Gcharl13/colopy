; ============================================================================
; func_02D3F9_unknown
; Region   : load_image
; Bytes    : file 0x02D3F9..0x02D44E  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D3F9  55                    PUSH   bp                           ; UNKNOWN
02D3FA  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D3FC  57                    PUSH   di                           ; UNKNOWN
02D3FD  56                    PUSH   si                           ; UNKNOWN
02D3FE  8B 7E 0E              MOV    di, word ptr [bp + 0xe]      ; UNKNOWN
02D401  8B 76 0A              MOV    si, word ptr [bp + 0xa]      ; UNKNOWN
02D404  57                    PUSH   di                           ; UNKNOWN
02D405  8B D7                 MOV    dx, di                       ; UNKNOWN
02D407  8B DF                 MOV    bx, di                       ; UNKNOWN
02D409  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02D40C  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
02D411  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
02D415  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
02D419  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D41C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D41F  2B C0                 SUB    ax, ax                       ; UNKNOWN
02D421  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
02D426  2B F0                 SUB    si, ax                       ; UNKNOWN
02D428  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
02D42C  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
02D430  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D433  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D436  6A 00                 PUSH   0                            ; UNKNOWN
02D438  8B C6                 MOV    ax, si                       ; UNKNOWN
02D43A  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
02D43E  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
02D441  8B F0                 MOV    si, ax                       ; UNKNOWN
02D443  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
02D448  8B C6                 MOV    ax, si                       ; UNKNOWN
02D44A  5E                    POP    si                           ; UNKNOWN
02D44B  5F                    POP    di                           ; UNKNOWN
02D44C  C9                    LEAVE                               ; UNKNOWN
02D44D  CB                    RETF                                ; UNKNOWN
