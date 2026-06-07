; ============================================================================
; func_008F2A_unpack_nibble_at_60
; Region   : load_image
; Bytes    : file 0x008F2A..0x008F5F  (53 bytes)
; Purpose  : Reads a packed-nibble entry from the byte-array at *(0x8542)+0x60. The array stores 2 nibbles per byte: even-index `i` lives in the low nibble of byte[i/2], odd-index `i` lives in the high nibble. Bound-checked against struct.byte[+0x1F] (the count). On out-of-bounds the function does NOT set AX and falls through past its RETF into the next function — same fast-path / fall-through pattern as is_arg2_negative.
; Args     : [bp+6] = entry index
; Returns  : AX = nibble value (0..15) on success; on out-of-bounds, falls through to 0x8F60 (next function, which probably returns a default).
; Callers  : TBD
; Callees  : (none — leaf nibble unpacker)
; Verified : Boundary verified: ENTER 2 / RETF, 53 bytes. Companion setter is at 0x8F6C (pack_nibble_at_60).
; Source   : Pattern: bound-check + (idx>>1)-byte-fetch + (idx&1)-shift-by-4 + low-nibble-mask.
; ============================================================================

008F2A  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame [bp-2] = result accumulator
008F2E  56                    PUSH   si                           ; preserve SI
008F2F  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr
008F33  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; AL = struct.byte[+0x1F] (the count)
008F36  98                    CWDE                                ; sign-extend AL → AX (count is unsigned, but stored as byte)
008F37  3B 46 06              CMP    ax, word ptr [bp + 6]        ; count vs index
008F3A  7E 24                 JLE    0x8f60                       ; if count <= idx → out of bounds, fall through past RETF
008F3C  8B 76 06              MOV    si, word ptr [bp + 6]        ; SI = idx
008F3F  D1 FE                 SAR    si, 1                        ; SI = idx >> 1 (byte offset within nibble array)
008F41  8A 40 60              MOV    al, byte ptr [bx + si + 0x60] ; AL = struct.byte[+0x60 + idx/2] (packed pair)
008F44  2A E4                 SUB    ah, ah                       ; zero-extend AL → AX
008F46  89 46 FE              MOV    word ptr [bp - 2], ax        ; result = byte (low nibble correct, high nibble may be needed)
008F49  F6 46 06 01           TEST   byte ptr [bp + 6], 1         ; idx & 1?
008F4D  74 06                 JE     0x8f55                       ; even idx → low nibble already in result
008F4F  C1 F8 04              SAR    ax, 4                        ; odd idx → AX = byte >> 4 (high nibble in low position)
008F52  89 46 FE              MOV    word ptr [bp - 2], ax        ; result = high nibble
008F55  83 66 FE 0F           AND    word ptr [bp - 2], 0xf       ; mask to 4 bits — discard sign-extension and any stray top bits
008F59  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; AX = nibble (0..15)
008F5C  5E                    POP    si                           ; restore SI
008F5D  C9                    LEAVE                               ; teardown
008F5E  CB                    RETF                                ; far-return: AX = nibble value
