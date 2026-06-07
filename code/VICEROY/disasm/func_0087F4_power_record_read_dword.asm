; ============================================================================
; func_0087F4_power_record_read_dword
; Region   : load_image
; Bytes    : file 0x0087F4..0x008806  (18 bytes)
; Purpose  : Reads a 32-bit DWORD from a player/power record. Index is multiplied by 0x13C (316 bytes = sizeof PowerRecord, confirmed in FUNCTIONS_INVENTORY.md), then offsets -0x77CE and -0x77CC (which together form the table base) are added to get the field address. Returns DX:AX = the DWORD.
; Args     : [bp+6] = power index (0..3 for the 4 nations)
; Returns  : DX:AX = 32-bit field read from PowerRecord[index]
; Callers  : TBD (4 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: PUSH BP / LEAVE / RETF, 18 bytes. Stride 0x13C matches the established PowerRecord size.
; Source   : Identified via callgraph; PowerRecord stride is well-known.
; ============================================================================

0087F4  55                    PUSH   bp                           ; standard frame prologue
0087F5  8B EC                 MOV    bp, sp                       ; BP = SP
0087F7  69 5E 06 3C 01        IMUL   bx, word ptr [bp + 6], 0x13c ; BX = power_index * 0x13C (sizeof PowerRecord = 316 bytes)
0087FC  8B 87 32 88           MOV    ax, word ptr [bx - 0x77ce]   ; AX = low word of DWORD field at power_table_base + offset_within_record
008800  8B 97 34 88           MOV    dx, word ptr [bx - 0x77cc]   ; DX = high word (2 bytes later) — together DX:AX = 32-bit field
008804  C9                    LEAVE                               ; teardown
008805  CB                    RETF                                ; far-return: DX:AX = PowerRecord[power_index].field (32-bit)
