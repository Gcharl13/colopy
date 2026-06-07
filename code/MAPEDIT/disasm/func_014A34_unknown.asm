; ============================================================================
; func_014A34_unknown
; Region   : load_image
; Bytes    : file 0x014A34..0x014A53  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

014A34  55                    PUSH   bp ; STACK_PUSH
014A35  8B EC                 MOV    bp, sp ; MOV
014A37  56                    PUSH   si ; STACK_PUSH
014A38  A1 68 3C              MOV    ax, word ptr [0x3c68] ; GLOBAL_LOAD
014A3B  0B C0                 OR     ax, ax ; LOGIC
014A3D  74 15                 JE     0x14a54 ; CJUMP
014A3F  BE 06 00              MOV    si, 6 ; MOV
014A42  03 F5                 ADD    si, bp ; ARITH
014A44  B4 0B                 MOV    ah, 0xb ; CONST_LOAD
014A46  FF 1E 6C 3C           LCALL  [0x3c6c] ; LCALL
014A4A  0B C0                 OR     ax, ax ; LOGIC
014A4C  74 06                 JE     0x14a54 ; CJUMP
014A4E  33 C0                 XOR    ax, ax ; LOGIC
014A50  5E                    POP    si ; STACK_POP
014A51  C9                    LEAVE ; EPILOGUE
014A52  CB                    RETF ; RETURN
