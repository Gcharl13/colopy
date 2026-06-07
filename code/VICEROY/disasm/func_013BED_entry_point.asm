; ============================================================================
; func_013BED_entry_point
; Region   : load_image
; Bytes    : file 0x013BED..0x013BF7  (10 bytes)
; Purpose  : MZ entry-point stub. The very first code DOS executes after loading VICEROY.EXE. Its only job is to (a) far-call system_init at 0x13BF7 to set up DOS/EMS/XMS/heap state and (b) tail-far-jump to dos_version_check_stub at 0xF720 which then falls into the C-runtime cstart. Two instructions, 10 bytes total. The MZ header points here via cs:ip = 110D:071D (segment-relative; file offset = header(0x2400) + 0x110D*16 + 0x071D = 0x13BED).
; Args     : (none — DS/ES point at the PSP per the DOS loader convention; AX, BX, CX, DX, SI, DI, BP, SP, SS are all in their DOS-loader-default state)
; Returns  : Does not return. The LJMP is a tail call; the LCALL above it returns to the LJMP, which then transfers control to dos_version_check_stub.
; Callers  : DOS program loader (per the e_cs:e_ip pair in the MZ header)
; Callees  : system_init at 0x13BF7 (via LCALL 110D:0727), dos_version_check_stub at 0xF720 (via LJMP 0D1D:0150)
; Verified : byte-equal to original — LCALL+LJMP encoded exactly as the original 10 bytes; reassembling these instructions reproduces the original bytes
; Source   : manually identified — MZ header e_cs:e_ip points here
; ============================================================================

013BED  9A 27 07 0D 11        LCALL  0x110d, 0x727                ; far-call system_init at 110D:0727 (file 0x13BF7) — DOS/EMS/XMS/heap setup
013BF2  EA 50 01 1D 0D        LJMP   0xd1d:0x150                  ; tail-jump to dos_version_check_stub at 0D1D:0150 (file 0xF720), which falls into cstart on DOS>=2
