; ============================================================================
; func_01037E_memset_near
; Region   : load_image
; Bytes    : file 0x01037E..0x0103AB  (45 bytes)
; Purpose  : C `memset(dest, c, n)` — fills n bytes at near-pointer dest with byte c. Uses REP STOSW with the fill byte broadcast to AH:AL, plus byte-pre/post handling for odd alignment and odd length.
; Args     : [bp+6] = dest near-pointer, [bp+8] = fill byte (low byte of word), [bp+0xA] = byte count
; Returns  : AX = original dest pointer
; Callers  : TBD (8 distinct call sites)
; Callees  : (none — leaf, REP STOSB/W only)
; Verified : Boundary verified: PUSH BP / POP BP / RETF, 45 bytes. Standard memset pattern: align-byte-stosw-tailbyte.
; Source   : Pattern matches MS C runtime memset exactly; called 8x.
; ============================================================================

01037E  55                    PUSH   bp                           ; standard frame prologue
01037F  8B EC                 MOV    bp, sp                       ; BP = SP
010381  8B D7                 MOV    dx, di                       ; preserve caller's DI in DX
010383  8C D8                 MOV    ax, ds                       ; AX = DS
010385  8E C0                 MOV    es, ax                       ; ES = DS for STOS
010387  8B 7E 06              MOV    di, word ptr [bp + 6]        ; DI = dest near-pointer
01038A  8B DF                 MOV    bx, di                       ; BX = saved dest pointer (return value)
01038C  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; CX = byte count
01038F  E3 15                 JCXZ   0x103a6                      ; if count==0, skip the fill
010391  8A 46 08              MOV    al, byte ptr [bp + 8]        ; AL = fill byte
010394  8A E0                 MOV    ah, al                       ; AH = AL — broadcast for word-wide STOSW
010396  F7 C7 01 00           TEST   di, 1                        ; dest odd-aligned?
01039A  74 02                 JE     0x1039e                      ; if even-aligned, skip the byte-pre-fill
01039C  AA                    STOSB  byte ptr es:[di], al         ; pre-fill 1 byte to align DI to a word boundary
01039D  49                    DEC    cx                           ; one fewer byte
01039E  D1 E9                 SHR    cx, 1                        ; CX = remaining_bytes / 2 (word count)
0103A0  F3 AB                 REP STOSW word ptr es:[di], ax         ; bulk-fill words with AX (= AH:AL = byte:byte)
0103A2  13 C9                 ADC    cx, cx                       ; CX = leftover-byte (carry from SHR)
0103A4  F3 AA                 REP STOSB byte ptr es:[di], al         ; fill trailing byte if length was odd
0103A6  8B FA                 MOV    di, dx                       ; restore DI
0103A8  93                    XCHG   bx, ax                       ; AX = original dest pointer (return value), BX = scratch
0103A9  5D                    POP    bp                           ; restore BP
0103AA  CB                    RETF                                ; far-return: AX = original dest pointer
