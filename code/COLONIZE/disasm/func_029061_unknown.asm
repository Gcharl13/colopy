; ============================================================================
; func_029061_unknown
; Region   : load_image
; Bytes    : file 0x029061..0x029109  (168 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029061  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
029065  C4 1E 8A 40           LES    bx, ptr [0x408a]             ; UNKNOWN
029069  26 8A 47 21           MOV    al, byte ptr es:[bx + 0x21]  ; UNKNOWN
02906D  2A E4                 SUB    ah, ah                       ; UNKNOWN
02906F  3B 06 94 40           CMP    ax, word ptr [0x4094]        ; UNKNOWN
029073  7F 3F                 JG     0x290b4                      ; UNKNOWN
029075  A3 94 40              MOV    word ptr [0x4094], ax        ; UNKNOWN
029078  50                    PUSH   ax                           ; UNKNOWN
029079  0E                    PUSH   cs                           ; UNKNOWN
02907A  E8 41 F2              CALL   0x282be                      ; UNKNOWN
02907D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029080  6A 01                 PUSH   1                            ; UNKNOWN
029082  6A 00                 PUSH   0                            ; UNKNOWN
029084  C4 1E 8A 40           LES    bx, ptr [0x408a]             ; UNKNOWN
029088  26 FF 77 22           PUSH   word ptr es:[bx + 0x22]      ; UNKNOWN
02908C  FF 36 96 40           PUSH   word ptr [0x4096]            ; UNKNOWN
029090  0E                    PUSH   cs                           ; UNKNOWN
029091  E8 D3 F3              CALL   0x28467                      ; UNKNOWN
029094  83 C4 08              ADD    sp, 8                        ; UNKNOWN
029097  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02909A  0B C0                 OR     ax, ax                       ; UNKNOWN
02909C  7C 65                 JL     0x29103                      ; UNKNOWN
02909E  3D E8 03              CMP    ax, 0x3e8                    ; UNKNOWN
0290A1  74 60                 JE     0x29103                      ; UNKNOWN
0290A3  C4 1E 8A 40           LES    bx, ptr [0x408a]             ; UNKNOWN
0290A7  26 FE 47 21           INC    byte ptr es:[bx + 0x21]      ; UNKNOWN
0290AB  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0290AE  0E                    PUSH   cs                           ; UNKNOWN
0290AF  E8 D5 F7              CALL   0x28887                      ; UNKNOWN
0290B2  EB 4C                 JMP    0x29100                      ; UNKNOWN
0290B4  FF 36 94 40           PUSH   word ptr [0x4094]            ; UNKNOWN
0290B8  0E                    PUSH   cs                           ; UNKNOWN
0290B9  E8 02 F2              CALL   0x282be                      ; UNKNOWN
0290BC  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0290BF  C4 1E 8A 40           LES    bx, ptr [0x408a]             ; UNKNOWN
0290C3  26 80 7F 21 01        CMP    byte ptr es:[bx + 0x21], 1   ; UNKNOWN
0290C8  76 05                 JBE    0x290cf                      ; UNKNOWN
0290CA  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0290CD  EB 02                 JMP    0x290d1                      ; UNKNOWN
0290CF  2B C0                 SUB    ax, ax                       ; UNKNOWN
0290D1  50                    PUSH   ax                           ; UNKNOWN
0290D2  6A 00                 PUSH   0                            ; UNKNOWN
0290D4  C4 1E 8E 40           LES    bx, ptr [0x408e]             ; UNKNOWN
0290D8  26 FF 37              PUSH   word ptr es:[bx]             ; UNKNOWN
0290DB  FF 36 96 40           PUSH   word ptr [0x4096]            ; UNKNOWN
0290DF  0E                    PUSH   cs                           ; UNKNOWN
0290E0  E8 84 F3              CALL   0x28467                      ; UNKNOWN
0290E3  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0290E6  0B C0                 OR     ax, ax                       ; UNKNOWN
0290E8  7C 19                 JL     0x29103                      ; UNKNOWN
0290EA  3D E8 03              CMP    ax, 0x3e8                    ; UNKNOWN
0290ED  74 09                 JE     0x290f8                      ; UNKNOWN
0290EF  C4 1E 8E 40           LES    bx, ptr [0x408e]             ; UNKNOWN
0290F3  26 89 07              MOV    word ptr es:[bx], ax         ; UNKNOWN
0290F6  EB 0B                 JMP    0x29103                      ; UNKNOWN
0290F8  FF 36 94 40           PUSH   word ptr [0x4094]            ; UNKNOWN
0290FC  0E                    PUSH   cs                           ; UNKNOWN
0290FD  E8 A8 F7              CALL   0x288a8                      ; UNKNOWN
029100  83 C4 02              ADD    sp, 2                        ; UNKNOWN
029103  0E                    PUSH   cs                           ; UNKNOWN
029104  E8 63 FB              CALL   0x28c6a                      ; UNKNOWN
029107  C9                    LEAVE                               ; UNKNOWN
029108  CB                    RETF                                ; UNKNOWN
