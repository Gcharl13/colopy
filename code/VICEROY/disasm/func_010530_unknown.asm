; ============================================================================
; func_010530___aFlmul
; Region   : load_image  (segment 0xD1D image-rel paragraph; Ghidra: 0x1D1D)
; Bytes    : file 0x010530..0x010561  (50 bytes — covers fast + slow paths)
; Purpose  : 32-bit signed/unsigned long multiplication — Microsoft C 6.0
;            runtime helper `__aFlmul` (a.k.a. `_aFlmul` or `LMUL`).
;            Computes truncated 32-bit product:
;              result = (a_hi:a_lo) * (b_hi:b_lo)  mod 2^32
;            Returns DX:AX = low 32 bits of the 64-bit product.
;            (Sign doesn't matter for low-32-bit truncation, so this is
;             the same routine MSC emits for signed and unsigned long mul.)
;
; Args     : far cdecl, 4 words = 8 bytes total
;              [bp+ 6] = a low
;              [bp+ 8] = a high
;              [bp+ a] = b low
;              [bp+ c] = b high
; Returns  : DX:AX = (a * b) mod 2^32
; ABI      : RETF 8 — pops 8 bytes
; Verified : BYTE_VERIFIED 2026-05-02 — fast-path matches MSC 6.0 emit:
;              0x10533: MOV AX,[bp+8]   ; a_hi
;              0x10536: MOV CX,[bp+c]   ; b_hi
;              0x10539: OR  CX,AX       ; both zero?
;              0x1053B: MOV CX,[bp+a]   ; b_lo (overwrites; flags from OR keep)
;              0x1053E: JNE slow_path
;              0x10540: MOV AX,[bp+6]   ; a_lo
;              0x10543: MUL CX          ; DX:AX = a_lo * b_lo
;              0x10546: RETF 8
;
; Algorithm:
;   Both high words zero -> simple 16x16 multiply, return DX:AX.
;   Otherwise:
;     low part      = (a_lo * b_lo).low
;     middle adds   = (a_hi * b_lo).low + (a_lo * b_hi).low
;     final DX      = (a_lo * b_lo).high + middle_adds
;     final AX      = low part
;   This is the standard 32x32 -> 32 truncation: only the cross-products'
;   LOW words contribute to the high half of the result; products that
;   would shift past bit 31 (i.e. a_hi * b_hi) are discarded.
;
; Used by  : raze (file 0x05C9BF) to compute multiplier * base before
;            dividing by 100, and many other game-logic functions.
; ============================================================================

010530  55                    PUSH   bp                           ; std prologue
010531  8B EC                 MOV    bp, sp
010533  8B 46 08              MOV    ax, word ptr [bp + 8]        ; AX = a.hi
010536  8B 4E 0C              MOV    cx, word ptr [bp + 0xc]      ; CX = b.hi
010539  0B C8                 OR     cx, ax                       ; CX |= AX  (test: are both high zero?)
01053B  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; CX = b.lo  (overwrites CX; flags retained)
01053E  75 09                 JNE    0x10549                      ; either high nonzero -> slow path

; ---- fast path: both high words zero, simple 16x16 ------------------------
010540  8B 46 06              MOV    ax, word ptr [bp + 6]        ; AX = a.lo
010543  F7 E1                 MUL    cx                           ; DX:AX = a.lo * b.lo
010545  5D                    POP    bp
010546  CA 08 00              RETF   8

; ---- slow path: full 32x32 truncated to 32 bits ---------------------------
010549  53                    PUSH   bx                           ; preserve BX (we use it as accumulator)
01054A  F7 E1                 MUL    cx                           ; DX:AX = a.hi * b.lo  (AX still = a.hi)
01054C  8B D8                 MOV    bx, ax                       ; BX = (a.hi * b.lo).lo  (high contrib #1)
01054E  8B 46 06              MOV    ax, word ptr [bp + 6]        ; AX = a.lo
010551  F7 66 0C              MUL    word ptr [bp + 0xc]          ; DX:AX = a.lo * b.hi
010554  03 D8                 ADD    bx, ax                       ; BX += (a.lo * b.hi).lo  (high contrib #2)
010556  8B 46 06              MOV    ax, word ptr [bp + 6]        ; AX = a.lo (third time)
010559  F7 E1                 MUL    cx                           ; DX:AX = a.lo * b.lo  (the BASE product)
01055B  03 D3                 ADD    dx, bx                       ; DX += sum-of-high-contribs
01055D  5B                    POP    bx
01055E  5D                    POP    bp
01055F  CA 08 00              RETF   8                            ; return DX:AX = a*b (low 32 bits)
