; ============================================================================
; func_06C77A_unknown
; Region   : overlay
; Bytes    : file 0x06C77A..0x06C7A0  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C77A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
06C77E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06C781  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06C784  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06C787  0E                    PUSH   cs ; STACK_PUSH
06C788  E8 96 30              CALL   0x6f821 ; CALL_NEAR
06C78B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06C78E  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
06C791  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
06C795  74 09                 JE     0x6c7a0 ; CJUMP
06C797  C4 5E FC              LES    bx, ptr [bp - 4] ; MOV_FAR
06C79A  26 80 0F 02           OR     byte ptr es:[bx], 2 ; LOGIC
06C79E  C9                    LEAVE ; EPILOGUE
06C79F  CB                    RETF ; RETURN
