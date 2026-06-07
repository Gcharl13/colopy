; ============================================================================
; func_00F720_dos_version_check_stub
; Region   : load_image
; Bytes    : file 0x00F720..0x00F72D  (13 bytes)
; Purpose  : Tiny pre-stack-relocation stub. Calls DOS Get-Version (INT 21h, AH=30h); if the major version is below 2 it falls through to a 'PUSH ES; PUSH AX; RETF' that returns to PSP:0 (DOS terminates the program). On DOS 2.0+ it jumps to 0xF72D (cstart) to set up the C runtime. Reached as the LJMP-target of the entry-point stub at 0x13BED, after system_init returns.
; Args     : (none — segments and stack are still in their DOS-loader-default state)
; Returns  : No normal return. On DOS<2 falls through to a far-return-via-PUSH that lands at PSP:0 (terminate-and-stay-resident style exit). On DOS>=2 jumps forward to the cstart routine.
; Callers  : 0x13BF2 (LJMP target of entry_point stub)
; Callees  : DOS INT 21h AH=30h
; Verified : boundary verified — 13 bytes from 0xF720 to 0xF72D inclusive of the RETF at 0xF72C
; Source   : manually identified — LJMP destination of entry_point at 0x13BED with cs:ip = 0D1D:0150 segment-relative (byte offset 0xD320 + header 0x2400 = 0xF720)
; ============================================================================

00F720  B4 30                 MOV    ah, 0x30                     ; INT 21h subfunction 30h: Get DOS Version
00F722  CD 21                 INT    0x21                         ; DOS Get-Version → AL = major, AH = minor, BX:CX = OEM serial
00F724  3C 02                 CMP    al, 2                        ; DOS major version >= 2?
00F726  73 05                 JAE    0xf72d                       ; if yes, jump to cstart (DOS 2+ has the FCB/handle APIs the runtime needs)
00F728  33 C0                 XOR    ax, ax                       ; (DOS<2 path) zero AX — used as the offset of the far address pushed below
00F72A  06                    PUSH   es                           ; push PSP segment (ES still points at PSP from the DOS loader)
00F72B  50                    PUSH   ax                           ; push offset 0 → far pointer = PSP:0000
00F72C  CB                    RETF                                ; far-return to PSP:0000 — the PSP's first 2 bytes are an INT 20h (legacy DOS 1 program-terminate) so this exits the program
