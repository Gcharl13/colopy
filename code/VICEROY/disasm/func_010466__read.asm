; ============================================================================
; func_010466__read
; Region   : load_image
; Bytes    : file 0x010466..0x01046D  (7 bytes)
; Purpose  : C `read(fd, buf, count)` low-level read. Loads AH=3Fh (DOS Read From File Handle) and tail-jumps to the shared read/write trampoline at 0x10472 which loads BX (handle), CX (count), and DS:DX (buffer) from the call frame, issues INT 21h, and stores the bytes-read result.
; Args     : [bp+6] = fd; [bp+8..0xB] = far pointer to buffer; [bp+0xC] = count; [bp+0xE..0x11] = far pointer to bytes-read return slot
; Returns  : AX = 0 on success (with bytes-read written to the supplied return slot); -1 with errno set on failure.
; Callers  : TBD
; Callees  : rw_impl at 0x10472 (via JMP)
; Verified : 4 instructions, 7 bytes; ends in JMP to the shared read/write impl. The next 5 bytes at 0x01046D are the sister function _write, which falls through into the same impl.
; Source   : manually identified — pre-AH-load + JMP shared-rw-implementation pattern; AH=3F = DOS Read
; ============================================================================

010466  55                    PUSH   bp                           ; standard frame prologue
010467  8B EC                 MOV    bp, sp                       ; BP = SP, lets [bp+N] address args
010469  B4 3F                 MOV    ah, 0x3f                     ; AH = 0x3F — INT 21h subfunction "Read From File Handle"
01046B  EB 05                 JMP    0x10472                      ; tail-jump past _write's stub into the shared rw_impl at 0x10472
