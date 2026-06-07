; ============================================================================
; func_069AB0_unknown
; Region   : load_image
; Bytes    : file 0x069AB0..0x069AD9  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069AB0  55                    PUSH   bp                           ; UNKNOWN
069AB1  8B EC                 MOV    bp, sp                       ; UNKNOWN
069AB3  8B D7                 MOV    dx, di                       ; UNKNOWN
069AB5  8B DE                 MOV    bx, si                       ; UNKNOWN
069AB7  1E                    PUSH   ds                           ; UNKNOWN
069AB8  C5 76 06              LDS    si, ptr [bp + 6]             ; UNKNOWN
069ABB  C4 7E 0A              LES    di, ptr [bp + 0xa]           ; UNKNOWN
069ABE  33 C0                 XOR    ax, ax                       ; UNKNOWN
069AC0  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
069AC3  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
069AC5  F7 D1                 NOT    cx                           ; UNKNOWN
069AC7  2B F9                 SUB    di, cx                       ; UNKNOWN
069AC9  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; UNKNOWN
069ACB  74 05                 JE     0x69ad2                      ; UNKNOWN
069ACD  1B C0                 SBB    ax, ax                       ; UNKNOWN
069ACF  1D FF FF              SBB    ax, 0xffff                   ; UNKNOWN
069AD2  1F                    POP    ds                           ; UNKNOWN
069AD3  8B F3                 MOV    si, bx                       ; UNKNOWN
069AD5  8B FA                 MOV    di, dx                       ; UNKNOWN
069AD7  5D                    POP    bp                           ; UNKNOWN
069AD8  CB                    RETF                                ; UNKNOWN
