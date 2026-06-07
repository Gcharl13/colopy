; ============================================================================
; func_005DCC_unknown
; Region   : load_image
; Bytes    : file 0x005DCC..0x005DF0  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005DCC  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
005DD0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005DD3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005DD6  0E                    PUSH   cs ; STACK_PUSH
005DD7  E8 AA FF              CALL   0x5d84 ; CALL_NEAR
005DDA  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
005DDD  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
005DE0  C4 5E FC              LES    bx, ptr [bp - 4] ; MOV_FAR
005DE3  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
005DE6  32 46 0A              XOR    al, byte ptr [bp + 0xa] ; LOGIC
005DE9  24 0F                 AND    al, 0xf ; LOGIC
005DEB  26 30 07              XOR    byte ptr es:[bx], al ; LOGIC
005DEE  C9                    LEAVE ; EPILOGUE
005DEF  CB                    RETF ; RETURN
