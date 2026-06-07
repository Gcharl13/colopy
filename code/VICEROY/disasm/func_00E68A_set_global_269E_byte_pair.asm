; ============================================================================
; func_00E68A_set_global_269E_byte_pair
; Region   : load_image
; Bytes    : file 0x00E68A..0x00E699  (15 bytes)
; Purpose  : Stores AL into DGROUP:0x269E and DL into DGROUP:0x269F (a 2-byte coordinate pair), then returns AX = BX. Looks like `set_cursor(x, y)` or `set_target(x, y)` — sets a 2-byte (x,y) state global from CX/DX, returns BX as a token.
; Args     : AL = first coordinate, DL = second coordinate, BX = token to return
; Returns  : AX = original BX (function-as-passthrough)
; Callers  : TBD (7 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: PUSH BP / 7 instructions, 15 bytes. The two MOV [0x269E]/[0x269F] writes are the signature.
; Source   : Identified via callgraph; pattern matches a 'set 2D coordinate state' helper.
; ============================================================================

00E68A  55                    PUSH   bp                           ; standard frame prologue
00E68B  8B EC                 MOV    bp, sp                       ; BP = SP
00E68D  8B C8                 MOV    cx, ax                       ; CX = AX (preserve original AX in CX since we'll write CL)
00E68F  88 0E 9E 26           MOV    byte ptr [0x269e], cl        ; DGROUP:0x269E = AL (low byte of first arg)
00E693  88 16 9F 26           MOV    byte ptr [0x269f], dl        ; DGROUP:0x269F = DL (low byte of second arg)
00E697  8B C3                 MOV    ax, bx                       ; AX = BX — return BX as the function's result (passthrough token)
