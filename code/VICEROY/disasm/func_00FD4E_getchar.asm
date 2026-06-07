; ============================================================================
; func_00FD4E_getchar
; Region   : load_image
; Bytes    : file 0x00FD4E..0x00FD56  (8 bytes)
; Purpose  : C `getchar(void)`. Loads BX with the address of the stdin FILE struct (DGROUP:0x290E) and tail-jumps to the shared getc fast path at 0xFD5C.
; Args     : (none)
; Returns  : AX = character read, or 0xFFFF (EOF) on read failure / end-of-file.
; Callers  : TBD
; Callees  : getc_fast at 0xFD5C (via JMP)
; Verified : 4 instructions, 8 bytes; FILE* literal 0x290E matches the first of two stdio FILE structs in DGROUP
; Source   : manually identified — pre-FILE-load + JMP shared-getc-implementation pattern
; ============================================================================

00FD4E  55                    PUSH   bp                           ; standard frame prologue
00FD4F  8B EC                 MOV    bp, sp                       ; BP = SP
00FD51  BB 0E 29              MOV    bx, 0x290e                   ; BX = &_iob[stdin] (DGROUP-relative FILE struct address for stdin)
00FD54  EB 06                 JMP    0xfd5c                       ; tail-jump to getc_fast at 0xFD5C (shared by getchar / fgetc)
