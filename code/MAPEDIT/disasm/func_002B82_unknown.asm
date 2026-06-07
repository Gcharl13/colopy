; ============================================================================
; func_002B82_unknown
; Region   : load_image
; Bytes    : file 0x002B82..0x002BCB  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002B82  55                    PUSH   bp ; STACK_PUSH
002B83  8B EC                 MOV    bp, sp ; MOV
002B85  56                    PUSH   si ; STACK_PUSH
002B86  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
002B89  8B C6                 MOV    ax, si ; MOV
002B8B  0B C0                 OR     ax, ax ; LOGIC
002B8D  7D 02                 JGE    0x2b91 ; CJUMP
002B8F  2B C0                 SUB    ax, ax ; ARITH
002B91  8B F0                 MOV    si, ax ; MOV
002B93  3D 03 00              CMP    ax, 3 ; CMP
002B96  7E 03                 JLE    0x2b9b ; CJUMP
002B98  B8 03 00              MOV    ax, 3 ; MOV
002B9B  8B F0                 MOV    si, ax ; MOV
002B9D  89 36 D0 04           MOV    word ptr [0x4d0], si ; GLOBAL_LOAD
002BA1  9A 06 00 47 0A        LCALL  0xa47, 6 ; LCALL
002BA6  6A 00                 PUSH   0 ; STACK_PUSH
002BA8  FF 36 54 4B           PUSH   word ptr [0x4b54] ; PUSH_GLOBAL
002BAC  FF 36 52 4B           PUSH   word ptr [0x4b52] ; PUSH_GLOBAL
002BB0  FF 36 54 4B           PUSH   word ptr [0x4b54] ; PUSH_GLOBAL
002BB4  FF 36 52 4B           PUSH   word ptr [0x4b52] ; PUSH_GLOBAL
002BB8  0E                    PUSH   cs ; STACK_PUSH
002BB9  E8 A2 FE              CALL   0x2a5e ; CALL_NEAR
002BBC  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
002BBF  0B C0                 OR     ax, ax ; LOGIC
002BC1  75 05                 JNE    0x2bc8 ; CJUMP
002BC3  9A 68 00 A2 08        LCALL  0x8a2, 0x68 ; LCALL
002BC8  5E                    POP    si ; STACK_POP
002BC9  C9                    LEAVE ; EPILOGUE
002BCA  CB                    RETF ; RETURN
