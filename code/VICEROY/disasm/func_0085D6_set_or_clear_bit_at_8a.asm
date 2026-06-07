; ============================================================================
; func_0085D6_set_or_clear_bit_at_8a
; Region   : load_image
; Bytes    : file 0x0085D6..0x00860E  (56 bytes)
;            NOTE: the auto-boundary detector split this into two pieces at
;                  0x8602 (a JE-target past an inline LEAVE/RETF). The full
;                  function covers 0x85D6..0x860D inclusive, a single
;                  set-or-clear-bit operation with two short-circuit tails.
; Purpose  : Sets or clears a bit in the bit-array at *(0x8542)+0x8A. The
;            second arg selects the operation: non-zero → OR-in the bit
;            (set), zero → AND-out the bit (clear). The companion getter
;            is func_0085B2 (test_bit_at_8a).
; Args     : [bp+6] = bit index, [bp+8] = 0 to clear, non-zero to set
; Returns  : (no explicit return — bit-array byte updated in place)
; Callers  : TBD
; Callees  : (none — leaf bit setter)
; Verified : Two LEAVE/RETF tails: 0x8600 (set branch), 0x860B (clear branch).
;            Both compute the same byte address and mask before branching.
; Source   : Pattern: build mask in [bp-4], compute byte-pointer in CX, then
;            branch on operation flag.
; ============================================================================

0085D6  C8 06 00 00           ENTER  6, 0                         ; allocate 6-byte local frame; [bp-4] holds the bit mask
0085DA  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; CL = bit index (low byte)
0085DD  80 E1 07              AND    cl, 7                        ; CL = bit-position within byte (0..7)
0085E0  B8 01 00              MOV    ax, 1                        ; AX = 1
0085E3  D3 E0                 SHL    ax, cl                       ; AX = 1 << cl  (single-bit mask)
0085E5  89 46 FC              MOV    word ptr [bp - 4], ax        ; mask = AX (low byte will be used later)
0085E8  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; CX = bit index (full word)
0085EB  C1 F9 03              SAR    cx, 3                        ; CX = idx >> 3 (byte offset within bit array)
0085EE  03 0E 42 85           ADD    cx, word ptr [0x8542]        ; CX += *(0x8542)  (struct base ptr)
0085F2  81 C1 8A 00           ADD    cx, 0x8a                     ; CX = &struct.bit_array[+0x8A + idx/8]
0085F6  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; operation flag: 0 = clear, !=0 = set
0085FA  74 06                 JE     0x8602                       ; if zero, jump to clear branch
0085FC  8B D9                 MOV    bx, cx                       ; BX = bit-array byte ptr
0085FE  08 07                 OR     byte ptr [bx], al            ; *bx |= mask  (set bit)
008600  C9                    LEAVE                               ; teardown
008601  CB                    RETF                                ; far-return (set branch)
; ----- clear branch (auto-detector mistakenly split here) -----
008602  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; AL = mask (low byte)
008605  F6 D0                 NOT    al                           ; AL = ~mask (clear-mask)
008607  8B D9                 MOV    bx, cx                       ; BX = bit-array byte ptr
008609  20 07                 AND    byte ptr [bx], al            ; *bx &= ~mask  (clear bit)
00860B  C9                    LEAVE                               ; teardown
00860C  CB                    RETF                                ; far-return (clear branch)
00860D  90                    NOP                                 ; padding to 16-bit alignment for next function at 0x860E
