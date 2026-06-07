; ============================================================================
; func_01070C_strlen_far
; Region   : load_image
; Bytes    : file 0x01070C..0x010723  (23 bytes)
; Purpose  : C `strlen(s)` for far-pointer s. Loads ES:DI from [bp+6..9], REPNE SCASB to NUL, returns AX = length. Far-pointer variant of strlen_near at 0xFE12.
; Args     : [bp+6..9] = string far-pointer
; Returns  : AX = strlen(string)
; Callers  : TBD (5 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: PUSH BP / RETF, 23 bytes. Standard REPNE SCASB / NOT CX / DEC CX / XCHG pattern with LES.
; Source   : Pattern matches MS C runtime _fstrlen.
; ============================================================================

01070C  55                    PUSH   bp                           ; standard frame prologue
01070D  8B EC                 MOV    bp, sp                       ; BP = SP
01070F  8B D7                 MOV    dx, di                       ; preserve caller's DI
010711  C4 7E 06              LES    di, ptr [bp + 6]             ; ES:DI = string far-pointer
010714  33 C0                 XOR    ax, ax                       ; AL = 0 — NUL search byte
010716  B9 FF FF              MOV    cx, 0xffff                   ; CX = -1 (max scan)
010719  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; scan for NUL
01071B  F7 D1                 NOT    cx                           ; CX = scanned + 1 (includes NUL)
01071D  49                    DEC    cx                           ; CX = strlen
01071E  91                    XCHG   cx, ax                       ; AX = strlen
01071F  8B FA                 MOV    di, dx                       ; restore DI
010721  5D                    POP    bp                           ; restore BP
010722  CB                    RETF                                ; far-return: AX = strlen
