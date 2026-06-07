; ============================================================================
; func_008F6C_pack_nibble_at_60
; Region   : load_image
; Bytes    : file 0x008F6C..0x008FB4  (72 bytes)
; Purpose  : Setter companion to `unpack_nibble_at_60` (0x8F2A). Writes a 4-bit value into the packed-nibble array at *(0x8542)+0x60. Even-index `i` is stored in the low nibble of byte[i/2]; odd-index in the high nibble. The value is clamped to 0..15 first. Bound-checked against struct.byte[+0x1F] — out-of-bounds is a silent no-op.
; Args     : [bp+6] = entry index, [bp+8] = nibble value (will be clamped to 0..15)
; Returns  : (no explicit return value — the array byte is updated in place)
; Callers  : TBD
; Callees  : (none — leaf nibble packer)
; Verified : Boundary verified: ENTER 2 / RETF, 72 bytes. Mask constants 0xF0 (clear low) and 0x0F (clear high) match the unpacker's high/low nibble convention.
; Source   : Pattern: bound-check + clamp + (idx&1)-mask-select + AND-OR-store.
; ============================================================================

008F6C  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame [bp-2] = mask register
008F70  56                    PUSH   si                           ; preserve SI
008F71  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr
008F75  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; AL = struct.byte[+0x1F] (the count)
008F78  98                    CWDE                                ; AL → AX
008F79  3B 46 06              CMP    ax, word ptr [bp + 6]        ; count vs index
008F7C  7E 33                 JLE    0x8fb1                       ; if count <= idx → out of bounds, skip write
008F7E  C7 46 FE F0 00        MOV    word ptr [bp - 2], 0xf0      ; mask = 0xF0 (default: clear low nibble for even-idx write)
008F83  8B 46 08              MOV    ax, word ptr [bp + 8]        ; AX = value
008F86  3D 0F 00              CMP    ax, 0xf                      ; value > 15?
008F89  7E 03                 JLE    0x8f8e                       ; if <= 15, no clamp
008F8B  B8 0F 00              MOV    ax, 0xf                      ; clamp value to 15
008F8E  89 46 08              MOV    word ptr [bp + 8], ax        ; write back clamped value
008F91  F6 46 06 01           TEST   byte ptr [bp + 6], 1         ; idx & 1?
008F95  74 09                 JE     0x8fa0                       ; even idx → keep mask=0xF0, value stays as low nibble
008F97  C7 46 FE 0F 00        MOV    word ptr [bp - 2], 0xf       ; odd idx → mask = 0x0F (clear high nibble)
008F9C  C1 66 08 04           SHL    word ptr [bp + 8], 4         ; shift value into high nibble
008FA0  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; AL = mask (0xF0 even / 0x0F odd)
008FA3  8B 76 06              MOV    si, word ptr [bp + 6]        ; SI = idx
008FA6  D1 FE                 SAR    si, 1                        ; SI = idx >> 1 (byte offset)
008FA8  20 40 60              AND    byte ptr [bx + si + 0x60], al ; clear the target nibble of byte[+0x60+idx/2]
008FAB  8A 46 08              MOV    al, byte ptr [bp + 8]        ; AL = shifted/clamped value
008FAE  08 40 60              OR     byte ptr [bx + si + 0x60], al ; set the target nibble
008FB1  5E                    POP    si                           ; restore SI
008FB2  C9                    LEAVE                               ; teardown
008FB3  CB                    RETF                                ; far-return
