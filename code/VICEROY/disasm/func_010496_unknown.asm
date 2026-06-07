; ============================================================================
; func_010496___aFldiv
; Region   : load_image  (segment 0xD1D image-rel paragraph; Ghidra: 0x1D1D)
; Bytes    : file 0x010496..0x01052D  (152 bytes)
; Purpose  : 32-bit signed long division — Microsoft C 6.0 runtime helper
;            `__aFldiv` (a.k.a. `_aFldiv` or `LDIV`).  Computes
;              quotient = (dividend_hi:dividend_lo) / (divisor_hi:divisor_lo)
;            Returns DX:AX = signed 32-bit quotient.  Uses signs-then-unsigned
;            algorithm: convert both operands to absolute, divide, then
;            re-apply sign by tracking xor of input signs in DI.
;
; Args     : far cdecl, 4 words = 8 bytes total
;              [bp+ 6] = dividend low
;              [bp+ 8] = dividend high
;              [bp+ a] = divisor  low
;              [bp+ c] = divisor  high
; Returns  : DX:AX = signed 32-bit quotient
; ABI      : RETF 8 — pops 8 bytes of args
; Verified : BYTE_VERIFIED 2026-05-02 — matches MSC 6.0 medium-model __aFldiv
;            (the SAR-RCR loop at 0x104F2..0x104FC plus the JBE/DEC SI
;             back-correction at 0x10519..0x1051C is the canonical pattern).
;
; Algorithm:
;   1. Initialize DI = sign-tracker (= 0).
;   2. If dividend_high < 0, increment DI and negate dividend (lines 0x1049E..0x104B3).
;   3. If divisor_high  < 0, increment DI and negate divisor  (lines 0x104B6..0x104CB).
;   4. If divisor fits in 16 bits (high == 0): two single-word divides
;      give the 32-bit quotient (fast path, lines 0x104D2..0x104E5).
;   5. Otherwise: normalize divisor by repeated SHR/RCR until the high
;      word becomes 0, then use a single 32/16 divide and back-correct
;      with the multiplication check (slow path, lines 0x104E7..0x1051E).
;   6. If DI == 1 (one negative, one positive), negate the result.
;   7. Return DX:AX.
;
; Used by  : raze (file 0x05C9C6) to compute (multiplier * base) / 100,
;            and dozens of other game-logic functions.
; ============================================================================

010496  55                    PUSH   bp                           ; std prologue
010497  8B EC                 MOV    bp, sp
010499  57                    PUSH   di                           ; preserve DI (sign-tracker)
01049A  56                    PUSH   si
01049B  53                    PUSH   bx
01049C  33 FF                 XOR    di, di                       ; DI = 0  (sign-counter)

; ---- if dividend < 0, negate it and increment sign counter ----------------
01049E  8B 46 08              MOV    ax, word ptr [bp + 8]        ; AX = dividend.hi
0104A1  0B C0                 OR     ax, ax
0104A3  7D 11                 JGE    0x104b6                      ; non-negative: skip
0104A5  47                    INC    di                           ; sign-counter++
0104A6  8B 56 06              MOV    dx, word ptr [bp + 6]        ; DX = dividend.lo
0104A9  F7 D8                 NEG    ax                           ; negate hi
0104AB  F7 DA                 NEG    dx                           ; negate lo
0104AD  1D 00 00              SBB    ax, 0                        ; borrow propagation
0104B0  89 46 08              MOV    word ptr [bp + 8], ax        ; store back hi
0104B3  89 56 06              MOV    word ptr [bp + 6], dx        ; store back lo

; ---- if divisor < 0, negate it and increment sign counter -----------------
0104B6  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; AX = divisor.hi
0104B9  0B C0                 OR     ax, ax
0104BB  7D 11                 JGE    0x104ce
0104BD  47                    INC    di
0104BE  8B 56 0A              MOV    dx, word ptr [bp + 0xa]
0104C1  F7 D8                 NEG    ax
0104C3  F7 DA                 NEG    dx
0104C5  1D 00 00              SBB    ax, 0
0104C8  89 46 0C              MOV    word ptr [bp + 0xc], ax
0104CB  89 56 0A              MOV    word ptr [bp + 0xa], dx

