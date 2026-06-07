; ============================================================================
; func_06F698_unknown
; Region   : overlay
; Bytes    : file 0x06F698..0x06F6D9  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F698  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
06F69C  52                    PUSH   dx ; STACK_PUSH
06F69D  50                    PUSH   ax ; STACK_PUSH
06F69E  53                    PUSH   bx ; STACK_PUSH
06F69F  57                    PUSH   di ; STACK_PUSH
06F6A0  56                    PUSH   si ; STACK_PUSH
06F6A1  6A 0A                 PUSH   0xa ; PUSH_CONST
06F6A3  8D 4E EC              LEA    cx, [bp - 0x14] ; ADDR
06F6A6  51                    PUSH   cx ; STACK_PUSH
06F6A7  52                    PUSH   dx ; STACK_PUSH
06F6A8  8B F0                 MOV    si, ax ; MOV
06F6AA  8B FB                 MOV    di, bx ; MOV
06F6AC  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
06F6B1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06F6B4  6A 05                 PUSH   5 ; STACK_PUSH
06F6B6  8B C6                 MOV    ax, si ; MOV
06F6B8  8B DF                 MOV    bx, di ; MOV
06F6BA  8D 56 EC              LEA    dx, [bp - 0x14] ; ADDR
06F6BD  0E                    PUSH   cs ; STACK_PUSH
06F6BE  E8 33 01              CALL   0x6f7f4 ; CALL_NEAR
06F6C1  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
06F6C4  68 20 98              PUSH   0x9820 ; PUSH_CONST
06F6C7  9A F6 08 1D 0D        LCALL  0xd1d, 0x8f6 ; LCALL
06F6CC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06F6CF  A3 C8 9C              MOV    word ptr [0x9cc8], ax ; GLOBAL_LOAD
06F6D2  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
06F6D5  5E                    POP    si ; STACK_POP
06F6D6  5F                    POP    di ; STACK_POP
06F6D7  C9                    LEAVE ; EPILOGUE
06F6D8  CB                    RETF ; RETURN
