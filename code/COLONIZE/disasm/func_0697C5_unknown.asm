; ============================================================================
; func_0697C5_unknown
; Region   : load_image
; Bytes    : file 0x0697C5..0x0697EE  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0697C5  55                    PUSH   bp                           ; UNKNOWN
0697C6  8B EC                 MOV    bp, sp                       ; UNKNOWN
0697C8  B4 40                 MOV    ah, 0x40                     ; UNKNOWN
0697CA  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0697CD  8B 4E 0C              MOV    cx, word ptr [bp + 0xc]      ; UNKNOWN
0697D0  81 3E A0 15 D6 D6     CMP    word ptr [0x15a0], 0xd6d6    ; UNKNOWN
0697D6  75 04                 JNE    0x697dc                      ; UNKNOWN
0697D8  FF 16 A2 15           CALL   word ptr [0x15a2]            ; UNKNOWN
0697DC  1E                    PUSH   ds                           ; UNKNOWN
0697DD  C5 56 08              LDS    dx, ptr [bp + 8]             ; UNKNOWN
0697E0  CD 21                 INT    0x21                         ; UNKNOWN
0697E2  1F                    POP    ds                           ; UNKNOWN
0697E3  72 05                 JB     0x697ea                      ; UNKNOWN
0697E5  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
0697E8  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0697EA  E9 77 06              JMP    0x69e64                      ; UNKNOWN
0697ED  00                    DB     0x00                         ; UNKNOWN (raw)
