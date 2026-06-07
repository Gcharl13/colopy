; ============================================================================
; func_005CFE_map_tile_read_layer_15C
; Region   : load_image
; Bytes    : file 0x005CFE..0x005D1A  (28 bytes)
; Purpose  : Reads a byte from one of the game's map tile-data layers. Computes byte offset = y * map_width + x, then loads ES = [DGROUP:0x15E] and uses BX = (offset + [DGROUP:0x15C]) to read the tile byte at ES:BX. The far pointer at DGROUP:[0x15C..0x15F] is the base of one of the map's parallel layers (probably the terrain-id layer based on its high call frequency).
; Args     : [bp+6] = x, [bp+8] = y
; Returns  : AL = byte at map_layer[y*map_width + x]
; Callers  : TBD (7 distinct call sites)
; Callees  : (none — leaf, far-pointer read only)
; Verified : Boundary verified: ENTER 4 / LEAVE / RETF, 28 bytes. Map width comes from DGROUP:0x853A (confirmed via is_xy_in_map_bounds).
; Source   : Identified via callgraph (7 callers); map-read pattern with map_width [0x853A] * y + x indexing into a far-pointer-pointed array.
; ============================================================================

005CFE  C8 04 00 00           ENTER  4, 0                         ; allocate 4-byte local frame
005D02  A1 3A 85              MOV    ax, word ptr [0x853a]        ; AX = map_width (DGROUP:0x853A)
005D05  F7 6E 08              IMUL   word ptr [bp + 8]            ; DX:AX = map_width * y  (signed multiply; we only use AX since map fits in 16 bits)
005D08  8B D8                 MOV    bx, ax                       ; BX = y * map_width (offset of row y in linear layer)
005D0A  03 1E 5C 01           ADD    bx, word ptr [0x15c]         ; BX += DGROUP:[0x15C] (offset within the layer's far-pointer base)
005D0E  8E 06 5E 01           MOV    es, word ptr [0x15e]         ; ES = DGROUP:[0x15E] (segment of the layer's far-pointer base)
005D12  03 5E 06              ADD    bx, word ptr [bp + 6]        ; BX += x (final byte offset = base_offset + y*map_width + x)
005D15  26 8A 07              MOV    al, byte ptr es:[bx]         ; AL = layer[y*width + x] — the tile byte
005D18  C9                    LEAVE                               ; teardown frame
005D19  CB                    RETF                                ; far-return: AL = tile byte from this map layer
