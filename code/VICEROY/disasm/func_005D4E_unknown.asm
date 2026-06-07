; ============================================================================
; func_005D4E_unknown
; Region   : load_image
; Bytes    : file 0x005D4E..0x005D76  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005D4E  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
005D52  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005D55  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005D58  0E                    PUSH   cs ; STACK_PUSH
005D59  E8 BE FF              CALL   0x5d1a ; CALL_NEAR
005D5C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005D5F  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
005D62  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
005D65  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
005D69  74 0B                 JE     0x5d76 ; CJUMP
005D6B  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
005D6E  C4 5E FC              LES    bx, ptr [bp - 4] ; MOV_FAR
005D71  26 08 07              OR     byte ptr es:[bx], al ; LOGIC
005D74  C9                    LEAVE ; EPILOGUE
005D75  CB                    RETF ; RETURN
