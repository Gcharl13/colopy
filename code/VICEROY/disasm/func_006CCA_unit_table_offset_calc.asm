; ============================================================================
; func_006CCA_unit_table_offset_calc
; Region   : load_image
; Bytes    : file 0x006CCA..0x006CD7  (13 bytes)
; Purpose  : Computes unit-table byte offset for index AX: returns BX = AX * 0x1C (28 = sizeof UnitRecord). Used as a shared helper by other unit-accessor functions that handle the array-base addition themselves.
; Args     : [bp+6] = unit index
; Returns  : AX = BX = index * 0x1C
; Callers  : TBD (4 distinct call sites)
; Callees  : (none)
; Verified : Boundary verified: ENTER 4 / falls into IMUL 0x1C — 13 bytes only because next instructions are part of next function; this entry is a tail-call helper.
; Source   : Identified via callgraph; IMUL 0x1C matches UnitRecord stride.
; ============================================================================

006CCA  C8 04 00 00           ENTER  4, 0                         ; allocate 4-byte local frame
006CCE  56                    PUSH   si                           ; preserve SI
006CCF  8B 76 06              MOV    si, word ptr [bp + 6]        ; SI = unit index
006CD2  6B DE 1C              IMUL   bx, si, 0x1c                 ; BX = SI * 0x1C (sizeof UnitRecord)
006CD5  8B C3                 MOV    ax, bx                       ; AX = BX = byte offset into unit table; falls into next function (caller adds the table base)
