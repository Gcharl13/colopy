; ============================================================================
; func_06C7DA_unknown
; Region   : overlay
; Bytes    : file 0x06C7DA..0x06C809  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C7DA  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
06C7DE  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
06C7E3  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06C7E6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06C7E9  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06C7EC  0E                    PUSH   cs ; STACK_PUSH
06C7ED  E8 31 30              CALL   0x6f821 ; CALL_NEAR
06C7F0  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06C7F3  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
06C7F6  0B D0                 OR     dx, ax ; LOGIC
06C7F8  74 0A                 JE     0x6c804 ; CJUMP
06C7FA  C4 5E FA              LES    bx, ptr [bp - 6] ; MOV_FAR
06C7FD  26 8B 47 06           MOV    ax, word ptr es:[bx + 6] ; MOV
06C801  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06C804  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
06C807  C9                    LEAVE ; EPILOGUE
06C808  CB                    RETF ; RETURN
