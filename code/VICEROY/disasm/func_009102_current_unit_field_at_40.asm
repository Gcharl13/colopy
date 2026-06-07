; ============================================================================
; func_009102_current_unit_field_at_40
; Region   : load_image
; Bytes    : file 0x009102..0x00911F  (29 bytes)
; Purpose  : Sister of current_unit_field_at_20 — reads from offset +0x40 instead of +0x20 within the same struct at *(0x8542). Same bound-check (count at +0x1F).
; Args     : [bp+6] = sub-index into the per-unit array at offset +0x40
; Returns  : AX = byte at unit_struct[+0x40 + index]
; Callers  : TBD (6 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: ENTER 2 / LEAVE / RETF, 29 bytes — identical layout to 0x90C8.
; Source   : Sibling of 0x90C8 reading a different sub-array within the same parent struct.
; ============================================================================

009102  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame
009106  56                    PUSH   si                           ; preserve SI
009107  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr (sister of 0x90C8)
00910B  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; AL = struct count byte
00910E  98                    CWDE                                ; sign-extend
00910F  3B 46 06              CMP    ax, word ptr [bp + 6]        ; count vs index
009112  7E 0C                 JLE    0x9120                       ; if out of range, return count
009114  8B 76 06              MOV    si, word ptr [bp + 6]        ; SI = index
009117  8A 40 40              MOV    al, byte ptr [bx + si + 0x40] ; AL = struct.array_at_40[index]  (different sub-array than 0x90C8)
00911A  2A E4                 SUB    ah, ah                       ; zero-extend
00911C  5E                    POP    si                           ; restore SI
00911D  C9                    LEAVE                               ; teardown
00911E  CB                    RETF                                ; far-return: AX = element value
