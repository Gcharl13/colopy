; ============================================================================
; func_06AB2A_unknown
; Region   : load_image
; Bytes    : file 0x06AB2A..0x06ABD6  (172 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06AB2A  55                    PUSH   bp                           ; UNKNOWN
06AB2B  8B EC                 MOV    bp, sp                       ; UNKNOWN
06AB2D  83 EC 0E              SUB    sp, 0xe                      ; UNKNOWN
06AB30  57                    PUSH   di                           ; UNKNOWN
06AB31  56                    PUSH   si                           ; UNKNOWN
06AB32  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
06AB35  8B C6                 MOV    ax, si                       ; UNKNOWN
06AB37  2D 78 12              SUB    ax, 0x1278                   ; UNKNOWN
06AB3A  05 18 13              ADD    ax, 0x1318                   ; UNKNOWN
06AB3D  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
06AB40  8A 44 07              MOV    al, byte ptr [si + 7]        ; UNKNOWN
06AB43  2A E4                 SUB    ah, ah                       ; UNKNOWN
06AB45  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
06AB48  83 7C 02 00           CMP    word ptr [si + 2], 0         ; UNKNOWN
06AB4C  7D 05                 JGE    0x6ab53                      ; UNKNOWN
06AB4E  C7 44 02 00 00        MOV    word ptr [si + 2], 0         ; UNKNOWN
06AB53  B8 01 00              MOV    ax, 1                        ; UNKNOWN
06AB56  50                    PUSH   ax                           ; UNKNOWN
06AB57  2B C0                 SUB    ax, ax                       ; UNKNOWN
06AB59  50                    PUSH   ax                           ; UNKNOWN
06AB5A  50                    PUSH   ax                           ; UNKNOWN
06AB5B  FF 76 F6              PUSH   word ptr [bp - 0xa]          ; UNKNOWN
06AB5E  9A DE 20 65 5F        LCALL  0x5f65, 0x20de               ; UNKNOWN
06AB63  83 C4 08              ADD    sp, 8                        ; UNKNOWN
06AB66  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
06AB69  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
06AB6C  0B D2                 OR     dx, dx                       ; UNKNOWN
06AB6E  7D 08                 JGE    0x6ab78                      ; UNKNOWN
06AB70  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
06AB73  99                    CDQ                                 ; UNKNOWN
06AB74  E9 23 01              JMP    0x6ac9a                      ; UNKNOWN
06AB77  90                    NOP                                 ; UNKNOWN
06AB78  F6 44 06 08           TEST   byte ptr [si + 6], 8         ; UNKNOWN
06AB7C  75 1E                 JNE    0x6ab9c                      ; UNKNOWN
06AB7E  8B 5E F2              MOV    bx, word ptr [bp - 0xe]      ; UNKNOWN
06AB81  F6 07 01              TEST   byte ptr [bx], 1             ; UNKNOWN
06AB84  75 16                 JNE    0x6ab9c                      ; UNKNOWN
06AB86  8B 44 02              MOV    ax, word ptr [si + 2]        ; UNKNOWN
06AB89  99                    CDQ                                 ; UNKNOWN
06AB8A  8B C8                 MOV    cx, ax                       ; UNKNOWN
06AB8C  8B DA                 MOV    bx, dx                       ; UNKNOWN
06AB8E  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
06AB91  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
06AB94  2B C1                 SUB    ax, cx                       ; UNKNOWN
06AB96  1B D3                 SBB    dx, bx                       ; UNKNOWN
06AB98  E9 FF 00              JMP    0x6ac9a                      ; UNKNOWN
06AB9B  90                    NOP                                 ; UNKNOWN
06AB9C  8B 04                 MOV    ax, word ptr [si]            ; UNKNOWN
06AB9E  2B 44 04              SUB    ax, word ptr [si + 4]        ; UNKNOWN
06ABA1  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
06ABA4  F6 44 06 03           TEST   byte ptr [si + 6], 3         ; UNKNOWN
06ABA8  74 2E                 JE     0x6abd8                      ; UNKNOWN
06ABAA  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
06ABAD  F6 87 47 12 80        TEST   byte ptr [bx + 0x1247], 0x80 ; UNKNOWN
06ABB2  74 13                 JE     0x6abc7                      ; UNKNOWN
06ABB4  8B 7C 04              MOV    di, word ptr [si + 4]        ; UNKNOWN
06ABB7  EB 0A                 JMP    0x6abc3                      ; UNKNOWN
06ABB9  90                    NOP                                 ; UNKNOWN
06ABBA  80 3D 0A              CMP    byte ptr [di], 0xa           ; UNKNOWN
06ABBD  75 03                 JNE    0x6abc2                      ; UNKNOWN
06ABBF  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
06ABC2  47                    INC    di                           ; UNKNOWN
06ABC3  39 3C                 CMP    word ptr [si], di            ; UNKNOWN
06ABC5  77 F3                 JA     0x6abba                      ; UNKNOWN
06ABC7  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
06ABCA  0B 46 FC              OR     ax, word ptr [bp - 4]        ; UNKNOWN
06ABCD  75 17                 JNE    0x6abe6                      ; UNKNOWN
06ABCF  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
06ABD2  2B D2                 SUB    dx, dx                       ; UNKNOWN
06ABD4  E9                    DB     0xE9                         ; UNKNOWN (raw)
06ABD5  C3                    DB     0xC3                         ; UNKNOWN (raw)
