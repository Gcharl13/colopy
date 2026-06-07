; ============================================================================
; func_0305A8 — market_accumulate_price_drift  (BYTE_VERIFIED 2026-05-03)
; ----------------------------------------------------------------------------
; Per-commodity per-power price-drift accumulator. For each commodity index,
; reads the per-power base price from [DGROUP:0x53EA] (stride 2 bytes per
; commodity) and accumulates 4 player-power deltas from the market state
; table at [DGROUP:0x8904] (stride 0x4F * 4 = 79*4 = 316 bytes per row).
;
; Inputs:
;   [DGROUP:0x53EA + 2*commodity]      base price word per commodity
;   [DGROUP:0x8904 + power*0x4F + ...] market state table, accessed via
;                                       [bx - 0x76FC] near-pointer addressing
;
; Locals:
;   [bp-0x5E] commodity_idx (16-bit, init=0; loop unbounded — caller passes a
;             non-zero exit condition or the function only handles 1 commodity)
;   [bp-0x54] power_idx (loops 0..3 — the 4 European powers)
;   [bp+si-0x4C..bp+si-0x4A] 32-bit accumulator per commodity (high+low word)
;
; The accumulation does signed long add: ax/dx are loaded from the market
; state table; if dx<0 (negative), zero them (clamp negatives to zero);
; then `ADD/ADC [bp+si-0x4C], ax/dx` accumulates into the per-commodity
; running total.
;
; Region   : overlay
; Bytes    : file 0x0305A8..0x0305FF  (87 bytes)
; Status   : BYTE_VERIFIED
; ============================================================================

0305A8  C8 66 00 00           ENTER  0x66, 0                       ; reserve 102-byte stack frame
0305AC  57                    PUSH   di                            ; preserve di
0305AD  56                    PUSH   si                            ; preserve si
0305AE  C7 46 A2 00 00        MOV    word ptr [bp - 0x5e], 0       ; commodity_idx = 0
0305B3  8B 5E A2              MOV    bx, word ptr [bp - 0x5e]      ; bx = commodity_idx
0305B6  D1 E3                 SHL    bx, 1                         ; bx *= 2 (word stride)
0305B8  8B 87 EA 53           MOV    ax, word ptr [bx + 0x53ea]    ; ax = g_base_prices[commodity]
0305BC  99                    CDQ                                  ; sign-extend ax into dx:ax
0305BD  8B 76 A2              MOV    si, word ptr [bp - 0x5e]      ; si = commodity_idx
0305C0  C1 E6 02              SHL    si, 2                         ; si *= 4 (32-bit accumulator stride)
0305C3  89 42 B4              MOV    word ptr [bp + si - 0x4c], ax ; accum.lo = base price
0305C6  89 52 B6              MOV    word ptr [bp + si - 0x4a], dx ; accum.hi = sign-extended
0305C9  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0       ; power_idx = 0
0305CE  6B 5E AC 4F           IMUL   bx, word ptr [bp - 0x54], 0x4f ; bx = power_idx * 79
0305D2  03 5E A2              ADD    bx, word ptr [bp - 0x5e]      ; bx += commodity_idx
0305D5  C1 E3 02              SHL    bx, 2                         ; bx *= 4 (32-bit cell stride)
0305D8  8B 87 04 89           MOV    ax, word ptr [bx - 0x76fc]    ; ax = market[power][commodity].lo
0305DC  8B 97 06 89           MOV    dx, word ptr [bx - 0x76fa]    ; dx = market[power][commodity].hi
0305E0  0B D2                 OR     dx, dx                        ; test dx sign
0305E2  7F 06                 JG     0x305ea                       ; if positive, keep
0305E4  7D 04                 JGE    0x305ea                       ; if zero, keep
0305E6  2B D2                 SUB    dx, dx                        ; clamp negative dx to 0
0305E8  2B C0                 SUB    ax, ax                        ; clamp negative ax to 0
0305EA  8B 76 A2              MOV    si, word ptr [bp - 0x5e]      ; si = commodity_idx
0305ED  C1 E6 02              SHL    si, 2                         ; si *= 4
0305F0  01 42 B4              ADD    word ptr [bp + si - 0x4c], ax ; accum.lo += clamped low
0305F3  11 52 B6              ADC    word ptr [bp + si - 0x4a], dx ; accum.hi += clamped high (with carry)
0305F6  FF 46 AC              INC    word ptr [bp - 0x54]          ; power_idx++
0305F9  83 7E AC 04           CMP    word ptr [bp - 0x54], 4       ; while (power_idx < 4)
0305FD  7C CF                 JL     0x305ce                       ; loop back to row IMUL
