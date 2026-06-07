; ============================================================================
; func_0066BA_unit_field_lookup_simple
; Region   : load_image
; Bytes    : file 0x0066BA..0x0066CC  (18 bytes)
; Purpose  : Reads a 16-bit field from the unit table. Stride is 0x1C (28 bytes — the well-known UnitRecord size from FUNCTIONS_INVENTORY.md). Index AX (signed 16-bit); on negative input returns AX unchanged (caller convention for 'no unit'). On nonnegative input returns the word at DGROUP:[0x315E + AX*0x1C], which is field +0 of UnitRecord[AX]. Called 18 times — the most-called custom utility function in the load image.
; Args     : AX = unit index (signed 16-bit; negative = sentinel)
; Returns  : AX = unit_table[index].field_0  (or input AX if index<0)
; Callers  : TBD (18 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: PUSH SI / RETF, 18 bytes. Stride 0x1C matches the established UnitRecord size.
; Source   : Identified as orphan call target with 18 callers; structure matches known unit-table accessor pattern.
; ============================================================================

0066BA  56                    PUSH   si                           ; preserve SI across the call
0066BB  8B D8                 MOV    bx, ax                       ; BX = unit index from caller (in AX)
0066BD  0B DB                 OR     bx, bx                       ; test sign / zero
0066BF  7C 07                 JL     0x66c8                       ; if BX < 0, skip the table lookup (return input as-is — sentinel)
0066C1  6B F3 1C              IMUL   si, bx, 0x1c                 ; SI = BX * 0x1C — byte offset into UnitRecord array (stride = 28 bytes = sizeof UnitRecord)
0066C4  8B 9C 5E 31           MOV    bx, word ptr [si + 0x315e]   ; BX = unit_table[index].field_0  (DGROUP:0x315E = unit_table base, field +0)
0066C8  8B C3                 MOV    ax, bx                       ; AX = the result word
0066CA  5E                    POP    si                           ; restore SI
0066CB  CB                    RETF                                ; far-return AX = field-0 of UnitRecord[index]
