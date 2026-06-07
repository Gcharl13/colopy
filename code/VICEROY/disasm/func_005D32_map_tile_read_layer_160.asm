; ============================================================================
; func_005D32_map_tile_read_layer_160
; Region   : load_image
; Bytes    : file 0x005D32..0x005D4E  (28 bytes)
; Purpose  : Sister function of map_tile_read_layer_15C — reads from a DIFFERENT map layer. Same indexing scheme (y*map_width + x) but the far pointer base is at DGROUP:[0x160..0x163]. The two layers together form the parallel-array tile-data structure (probably terrain id + terrain features, OR base terrain + overlays).
; Args     : [bp+6] = x, [bp+8] = y
; Returns  : AL = byte at second_map_layer[y*map_width + x]
; Callers  : TBD (5 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: ENTER 4 / LEAVE / RETF, 28 bytes. Identical pattern to 0x5CFE but with [0x160]/[0x162] base.
; Source   : Identified as a sibling of map_tile_read_layer_15C; both are reachable from map-rendering and visibility code.
; ============================================================================

005D32  C8 04 00 00           ENTER  4, 0                         ; allocate 4-byte local frame
005D36  A1 3A 85              MOV    ax, word ptr [0x853a]        ; AX = map_width
005D39  F7 6E 08              IMUL   word ptr [bp + 8]            ; DX:AX = map_width * y
005D3C  8B D8                 MOV    bx, ax                       ; BX = y * map_width
005D3E  03 1E 60 01           ADD    bx, word ptr [0x160]         ; BX += DGROUP:[0x160] (second-layer base offset)
005D42  8E 06 62 01           MOV    es, word ptr [0x162]         ; ES = DGROUP:[0x162] (second-layer base segment)
005D46  03 5E 06              ADD    bx, word ptr [bp + 6]        ; BX += x
005D49  26 8A 07              MOV    al, byte ptr es:[bx]         ; AL = second_layer[y*width + x]
005D4C  C9                    LEAVE                               ; teardown frame
005D4D  CB                    RETF                                ; far-return: AL = tile byte from layer #2
