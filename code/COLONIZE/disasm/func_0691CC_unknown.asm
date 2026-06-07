; ============================================================================
; func_0691CC_unknown
; Region   : load_image
; Bytes    : file 0x0691CC..0x069204  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0691CC  55                    PUSH   bp                           ; UNKNOWN
0691CD  8B EC                 MOV    bp, sp                       ; UNKNOWN
0691CF  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0691D2  3B 1E 45 12           CMP    bx, word ptr [0x1245]        ; UNKNOWN
0691D6  72 06                 JB     0x691de                      ; UNKNOWN
0691D8  B8 00 09              MOV    ax, 0x900                    ; UNKNOWN
0691DB  F9                    STC                                 ; UNKNOWN
0691DC  EB 23                 JMP    0x69201                      ; UNKNOWN
0691DE  B4 45                 MOV    ah, 0x45                     ; UNKNOWN
0691E0  CD 21                 INT    0x21                         ; UNKNOWN
0691E2  72 1D                 JB     0x69201                      ; UNKNOWN
0691E4  3B 06 45 12           CMP    ax, word ptr [0x1245]        ; UNKNOWN
0691E8  72 0C                 JB     0x691f6                      ; UNKNOWN
0691EA  8B D8                 MOV    bx, ax                       ; UNKNOWN
0691EC  B4 3E                 MOV    ah, 0x3e                     ; UNKNOWN
0691EE  CD 21                 INT    0x21                         ; UNKNOWN
0691F0  B8 00 18              MOV    ax, 0x1800                   ; UNKNOWN
0691F3  F9                    STC                                 ; UNKNOWN
0691F4  EB 0B                 JMP    0x69201                      ; UNKNOWN
0691F6  8A 8F 47 12           MOV    cl, byte ptr [bx + 0x1247]   ; UNKNOWN
0691FA  8B D8                 MOV    bx, ax                       ; UNKNOWN
0691FC  88 8F 47 12           MOV    byte ptr [bx + 0x1247], cl   ; UNKNOWN
069200  F8                    CLC                                 ; UNKNOWN
069201  E9 6D 0C              JMP    0x69e71                      ; UNKNOWN
