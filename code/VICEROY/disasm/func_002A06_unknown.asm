; ============================================================================
; func_002A06_unknown
; Region   : load_image
; Bytes    : file 0x002A06..0x002A6E  (104 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002A06  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
002A0A  57                    PUSH   di ; STACK_PUSH
002A0B  56                    PUSH   si ; STACK_PUSH
002A0C  6A 02                 PUSH   2 ; STACK_PUSH
002A0E  8D 46 E8              LEA    ax, [bp - 0x18] ; ADDR
002A11  50                    PUSH   ax ; STACK_PUSH
002A12  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
002A15  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
002A1A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
002A1D  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
002A22  8D 46 E8              LEA    ax, [bp - 0x18] ; ADDR
002A25  50                    PUSH   ax ; STACK_PUSH
002A26  9A 42 08 1D 0D        LCALL  0xd1d, 0x842 ; LCALL
002A2B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
002A2E  8B F8                 MOV    di, ax ; MOV
002A30  B8 08 00              MOV    ax, 8 ; MOV
002A33  2B C7                 SUB    ax, di ; ARITH
002A35  0B C0                 OR     ax, ax ; LOGIC
002A37  7E 1E                 JLE    0x2a57 ; CJUMP
002A39  BE 08 00              MOV    si, 8 ; MOV
002A3C  2B F7                 SUB    si, di ; ARITH
002A3E  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
002A41  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
002A44  1E                    PUSH   ds ; STACK_PUSH
002A45  68 6C 00              PUSH   0x6c ; PUSH_CONST
002A48  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002A4B  57                    PUSH   di ; STACK_PUSH
002A4C  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
002A51  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
002A54  4E                    DEC    si ; ARITH
002A55  75 ED                 JNE    0x2a44 ; CJUMP
002A57  8D 46 E8              LEA    ax, [bp - 0x18] ; ADDR
002A5A  16                    PUSH   ss ; STACK_PUSH
002A5B  50                    PUSH   ax ; STACK_PUSH
002A5C  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002A5F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002A62  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
002A67  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
002A6A  5E                    POP    si ; STACK_POP
002A6B  5F                    POP    di ; STACK_POP
002A6C  C9                    LEAVE ; EPILOGUE
002A6D  CB                    RETF ; RETURN
