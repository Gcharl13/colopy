; ============================================================================
; func_001CA2_unknown
; Region   : load_image
; Bytes    : file 0x001CA2..0x001CD2  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

001CA2  55                    PUSH   bp ; STACK_PUSH
001CA3  8B EC                 MOV    bp, sp ; MOV
001CA5  9A 58 00 35 07        LCALL  0x735, 0x58 ; LCALL
001CAA  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
001CAD  FF 36 E8 36           PUSH   word ptr [0x36e8] ; PUSH_GLOBAL
001CB1  FF 36 E6 36           PUSH   word ptr [0x36e6] ; PUSH_GLOBAL
001CB5  FF 36 C0 36           PUSH   word ptr [0x36c0] ; PUSH_GLOBAL
001CB9  FF 36 BE 36           PUSH   word ptr [0x36be] ; PUSH_GLOBAL
001CBD  9A 32 01 7D 03        LCALL  0x37d, 0x132 ; LCALL
001CC2  8B E5                 MOV    sp, bp ; MOV
001CC4  83 3E 70 45 00        CMP    word ptr [0x4570], 0 ; CMP
001CC9  74 05                 JE     0x1cd0 ; CJUMP
001CCB  9A 11 00 35 07        LCALL  0x735, 0x11 ; LCALL
001CD0  C9                    LEAVE ; EPILOGUE
001CD1  CB                    RETF ; RETURN
