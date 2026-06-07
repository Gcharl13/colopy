; ============================================================================
; func_0658F6_unknown
; Region   : load_image
; Bytes    : file 0x0658F6..0x065919  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0658F6  55                    PUSH   bp                           ; UNKNOWN
0658F7  8B EC                 MOV    bp, sp                       ; UNKNOWN
0658F9  8B 0E E2 0E           MOV    cx, word ptr [0xee2]         ; UNKNOWN
0658FD  3B C1                 CMP    ax, cx                       ; UNKNOWN
0658FF  7F 18                 JG     0x65919                      ; UNKNOWN
065901  3B D9                 CMP    bx, cx                       ; UNKNOWN
065903  7C 14                 JL     0x65919                      ; UNKNOWN
065905  8B 1E E4 0E           MOV    bx, word ptr [0xee4]         ; UNKNOWN
065909  3B D3                 CMP    dx, bx                       ; UNKNOWN
06590B  7F 0C                 JG     0x65919                      ; UNKNOWN
06590D  39 5E 06              CMP    word ptr [bp + 6], bx        ; UNKNOWN
065910  7C 07                 JL     0x65919                      ; UNKNOWN
065912  B8 01 00              MOV    ax, 1                        ; UNKNOWN
065915  C9                    LEAVE                               ; UNKNOWN
065916  CA 02 00              RETF   2                            ; UNKNOWN
