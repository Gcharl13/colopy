; ============================================================================
; func_069012_unknown
; Region   : load_image
; Bytes    : file 0x069012..0x069091  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069012  55                    PUSH   bp                           ; UNKNOWN
069013  8B EC                 MOV    bp, sp                       ; UNKNOWN
069015  56                    PUSH   si                           ; UNKNOWN
069016  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
069019  F6 44 06 83           TEST   byte ptr [si + 6], 0x83      ; UNKNOWN
06901D  74 0C                 JE     0x6902b                      ; UNKNOWN
06901F  83 7E 0C 02           CMP    word ptr [bp + 0xc], 2       ; UNKNOWN
069023  7F 06                 JG     0x6902b                      ; UNKNOWN
069025  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
069029  7D 09                 JGE    0x69034                      ; UNKNOWN
06902B  C7 06 38 12 16 00     MOV    word ptr [0x1238], 0x16      ; UNKNOWN
069031  EB 52                 JMP    0x69085                      ; UNKNOWN
069033  90                    NOP                                 ; UNKNOWN
069034  80 64 06 EF           AND    byte ptr [si + 6], 0xef      ; UNKNOWN
069038  83 7E 0C 01           CMP    word ptr [bp + 0xc], 1       ; UNKNOWN
06903C  75 14                 JNE    0x69052                      ; UNKNOWN
06903E  56                    PUSH   si                           ; UNKNOWN
06903F  9A DA 24 65 5F        LCALL  0x5f65, 0x24da               ; UNKNOWN
069044  83 C4 02              ADD    sp, 2                        ; UNKNOWN
069047  01 46 08              ADD    word ptr [bp + 8], ax        ; UNKNOWN
06904A  11 56 0A              ADC    word ptr [bp + 0xa], dx      ; UNKNOWN
06904D  C7 46 0C 00 00        MOV    word ptr [bp + 0xc], 0       ; UNKNOWN
069052  56                    PUSH   si                           ; UNKNOWN
069053  9A 18 06 65 5F        LCALL  0x5f65, 0x618                ; UNKNOWN
069058  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06905B  F6 44 06 80           TEST   byte ptr [si + 6], 0x80      ; UNKNOWN
06905F  74 04                 JE     0x69065                      ; UNKNOWN
069061  80 64 06 FC           AND    byte ptr [si + 6], 0xfc      ; UNKNOWN
069065  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
069068  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
06906B  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06906E  8A 44 07              MOV    al, byte ptr [si + 7]        ; UNKNOWN
069071  2A E4                 SUB    ah, ah                       ; UNKNOWN
069073  50                    PUSH   ax                           ; UNKNOWN
069074  9A DE 20 65 5F        LCALL  0x5f65, 0x20de               ; UNKNOWN
069079  83 C4 08              ADD    sp, 8                        ; UNKNOWN
06907C  3D FF FF              CMP    ax, 0xffff                   ; UNKNOWN
06907F  75 09                 JNE    0x6908a                      ; UNKNOWN
069081  3B D0                 CMP    dx, ax                       ; UNKNOWN
069083  75 05                 JNE    0x6908a                      ; UNKNOWN
069085  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
069088  EB 02                 JMP    0x6908c                      ; UNKNOWN
06908A  2B C0                 SUB    ax, ax                       ; UNKNOWN
06908C  5E                    POP    si                           ; UNKNOWN
06908D  8B E5                 MOV    sp, bp                       ; UNKNOWN
06908F  5D                    POP    bp                           ; UNKNOWN
069090  CB                    RETF                                ; UNKNOWN
