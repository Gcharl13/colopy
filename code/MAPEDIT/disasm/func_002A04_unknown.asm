; ============================================================================
; func_002A04_unknown
; Region   : load_image
; Bytes    : file 0x002A04..0x002A26  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002A04  55                    PUSH   bp ; STACK_PUSH
002A05  8B EC                 MOV    bp, sp ; MOV
002A07  57                    PUSH   di ; STACK_PUSH
002A08  56                    PUSH   si ; STACK_PUSH
002A09  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
002A0C  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
002A0F  56                    PUSH   si ; STACK_PUSH
002A10  57                    PUSH   di ; STACK_PUSH
002A11  9A 0E 00 AB 02        LCALL  0x2ab, 0xe ; LCALL
002A16  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
002A19  0B C0                 OR     ax, ax ; LOGIC
002A1B  74 3D                 JE     0x2a5a ; CJUMP
002A1D  89 3E C8 04           MOV    word ptr [0x4c8], di ; GLOBAL_LOAD
002A21  89 36 CA 04           MOV    word ptr [0x4ca], si ; GLOBAL_LOAD
002A25  83                    DB     0x83 ; DATA_BYTE
