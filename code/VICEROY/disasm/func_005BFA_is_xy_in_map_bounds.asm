; ============================================================================
; func_005BFA_is_xy_in_map_bounds
; Region   : load_image
; Bytes    : file 0x005BFA..0x005C2B  (49 bytes)
; Purpose  : Returns 1 if a 2D map coordinate (x,y) is strictly inside the playable map area (1 <= x < map_width-1 AND 1 <= y < map_height-1), 0 otherwise. The map dimensions are read from DGROUP:0x853A (width) and DGROUP:0x853C (height). Used by movement-validation, sight-radius, and rendering code to test whether to read a tile.
; Args     : [bp+6] = x, [bp+8] = y (16-bit signed)
; Returns  : AX = 1 if in-bounds, 0 otherwise. Local at [bp-2] is the working flag.
; Callers  : TBD (24 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: ENTER prologue at 0x5BFA, LEAVE/RETF at 0x5C29-0x5C2A. 49 bytes. Compares x<map_width-1 and y<map_height-1.
; Source   : Identified via callgraph (24 callers); verified by inspecting the comparison sequence.
; ============================================================================

005BFA  C8 02 00 00           ENTER  2, 0                         ; Borland prologue: allocate 2-byte local frame
005BFE  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; result = 1 (assume in-bounds)
005C03  83 7E 06 01           CMP    word ptr [bp + 6], 1         ; x >= 1 ?
005C07  7C 18                 JL     0x5c21                       ; if x < 1, jump to "out of bounds"
005C09  83 7E 08 01           CMP    word ptr [bp + 8], 1         ; y >= 1 ?
005C0D  7C 12                 JL     0x5c21                       ; if y < 1, jump to "out of bounds"
005C0F  A1 3A 85              MOV    ax, word ptr [0x853a]        ; AX = map_width (DGROUP:0x853A — confirmed game-state global)
005C12  48                    DEC    ax                           ; AX = map_width - 1
005C13  3B 46 06              CMP    ax, word ptr [bp + 6]        ; (map_width - 1) - x ?
005C16  7E 09                 JLE    0x5c21                       ; if (map_width-1) <= x → x is at/past the right edge → out of bounds
005C18  A1 3C 85              MOV    ax, word ptr [0x853c]        ; AX = map_height (DGROUP:0x853C)
005C1B  48                    DEC    ax                           ; AX = map_height - 1
005C1C  3B 46 08              CMP    ax, word ptr [bp + 8]        ; (map_height - 1) - y ?
005C1F  7F 05                 JG     0x5c26                       ; if (map_height-1) > y → strictly inside → keep result=1
005C21  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; out-of-bounds path: result = 0
005C26  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; AX = result
005C29  C9                    LEAVE                               ; teardown frame
005C2A  CB                    RETF                                ; far-return: AX = 1 if (1 <= x < map_width-1 && 1 <= y < map_height-1) else 0
