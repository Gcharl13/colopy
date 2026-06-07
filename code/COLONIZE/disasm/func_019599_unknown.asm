; ============================================================================
; func_019599_unknown
; Region   : load_image
; Bytes    : file 0x019599..0x0195EB  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019599  55                    PUSH   bp                           ; UNKNOWN
01959A  8B EC                 MOV    bp, sp                       ; UNKNOWN
01959C  6A 30                 PUSH   0x30                         ; UNKNOWN
01959E  6A 5B                 PUSH   0x5b                         ; UNKNOWN
0195A0  68 82 00              PUSH   0x82                         ; UNKNOWN
0195A3  68 D3 00              PUSH   0xd3                         ; UNKNOWN
0195A6  0E                    PUSH   cs                           ; UNKNOWN
0195A7  E8 FB E1              CALL   0x177a5                      ; UNKNOWN
0195AA  8B E5                 MOV    sp, bp                       ; UNKNOWN
0195AC  A0 04 09              MOV    al, byte ptr [0x904]         ; UNKNOWN
0195AF  2A E4                 SUB    ah, ah                       ; UNKNOWN
0195B1  EB 12                 JMP    0x195c5                      ; UNKNOWN
0195B3  0E                    PUSH   cs                           ; UNKNOWN
0195B4  E8 6D F4              CALL   0x18a24                      ; UNKNOWN
0195B7  EB 16                 JMP    0x195cf                      ; UNKNOWN
0195B9  0E                    PUSH   cs                           ; UNKNOWN
0195BA  E8 DF F5              CALL   0x18b9c                      ; UNKNOWN
0195BD  EB 10                 JMP    0x195cf                      ; UNKNOWN
0195BF  0E                    PUSH   cs                           ; UNKNOWN
0195C0  E8 46 FA              CALL   0x19009                      ; UNKNOWN
0195C3  EB 0A                 JMP    0x195cf                      ; UNKNOWN
0195C5  0B C0                 OR     ax, ax                       ; UNKNOWN
0195C7  74 EA                 JE     0x195b3                      ; UNKNOWN
0195C9  48                    DEC    ax                           ; UNKNOWN
0195CA  74 ED                 JE     0x195b9                      ; UNKNOWN
0195CC  48                    DEC    ax                           ; UNKNOWN
0195CD  74 F0                 JE     0x195bf                      ; UNKNOWN
0195CF  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0195D3  74 14                 JE     0x195e9                      ; UNKNOWN
0195D5  68 82 00              PUSH   0x82                         ; UNKNOWN
0195D8  6A 5B                 PUSH   0x5b                         ; UNKNOWN
0195DA  6A 30                 PUSH   0x30                         ; UNKNOWN
0195DC  B8 D3 00              MOV    ax, 0xd3                     ; UNKNOWN
0195DF  BA 82 00              MOV    dx, 0x82                     ; UNKNOWN
0195E2  8B D8                 MOV    bx, ax                       ; UNKNOWN
0195E4  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
0195E9  C9                    LEAVE                               ; UNKNOWN
0195EA  CB                    RETF                                ; UNKNOWN
