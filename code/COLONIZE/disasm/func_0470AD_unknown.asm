; ============================================================================
; func_0470AD_unknown
; Region   : load_image
; Bytes    : file 0x0470AD..0x0470FF  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0470AD  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
0470B1  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
0470B6  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
0470BB  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0470BF  2A E4                 SUB    ah, ah                       ; UNKNOWN
0470C1  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
0470C4  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0470C7  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
0470CB  2A ED                 SUB    ch, ch                       ; UNKNOWN
0470CD  03 4E 08              ADD    cx, word ptr [bp + 8]        ; UNKNOWN
0470D0  89 4E F2              MOV    word ptr [bp - 0xe], cx      ; UNKNOWN
0470D3  8B D0                 MOV    dx, ax                       ; UNKNOWN
0470D5  8B D9                 MOV    bx, cx                       ; UNKNOWN
0470D7  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
0470DA  0E                    PUSH   cs                           ; UNKNOWN
0470DB  E8 91 FC              CALL   0x46d6f                      ; UNKNOWN
0470DE  0B C0                 OR     ax, ax                       ; UNKNOWN
0470E0  74 03                 JE     0x470e5                      ; UNKNOWN
0470E2  E9 40 01              JMP    0x47225                      ; UNKNOWN
0470E5  A1 DE C5              MOV    ax, word ptr [0xc5de]        ; UNKNOWN
0470E8  E9 17 01              JMP    0x47202                      ; UNKNOWN
0470EB  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
0470EF  8D 06 96 28           LEA    ax, [0x2896]                 ; UNKNOWN
0470F3  2B D2                 SUB    dx, dx                       ; UNKNOWN
0470F5  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
0470FA  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0470FD  C9                    LEAVE                               ; UNKNOWN
0470FE  CB                    RETF                                ; UNKNOWN
