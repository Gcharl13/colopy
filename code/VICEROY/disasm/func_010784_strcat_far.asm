; ============================================================================
; func_010784_strcat_far
; Region   : load_image
; Bytes    : file 0x010784..0x0107CA  (70 bytes)
; Purpose  : Far-pointer variant of strcat: dest is a far pointer at [bp+6..9] (LES DI), additional segment at [bp+8] (?), src is a far pointer at [bp+0xA..0xD]. Implements `_fstrcat`. Two REPNE SCASB phases (dest length, src length) followed by REP MOVSW + MOVSB-tail.
; Args     : [bp+6..9] = dest far-pointer, [bp+0xA..0xD] = src far-pointer
; Returns  : DX:AX = original dest far-pointer
; Callers  : TBD (16 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: PUSH BP / PUSH DS / RETF, 70 bytes.
; Source   : Far-pointer adaptation of strcat_near; signature matches the MS C runtime _fstrcat.
; ============================================================================

010784  55                    PUSH   bp                           ; standard frame prologue
010785  8B EC                 MOV    bp, sp                       ; BP = SP
010787  8B D7                 MOV    dx, di                       ; preserve caller's DI in DX
010789  8B DE                 MOV    bx, si                       ; preserve caller's SI in BX
01078B  1E                    PUSH   ds                           ; preserve DS
01078C  C4 7E 06              LES    di, ptr [bp + 6]             ; ES:DI = dest far-pointer
01078F  33 C0                 XOR    ax, ax                       ; AL = 0
010791  B9 FF FF              MOV    cx, 0xffff                   ; CX = -1
010794  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; scan dest for NUL
010796  8D 75 FF              LEA    si, [di - 1]                 ; SI = pointer to dest's NUL (where to start appending)
010799  C4 7E 0A              LES    di, ptr [bp + 0xa]           ; ES:DI = src far-pointer
01079C  B9 FF FF              MOV    cx, 0xffff                   ; CX = -1
01079F  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; scan src for NUL
0107A1  F7 D1                 NOT    cx                           ; CX = src_len + 1 (includes NUL)
0107A3  2B F9                 SUB    di, cx                       ; rewind DI to start of src
0107A5  8C C0                 MOV    ax, es                       ; AX = src segment
0107A7  8E D8                 MOV    ds, ax                       ; DS = src segment (for the source side of MOVSW)
0107A9  8E 46 08              MOV    es, word ptr [bp + 8]        ; ES = dest segment (high word of dest far-pointer)
0107AC  87 FE                 XCHG   si, di                       ; swap: SI = src start, DI = dest's NUL position (where to append)
0107AE  8B 46 06              MOV    ax, word ptr [bp + 6]        ; AX = dest offset (low half of return value)
0107B1  F7 C6 01 00           TEST   si, 1                        ; src start odd?
0107B5  74 02                 JE     0x107b9                      ; if even, skip pre-copy
0107B7  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; align src to word boundary
0107B8  49                    DEC    cx                           ; one fewer byte
0107B9  D1 E9                 SHR    cx, 1                        ; CX = word count
0107BB  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; bulk copy
0107BD  13 C9                 ADC    cx, cx                       ; CX = leftover-byte flag
0107BF  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; trailing byte
0107C1  8B F3                 MOV    si, bx                       ; restore SI
0107C3  8B FA                 MOV    di, dx                       ; restore DI
0107C5  1F                    POP    ds                           ; restore DS
0107C6  8C C2                 MOV    dx, es                       ; DX = dest segment (high half of return)
0107C8  5D                    POP    bp                           ; restore BP
0107C9  CB                    RETF                                ; far-return: DX:AX = original dest far-pointer
