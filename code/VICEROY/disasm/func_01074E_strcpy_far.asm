; ============================================================================
; func_01074E_strcpy_far
; Region   : load_image
; Bytes    : file 0x01074E..0x010784  (54 bytes)
; Purpose  : Far-pointer variant of strcpy: dest is a far pointer at [bp+6..9] (LES DI), src is a far pointer at [bp+0xA..0xD] (LDS SI). Otherwise identical to strcpy_near (REPNE SCASB to find src length, then REP MOVSW + MOVSB-tail to copy). Returns DX:AX = original dest far-pointer.
; Args     : [bp+6..9] = dest far-pointer, [bp+0xA..0xD] = src far-pointer
; Returns  : DX:AX = original dest far-pointer
; Callers  : TBD (17 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: PUSH BP / PUSH DS / RETF, 54 bytes.
; Source   : Far-pointer adaptation of strcpy_near; signature matches the MS C runtime _fstrcpy.
; ============================================================================

01074E  55                    PUSH   bp                           ; standard frame prologue
01074F  8B EC                 MOV    bp, sp                       ; BP = SP
010751  8B D7                 MOV    dx, di                       ; preserve caller's DI in DX
010753  8B DE                 MOV    bx, si                       ; preserve caller's SI in BX
010755  1E                    PUSH   ds                           ; preserve caller's DS — we'll be overwriting it for the LDS
010756  C5 76 0A              LDS    si, ptr [bp + 0xa]           ; DS:SI = src far-pointer
010759  8B FE                 MOV    di, si                       ; DI = SI (we'll use DI for SCASB but keep SI for the copy)
01075B  8C D8                 MOV    ax, ds                       ; AX = DS (the src segment)
01075D  8E C0                 MOV    es, ax                       ; ES = src segment for the SCASB scan
01075F  33 C0                 XOR    ax, ax                       ; AL = 0 (NUL terminator)
010761  B9 FF FF              MOV    cx, 0xffff                   ; CX = -1 (max scan)
010764  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; scan to NUL
010766  F7 D1                 NOT    cx                           ; CX = src_len + 1
010768  C4 7E 06              LES    di, ptr [bp + 6]             ; ES:DI = dest far-pointer
01076B  8B C7                 MOV    ax, di                       ; AX = dest offset (low half of return value)
01076D  A8 01                 TEST   al, 1                        ; dest odd-aligned?
01076F  74 02                 JE     0x10773                      ; if even-aligned, skip the byte-pre-copy
010771  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; copy 1 byte to align ES:DI to a word boundary
010772  49                    DEC    cx                           ; one fewer byte
010773  D1 E9                 SHR    cx, 1                        ; CX = remaining_bytes / 2 (word count)
010775  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; bulk copy (DS:SI → ES:DI)
010777  13 C9                 ADC    cx, cx                       ; CX = leftover-byte flag
010779  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; trailing byte if length was odd
01077B  8B F3                 MOV    si, bx                       ; restore SI
01077D  8B FA                 MOV    di, dx                       ; restore DI
01077F  1F                    POP    ds                           ; restore DS
010780  8C C2                 MOV    dx, es                       ; DX = dest segment (high half of return)
010782  5D                    POP    bp                           ; restore BP
010783  CB                    RETF                                ; far-return: DX:AX = original dest far-pointer
