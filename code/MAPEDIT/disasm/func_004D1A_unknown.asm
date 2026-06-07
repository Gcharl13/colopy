; ============================================================================
; func_004D1A_unknown
; Region   : load_image
; Bytes    : file 0x004D1A..0x004D5A  (64 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004D1A  55                    PUSH   bp ; STACK_PUSH
004D1B  8B EC                 MOV    bp, sp ; MOV
004D1D  50                    PUSH   ax ; STACK_PUSH
004D1E  83 3E 6C 05 00        CMP    word ptr [0x56c], 0 ; CMP
004D23  74 69                 JE     0x4d8e ; CJUMP
004D25  80 7E 0A 07           CMP    byte ptr [bp + 0xa], 7 ; CMP
004D29  75 63                 JNE    0x4d8e ; CJUMP
004D2B  83 3E 8A 05 00        CMP    word ptr [0x58a], 0 ; CMP
004D30  74 28                 JE     0x4d5a ; CJUMP
004D32  FF 36 02 3B           PUSH   word ptr [0x3b02] ; PUSH_GLOBAL
004D36  FF 36 00 3B           PUSH   word ptr [0x3b00] ; PUSH_GLOBAL
004D3A  FF 36 FE 3A           PUSH   word ptr [0x3afe] ; PUSH_GLOBAL
004D3E  FF 36 FC 3A           PUSH   word ptr [0x3afc] ; PUSH_GLOBAL
004D42  FF 76 1A              PUSH   word ptr [bp + 0x1a] ; PUSH_GLOBAL
004D45  FF 76 18              PUSH   word ptr [bp + 0x18] ; PUSH_GLOBAL
004D48  FF 76 16              PUSH   word ptr [bp + 0x16] ; PUSH_GLOBAL
004D4B  FF 76 14              PUSH   word ptr [bp + 0x14] ; PUSH_GLOBAL
004D4E  FF 76 12              PUSH   word ptr [bp + 0x12] ; PUSH_GLOBAL
004D51  9A 00 00 4C 0C        LCALL  0xc4c, 0 ; LCALL
004D56  C9                    LEAVE ; EPILOGUE
004D57  C2 18 00              RET    0x18 ; RETURN
