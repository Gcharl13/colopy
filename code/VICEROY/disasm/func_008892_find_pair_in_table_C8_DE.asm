; ============================================================================
; func_008892_find_pair_in_table_C8_DE
; Region   : load_image
; Bytes    : file 0x008892..0x0088D0  (62 bytes)
; Purpose  : Searches two parallel 20-byte tables at DGROUP:0xC8 and DGROUP:0xDE for an entry matching ([bp+6]-2, [bp+8]-2). Iterates 0..0x13 (20 entries), checking byte at [bx+0xC8] == [bp+6]-2 AND byte at [bx+0xDE] == [bp+8]-2. Returns the matching index (signed), or -1 if no match. The -2 offsets suggest the input is in 1-based screen-coordinate space and the tables are in 0-based internal space (or the tables index a smaller region than the screen).
; Args     : [bp+6] = first key (e.g. screen x), [bp+8] = second key (e.g. screen y)
; Returns  : AX = matching index (0..0x13), or -1 if no match.
; Callers  : TBD (4 distinct call sites)
; Callees  : (none — leaf, two-byte table search)
; Verified : Boundary verified: ENTER 4 / LEAVE / RETF, 62 bytes.
; Source   : Pattern: linear scan of 20 entries comparing two parallel byte fields.
; ============================================================================

008892  C8 04 00 00           ENTER  4, 0                         ; allocate 4-byte local frame: [bp-2]=found_index, [bp-4]=loop_counter
008896  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; found_index = -1 (no match)
00889B  83 6E 06 02           SUB    word ptr [bp + 6], 2         ; arg1 -= 2 (key1 → table-relative)
00889F  83 6E 08 02           SUB    word ptr [bp + 8], 2         ; arg2 -= 2 (key2 → table-relative)
0088A3  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; loop_counter = 0
0088A8  EB 03                 JMP    0x88ad                       ; jump to loop test
; ----- loop body: increment counter -----
0088AA  FF 46 FC              INC    word ptr [bp - 4]            ; counter++
; ----- loop test: counter < 0x14 (20) -----
0088AD  83 7E FC 14           CMP    word ptr [bp - 4], 0x14      ; counter >= 20?
0088B1  7D 18                 JGE    0x88cb                       ; if so, loop done — return found_index (-1 if no match)
; ----- check entry [bx]: bytes at +0xC8 and +0xDE must both match -----
0088B3  8A 46 06              MOV    al, byte ptr [bp + 6]        ; AL = key1 (low byte)
0088B6  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; BX = counter = entry index
0088B9  38 87 C8 00           CMP    byte ptr [bx + 0xc8], al     ; table_C8[counter] == key1?
0088BD  75 EB                 JNE    0x88aa                       ; mismatch → next entry
0088BF  8A 46 08              MOV    al, byte ptr [bp + 8]        ; AL = key2 (low byte)
0088C2  38 87 DE 00           CMP    byte ptr [bx + 0xde], al     ; table_DE[counter] == key2?
0088C6  75 E2                 JNE    0x88aa                       ; mismatch → next entry
; ----- both match: record the index and exit -----
0088C8  89 5E FE              MOV    word ptr [bp - 2], bx        ; found_index = counter
0088CB  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; AX = found_index (or -1)
0088CE  C9                    LEAVE                               ; teardown
0088CF  CB                    RETF                                ; far-return: AX = matching index, or -1 if not found
