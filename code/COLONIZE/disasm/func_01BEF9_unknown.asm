; ============================================================================
; func_01BEF9_unknown
; Region   : load_image
; Bytes    : file 0x01BEF9..0x01BF38  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01BEF9  C8 64 00 00           ENTER  0x64, 0                      ; UNKNOWN
01BEFD  57                    PUSH   di                           ; UNKNOWN
01BEFE  56                    PUSH   si                           ; UNKNOWN
01BEFF  2B C0                 SUB    ax, ax                       ; UNKNOWN
01BF01  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
01BF04  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
01BF07  FF 36 DD 0A           PUSH   word ptr [0xadd]             ; UNKNOWN
01BF0B  9A 2F 2F 5F 24        LCALL  0x245f, 0x2f2f               ; UNKNOWN
01BF10  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01BF13  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
01BF16  0B C0                 OR     ax, ax                       ; UNKNOWN
01BF18  7D 03                 JGE    0x1bf1d                      ; UNKNOWN
01BF1A  E9 60 02              JMP    0x1c17d                      ; UNKNOWN
01BF1D  9A 0C 13 B7 36        LCALL  0x36b7, 0x130c               ; UNKNOWN
01BF22  0B C0                 OR     ax, ax                       ; UNKNOWN
01BF24  74 06                 JE     0x1bf2c                      ; UNKNOWN
01BF26  8B 46 A0              MOV    ax, word ptr [bp - 0x60]     ; UNKNOWN
01BF29  A3 0A 3E              MOV    word ptr [0x3e0a], ax        ; UNKNOWN
01BF2C  6B 5E A0 1C           IMUL   bx, word ptr [bp - 0x60], 0x1c ; UNKNOWN
01BF30  8D 87 82 88           LEA    ax, [bx - 0x777e]            ; UNKNOWN
01BF34  8B F0                 MOV    si, ax                       ; UNKNOWN
01BF36  8B CB                 MOV    cx, bx                       ; UNKNOWN
