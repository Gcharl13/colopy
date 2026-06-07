; ============================================================================
; func_00863E_wrapper_with_global_8DC6
; Region   : load_image
; Bytes    : file 0x00863E..0x00864D  (15 bytes)
; Purpose  : Small near-call wrapper that pushes [bp+6] (the caller's argument) and the 16-bit global at DGROUP:0x8DC6 (likely a global state index — current player? current colony?), then near-calls 0x860E. Effectively a 'forward this call together with the current-context global' helper.
; Args     : [bp+6] = forwarded argument
; Returns  : Whatever 0x860E returns (likely AX).
; Callers  : TBD (9 distinct call sites)
; Callees  : 0x860E (the main implementation that needs the [0x8DC6] context)
; Verified : Boundary verified: 15 bytes; LEAVE follows the near-CALL.
; Source   : Identified via callgraph as a small wrapper.
; ============================================================================

00863E  55                    PUSH   bp                           ; standard frame prologue
00863F  8B EC                 MOV    bp, sp                       ; BP = SP
008641  FF 76 06              PUSH   word ptr [bp + 6]            ; push caller's argument as 1st arg to 0x860E
008644  FF 36 C6 8D           PUSH   word ptr [0x8dc6]            ; push current-context global at DGROUP:0x8DC6 as 2nd arg (likely current player or current colony index)
008648  0E                    PUSH   cs                           ; push CS for the near-CALL — needed because target is near but caller invokes as far
008649  E8 C2 FF              CALL   0x860e                       ; near-call the actual implementation; AX returns the result
00864C  C9                    LEAVE                               ; teardown frame; falls through past LEAVE to RET that's part of the next function (this function is 15 bytes ending here)
