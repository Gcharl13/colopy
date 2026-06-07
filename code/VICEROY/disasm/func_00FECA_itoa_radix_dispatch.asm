; ============================================================================
; func_00FECA_itoa_radix_dispatch
; Region   : load_image
; Bytes    : file 0x00FECA..0x00FEE6  (28 bytes)
; Purpose  : Front-half of `itoa(value, buf, radix)` / `ltoa`-equivalent. Loads the radix from [bp+0xA], the value's low word from [bp+6], computes DX = high word (via CDQ if radix is 10, else 0 for unsigned), loads buffer pointer DI = [bp+8], then jumps to the shared body at 0x11B02 which performs the digit conversion. Sets BL = 1 to flag 'this is the radix-10 / signed path'.
; Args     : [bp+6] = value low word, [bp+8] = buffer pointer, [bp+0xA] = radix (commonly 10 or 16)
; Returns  : Tail-jumps to 0x11B02; that function returns the buffer pointer in AX.
; Callers  : TBD (12 distinct call sites)
; Callees  : 0x11B02 (shared digit-emit body) — via JMP, not CALL
; Verified : Boundary verified: ENTER-less PUSH SI/PUSH DI / JMP 0x11B02, 28 bytes.
; Source   : Pattern matches the MS C itoa entry; CDQ when radix=10 indicates the signed-decimal path.
; ============================================================================

00FECA  55                    PUSH   bp                           ; standard frame prologue
00FECB  8B EC                 MOV    bp, sp                       ; BP = SP
00FECD  56                    PUSH   si                           ; preserve SI
00FECE  57                    PUSH   di                           ; preserve DI
00FECF  B3 01                 MOV    bl, 1                        ; BL = 1 — flag "this is the itoa entry" for the shared body at 0x11B02
00FED1  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; CX = radix (3rd arg)
00FED4  8B 46 06              MOV    ax, word ptr [bp + 6]        ; AX = value low word (1st arg)
00FED7  33 D2                 XOR    dx, dx                       ; DX = 0 — high word (default for unsigned)
00FED9  83 F9 0A              CMP    cx, 0xa                      ; is radix == 10 (decimal)?
00FEDC  75 01                 JNE    0xfedf                       ; if not, keep DX=0 (unsigned)
00FEDE  99                    CDQ                                 ; signed-decimal path: DX = sign-extension of AX (now DX:AX = signed long)
00FEDF  8B 7E 08              MOV    di, word ptr [bp + 8]        ; DI = output buffer pointer (2nd arg)
00FEE2  E9 1D 1C              JMP    0x11b02                      ; tail-jump to the shared digit-emit body (handles both signed-10 and unsigned-N cases)
00FEE5  00                    DB     0x00                         ; one-byte alignment padding
