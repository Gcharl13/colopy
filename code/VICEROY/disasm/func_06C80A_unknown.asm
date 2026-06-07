; ============================================================================
; func_06C80A_unknown
; Region   : overlay
; Bytes    : file 0x06C80A..0x06C831  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C80A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
06C80E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06C811  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06C814  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06C817  0E                    PUSH   cs ; STACK_PUSH
06C818  E8 06 30              CALL   0x6f821 ; CALL_NEAR
06C81B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06C81E  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
06C821  0B D0                 OR     dx, ax ; LOGIC
06C823  74 0A                 JE     0x6c82f ; CJUMP
06C825  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
06C828  C4 5E FC              LES    bx, ptr [bp - 4] ; MOV_FAR
06C82B  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
06C82F  C9                    LEAVE ; EPILOGUE
06C830  CB                    RETF ; RETURN
