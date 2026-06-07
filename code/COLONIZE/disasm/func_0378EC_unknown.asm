; ============================================================================
; func_0378EC_unknown
; Region   : load_image
; Bytes    : file 0x0378EC..0x037951  (101 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0378EC  C8 74 00 00           ENTER  0x74, 0                      ; UNKNOWN
0378F0  56                    PUSH   si                           ; UNKNOWN
0378F1  2B C0                 SUB    ax, ax                       ; UNKNOWN
0378F3  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
0378F6  89 46 94              MOV    word ptr [bp - 0x6c], ax     ; UNKNOWN
0378F9  C7 06 06 0A 02 00     MOV    word ptr [0xa06], 2          ; UNKNOWN
0378FF  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
037903  8D 06 3A 21           LEA    ax, [0x213a]                 ; UNKNOWN
037907  2B D2                 SUB    dx, dx                       ; UNKNOWN
037909  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
03790E  89 46 94              MOV    word ptr [bp - 0x6c], ax     ; UNKNOWN
037911  89 56 96              MOV    word ptr [bp - 0x6a], dx     ; UNKNOWN
037914  0B D0                 OR     dx, ax                       ; UNKNOWN
037916  75 03                 JNE    0x3791b                      ; UNKNOWN
037918  E9 59 02              JMP    0x37b74                      ; UNKNOWN
03791B  C4 5E 94              LES    bx, ptr [bp - 0x6c]          ; UNKNOWN
03791E  26 80 4F 0A 01        OR     byte ptr es:[bx + 0xa], 1    ; UNKNOWN
037923  26 C7 47 22 08 00     MOV    word ptr es:[bx + 0x22], 8   ; UNKNOWN
037929  6A 01                 PUSH   1                            ; UNKNOWN
03792B  FF 36 00 33           PUSH   word ptr [0x3300]            ; UNKNOWN
03792F  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
037934  83 C4 02              ADD    sp, 2                        ; UNKNOWN
037937  52                    PUSH   dx                           ; UNKNOWN
037938  50                    PUSH   ax                           ; UNKNOWN
037939  FF 76 96              PUSH   word ptr [bp - 0x6a]         ; UNKNOWN
03793C  FF 76 94              PUSH   word ptr [bp - 0x6c]         ; UNKNOWN
03793F  9A E6 09 97 1B        LCALL  0x1b97, 0x9e6                ; UNKNOWN
037944  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
037947  C7 46 8E 00 00        MOV    word ptr [bp - 0x72], 0      ; UNKNOWN
03794C  8B 5E 8E              MOV    bx, word ptr [bp - 0x72]     ; UNKNOWN
03794F  8B C3                 MOV    ax, bx                       ; UNKNOWN
