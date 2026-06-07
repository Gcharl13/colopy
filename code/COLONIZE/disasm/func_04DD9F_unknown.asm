; ============================================================================
; func_04DD9F_unknown
; Region   : load_image
; Bytes    : file 0x04DD9F..0x04DE08  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04DD9F  C8 12 03 00           ENTER  0x312, 0                     ; UNKNOWN
04DDA3  50                    PUSH   ax                           ; UNKNOWN
04DDA4  57                    PUSH   di                           ; UNKNOWN
04DDA5  56                    PUSH   si                           ; UNKNOWN
04DDA6  8D 86 F6 FC           LEA    ax, [bp - 0x30a]             ; UNKNOWN
04DDAA  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04DDAD  8C 56 FE              MOV    word ptr [bp - 2], ss        ; UNKNOWN
04DDB0  2B C9                 SUB    cx, cx                       ; UNKNOWN
04DDB2  89 0E C6 CE           MOV    word ptr [0xcec6], cx        ; UNKNOWN
04DDB6  89 0E C4 CE           MOV    word ptr [0xcec4], cx        ; UNKNOWN
04DDBA  6A 03                 PUSH   3                            ; UNKNOWN
04DDBC  16                    PUSH   ss                           ; UNKNOWN
04DDBD  50                    PUSH   ax                           ; UNKNOWN
04DDBE  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04DDC1  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
04DDC4  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04DDC7  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
04DDCA  52                    PUSH   dx                           ; UNKNOWN
04DDCB  50                    PUSH   ax                           ; UNKNOWN
04DDCC  0E                    PUSH   cs                           ; UNKNOWN
04DDCD  E8 A8 FF              CALL   0x4dd78                      ; UNKNOWN
04DDD0  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04DDD3  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
04DDD8  9A 20 00 23 5E        LCALL  0x5e23, 0x20                 ; UNKNOWN
04DDDD  8B C8                 MOV    cx, ax                       ; UNKNOWN
04DDDF  8B 86 EC FC           MOV    ax, word ptr [bp - 0x314]    ; UNKNOWN
04DDE3  8B DA                 MOV    bx, dx                       ; UNKNOWN
04DDE5  99                    CDQ                                 ; UNKNOWN
04DDE6  03 C1                 ADD    ax, cx                       ; UNKNOWN
04DDE8  13 D3                 ADC    dx, bx                       ; UNKNOWN
04DDEA  89 86 F2 FC           MOV    word ptr [bp - 0x30e], ax    ; UNKNOWN
04DDEE  89 96 F4 FC           MOV    word ptr [bp - 0x30c], dx    ; UNKNOWN
04DDF2  1E                    PUSH   ds                           ; UNKNOWN
04DDF3  C4 5E FC              LES    bx, ptr [bp - 4]             ; UNKNOWN
04DDF6  C4 7E F8              LES    di, ptr [bp - 8]             ; UNKNOWN
04DDF9  C5 76 F8              LDS    si, ptr [bp - 8]             ; UNKNOWN
04DDFC  B9 00 03              MOV    cx, 0x300                    ; UNKNOWN
04DDFF  AC                    LODSB  al, byte ptr [si]            ; UNKNOWN
04DE00  36 8A 17              MOV    dl, byte ptr ss:[bx]         ; UNKNOWN
04DE03  43                    INC    bx                           ; UNKNOWN
04DE04  2A C2                 SUB    al, dl                       ; UNKNOWN
04DE06  73 02                 JAE    0x4de0a                      ; UNKNOWN
