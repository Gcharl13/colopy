; ============================================================================
; func_00FEE6_ltoa_dispatch
; Region   : load_image
; Bytes    : file 0x00FEE6..0x00FEF0  (10 bytes)
; Purpose  : Sister of `itoa_radix_dispatch` (0xFECA): sets BL=1 to flag 'long-decimal path' to the shared digit-emit body at 0x11AF6 (a different shared body than itoa's 0x11B02). Used for `ltoa(value, buf)` (long-int to string).
; Args     : [bp+6..9] = long value, [bp+0xA] = buffer pointer
; Returns  : Tail-jumps to 0x11AF6.
; Callers  : TBD (3 distinct call sites)
; Callees  : 0x11AF6 (shared long-digit-emit body)
; Verified : Boundary verified: 10 bytes; ends in JMP.
; Source   : Sister-of-itoa pattern with different shared-body target.
; ============================================================================

00FEE6  55                    PUSH   bp                           ; standard frame prologue
00FEE7  8B EC                 MOV    bp, sp                       ; BP = SP
00FEE9  56                    PUSH   si                           ; preserve SI
00FEEA  57                    PUSH   di                           ; preserve DI
00FEEB  B3 01                 MOV    bl, 1                        ; BL = 1 — flag "long-decimal path" for the shared digit-emit body at 0x11AF6
00FEED  E9 06 1C              JMP    0x11af6                      ; tail-jump to the shared body
