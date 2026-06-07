; ============================================================================
; func_068DF6_unknown
; Region   : load_image
; Bytes    : file 0x068DF6..0x068E21  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068DF6  55                    PUSH   bp                           ; UNKNOWN
068DF7  8B EC                 MOV    bp, sp                       ; UNKNOWN
068DF9  8B D7                 MOV    dx, di                       ; UNKNOWN
068DFB  8B DE                 MOV    bx, si                       ; UNKNOWN
068DFD  8C D8                 MOV    ax, ds                       ; UNKNOWN
068DFF  8E C0                 MOV    es, ax                       ; UNKNOWN
068E01  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
068E04  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
068E07  33 C0                 XOR    ax, ax                       ; UNKNOWN
068E09  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
068E0C  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
068E0E  F7 D1                 NOT    cx                           ; UNKNOWN
068E10  2B F9                 SUB    di, cx                       ; UNKNOWN
068E12  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; UNKNOWN
068E14  74 05                 JE     0x68e1b                      ; UNKNOWN
068E16  1B C0                 SBB    ax, ax                       ; UNKNOWN
068E18  1D FF FF              SBB    ax, 0xffff                   ; UNKNOWN
068E1B  8B F3                 MOV    si, bx                       ; UNKNOWN
068E1D  8B FA                 MOV    di, dx                       ; UNKNOWN
068E1F  5D                    POP    bp                           ; UNKNOWN
068E20  CB                    RETF                                ; UNKNOWN
