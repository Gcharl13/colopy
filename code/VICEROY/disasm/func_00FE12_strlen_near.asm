; ============================================================================
; func_00FE12_strlen_near
; Region   : load_image
; Bytes    : file 0x00FE12..0x00FE2D  (27 bytes)
; Purpose  : C `strlen(s)` — single near-pointer argument. Locates the NUL terminator with REPNE SCASB, returns the byte count not including the terminator. AX = length.
; Args     : [bp+6] = string near-pointer
; Returns  : AX = strlen(s)
; Callers  : TBD (9 distinct call sites)
; Callees  : (none — leaf, REPNE SCASB only)
; Verified : Boundary verified: PUSH BP / RETF, 27 bytes. Standard REPNE SCASB / NOT CX / DEC CX / XCHG AX,CX pattern.
; Source   : Pattern matches MS C runtime strlen exactly.
; ============================================================================

00FE12  55                    PUSH   bp                           ; standard frame prologue
00FE13  8B EC                 MOV    bp, sp                       ; BP = SP
00FE15  8B D7                 MOV    dx, di                       ; preserve caller's DI in DX
00FE17  8C D8                 MOV    ax, ds                       ; AX = DS
00FE19  8E C0                 MOV    es, ax                       ; ES = DS for REPNE SCASB
00FE1B  8B 7E 06              MOV    di, word ptr [bp + 6]        ; DI = string near-pointer
00FE1E  33 C0                 XOR    ax, ax                       ; AL = 0 — search for NUL terminator
00FE20  B9 FF FF              MOV    cx, 0xffff                   ; CX = -1 (max possible decrement-count)
00FE23  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; scan ES:DI byte-by-byte until 0 found
00FE25  F7 D1                 NOT    cx                           ; CX = number_scanned + 1 (includes terminator)
00FE27  49                    DEC    cx                           ; CX = strlen (excludes terminator)
00FE28  91                    XCHG   cx, ax                       ; AX = strlen (return value)
00FE29  8B FA                 MOV    di, dx                       ; restore caller's DI
00FE2B  5D                    POP    bp                           ; restore BP
00FE2C  CB                    RETF                                ; far-return: AX = strlen(string)
