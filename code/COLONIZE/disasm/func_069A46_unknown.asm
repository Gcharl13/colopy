; ============================================================================
; func_069A46_unknown
; Region   : load_image
; Bytes    : file 0x069A46..0x069A70  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069A46  55                    PUSH   bp                           ; UNKNOWN
069A47  8B EC                 MOV    bp, sp                       ; UNKNOWN
069A49  57                    PUSH   di                           ; UNKNOWN
069A4A  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
069A4D  33 C0                 XOR    ax, ax                       ; UNKNOWN
069A4F  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
069A52  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
069A54  41                    INC    cx                           ; UNKNOWN
069A55  F7 D9                 NEG    cx                           ; UNKNOWN
069A57  4F                    DEC    di                           ; UNKNOWN
069A58  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
069A5B  FD                    STD                                 ; UNKNOWN
069A5C  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
069A5E  47                    INC    di                           ; UNKNOWN
069A5F  26 38 05              CMP    byte ptr es:[di], al         ; UNKNOWN
069A62  74 06                 JE     0x69a6a                      ; UNKNOWN
069A64  33 C0                 XOR    ax, ax                       ; UNKNOWN
069A66  8B D0                 MOV    dx, ax                       ; UNKNOWN
069A68  EB 04                 JMP    0x69a6e                      ; UNKNOWN
069A6A  8B C7                 MOV    ax, di                       ; UNKNOWN
069A6C  8C C2                 MOV    dx, es                       ; UNKNOWN
069A6E  FC                    CLD                                 ; UNKNOWN
069A6F  5F                    POP    di                           ; UNKNOWN
