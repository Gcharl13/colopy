; ============================================================================
; func_008E02_set_commodity_band_at_index
; Region   : load_image
; Bytes    : file 0x008E02..0x008E45  (68 bytes)
; Purpose  : Updates three parallel WORD arrays in DGROUP for a given index.
;              base_table[idx]  = primary    (DGROUP:0x8E0A — 20 words / 40 bytes)
;              over_low[idx]    = max(0, primary - midpoint)        (DGROUP:0x8E32)
;              over_high[idx]   = max(0, midpoint - (primary - delta))  (DGROUP:0x8E5A)
;            The triple is the classic "amount, headroom-above, headroom-below" pattern. Used by func_008E46 and func_008F02 for what looks like Europe-market commodity tracking (where the index 0..14 is the commodity number — Tools at 14 has a separate adjustment via the Ore-overflow word at 0x8E66).
; Args     : [bp+6] = index (0..14, commodity slot), [bp+8] = midpoint (band centre), [bp+0xA] = primary value, [bp+0xC] = delta (drift / window)
; Returns  : (no explicit return value — three table slots are updated)
; Callers  : TBD (callgraph pending)
; Callees  : (none — leaf table writer)
; Verified : Boundary verified: PUSH BP/MOV BP,SP / LEAVE / RETF, 68 bytes. The three table addresses (0x8E0A, 0x8E32, 0x8E5A) match the read-sites in func_008E46 and func_008F02.
; Source   : Pattern: triple-write to three parallel arrays at constant DGROUP offsets, with conditional "max(0, ...)" on each overflow.
; ============================================================================

008E02  55                    PUSH   bp                           ; standard frame prologue
008E03  8B EC                 MOV    bp, sp                       ; BP = SP
008E05  2B C0                 SUB    ax, ax                       ; AX = 0 (preset zero — both overflows default to 0)
008E07  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; BX = index
008E0A  D1 E3                 SHL    bx, 1                        ; BX = index * 2 (word stride)
008E0C  89 87 32 8E           MOV    word ptr [bx - 0x71ce], ax   ; over_low[idx] = 0  (DGROUP:0x8E32 + idx*2)
008E10  89 87 5A 8E           MOV    word ptr [bx - 0x71a6], ax   ; over_high[idx] = 0 (DGROUP:0x8E5A + idx*2)
008E14  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; AX = primary
008E17  89 87 0A 8E           MOV    word ptr [bx - 0x71f6], ax   ; base_table[idx] = primary (DGROUP:0x8E0A + idx*2)
008E1B  3B 46 08              CMP    ax, word ptr [bp + 8]        ; primary vs midpoint
008E1E  7E 07                 JLE    0x8e27                       ; if primary <= midpoint, skip over_low write (stays 0)
008E20  2B 46 08              SUB    ax, word ptr [bp + 8]        ; AX = primary - midpoint (positive)
008E23  89 87 32 8E           MOV    word ptr [bx - 0x71ce], ax   ; over_low[idx] = primary - midpoint (excess above band centre)
008E27  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; AX = delta
008E2A  03 46 08              ADD    ax, word ptr [bp + 8]        ; AX = midpoint + delta
008E2D  3B 46 0A              CMP    ax, word ptr [bp + 0xa]      ; midpoint+delta vs primary
008E30  7D 12                 JGE    0x8e44                       ; if midpoint+delta >= primary, skip over_high (stays 0)
008E32  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; AX = primary
008E35  2B 46 0C              SUB    ax, word ptr [bp + 0xc]      ; AX = primary - delta
008E38  2B 46 08              SUB    ax, word ptr [bp + 8]        ; AX = primary - delta - midpoint (positive when underflow exceeds delta)
008E3B  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; BX = index (reload — was clobbered above? actually no, but defensive)
008E3E  D1 E3                 SHL    bx, 1                        ; BX = index * 2
008E40  89 87 5A 8E           MOV    word ptr [bx - 0x71a6], ax   ; over_high[idx] = primary - delta - midpoint
008E44  C9                    LEAVE                               ; teardown
008E45  CB                    RETF                                ; far-return
