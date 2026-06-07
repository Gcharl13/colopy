; ============================================================================
; func_005DF0_unknown
; Region   : load_image
; Bytes    : file 0x005DF0..0x005E18  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005DF0  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
005DF4  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005DF7  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005DFA  0E                    PUSH   cs ; STACK_PUSH
005DFB  E8 9E FF              CALL   0x5d9c ; CALL_NEAR
005DFE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005E01  C0 E8 04              SHR    al, 4 ; LOGIC
005E04  2A E4                 SUB    ah, ah ; ARITH
005E06  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
005E09  3D 0F 00              CMP    ax, 0xf ; CMP
005E0C  75 05                 JNE    0x5e13 ; CJUMP
005E0E  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
005E13  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
005E16  C9                    LEAVE ; EPILOGUE
005E17  CB                    RETF ; RETURN
