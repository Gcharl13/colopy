; ============================================================================
; func_0431C9_unknown
; Region   : load_image
; Bytes    : file 0x0431C9..0x043256  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0431C9  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0431CD  57                    PUSH   di                           ; UNKNOWN
0431CE  56                    PUSH   si                           ; UNKNOWN
0431CF  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
0431D3  74 09                 JE     0x431de                      ; UNKNOWN
0431D5  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
0431D9  75 03                 JNE    0x431de                      ; UNKNOWN
0431DB  E9 90 00              JMP    0x4326e                      ; UNKNOWN
0431DE  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
0431E2  74 09                 JE     0x431ed                      ; UNKNOWN
0431E4  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0431E7  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0       ; UNKNOWN
0431EB  75 1E                 JNE    0x4320b                      ; UNKNOWN
0431ED  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
0431F0  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
0431F3  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
0431F7  2A E4                 SUB    ah, ah                       ; UNKNOWN
0431F9  50                    PUSH   ax                           ; UNKNOWN
0431FA  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0431FE  50                    PUSH   ax                           ; UNKNOWN
0431FF  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
043204  83 C4 04              ADD    sp, 4                        ; UNKNOWN
043207  0B C0                 OR     ax, ax                       ; UNKNOWN
043209  7D 63                 JGE    0x4326e                      ; UNKNOWN
04320B  83 7E 08 01           CMP    word ptr [bp + 8], 1         ; UNKNOWN
04320F  1B FF                 SBB    di, di                       ; UNKNOWN
043211  83 E7 40              AND    di, 0x40                     ; UNKNOWN
043214  81 C7 80 00           ADD    di, 0x80                     ; UNKNOWN
043218  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
04321B  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
04321F  2A E4                 SUB    ah, ah                       ; UNKNOWN
043221  2B 06 80 82           SUB    ax, word ptr [0x8280]        ; UNKNOWN
043225  03 06 82 82           ADD    ax, word ptr [0x8282]        ; UNKNOWN
043229  F7 2E 7C 82           IMUL   word ptr [0x827c]            ; UNKNOWN
04322D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
043230  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
043234  2A E4                 SUB    ah, ah                       ; UNKNOWN
043236  2B 06 86 82           SUB    ax, word ptr [0x8286]        ; UNKNOWN
04323A  03 06 84 82           ADD    ax, word ptr [0x8284]        ; UNKNOWN
04323E  F7 2E 7E 82           IMUL   word ptr [0x827e]            ; UNKNOWN
043242  83 C0 08              ADD    ax, 8                        ; UNKNOWN
043245  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
043248  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
04324C  24 0F                 AND    al, 0xf                      ; UNKNOWN
04324E  3A 06 0E 3E           CMP    al, byte ptr [0x3e0e]        ; UNKNOWN
043252  74 03                 JE     0x43257                      ; UNKNOWN
043254  83                    DB     0x83                         ; UNKNOWN (raw)
043255  CF                    DB     0xCF                         ; UNKNOWN (raw)
