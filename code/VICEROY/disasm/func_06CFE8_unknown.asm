; ============================================================================
; func_06CFE8_unknown
; Region   : overlay
; Bytes    : file 0x06CFE8..0x06D02C  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06CFE8  C8 6A 01 00           ENTER  0x16a, 0 ; PROLOGUE
06CFEC  50                    PUSH   ax ; STACK_PUSH
06CFED  57                    PUSH   di ; STACK_PUSH
06CFEE  56                    PUSH   si ; STACK_PUSH
06CFEF  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06CFF2  26 8B 47 58           MOV    ax, word ptr es:[bx + 0x58] ; MOV
06CFF6  26 8B 57 5A           MOV    dx, word ptr es:[bx + 0x5a] ; MOV
06CFFA  89 86 F4 FE           MOV    word ptr [bp - 0x10c], ax ; LOCAL_STORE
06CFFE  89 96 F6 FE           MOV    word ptr [bp - 0x10a], dx ; LOCAL_STORE
06D002  26 8B 47 48           MOV    ax, word ptr es:[bx + 0x48] ; MOV
06D006  D1 E0                 SHL    ax, 1 ; LOGIC
06D008  26 2B 47 28           SUB    ax, word ptr es:[bx + 0x28] ; ARITH
06D00C  F7 D8                 NEG    ax ; ARITH
06D00E  89 86 F8 FE           MOV    word ptr [bp - 0x108], ax ; LOCAL_STORE
06D012  26 8B 47 2C           MOV    ax, word ptr es:[bx + 0x2c] ; MOV
06D016  89 86 F2 FE           MOV    word ptr [bp - 0x10e], ax ; LOCAL_STORE
06D01A  C6 86 FA FE 00        MOV    byte ptr [bp - 0x106], 0 ; LOCAL_STORE
06D01F  2B C0                 SUB    ax, ax ; ARITH
06D021  89 86 9A FE           MOV    word ptr [bp - 0x166], ax ; LOCAL_STORE
06D025  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06D028  8B C2                 MOV    ax, dx ; MOV
06D02A  0B                    DB     0x0B ; DATA_BYTE
06D02B  86                    DB     0x86 ; DATA_BYTE