; ---- if divisor.hi == 0, fast path (single divide) ------------------------
0104CE  0B C0                 OR     ax, ax                       ; (divisor.hi still in AX)
0104D0  75 15                 JNE    0x104e7                      ; nonzero -> slow path
0104D2  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; CX = divisor.lo
0104D5  8B 46 08              MOV    ax, word ptr [bp + 8]        ; AX = dividend.hi
0104D8  33 D2                 XOR    dx, dx
0104DA  F7 F1                 DIV    cx                           ; AX = hi / lo, DX = rem
0104DC  8B D8                 MOV    bx, ax                       ; save high quotient digit
0104DE  8B 46 06              MOV    ax, word ptr [bp + 6]        ; AX = dividend.lo
0104E1  F7 F1                 DIV    cx                           ; AX = (rem<<16 | lo) / divisor
0104E3  8B D3                 MOV    dx, bx                       ; DX = high quotient digit
0104E5  EB 38                 JMP    0x1051f                      ; jump to sign-correction

; ---- slow path: 32-bit divisor (binary normalization) ---------------------
0104E7  8B D8                 MOV    bx, ax                       ; BX = divisor.hi
0104E9  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; CX = divisor.lo
0104EC  8B 56 08              MOV    dx, word ptr [bp + 8]        ; DX = dividend.hi
0104EF  8B 46 06              MOV    ax, word ptr [bp + 6]        ; AX = dividend.lo
0104F2  D1 EB                 SHR    bx, 1                        ; normalize: shift divisor right
0104F4  D1 D9                 RCR    cx, 1                        ;   until BX = 0
0104F6  D1 EA                 SHR    dx, 1                        ; mirror shift on dividend
0104F8  D1 D8                 RCR    ax, 1
0104FA  0B DB                 OR     bx, bx
0104FC  75 F4                 JNE    0x104f2                      ; loop until divisor.hi = 0
0104FE  F7 F1                 DIV    cx                           ; trial quotient
010500  8B F0                 MOV    si, ax                       ; SI = trial Q
010502  F7 66 0C              MUL    word ptr [bp + 0xc]          ; verify: trial * orig_div.hi
010505  91                    XCHG   cx, ax                       ; CX = (trial * div.hi).lo, AX swap
010506  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; AX = orig_div.lo
010509  F7 E6                 MUL    si                           ; trial * orig_div.lo
01050B  03 D1                 ADD    dx, cx                       ; DX = (trial * div) high
01050D  72 0C                 JB     0x1051b                      ; carry -> trial too big
01050F  3B 56 08              CMP    dx, word ptr [bp + 8]
010512  77 07                 JA     0x1051b                      ; > dividend.hi -> too big
010514  72 06                 JB     0x1051c                      ; < dividend.hi -> ok
010516  3B 46 06              CMP    ax, word ptr [bp + 6]
010519  76 01                 JBE    0x1051c                      ; <= dividend.lo -> ok
01051B  4E                    DEC    si                           ; back off by 1
01051C  33 D2                 XOR    dx, dx                       ; DX = 0 (32-bit Q's hi is 0 in slow path)
01051E  96                    XCHG   si, ax                       ; AX = SI (final quotient low)

; ---- sign-correct and return ----------------------------------------------
01051F  4F                    DEC    di                           ; DI was 0,1,2 (count of negations)
010520  75 07                 JNE    0x10529                      ; if DI != 1, skip negation
010522  F7 DA                 NEG    dx                           ; negate result
010524  F7 D8                 NEG    ax
010526  83 DA 00              SBB    dx, 0
010529  5B                    POP    bx
01052A  5E                    POP    si
01052B  5F                    POP    di
01052C  5D                    POP    bp
01052D  CA 08 00              RETF   8                            ; return DX:AX, pop 8 bytes
