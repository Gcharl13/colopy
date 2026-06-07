; ============================================================================
; func_045FD4_unknown
; Region   : load_image
; Bytes    : file 0x045FD4..0x04602A  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

045FD4  C8 40 00 00           ENTER  0x40, 0                      ; UNKNOWN
045FD8  57                    PUSH   di                           ; UNKNOWN
045FD9  56                    PUSH   si                           ; UNKNOWN
045FDA  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
045FDD  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
045FE0  2B C0                 SUB    ax, ax                       ; UNKNOWN
045FE2  89 46 DE              MOV    word ptr [bp - 0x22], ax     ; UNKNOWN
045FE5  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
045FE9  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
045FEC  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
045FEF  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
045FF3  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
045FF7  2A E4                 SUB    ah, ah                       ; UNKNOWN
045FF9  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
045FFC  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
046000  89 46 D8              MOV    word ptr [bp - 0x28], ax     ; UNKNOWN
046003  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
046006  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
046009  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
04600E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
046011  8B D8                 MOV    bx, ax                       ; UNKNOWN
046013  89 5E D4              MOV    word ptr [bp - 0x2c], bx     ; UNKNOWN
046016  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
046019  8A 87 B6 34           MOV    al, byte ptr [bx + 0x34b6]   ; UNKNOWN
04601D  2A E4                 SUB    ah, ah                       ; UNKNOWN
04601F  8B C8                 MOV    cx, ax                       ; UNKNOWN
046021  D1 E0                 SHL    ax, 1                        ; UNKNOWN
046023  03 C1                 ADD    ax, cx                       ; UNKNOWN
046025  89 46 C2              MOV    word ptr [bp - 0x3e], ax     ; UNKNOWN
046028  FF                    DB     0xFF                         ; UNKNOWN (raw)
046029  76                    DB     0x76                         ; UNKNOWN (raw)
