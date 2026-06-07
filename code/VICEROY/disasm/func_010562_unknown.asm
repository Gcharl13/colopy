; ============================================================================
; func_010562_unknown
; Region   : load_image
; Bytes    : file 0x010562..0x010582  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010562  55                    PUSH   bp ; STACK_PUSH
010563  8B EC                 MOV    bp, sp ; MOV
010565  53                    PUSH   bx ; STACK_PUSH
010566  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
010569  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
01056C  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
01056F  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
010572  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
010574  0E                    PUSH   cs ; STACK_PUSH
010575  E8 1E FF              CALL   0x10496 ; CALL_NEAR
010578  89 57 02              MOV    word ptr [bx + 2], dx ; MOV
01057B  89 07                 MOV    word ptr [bx], ax ; MOV
01057D  5B                    POP    bx ; STACK_POP
01057E  5D                    POP    bp ; STACK_POP
01057F  CA 06 00              RETF   6 ; RETURN
