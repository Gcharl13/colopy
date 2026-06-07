; ============================================================================
; func_00F8E4_exit_abort
; Region   : load_image
; Bytes    : file 0x00F8E4..0x00F8EC  (8 bytes)
; Purpose  : C `_exit(status)` / `abort()`-style entry. Sets CX=1 (the merged implementation at 0xF8FE skips the atexit chain and stdio flush when CX is non-zero, going straight to INT 21h AH=4Ch with the supplied exit code).
; Args     : [bp+6] = exit code (16-bit; only AL is used by INT 21h AH=4Ch)
; Returns  : Does not return.
; Callers  : TBD (xrefs not yet gathered)
; Callees  : exit_impl at 0xF8FE (via JMP)
; Verified : 4 instructions, 7 bytes; ends in JMP
; Source   : manually identified — pattern MOV CX,1 + JMP merge-point matches the standard MS C _exit() (no-cleanup) variant
; ============================================================================

00F8E4  55                    PUSH   bp                           ; standard frame prologue
00F8E5  8B EC                 MOV    bp, sp                       ; BP = SP
00F8E7  B9 01 00              MOV    cx, 1                        ; CX = 1 — flag: "abort exit, skip atexit and stdio flush"
00F8EA  EB 12                 JMP    0xf8fe                       ; tail-jump to exit_impl at 0xF8FE (shared with exit() which sets CX=0)
