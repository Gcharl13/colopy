; ============================================================================
; func_00E454_normalize_far_pointer
; Region   : load_image
; Bytes    : file 0x00E454..0x00E46B  (23 bytes)
; Purpose  : Normalises a far pointer (segment, offset) so the offset is in 0..15 (i.e. shifts the high nibble of offset into the segment). Equivalent to MS C `_makeptr` / `_pmakefp` normalisation. Returns DX:AX where DX = segment + (offset >> 4) and AX = offset & 0xF.
; Args     : [bp+6] = offset, [bp+8] = segment
; Returns  : DX:AX = normalised far pointer (offset in 0..15)
; Callers  : TBD (3 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: 23 bytes; ends with RETF 4 (callee cleans 4 bytes of args). Pattern matches MS C runtime far-pointer normalisation.
; Source   : Pattern: SHR offset by 4, ADD into segment, AND offset with 0xF.
; ============================================================================

00E454  55                    PUSH   bp                           ; standard frame prologue
00E455  8B EC                 MOV    bp, sp                       ; BP = SP
00E457  8B 46 06              MOV    ax, word ptr [bp + 6]        ; AX = offset (input)
00E45A  8B 56 08              MOV    dx, word ptr [bp + 8]        ; DX = segment (input)
00E45D  8B D8                 MOV    bx, ax                       ; BX = offset (working copy)
00E45F  C1 EB 04              SHR    bx, 4                        ; BX = offset / 16 (paragraphs)
00E462  03 D3                 ADD    dx, bx                       ; DX = segment + (offset / 16) — new segment with the high nibble of offset folded in
00E464  25 0F 00              AND    ax, 0xf                      ; AX = offset & 0xF — keep only the low nibble of offset
00E467  C9                    LEAVE                               ; teardown
00E468  CA 04 00              RETF   4                            ; far-return + clean 4 bytes of args; DX:AX = normalised far pointer
