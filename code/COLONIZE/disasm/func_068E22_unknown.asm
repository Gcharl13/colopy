; ============================================================================
; func_068E22_unknown
; Region   : load_image
; Bytes    : file 0x068E22..0x068E3D  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068E22  55                    PUSH   bp                           ; UNKNOWN
068E23  8B EC                 MOV    bp, sp                       ; UNKNOWN
068E25  8B D7                 MOV    dx, di                       ; UNKNOWN
068E27  8C D8                 MOV    ax, ds                       ; UNKNOWN
068E29  8E C0                 MOV    es, ax                       ; UNKNOWN
068E2B  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
068E2E  33 C0                 XOR    ax, ax                       ; UNKNOWN
068E30  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
068E33  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
068E35  F7 D1                 NOT    cx                           ; UNKNOWN
068E37  49                    DEC    cx                           ; UNKNOWN
068E38  91                    XCHG   cx, ax                       ; UNKNOWN
068E39  8B FA                 MOV    di, dx                       ; UNKNOWN
068E3B  5D                    POP    bp                           ; UNKNOWN
068E3C  CB                    RETF                                ; UNKNOWN
