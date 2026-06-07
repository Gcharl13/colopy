; ============================================================================
; func_00F8DD_exit
; Region   : load_image
; Bytes    : file 0x00F8DD..0x00F8E4  (7 bytes)
; Purpose  : C `exit(status)` entry point. The runtime convention here is two cooperating thunks that share an implementation at 0xF8FE: this one zeroes CX (CL flag = 'normal exit, run atexit handlers') and tail-jumps to 0xF8FE. Called by cstart immediately after _main returns (with the exit code already pushed as [bp+6]).
; Args     : [bp+6] = exit code (16-bit; only AL is used by INT 21h AH=4Ch)
; Returns  : Does not return; the merged implementation runs atexit chain, flushes stdio, and INT 21h AH=4Ch terminates the program.
; Callers  : cstart at 0xF7DF (CALL to 0xF8DD with _main's return value pushed)
; Callees  : exit_impl at 0xF8FE (via JMP)
; Verified : 4 instructions, 7 bytes; ends in JMP
; Source   : manually identified — pattern XOR CX,CX + JMP merge-point matches the standard MS C exit() / _exit() pair
; ============================================================================

00F8DD  55                    PUSH   bp                           ; standard frame prologue (lets [bp+6] address the exit-code argument)
00F8DE  8B EC                 MOV    bp, sp                       ; BP = SP
00F8E0  33 C9                 XOR    cx, cx                       ; CX = 0 — flag: "normal exit, run atexit + flush stdio"
00F8E2  EB 1A                 JMP    0xf8fe                       ; tail-jump to exit_impl at 0xF8FE (shared with exit_abort which sets CX=1)
