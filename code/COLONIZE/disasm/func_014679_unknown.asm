; ============================================================================
; func_014679_unknown
; Region   : load_image
; Bytes    : file 0x014679..0x0146B7  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

014679  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
01467D  56                    PUSH   si                           ; UNKNOWN
01467E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
014681  FF 36 3A 82           PUSH   word ptr [0x823a]            ; UNKNOWN
014685  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
01468A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
01468D  83 C0 4B              ADD    ax, 0x4b                     ; UNKNOWN
014690  99                    CDQ                                 ; UNKNOWN
014691  52                    PUSH   dx                           ; UNKNOWN
014692  50                    PUSH   ax                           ; UNKNOWN
014693  8B 1E 3A 82           MOV    bx, word ptr [0x823a]        ; UNKNOWN
014697  8A 87 6F 88           MOV    al, byte ptr [bx - 0x7791]   ; UNKNOWN
01469B  2A E4                 SUB    ah, ah                       ; UNKNOWN
01469D  8B C8                 MOV    cx, ax                       ; UNKNOWN
01469F  C1 E0 03              SHL    ax, 3                        ; UNKNOWN
0146A2  99                    CDQ                                 ; UNKNOWN
0146A3  8B F0                 MOV    si, ax                       ; UNKNOWN
0146A5  8A 87 9A 85           MOV    al, byte ptr [bx - 0x7a66]   ; UNKNOWN
0146A9  C0 E8 02              SHR    al, 2                        ; UNKNOWN
0146AC  25 FE 00              AND    ax, 0xfe                     ; UNKNOWN
0146AF  D1 E1                 SHL    cx, 1                        ; UNKNOWN
0146B1  2B C1                 SUB    ax, cx                       ; UNKNOWN
0146B3  8B CA                 MOV    cx, dx                       ; UNKNOWN
0146B5  99                    CDQ                                 ; UNKNOWN
0146B6  03                    DB     0x03                         ; UNKNOWN (raw)
