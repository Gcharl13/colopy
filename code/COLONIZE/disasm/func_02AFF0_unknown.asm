; ============================================================================
; func_02AFF0_unknown
; Region   : load_image
; Bytes    : file 0x02AFF0..0x02B01E  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AFF0  55                    PUSH   bp                           ; UNKNOWN
02AFF1  8B EC                 MOV    bp, sp                       ; UNKNOWN
02AFF3  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02AFF6  8B 16 E2 0E           MOV    dx, word ptr [0xee2]         ; UNKNOWN
02AFFA  3B DA                 CMP    bx, dx                       ; UNKNOWN
02AFFC  7F 20                 JG     0x2b01e                      ; UNKNOWN
02AFFE  03 5E 0A              ADD    bx, word ptr [bp + 0xa]      ; UNKNOWN
02B001  4B                    DEC    bx                           ; UNKNOWN
02B002  3B DA                 CMP    bx, dx                       ; UNKNOWN
02B004  7C 18                 JL     0x2b01e                      ; UNKNOWN
02B006  8B 16 E4 0E           MOV    dx, word ptr [0xee4]         ; UNKNOWN
02B00A  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
02B00D  3B DA                 CMP    bx, dx                       ; UNKNOWN
02B00F  7F 0D                 JG     0x2b01e                      ; UNKNOWN
02B011  03 5E 0C              ADD    bx, word ptr [bp + 0xc]      ; UNKNOWN
02B014  4B                    DEC    bx                           ; UNKNOWN
02B015  3B DA                 CMP    bx, dx                       ; UNKNOWN
02B017  7C 05                 JL     0x2b01e                      ; UNKNOWN
02B019  B8 01 00              MOV    ax, 1                        ; UNKNOWN
02B01C  C9                    LEAVE                               ; UNKNOWN
02B01D  CB                    RETF                                ; UNKNOWN
