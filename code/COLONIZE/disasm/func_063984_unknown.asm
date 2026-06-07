; ============================================================================
; func_063984_unknown
; Region   : load_image
; Bytes    : file 0x063984..0x0639DC  (88 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063984  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
063988  52                    PUSH   dx                           ; UNKNOWN
063989  50                    PUSH   ax                           ; UNKNOWN
06398A  53                    PUSH   bx                           ; UNKNOWN
06398B  57                    PUSH   di                           ; UNKNOWN
06398C  56                    PUSH   si                           ; UNKNOWN
06398D  8B D8                 MOV    bx, ax                       ; UNKNOWN
06398F  83 3F 00              CMP    word ptr [bx], 0             ; UNKNOWN
063992  7D 0B                 JGE    0x6399f                      ; UNKNOWN
063994  8B 0F                 MOV    cx, word ptr [bx]            ; UNKNOWN
063996  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
063999  01 0C                 ADD    word ptr [si], cx            ; UNKNOWN
06399B  C7 07 00 00           MOV    word ptr [bx], 0             ; UNKNOWN
06399F  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0639A2  83 3F 00              CMP    word ptr [bx], 0             ; UNKNOWN
0639A5  7D 0B                 JGE    0x639b2                      ; UNKNOWN
0639A7  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
0639A9  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0639AC  01 04                 ADD    word ptr [si], ax            ; UNKNOWN
0639AE  C7 07 00 00           MOV    word ptr [bx], 0             ; UNKNOWN
0639B2  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0639B5  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
0639B7  8B 76 F8              MOV    si, word ptr [bp - 8]        ; UNKNOWN
0639BA  03 04                 ADD    ax, word ptr [si]            ; UNKNOWN
0639BC  48                    DEC    ax                           ; UNKNOWN
0639BD  8B 7E F6              MOV    di, word ptr [bp - 0xa]      ; UNKNOWN
0639C0  8B 4D 02              MOV    cx, word ptr [di + 2]        ; UNKNOWN
0639C3  49                    DEC    cx                           ; UNKNOWN
0639C4  3B C1                 CMP    ax, cx                       ; UNKNOWN
0639C6  7E 02                 JLE    0x639ca                      ; UNKNOWN
0639C8  8B C1                 MOV    ax, cx                       ; UNKNOWN
0639CA  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0639CD  8B 0F                 MOV    cx, word ptr [bx]            ; UNKNOWN
0639CF  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
0639D2  03 0F                 ADD    cx, word ptr [bx]            ; UNKNOWN
0639D4  49                    DEC    cx                           ; UNKNOWN
0639D5  8B 15                 MOV    dx, word ptr [di]            ; UNKNOWN
0639D7  4A                    DEC    dx                           ; UNKNOWN
0639D8  3B CA                 CMP    cx, dx                       ; UNKNOWN
0639DA  7E 02                 JLE    0x639de                      ; UNKNOWN
