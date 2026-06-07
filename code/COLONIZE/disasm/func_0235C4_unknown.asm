; ============================================================================
; func_0235C4_unknown
; Region   : load_image
; Bytes    : file 0x0235C4..0x0235DE  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0235C4  55                    PUSH   bp                           ; UNKNOWN
0235C5  8B EC                 MOV    bp, sp                       ; UNKNOWN
0235C7  83 3E 1A 0F 00        CMP    word ptr [0xf1a], 0          ; UNKNOWN
0235CC  74 10                 JE     0x235de                      ; UNKNOWN
0235CE  83 3E 1C 0F 00        CMP    word ptr [0xf1c], 0          ; UNKNOWN
0235D3  75 09                 JNE    0x235de                      ; UNKNOWN
0235D5  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0235D8  0E                    PUSH   cs                           ; UNKNOWN
0235D9  E8 B5 FF              CALL   0x23591                      ; UNKNOWN
0235DC  C9                    LEAVE                               ; UNKNOWN
0235DD  CB                    RETF                                ; UNKNOWN
