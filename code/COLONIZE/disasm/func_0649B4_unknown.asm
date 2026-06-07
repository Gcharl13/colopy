; ============================================================================
; func_0649B4_unknown
; Region   : load_image
; Bytes    : file 0x0649B4..0x0649C3  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0649B4  55                    PUSH   bp                           ; UNKNOWN
0649B5  8B EC                 MOV    bp, sp                       ; UNKNOWN
0649B7  B4 00                 MOV    ah, 0                        ; UNKNOWN
0649B9  CD 16                 INT    0x16                         ; UNKNOWN
0649BB  0A C0                 OR     al, al                       ; UNKNOWN
0649BD  74 04                 JE     0x649c3                      ; UNKNOWN
0649BF  32 E4                 XOR    ah, ah                       ; UNKNOWN
0649C1  C9                    LEAVE                               ; UNKNOWN
0649C2  CB                    RETF                                ; UNKNOWN
