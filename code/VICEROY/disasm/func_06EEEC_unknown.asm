; ============================================================================
; func_06EEEC_unknown
; Region   : overlay
; Bytes    : file 0x06EEEC..0x06EF3F  (83 bytes)
; Purpose  : Text-template parser ($COUNTRY$/$NUMBER$/$STRING$/$YEAR$ substitution)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; Tagged: "STRING"  (auto-named via string xrefs)
; ============================================================================

06EEEC  C8 2E 00 00           ENTER  0x2e, 0 ; PROLOGUE
06EEF0  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
06EEF3  C6 07 00              MOV    byte ptr [bx], 0 ; MOV
06EEF6  6A 25                 PUSH   0x25 ; PUSH_CONST
06EEF8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06EEFB  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
06EF00  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06EF03  89 46 D4              MOV    word ptr [bp - 0x2c], ax ; LOCAL_STORE
06EF06  0B C0                 OR     ax, ax ; LOGIC
06EF08  74 05                 JE     0x6ef0f ; CJUMP
06EF0A  8B D8                 MOV    bx, ax ; MOV
06EF0C  C6 07 00              MOV    byte ptr [bx], 0 ; MOV
06EF0F  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
06EF12  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
06EF15  74 0C                 JE     0x6ef23 ; CJUMP
06EF17  53                    PUSH   bx ; STACK_PUSH
06EF18  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06EF1B  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
06EF20  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06EF23  83 7E D4 00           CMP    word ptr [bp - 0x2c], 0 ; CMP
06EF27  75 03                 JNE    0x6ef2c ; CJUMP
06EF29  E9 BD 01              JMP    0x6f0e9 ; JUMP
06EF2C  FF 46 D4              INC    word ptr [bp - 0x2c] ; ARITH
06EF2F  8B 46 D4              MOV    ax, word ptr [bp - 0x2c] ; LOCAL_LOAD
06EF32  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
06EF35  6A 06                 PUSH   6 ; STACK_PUSH
06EF37  68 A4 1F              PUSH   0x1fa4                       ; STRING: "STRING"
06EF3A  50                    PUSH   ax ; STACK_PUSH
06EF3B  9A                    DB     0x9A ; DATA_BYTE
06EF3C  C2                    DB     0xC2 ; DATA_BYTE
06EF3D  0C                    DB     0x0C ; DATA_BYTE
06EF3E  1D                    DB     0x1D ; DATA_BYTE
