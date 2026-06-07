; ============================================================================
; func_035875_unknown
; Region   : load_image
; Bytes    : file 0x035875..0x035906  (145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

035875  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
035879  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03587C  0E                    PUSH   cs                           ; UNKNOWN
03587D  E8 03 DC              CALL   0x33483                      ; UNKNOWN
035880  83 C4 02              ADD    sp, 2                        ; UNKNOWN
035883  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
035886  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
035889  8A 8F 88 88           MOV    cl, byte ptr [bx - 0x7778]   ; UNKNOWN
03588D  88 4E F4              MOV    byte ptr [bp - 0xc], cl      ; UNKNOWN
035890  C6 87 88 88 00        MOV    byte ptr [bx - 0x7778], 0    ; UNKNOWN
035895  50                    PUSH   ax                           ; UNKNOWN
035896  9A 9C 10 B7 36        LCALL  0x36b7, 0x109c               ; UNKNOWN
03589B  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03589E  2B D2                 SUB    dx, dx                       ; UNKNOWN
0358A0  89 16 06 0A           MOV    word ptr [0xa06], dx         ; UNKNOWN
0358A4  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0358A8  8D 06 27 20           LEA    ax, [0x2027]                 ; UNKNOWN
0358AC  9A 5A 32 97 1B        LCALL  0x1b97, 0x325a               ; UNKNOWN
0358B1  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0358B4  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
0358B7  0B D0                 OR     dx, ax                       ; UNKNOWN
0358B9  75 03                 JNE    0x358be                      ; UNKNOWN
0358BB  E9 F9 00              JMP    0x359b7                      ; UNKNOWN
0358BE  6A 00                 PUSH   0                            ; UNKNOWN
0358C0  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
0358C3  9A D3 04 B7 36        LCALL  0x36b7, 0x4d3                ; UNKNOWN
0358C8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0358CB  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
0358CE  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
0358D3  EB 2A                 JMP    0x358ff                      ; UNKNOWN
0358D5  6A 00                 PUSH   0                            ; UNKNOWN
0358D7  6A 00                 PUSH   0                            ; UNKNOWN
0358D9  6A 00                 PUSH   0                            ; UNKNOWN
0358DB  9A 67 00 76 1A        LCALL  0x1a76, 0x67                 ; UNKNOWN
0358E0  50                    PUSH   ax                           ; UNKNOWN
0358E1  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
0358E5  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
0358E9  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0358EC  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
0358EF  9A 1D 0F 97 1B        LCALL  0x1b97, 0xf1d                ; UNKNOWN
0358F4  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
0358F7  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
0358FA  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
0358FF  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
035902  0B C0                 OR     ax, ax                       ; UNKNOWN
035904  7D CF                 JGE    0x358d5                      ; UNKNOWN
