; ============================================================================
; func_06C74A_unknown
; Region   : overlay
; Bytes    : file 0x06C74A..0x06C770  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C74A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
06C74E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06C751  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06C754  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06C757  0E                    PUSH   cs ; STACK_PUSH
06C758  E8 C6 30              CALL   0x6f821 ; CALL_NEAR
06C75B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06C75E  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
06C761  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
06C765  74 09                 JE     0x6c770 ; CJUMP
06C767  C4 5E FC              LES    bx, ptr [bp - 4] ; MOV_FAR
06C76A  26 80 0F 01           OR     byte ptr es:[bx], 1 ; LOGIC
06C76E  C9                    LEAVE ; EPILOGUE
06C76F  CB                    RETF ; RETURN
