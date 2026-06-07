; ============================================================================
; func_040043_unknown
; Region   : load_image
; Bytes    : file 0x040043..0x04008A  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040043  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
040047  57                    PUSH   di                           ; UNKNOWN
040048  56                    PUSH   si                           ; UNKNOWN
040049  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
04004C  C7 46 F8 FF FF        MOV    word ptr [bp - 8], 0xffff    ; UNKNOWN
040051  0B F6                 OR     si, si                       ; UNKNOWN
040053  7D 03                 JGE    0x40058                      ; UNKNOWN
040055  E9 53 01              JMP    0x401ab                      ; UNKNOWN
040058  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
04005B  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
04005F  2A E4                 SUB    ah, ah                       ; UNKNOWN
040061  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
040064  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
040068  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
04006B  8B C6                 MOV    ax, si                       ; UNKNOWN
04006D  0E                    PUSH   cs                           ; UNKNOWN
04006E  E8 07 FB              CALL   0x3fb78                      ; UNKNOWN
040071  8B F0                 MOV    si, ax                       ; UNKNOWN
040073  0B F6                 OR     si, si                       ; UNKNOWN
040075  7C 39                 JL     0x400b0                      ; UNKNOWN
040077  8B C6                 MOV    ax, si                       ; UNKNOWN
040079  0E                    PUSH   cs                           ; UNKNOWN
04007A  E8 41 FB              CALL   0x3fbbe                      ; UNKNOWN
04007D  8B F8                 MOV    di, ax                       ; UNKNOWN
04007F  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040082  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
040086  2A FF                 SUB    bh, bh                       ; UNKNOWN
040088  8B C3                 MOV    ax, bx                       ; UNKNOWN
