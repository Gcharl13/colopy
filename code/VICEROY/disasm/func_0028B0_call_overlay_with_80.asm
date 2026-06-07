; ============================================================================
; func_0028B0_call_overlay_with_80
; Region   : load_image
; Bytes    : file 0x0028B0..0x0028C0  (16 bytes)
; Purpose  : Pushes 0x50 (80) and the caller's argument [bp+6], then far-calls 0x0D1D:0x07A4 (overlay-resident helper). The 0x50 likely identifies a fixed target-id (screen/menu/buffer-id 80 per a runtime lookup table), so this is a 'call-helper-X-with-context-Y' wrapper.
; Args     : [bp+6] = caller's argument forwarded to the overlay helper
; Returns  : Whatever the helper returns
; Callers  : TBD (3 distinct call sites)
; Callees  : 0x0D1D:0x07A4 (overlay helper)
; Verified : Boundary verified: PUSH BP / LEAVE / RETF, 16 bytes.
; Source   : Pattern: PUSH constant + PUSH arg + LCALL.
; ============================================================================

0028B0  55                    PUSH   bp                           ; standard frame prologue
0028B1  8B EC                 MOV    bp, sp                       ; BP = SP
0028B3  68 50 00              PUSH   0x50                         ; push constant 0x50 (= 80) — fixed context-id arg to the helper
0028B6  FF 76 06              PUSH   word ptr [bp + 6]            ; push caller's argument
0028B9  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4                 ; far-call overlay helper at 0x0D1D:0x07A4 — handles the (id=80, arg) call
0028BE  C9                    LEAVE                               ; teardown
0028BF  CB                    RETF                                ; far-return: AX = whatever the helper returned
