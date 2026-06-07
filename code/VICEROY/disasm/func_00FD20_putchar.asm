; ============================================================================
; func_00FD20_putchar
; Region   : load_image
; Bytes    : file 0x00FD20..0x00FD28  (8 bytes)
; Purpose  : C `putchar(int c)`. Loads BX with the address of the stdout FILE struct (DGROUP:0x2916) and tail-jumps to the shared putc fast path at 0xFD2E.
; Args     : [bp+6] = character to write
; Returns  : AX = character written, or 0xFFFF (EOF) on error.
; Callers  : TBD
; Callees  : putc_fast at 0xFD2E (via JMP)
; Verified : 4 instructions, 8 bytes; FILE* literal 0x2916 matches the second of two stdio FILE structs in DGROUP
; Source   : manually identified — fpost-FILE-load + JMP shared-putc-implementation pattern
; ============================================================================

00FD20  55                    PUSH   bp                           ; standard frame prologue
00FD21  8B EC                 MOV    bp, sp                       ; BP = SP, so [bp+6] addresses the character argument
00FD23  BB 16 29              MOV    bx, 0x2916                   ; BX = &_iob[stdout] (DGROUP-relative FILE struct address for stdout)
00FD26  EB 06                 JMP    0xfd2e                       ; tail-jump to putc_fast at 0xFD2E (shared by putchar / fputc)
