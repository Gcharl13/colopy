; ============================================================================
; func_00E7C0_unknown
; Region   : load_image
; Bytes    : file 0x00E7C0..0x00E7DD  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E7C0  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
00E7C4  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
00E7C7  B4 45                 MOV    ah, 0x45                     ; UNKNOWN
00E7C9  CD 67                 INT    0x67                         ; UNKNOWN
00E7CB  8A C4                 MOV    al, ah                       ; UNKNOWN
00E7CD  32 E4                 XOR    ah, ah                       ; UNKNOWN
00E7CF  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00E7D2  83 3E 4E 05 01        CMP    word ptr [0x54e], 1          ; UNKNOWN
00E7D7  1B C0                 SBB    ax, ax                       ; UNKNOWN
00E7D9  F7 D8                 NEG    ax                           ; UNKNOWN
00E7DB  C9                    LEAVE                               ; UNKNOWN
00E7DC  CB                    RETF                                ; UNKNOWN
