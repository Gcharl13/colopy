; ============================================================================
; func_068D84_unknown
; Region   : load_image
; Bytes    : file 0x068D84..0x068DC3  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068D84  55                    PUSH   bp                           ; UNKNOWN
068D85  8B EC                 MOV    bp, sp                       ; UNKNOWN
068D87  8B D7                 MOV    dx, di                       ; UNKNOWN
068D89  8B DE                 MOV    bx, si                       ; UNKNOWN
068D8B  8C D8                 MOV    ax, ds                       ; UNKNOWN
068D8D  8E C0                 MOV    es, ax                       ; UNKNOWN
068D8F  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
068D92  33 C0                 XOR    ax, ax                       ; UNKNOWN
068D94  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
068D97  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
068D99  8D 75 FF              LEA    si, [di - 1]                 ; UNKNOWN
068D9C  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
068D9F  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
068DA2  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
068DA4  F7 D1                 NOT    cx                           ; UNKNOWN
068DA6  2B F9                 SUB    di, cx                       ; UNKNOWN
068DA8  87 FE                 XCHG   si, di                       ; UNKNOWN
068DAA  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
068DAD  F7 C6 01 00           TEST   si, 1                        ; UNKNOWN
068DB1  74 02                 JE     0x68db5                      ; UNKNOWN
068DB3  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; UNKNOWN
068DB4  49                    DEC    cx                           ; UNKNOWN
068DB5  D1 E9                 SHR    cx, 1                        ; UNKNOWN
068DB7  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; UNKNOWN
068DB9  13 C9                 ADC    cx, cx                       ; UNKNOWN
068DBB  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; UNKNOWN
068DBD  8B F3                 MOV    si, bx                       ; UNKNOWN
068DBF  8B FA                 MOV    di, dx                       ; UNKNOWN
068DC1  5D                    POP    bp                           ; UNKNOWN
068DC2  CB                    RETF                                ; UNKNOWN
