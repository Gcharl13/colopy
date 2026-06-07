; ============================================================================
; func_00FD74_strcat_near
; Region   : load_image
; Bytes    : file 0x00FD74..0x00FDB3  (63 bytes)
; Purpose  : C `strcat(dest, src)` — both arguments are near (DGROUP-relative) pointers. Locates the end of dest with REPNE SCASB (scan-byte-while-not-zero), locates the source length similarly, then REP MOVSW + MOVSB-tail to append source onto dest. Returns AX = original dest pointer.
; Args     : [bp+6] = dest near-pointer, [bp+8] = src near-pointer
; Returns  : AX = [bp+6] (original dest pointer)
; Callers  : TBD (34 distinct call sites)
; Callees  : (none — leaf, REP-prefixed string ops)
; Verified : Boundary verified: PUSH BP / RETF, 63 bytes. Two REPNE SCASB phases (dest length, src length) followed by SHR/REP MOVSW pattern characteristic of strcat.
; Source   : Pattern matches MS C runtime strcat; 34 callers makes it one of the most-used helpers.
; ============================================================================

00FD74  55                    PUSH   bp                           ; standard frame prologue
00FD75  8B EC                 MOV    bp, sp                       ; BP = SP
00FD77  8B D7                 MOV    dx, di                       ; preserve caller's DI in DX
00FD79  8B DE                 MOV    bx, si                       ; preserve caller's SI in BX
00FD7B  8C D8                 MOV    ax, ds                       ; AX = DS
00FD7D  8E C0                 MOV    es, ax                       ; ES = DS for REPNE SCASB
00FD7F  8B 7E 06              MOV    di, word ptr [bp + 6]        ; DI = dest near-pointer
00FD82  33 C0                 XOR    ax, ax                       ; AL = 0
00FD84  B9 FF FF              MOV    cx, 0xffff                   ; CX = -1
00FD87  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; scan dest for NUL; DI now points just past dest's NUL
00FD89  8D 75 FF              LEA    si, [di - 1]                 ; SI = pointer to dest's NUL — append starts here
00FD8C  8B 7E 08              MOV    di, word ptr [bp + 8]        ; DI = src near-pointer
00FD8F  B9 FF FF              MOV    cx, 0xffff                   ; CX = -1
00FD92  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; scan src; DI now points just past src's NUL
00FD94  F7 D1                 NOT    cx                           ; CX = src_len + 1 (includes NUL)
00FD96  2B F9                 SUB    di, cx                       ; rewind DI to start of src — we'll copy from here
00FD98  87 FE                 XCHG   si, di                       ; swap: SI = src start, DI = dest end (the NUL position)
00FD9A  8B 46 06              MOV    ax, word ptr [bp + 6]        ; AX = original dest pointer (return value)
00FD9D  F7 C6 01 00           TEST   si, 1                        ; src start odd-aligned?
00FDA1  74 02                 JE     0xfda5                       ; if even-aligned, skip the byte-pre-copy
00FDA3  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; copy 1 byte to align SI to a word boundary
00FDA4  49                    DEC    cx                           ; one fewer byte to copy
00FDA5  D1 E9                 SHR    cx, 1                        ; CX = remaining byte count / 2 (= word count)
00FDA7  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; bulk-copy words
00FDA9  13 C9                 ADC    cx, cx                       ; CX = leftover byte (carry from the SHR)
00FDAB  F3 A4                 REP MOVSB byte ptr es:[di], byte ptr [si] ; copy trailing byte if length was odd
00FDAD  8B F3                 MOV    si, bx                       ; restore SI
00FDAF  8B FA                 MOV    di, dx                       ; restore DI
00FDB1  5D                    POP    bp                           ; restore BP
00FDB2  CB                    RETF                                ; far-return: AX = original dest pointer
