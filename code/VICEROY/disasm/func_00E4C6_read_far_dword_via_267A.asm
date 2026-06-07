; ============================================================================
; func_00E4C6_read_far_dword_via_267A
; Region   : load_image
; Bytes    : file 0x00E4C6..0x00E4D2  (12 bytes)
; Purpose  : Reads the first 4 bytes (DWORD) at the far pointer stored in DGROUP:[0x267A]. The far pointer itself is set up at runtime to point at a major game-state structure. Called 17 times — a hot accessor for whatever lives at *(0x267A). 4 instructions.
; Args     : (none)
; Returns  : DX:AX = *(*(0x267A))  (DWORD at the far-pointer-pointed-to structure's offset 0)
; Callers  : TBD (17 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: LES BX,[0x267A] / MOV AX,[ES:BX] / MOV DX,[ES:BX+2] / RETF, 12 bytes total.
; Source   : Identified as orphan call target with 17 callers.
; ============================================================================

00E4C6  C4 1E 7A 26           LES    bx, ptr [0x267a]             ; ES:BX = far pointer stored at DGROUP:0x267A (points at some major game-state record)
00E4CA  26 8B 07              MOV    ax, word ptr es:[bx]         ; AX = low word of the DWORD at ES:[BX+0]
00E4CD  26 8B 57 02           MOV    dx, word ptr es:[bx + 2]     ; DX = high word of the DWORD at ES:[BX+2]
00E4D1  CB                    RETF                                ; far-return DX:AX = the 32-bit value at *(*(0x267A))
