; ============================================================================
; func_0129FC_unknown
; Region   : load_image
; Bytes    : file 0x0129FC..0x012A35  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0129FC  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
012A00  57                    PUSH   di ; STACK_PUSH
012A01  56                    PUSH   si ; STACK_PUSH
012A02  8B F8                 MOV    di, ax ; MOV
012A04  C6 46 FF 4E           MOV    byte ptr [bp - 1], 0x4e ; LOCAL_STORE
012A08  2B D2                 SUB    dx, dx ; ARITH
012A0A  BE F0 26              MOV    si, 0x26f0 ; CONST_LOAD
012A0D  8B 4E FC              MOV    cx, word ptr [bp - 4] ; LOCAL_LOAD
012A10  81 FE 70 27           CMP    si, 0x2770 ; CMP
012A14  73 18                 JAE    0x12a2e ; CJUMP
012A16  8A 04                 MOV    al, byte ptr [si] ; MOV
012A18  2A E4                 SUB    ah, ah ; ARITH
012A1A  3B C7                 CMP    ax, di ; CMP
012A1C  75 09                 JNE    0x12a27 ; CJUMP
012A1E  BA FF FF              MOV    dx, 0xffff ; CONST_LOAD
012A21  8A 44 06              MOV    al, byte ptr [si + 6] ; MOV
012A24  88 46 FF              MOV    byte ptr [bp - 1], al ; LOCAL_STORE
012A27  83 C6 08              ADD    si, 8 ; ARITH
012A2A  0B D2                 OR     dx, dx ; LOGIC
012A2C  74 E2                 JE     0x12a10 ; CJUMP
012A2E  8A 46 FF              MOV    al, byte ptr [bp - 1] ; LOCAL_LOAD
012A31  5E                    POP    si ; STACK_POP
012A32  5F                    POP    di ; STACK_POP
012A33  C9                    LEAVE ; EPILOGUE
012A34  CB                    RETF ; RETURN
