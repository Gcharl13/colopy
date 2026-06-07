; ============================================================================
; func_0216BB_unknown
; Region   : load_image
; Bytes    : file 0x0216BB..0x0216FF  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0216BB  55                    PUSH   bp                           ; UNKNOWN
0216BC  8B EC                 MOV    bp, sp                       ; UNKNOWN
0216BE  50                    PUSH   ax                           ; UNKNOWN
0216BF  83 3E D6 09 00        CMP    word ptr [0x9d6], 0          ; UNKNOWN
0216C4  74 39                 JE     0x216ff                      ; UNKNOWN
0216C6  80 7E 0A 07           CMP    byte ptr [bp + 0xa], 7       ; UNKNOWN
0216CA  75 33                 JNE    0x216ff                      ; UNKNOWN
0216CC  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
0216CF  FF 76 10              PUSH   word ptr [bp + 0x10]         ; UNKNOWN
0216D2  FF 76 12              PUSH   word ptr [bp + 0x12]         ; UNKNOWN
0216D5  53                    PUSH   bx                           ; UNKNOWN
0216D6  52                    PUSH   dx                           ; UNKNOWN
0216D7  50                    PUSH   ax                           ; UNKNOWN
0216D8  8B 1E D6 09           MOV    bx, word ptr [0x9d6]         ; UNKNOWN
0216DC  FF 77 06              PUSH   word ptr [bx + 6]            ; UNKNOWN
0216DF  FF 77 04              PUSH   word ptr [bx + 4]            ; UNKNOWN
0216E2  FF 77 02              PUSH   word ptr [bx + 2]            ; UNKNOWN
0216E5  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
0216E7  FF 76 1A              PUSH   word ptr [bp + 0x1a]         ; UNKNOWN
0216EA  FF 76 18              PUSH   word ptr [bp + 0x18]         ; UNKNOWN
0216ED  FF 76 16              PUSH   word ptr [bp + 0x16]         ; UNKNOWN
0216F0  FF 76 14              PUSH   word ptr [bp + 0x14]         ; UNKNOWN
0216F3  9A 0C 00 B6 5A        LCALL  0x5ab6, 0xc                  ; UNKNOWN
0216F8  83 C4 1C              ADD    sp, 0x1c                     ; UNKNOWN
0216FB  C9                    LEAVE                               ; UNKNOWN
0216FC  C2 18 00              RET    0x18                         ; UNKNOWN
