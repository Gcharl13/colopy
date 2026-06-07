; ============================================================================
; func_008918_blit_at_origin_if_pair_visible
; Region   : load_image
; Bytes    : file 0x008918..0x008956  (62 bytes)
; Purpose  : Conditional blit: looks up (key1, key2) in the 20-entry C8/DE pair table via `find_pair_in_table_C8_DE` (0x8892). If the pair is registered, translates (key1, key2) by the current-context origin (struct.byte[+0] - 2, struct.byte[+1] - 2) and dispatches to the far drawing routine at 0x37F:0x15E with (adj_key1, adj_key2, 0x10, arg3). The find_pair return value is used purely as a "is this pair visible?" predicate — the match index itself is discarded.
; Args     : [bp+6] = key1 (e.g. screen-cell column), [bp+8] = key2 (e.g. screen-cell row), [bp+0xA] = arg3 (passed through to drawer)
; Returns  : (caller likely ignores AX; LCALL's return is left in AX after the ADD SP)
; Callers  : 0x008B8C (within func_008982) at the 'no entry / clear-and-draw' tail
; Callees  : find_pair_in_table_C8_DE (0x8892), far drawer at 0x37F:0x15E (overlay-resident)
; Verified : Boundary verified: ENTER 2 / RETF, 62 bytes. Uses *(0x8542)+0 and *(0x8542)+1 as origin bytes.
; Source   : Pattern matches a "draw if registered" gate — find_pair as predicate, then translate-and-dispatch.
; ============================================================================

008918  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame (unused; spec for callee)
00891C  FF 76 08              PUSH   word ptr [bp + 8]            ; push key2
00891F  FF 76 06              PUSH   word ptr [bp + 6]            ; push key1
008922  0E                    PUSH   cs                           ; push CS for near-CALL
008923  E8 6C FF              CALL   0x8892                       ; near-call find_pair_in_table_C8_DE → AX = match_idx or -1
008926  83 C4 04              ADD    sp, 4                        ; pop key1, key2 from stack
008929  0B C0                 OR     ax, ax                       ; test return value
00892B  7C 27                 JL     0x8954                       ; if AX < 0 (no match), skip directly to LEAVE
00892D  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; push arg3 (drawer parameter)
008930  6A 10                 PUSH   0x10                         ; push 0x10 (drawer parameter — likely sprite-id or flag)
008932  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr
008936  8A 47 01              MOV    al, byte ptr [bx + 1]        ; AL = struct.byte[+1] (origin Y, 1-based)
008939  2A E4                 SUB    ah, ah                       ; zero-extend AL → AX
00893B  48                    DEC    ax                           ; AX -= 1
00893C  48                    DEC    ax                           ; AX -= 1 (total: -2 → 0-based interior origin)
00893D  01 46 08              ADD    word ptr [bp + 8], ax        ; key2 += (struct.origin_y - 2)
008940  FF 76 08              PUSH   word ptr [bp + 8]            ; push translated key2
008943  8A 07                 MOV    al, byte ptr [bx]            ; AL = struct.byte[+0] (origin X, 1-based)
008945  2A E4                 SUB    ah, ah                       ; zero-extend AL → AX
008947  48                    DEC    ax                           ; -1
008948  48                    DEC    ax                           ; -2 (0-based interior origin)
008949  01 46 06              ADD    word ptr [bp + 6], ax        ; key1 += (struct.origin_x - 2)
00894C  FF 76 06              PUSH   word ptr [bp + 6]            ; push translated key1
00894F  9A 5E 01 7F 03        LCALL  0x37f, 0x15e                 ; far-call drawer(adj_key1, adj_key2, 0x10, arg3) — overlay-resident
008954  C9                    LEAVE                               ; teardown (note: SP=4 args still on stack — caller cleans up)
008955  CB                    RETF                                ; far-return
