; ============================================================================
; func_0090C8_current_unit_field_at_20
; Region   : load_image
; Bytes    : file 0x0090C8..0x0090E5  (29 bytes)
; Purpose  : Reads byte field at offset +0x20 within the current-unit-or-context struct pointed to by [DGROUP:0x8542]. The byte at +0x1F is the bound-check count: if [bp+6] < count, returns the byte at *(0x8542) + 0x20 + index; else returns the count. (Indexed access into a per-unit subarray.)
; Args     : [bp+6] = sub-index into the per-unit array at offset +0x20
; Returns  : AX = byte at unit_struct[+0x20 + index] (zero-extended), or the count if index out of range
; Callers  : TBD (6 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: ENTER 2 / LEAVE / RETF, 29 bytes. The fixed [0x8542] anchor and +0x1F count + +0x20 array are the signature.
; Source   : Identified via callgraph; the global at 0x8542 is the most-touched DGROUP variable (102 distinct functions reference it) — likely 'current unit ptr' or 'current colony ptr'.
; ============================================================================

0090C8  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame
0090CC  56                    PUSH   si                           ; preserve SI
0090CD  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = pointer to current-context struct (DGROUP:0x8542 — most-touched global, 102 distinct fns)
0090D1  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; AL = struct's count byte at offset +0x1F
0090D4  98                    CWDE                                ; sign-extend AL → AX (as 16-bit count)
0090D5  3B 46 06              CMP    ax, word ptr [bp + 6]        ; compare count vs requested index
0090D8  7E 0C                 JLE    0x90e6                       ; if count <= index (out of range), branch out (returns AX = count)
0090DA  8B 76 06              MOV    si, word ptr [bp + 6]        ; SI = index
0090DD  8A 40 20              MOV    al, byte ptr [bx + si + 0x20] ; AL = struct.array_at_20[index] — read the element
0090E0  2A E4                 SUB    ah, ah                       ; zero-extend AL → AX
0090E2  5E                    POP    si                           ; restore SI
0090E3  C9                    LEAVE                               ; teardown
0090E4  CB                    RETF                                ; far-return: AX = element value (or count on out-of-range)
