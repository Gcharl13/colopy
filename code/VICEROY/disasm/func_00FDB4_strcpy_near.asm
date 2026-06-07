; ============================================================================
; func_00FDB4_strcpy_near
; Region   : load_image
; Bytes    : file 0x00FDB4..0x00FDE6  (50 bytes)
; Purpose  : C `strcpy(dest, src)` — both arguments are near (DGROUP-relative) pointers. Locates the source length with REPNE SCASB, then REP MOVSW + MOVSB-tail to copy. Returns AX = original dest pointer.
; Args     : [bp+6] = dest near-pointer, [bp+8] = src near-pointer
; Returns  : AX = [bp+6] (original dest pointer)
; Callers  : TBD (38 distinct call sites — most-called custom helper)
; Callees  : (none — leaf, REP-prefixed string ops)
; Verified : Boundary verified: PUSH BP / RETF, 50 bytes. Single REPNE SCASB phase + SHR/REP MOVSW pattern.
; Source   : Pattern matches MS C runtime strcpy; 38 callers makes it the single most-called load-image helper.
; ============================================================================

00FDB4  55                    PUSH   bp                           ; standard frame prologue
00FDB5  8B EC                 MOV    bp, sp                       ; BP = SP
00FDB7  8B D7                 MOV    dx, di                       ; preserve DI (caller's value) in DX
00FDB9  8B DE                 MOV    bx, si                       ; preserve SI (caller's value) in BX
00FDBB  8B 76 08              MOV    si, word ptr [bp + 8]        ; SI = src near-pointer
00FDBE  8B FE                 MOV    di, si                       ; DI = SI (we'll scan with DI to leave SI pointing at the source for the copy phase)
00FDC0  8C D8                 MOV    ax, ds                       ; AX = DS
00FDC2  8E C0                 MOV    es, ax                       ; ES = DS — REPNE SCASB scans ES:DI
00FDC4  33 C0                 XOR    ax, ax                       ; AL = 0 — the byte to find (NUL terminator)
00FDC6  B9 FF FF              MOV    cx, 0xffff                   ; CX = -1 — max scan count
00FDC9  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; scan forward until [DI] == 0; CX decrements each step
00FDCB  F7 D1                 NOT    cx                           ; CX = strlen(src) + 1  (includes the NUL)
00FDCD  8B 7E 06              MOV    di, word ptr [bp + 6]        ; DI = dest near-pointer
00FDD0  8B C7                 MOV    ax, di                       ; AX = dest pointer (return value)
00FDD2  A8 01                 TEST   al, 1                        ; is dest pointer odd-aligned?
00FDD4  74 02                 JE     0xfdd8                       ; if even-aligned, skip the byte-pre-copy
00FDD6  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; copy 1 byte to align DI to a word boundary
00FDD7  49                    DEC    cx                           ; one fewer byte to copy
00FDD8  D1 E9                 SHR    cx, 1                        ; CX = (remaining_count) / 2 — number of WORDS to copy
00FDDA  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; bulk-copy words
00FDDC  13 C9                 ADC    cx, cx                       ; CX = leftover byte (carry-flag-from-shift)
00FDDE  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; copy the trailing byte if length was odd
00FDE0  8B F3                 MOV    si, bx                       ; restore SI
00FDE2  8B FA                 MOV    di, dx                       ; restore DI
00FDE4  5D                    POP    bp                           ; restore BP
00FDE5  CB                    RETF                                ; far-return: AX = original dest pointer
