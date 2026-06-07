; ============================================================================
; func_006672_unit_chain_resolve
; Region   : load_image
; Bytes    : file 0x006672..0x006695  (35 bytes)
; Purpose  : Chain-follow utility for the unit table at DGROUP:0x315E (stride 0x1C = UnitRecord). Walks a 'next-unit' field at offset -2 within each entry (DGROUP:0x315C + index*0x1C): starting from index AX, repeatedly follows the field while the value is non-negative; stops on the first negative value and returns the LAST POSITIVE index. Implements the equivalent of 'find the leader of this unit's chain' — used when units are linked in some equivalence class (probably the cargo / passenger / stack chain). 15 callers.
; Args     : AX = starting unit index (signed)
; Returns  : AX = last positive index in the chain (or input if it was negative or already pointed at a negative).
; Callers  : TBD (15 distinct call sites)
; Callees  : (none — leaf, uses internal loop)
; Verified : Boundary verified: PUSH SI / RETF at 0x6694, 35 bytes.
; Source   : Identified as orphan call target with 15 callers; chain-following pattern over the known UnitRecord stride 0x1C.
; ============================================================================

006672  56                    PUSH   si                           ; preserve SI
006673  8B D8                 MOV    bx, ax                       ; BX = starting unit index (caller's AX)
006675  0B DB                 OR     bx, bx                       ; test sign
006677  7C 18                 JL     0x6691                       ; if start index is negative, skip the chain walk entirely
006679  6B F3 1C              IMUL   si, bx, 0x1c                 ; SI = BX * 0x1C — byte offset into UnitRecord array
00667C  8B 84 5C 31           MOV    ax, word ptr [si + 0x315c]   ; AX = unit_table[BX].chain_field  (DGROUP:0x315C = chain-link field; 2 bytes before unit-table-base 0x315E)
006680  0B C0                 OR     ax, ax                       ; is the next-link index negative (terminator)?
006682  7C 0D                 JL     0x6691                       ; if first hop is negative, return BX (the input)
006684  8B D8                 MOV    bx, ax                       ; BX = current valid index (saved as last-positive)
006686  6B F3 1C              IMUL   si, bx, 0x1c                 ; SI = BX * 0x1C
006689  8B 84 5C 31           MOV    ax, word ptr [si + 0x315c]   ; AX = unit_table[BX].chain_field
00668D  0B C0                 OR     ax, ax                       ; positive?
00668F  7D F3                 JGE    0x6684                       ; if yes, continue walking the chain
006691  8B C3                 MOV    ax, bx                       ; AX = last positive (or original) index
006693  5E                    POP    si                           ; restore SI
006694  CB                    RETF                                ; far-return: AX = root of chain
