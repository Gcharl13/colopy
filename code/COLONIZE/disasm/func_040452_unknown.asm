; ============================================================================
; func_040452_unknown
; Region   : load_image
; Bytes    : file 0x040452..0x0404BB  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040452  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
040456  57                    PUSH   di                           ; UNKNOWN
040457  56                    PUSH   si                           ; UNKNOWN
040458  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
04045B  0B F6                 OR     si, si                       ; UNKNOWN
04045D  7C 54                 JL     0x404b3                      ; UNKNOWN
04045F  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040462  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
040466  2A E4                 SUB    ah, ah                       ; UNKNOWN
040468  8B F8                 MOV    di, ax                       ; UNKNOWN
04046A  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
04046E  2A ED                 SUB    ch, ch                       ; UNKNOWN
040470  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
040473  51                    PUSH   cx                           ; UNKNOWN
040474  50                    PUSH   ax                           ; UNKNOWN
040475  56                    PUSH   si                           ; UNKNOWN
040476  0E                    PUSH   cs                           ; UNKNOWN
040477  E8 57 FA              CALL   0x3fed1                      ; UNKNOWN
04047A  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04047D  8B C6                 MOV    ax, si                       ; UNKNOWN
04047F  9A E8 02 32 18        LCALL  0x1832, 0x2e8                ; UNKNOWN
040484  6A 00                 PUSH   0                            ; UNKNOWN
040486  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
040489  57                    PUSH   di                           ; UNKNOWN
04048A  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04048D  57                    PUSH   di                           ; UNKNOWN
04048E  9A F9 02 0B 38        LCALL  0x380b, 0x2f9                ; UNKNOWN
040493  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
040496  0B C0                 OR     ax, ax                       ; UNKNOWN
040498  75 19                 JNE    0x404b3                      ; UNKNOWN
04049A  6A 01                 PUSH   1                            ; UNKNOWN
04049C  6A 07                 PUSH   7                            ; UNKNOWN
04049E  6A 07                 PUSH   7                            ; UNKNOWN
0404A0  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0404A3  83 E8 03              SUB    ax, 3                        ; UNKNOWN
0404A6  50                    PUSH   ax                           ; UNKNOWN
0404A7  8D 45 FD              LEA    ax, [di - 3]                 ; UNKNOWN
0404AA  50                    PUSH   ax                           ; UNKNOWN
0404AB  9A 0C 00 E4 35        LCALL  0x35e4, 0xc                  ; UNKNOWN
0404B0  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
0404B3  89 36 0A 3E           MOV    word ptr [0x3e0a], si        ; UNKNOWN
0404B7  5E                    POP    si                           ; UNKNOWN
0404B8  5F                    POP    di                           ; UNKNOWN
0404B9  C9                    LEAVE                               ; UNKNOWN
0404BA  CB                    RETF                                ; UNKNOWN
