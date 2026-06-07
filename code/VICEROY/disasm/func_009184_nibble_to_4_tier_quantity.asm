; ============================================================================
; func_009184_nibble_to_4_tier_quantity
; Region   : load_image
; Bytes    : file 0x009184..0x0091CC  (72 bytes)
;            NOTE: the auto-boundary detector split this into FOUR pieces
;                  (each branch returns from a separate inline LEAVE/RETF and
;                  the JL falls past it). The full function covers 0x9184..0x91CB.
; Purpose  : Reads a packed-nibble entry via `unpack_nibble_at_60` (0x8F2A) at
;            the given index, then maps the 0..15 nibble into a 0..3 four-tier
;            category:
;                nibble == 0xF  → 3  (max / full)
;                nibble >= 8    → 2  (large)
;                nibble >= 4    → 1  (medium)
;                else           → 0  (small / empty)
;            Likely a "stockpile / occupancy / level" bucket — converting raw
;            packed quantity into a UI-friendly 4-state category (e.g. for
;            colony stock display, building state, or occupancy bar).
; Args     : [bp+6] = entry index (passed straight through to unpack_nibble_at_60)
; Returns  : AX = 0..3 category
; Callers  : TBD
; Callees  : unpack_nibble_at_60 (0x8F2A near-call)
; Verified : Four LEAVE/RETF tails: 0x919F (=3), 0x91AF (=2), 0x91BF (=1),
;            0x91CA (=0). Each branch tests a power-of-2 threshold (0xF, 8, 4).
; Source   : Pattern: nibble fetch + cascading "JL → return constant" tiers.
; ============================================================================

009184  C8 04 00 00           ENTER  4, 0                         ; allocate 4-byte local frame; [bp-4] holds the result
009188  FF 76 06              PUSH   word ptr [bp + 6]            ; push index
00918B  0E                    PUSH   cs                           ; push CS for near-CALL
00918C  E8 9B FD              CALL   0x8f2a                       ; near-call unpack_nibble_at_60(idx) → AX = nibble (0..15)
00918F  83 C4 02              ADD    sp, 2                        ; pop arg
009192  3D 0F 00              CMP    ax, 0xf                      ; nibble == 15 (full)?
009195  7C 0B                 JL     0x91a2                       ; if < 15, fall through to next tier
009197  C7 46 FC 03 00        MOV    word ptr [bp - 4], 3         ; tier 3 (full)
00919C  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; AX = result
00919F  C9                    LEAVE                               ; teardown
0091A0  CB                    RETF                                ; far-return: AX=3
0091A1  90                    NOP                                 ; padding (auto-detector split here)
; ----- tier 2 branch -----
0091A2  3D 08 00              CMP    ax, 8                        ; nibble >= 8?
0091A5  7C 0B                 JL     0x91b2                       ; if < 8, fall through
0091A7  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2         ; tier 2 (large)
0091AC  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; AX = result
0091AF  C9                    LEAVE                               ; teardown
0091B0  CB                    RETF                                ; far-return: AX=2
0091B1  90                    NOP                                 ; padding
; ----- tier 1 branch -----
0091B2  3D 04 00              CMP    ax, 4                        ; nibble >= 4?
0091B5  7C 0B                 JL     0x91c2                       ; if < 4, fall through to tier 0
0091B7  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; tier 1 (medium)
0091BC  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; AX = result
0091BF  C9                    LEAVE                               ; teardown
0091C0  CB                    RETF                                ; far-return: AX=1
0091C1  90                    NOP                                 ; padding
; ----- tier 0 branch -----
0091C2  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; tier 0 (small/empty)
0091C7  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; AX = result
0091CA  C9                    LEAVE                               ; teardown
0091CB  CB                    RETF                                ; far-return: AX=0
