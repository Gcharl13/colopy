; ============================================================================
; func_008956_lookup_byte_from_pair
; Region   : load_image
; Bytes    : file 0x008956..0x008982  (44 bytes)
; Purpose  : Given (key1, key2), looks up the matching entry via `find_pair_in_table_C8_DE` (0x8892). On a successful match, indexes the 'current-context' struct *(0x8542) at offset +0x70 + match_index to retrieve a byte value. Returns the byte, or -1 if no match was found.
; Args     : [bp+6] = first key, [bp+8] = second key
; Returns  : AX = byte at *(0x8542)[+0x70 + match_index] or -1
; Callers  : TBD (4 distinct call sites)
; Callees  : find_pair_in_table_C8_DE (0x8892)
; Verified : Boundary verified: ENTER 4 / RETF, 44 bytes. Branches on the AX < 0 (no-match) signal from the pair-finder.
; Source   : Pattern matches a 'lookup-by-coordinate' utility built on top of 0x8892.
; ============================================================================

008956  C8 04 00 00           ENTER  4, 0                         ; allocate 4-byte local frame
00895A  56                    PUSH   si                           ; preserve SI
00895B  C6 46 FE FF           MOV    byte ptr [bp - 2], 0xff      ; result = 0xFF (= -1 byte sentinel for "not found")
00895F  FF 76 08              PUSH   word ptr [bp + 8]            ; push key2
008962  FF 76 06              PUSH   word ptr [bp + 6]            ; push key1
008965  0E                    PUSH   cs                           ; push CS for near-CALL
008966  E8 29 FF              CALL   0x8892                       ; near-call find_pair_in_table_C8_DE → AX = match index or -1
008969  83 C4 04              ADD    sp, 4                        ; pop key1, key2 from stack
00896C  0B C0                 OR     ax, ax                       ; test return value
00896E  7C 0C                 JL     0x897c                       ; if AX < 0 (no match), skip the lookup
008970  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr
008974  8B F0                 MOV    si, ax                       ; SI = match index
008976  8A 40 70              MOV    al, byte ptr [bx + si + 0x70] ; AL = struct.array_at_70[match_index]
008979  88 46 FE              MOV    byte ptr [bp - 2], al        ; result = AL
00897C  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; AL = result (or 0xFF if no match)
00897F  5E                    POP    si                           ; restore SI
008980  C9                    LEAVE                               ; teardown
008981  CB                    RETF                                ; far-return: AL = byte from struct or 0xFF
