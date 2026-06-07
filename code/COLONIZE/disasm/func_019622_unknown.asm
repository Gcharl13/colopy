; ============================================================================
; func_019622_unknown
; Region   : load_image
; Bytes    : file 0x019622..0x0196B5  (147 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019622  C8 80 00 00           ENTER  0x80, 0                      ; UNKNOWN
019626  56                    PUSH   si                           ; UNKNOWN
019627  6A 15                 PUSH   0x15                         ; UNKNOWN
019629  68 40 01              PUSH   0x140                        ; UNKNOWN
01962C  68 B3 00              PUSH   0xb3                         ; UNKNOWN
01962F  6A 00                 PUSH   0                            ; UNKNOWN
019631  0E                    PUSH   cs                           ; UNKNOWN
019632  E8 70 E1              CALL   0x177a5                      ; UNKNOWN
019635  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019638  C7 46 92 01 00        MOV    word ptr [bp - 0x6e], 1      ; UNKNOWN
01963D  C7 46 8E B5 00        MOV    word ptr [bp - 0x72], 0xb5   ; UNKNOWN
019642  C7 46 82 00 00        MOV    word ptr [bp - 0x7e], 0      ; UNKNOWN
019647  EB 33                 JMP    0x1967c                      ; UNKNOWN
019649  6A 0A                 PUSH   0xa                          ; UNKNOWN
01964B  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
01964E  50                    PUSH   ax                           ; UNKNOWN
01964F  FF 76 8A              PUSH   word ptr [bp - 0x76]         ; UNKNOWN
019652  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
019657  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01965A  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
01965D  FF 76 84              PUSH   word ptr [bp - 0x7c]         ; UNKNOWN
019660  8B 46 88              MOV    ax, word ptr [bp - 0x78]     ; UNKNOWN
019663  40                    INC    ax                           ; UNKNOWN
019664  50                    PUSH   ax                           ; UNKNOWN
019665  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
019668  16                    PUSH   ss                           ; UNKNOWN
019669  50                    PUSH   ax                           ; UNKNOWN
01966A  9A 8F 02 13 24        LCALL  0x2413, 0x28f                ; UNKNOWN
01966F  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
019672  89 46 88              MOV    word ptr [bp - 0x78], ax     ; UNKNOWN
019675  83 46 92 13           ADD    word ptr [bp - 0x6e], 0x13   ; UNKNOWN
019679  FF 46 82              INC    word ptr [bp - 0x7e]         ; UNKNOWN
01967C  83 7E 82 10           CMP    word ptr [bp - 0x7e], 0x10   ; UNKNOWN
019680  7C 03                 JL     0x19685                      ; UNKNOWN
019682  E9 59 01              JMP    0x197de                      ; UNKNOWN
019685  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
019689  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
01968D  FF 76 8E              PUSH   word ptr [bp - 0x72]         ; UNKNOWN
019690  8B 46 82              MOV    ax, word ptr [bp - 0x7e]     ; UNKNOWN
019693  8B F0                 MOV    si, ax                       ; UNKNOWN
019695  8B C8                 MOV    cx, ax                       ; UNKNOWN
019697  D1 E6                 SHL    si, 1                        ; UNKNOWN
019699  03 F1                 ADD    si, cx                       ; UNKNOWN
01969B  C1 E6 02              SHL    si, 2                        ; UNKNOWN
01969E  83 C0 17              ADD    ax, 0x17                     ; UNKNOWN
0196A1  8B 56 92              MOV    dx, word ptr [bp - 0x6e]     ; UNKNOWN
0196A4  C4 1E 70 09           LES    bx, ptr [0x970]              ; UNKNOWN
0196A8  26 8B 88 52 01        MOV    cx, word ptr es:[bx + si + 0x152] ; UNKNOWN
0196AD  D1 F9                 SAR    cx, 1                        ; UNKNOWN
0196AF  2B D1                 SUB    dx, cx                       ; UNKNOWN
0196B1  83 C2 09              ADD    dx, 9                        ; UNKNOWN
0196B4  89                    DB     0x89                         ; UNKNOWN (raw)
