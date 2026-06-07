; ============================================================================
; func_035AD0_unknown
; Region   : overlay
; Bytes    : file 0x035AD0..0x035B06  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

035AD0  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
035AD4  A0 A7 0F              MOV    al, byte ptr [0xfa7] ; GLOBAL_LOAD
035AD7  88 46 FE              MOV    byte ptr [bp - 2], al ; LOCAL_STORE
035ADA  C6 06 A7 0F 00        MOV    byte ptr [0xfa7], 0 ; GLOBAL_LOAD
035ADF  0E                    PUSH   cs ; STACK_PUSH
035AE0  E8 70 0E              CALL   0x36953 ; CALL_NEAR
035AE3  80 3E A7 0F 00        CMP    byte ptr [0xfa7], 0 ; CMP
035AE8  75 0E                 JNE    0x35af8 ; CJUMP
035AEA  80 7E FE 00           CMP    byte ptr [bp - 2], 0 ; CMP
035AEE  74 08                 JE     0x35af8 ; CJUMP
035AF0  6A 01                 PUSH   1 ; STACK_PUSH
035AF2  E8 BF B5              CALL   0x310b4 ; CALL_NEAR
035AF5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
035AF8  80 3E A7 0F 00        CMP    byte ptr [0xfa7], 0 ; CMP
035AFD  75 05                 JNE    0x35b04 ; CJUMP
035AFF  C6 06 A6 0F FE        MOV    byte ptr [0xfa6], 0xfe ; GLOBAL_LOAD
035B04  C9                    LEAVE ; EPILOGUE
035B05  C3                    RET ; RETURN
