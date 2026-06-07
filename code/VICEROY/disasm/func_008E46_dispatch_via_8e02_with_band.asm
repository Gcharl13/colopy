; ============================================================================
; func_008E46_dispatch_via_8e02_with_band
; Region   : load_image
; Bytes    : file 0x008E46..0x008E83  (61 bytes)
; Purpose  : Dispatcher that wraps `set_commodity_band_at_index` (0x8E02). For an index `i` in the 0..14 range, reads the global per-index WORD at DGROUP:0x8DC8[i] (call it 'global_amount'), applies a special-case adjustment for index 14 (subtracts the word at DGROUP:0x8E66 — apparently the "Ore overflow" used to dampen Tools demand), then calls set_commodity_band_at_index with (idx, midpoint=[bp+8], primary=adjusted_global, delta=struct[+0x9A + idx*2]).
;            The signature 0..14 + special-case-14 + index 14's adjustment word at 0x8E66 (= over_high[idx=6]) very strongly suggests a Colonization commodity index, where 14=Tools and 6=Ore (Ore is consumed to make Tools).
; Args     : [bp+6] = commodity index (0..14), [bp+8] = midpoint (band centre)
; Returns  : (no return — pure side effect via set_commodity_band_at_index)
; Callers  : TBD
; Callees  : set_commodity_band_at_index (0x8E02, near-call)
; Verified : Boundary verified: ENTER 2 / RETF, 61 bytes. The DGROUP addresses 0x8DC8, 0x8E66, 0x8542+0x9A all match cross-references in func_008E02 and func_008F02.
; Source   : Pattern: read-global-word + special-case-14 + invoke-band-setter.
; ============================================================================

008E46  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame (unused; spec for callee)
008E4A  56                    PUSH   si                           ; preserve SI
008E4B  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; BX = commodity index
008E4E  D1 E3                 SHL    bx, 1                        ; BX = index * 2 (word stride)
008E50  8B 87 C8 8D           MOV    ax, word ptr [bx - 0x7238]   ; AX = global_amount[idx] (DGROUP:0x8DC8 + idx*2)
008E54  83 7E 06 0E           CMP    word ptr [bp + 6], 0xe       ; index == 14 (Tools)?
008E58  75 0B                 JNE    0x8e65                       ; not 14 — skip Ore-overflow adjustment
008E5A  83 3E 66 8E 00        CMP    word ptr [0x8e66], 0         ; over_high[6] (Ore overflow) != 0?
008E5F  74 04                 JE     0x8e65                       ; if zero, no adjustment
008E61  2B 06 66 8E           SUB    ax, word ptr [0x8e66]        ; AX -= over_high[6] (Tools amount reduced by surplus Ore)
008E65  8B 76 06              MOV    si, word ptr [bp + 6]        ; SI = index
008E68  D1 E6                 SHL    si, 1                        ; SI = index * 2
008E6A  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr
008E6E  FF B0 9A 00           PUSH   word ptr [bx + si + 0x9a]    ; push delta = struct.word[+0x9A + idx*2]
008E72  FF 76 08              PUSH   word ptr [bp + 8]            ; push midpoint = caller's [bp+8]
008E75  50                    PUSH   ax                           ; push primary = adjusted global_amount
008E76  FF 76 06              PUSH   word ptr [bp + 6]            ; push idx
008E79  0E                    PUSH   cs                           ; push CS for near-CALL
008E7A  E8 85 FF              CALL   0x8e02                       ; near-call set_commodity_band_at_index(idx, midpoint, primary, delta)
008E7D  83 C4 08              ADD    sp, 8                        ; pop 4 args
008E80  5E                    POP    si                           ; restore SI
008E81  C9                    LEAVE                               ; teardown
008E82  CB                    RETF                                ; far-return
