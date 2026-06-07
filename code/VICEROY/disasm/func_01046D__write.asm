; ============================================================================
; func_01046D__write
; Region   : load_image
; Bytes    : file 0x01046D..0x010472  (5 bytes)
; Purpose  : C `write(fd, buf, count)` low-level write. Sister to `_read` at 0x010466: same call-frame conventions, but loads AH=40h (DOS Write to File Handle) instead. Note this stub does NOT end in a JMP — it falls through into the shared read/write trampoline at 0x010472, which is the very next instruction after MOV AH,0x40.
; Args     : [bp+6] = fd; [bp+8..0xB] = far pointer to buffer; [bp+0xC] = count; [bp+0xE..0x11] = far pointer to bytes-written return slot
; Returns  : AX = 0 on success (with bytes-written written to the supplied return slot); -1 with errno set on failure.
; Callers  : TBD
; Callees  : rw_impl at 0x10472 (via fall-through, no JMP)
; Verified : 3 instructions, 5 bytes; falls through to 0x010472
; Source   : manually identified — sister of _read at 0x010466 with AH=40 (DOS Write)
; ============================================================================

01046D  55                    PUSH   bp                           ; standard frame prologue
01046E  8B EC                 MOV    bp, sp                       ; BP = SP, lets [bp+N] address args
010470  B4 40                 MOV    ah, 0x40                     ; AH = 0x40 — INT 21h subfunction "Write to File Handle"; falls through into rw_impl at 0x010472
