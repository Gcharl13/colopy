; ============================================================================
; func_040FD6_unknown
; Region   : overlay
; Bytes    : file 0x040FD6..0x04101C  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040FD6  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
040FDA  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
040FDF  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
040FE2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
040FE5  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
040FEA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
040FED  3D 19 00              CMP    ax, 0x19 ; CMP
040FF0  74 05                 JE     0x40ff7 ; CJUMP
040FF2  3D 1A 00              CMP    ax, 0x1a ; CMP
040FF5  75 20                 JNE    0x41017 ; CJUMP
040FF7  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
040FFA  3D 1A 00              CMP    ax, 0x1a ; CMP
040FFD  74 18                 JE     0x41017 ; CJUMP
040FFF  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
041002  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
041005  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
041008  9A 18 07 1F 18        LCALL  0x181f, 0x718 ; THUNK -> 0x037F:0x04B0 (thunk @file 0x01AD08 type B) overlay @file 0x02EFEC
04100D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041010  40                    INC    ax ; ARITH
041011  74 04                 JE     0x41017 ; CJUMP
041013  83 46 FE 03           ADD    word ptr [bp - 2], 3 ; ARITH
041017  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
04101A  C9                    LEAVE ; EPILOGUE
04101B  CB                    RETF ; RETURN
