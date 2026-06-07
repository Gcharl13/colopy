; ============================================================================
; func_010226_strchr_near
; Region   : load_image
; Bytes    : file 0x010226..0x010250  (42 bytes)
; Purpose  : C `strchr(s, c)` — finds the FIRST occurrence of byte c in string s. First REPNE SCASB finds the string length (so we know the bound for the second scan); the second REPNE SCASB scans forward looking for c. After the find, DEC DI to point at the match, then CMP to distinguish 'found' from 'CX-exhausted'. Returns DI = pointer to first match, or 0 if no match.
; Args     : [bp+6] = string near-pointer, [bp+8] = byte to find (low byte of word)
; Returns  : AX = pointer to first occurrence of byte, or 0 if not found.
; Callers  : TBD (10 distinct call sites)
; Callees  : (none — leaf, REPNE SCASB twice)
; Verified : Boundary verified: PUSH BP / PUSH DI / RETF, 42 bytes.
; Source   : Pattern: dual REPNE SCASB with NEG CX in between is canonical strchr (length-first then scan-with-bound).
; ============================================================================

010226  55                    PUSH   bp                           ; standard frame prologue
010227  8B EC                 MOV    bp, sp                       ; BP = SP
010229  57                    PUSH   di                           ; preserve caller's DI
01022A  8B 7E 06              MOV    di, word ptr [bp + 6]        ; DI = string near-pointer
01022D  1E                    PUSH   ds                           ; ES = DS for SCASB (push DS, pop ES)
01022E  07                    POP    es ; STACK_POP
01022F  8B DF                 MOV    bx, di                       ; BX = saved start of string
010231  33 C0                 XOR    ax, ax                       ; AL = 0 — search for NUL
010233  B9 FF FF              MOV    cx, 0xffff                   ; CX = -1
010236  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; scan to NUL
010238  41                    INC    cx                           ; CX was -strlen-2; now -strlen-1
010239  F7 D9                 NEG    cx                           ; CX = strlen+1 (positive count, includes NUL)
01023B  8A 46 08              MOV    al, byte ptr [bp + 8]        ; AL = byte to find (low byte of the second arg)
01023E  8B FB                 MOV    di, bx                       ; rewind DI to start of string
010240  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; scan up to CX bytes; stops on first match (CX!=0) or end
010242  4F                    DEC    di                           ; back up to the matched byte
010243  38 05                 CMP    byte ptr [di], al            ; verify it's actually a match (not just end-of-scan)
010245  74 02                 JE     0x10249                      ; on real match, jump past the zero-out
010247  33 FF                 XOR    di, di                       ; no match → DI = 0 (return NULL)
010249  8B C7                 MOV    ax, di                       ; AX = match pointer or NULL
01024B  5F                    POP    di                           ; restore caller's DI
01024C  8B E5                 MOV    sp, bp                       ; restore SP from frame
01024E  5D                    POP    bp                           ; restore BP
01024F  CB                    RETF                                ; far-return: AX = pointer to first occurrence of byte, or 0
