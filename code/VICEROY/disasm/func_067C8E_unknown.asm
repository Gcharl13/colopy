; ============================================================================
; func_067C8E_unknown
; Region   : overlay
; Bytes    : file 0x067C8E..0x067CF4  (102 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067C8E  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
067C92  50                    PUSH   ax ; STACK_PUSH
067C93  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
067C98  39 16 84 01           CMP    word ptr [0x184], dx ; CMP
067C9C  7F 51                 JG     0x67cef ; CJUMP
067C9E  A1 48 85              MOV    ax, word ptr [0x8548] ; GLOBAL_LOAD
067CA1  F7 D8                 NEG    ax ; ARITH
067CA3  50                    PUSH   ax ; STACK_PUSH
067CA4  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
067CA7  E8 AA FF              CALL   0x67c54 ; CALL_NEAR
067CAA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
067CAD  0B C0                 OR     ax, ax ; LOGIC
067CAF  74 04                 JE     0x67cb5 ; CJUMP
067CB1  83 46 FE 08           ADD    word ptr [bp - 2], 8 ; ARITH
067CB5  FF 36 48 85           PUSH   word ptr [0x8548] ; PUSH_GLOBAL
067CB9  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
067CBC  E8 95 FF              CALL   0x67c54 ; CALL_NEAR
067CBF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
067CC2  0B C0                 OR     ax, ax ; LOGIC
067CC4  74 04                 JE     0x67cca ; CJUMP
067CC6  83 46 FE 04           ADD    word ptr [bp - 2], 4 ; ARITH
067CCA  6A FF                 PUSH   -1 ; STACK_PUSH
067CCC  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
067CCF  E8 82 FF              CALL   0x67c54 ; CALL_NEAR
067CD2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
067CD5  0B C0                 OR     ax, ax ; LOGIC
067CD7  74 04                 JE     0x67cdd ; CJUMP
067CD9  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
067CDD  6A 01                 PUSH   1 ; STACK_PUSH
067CDF  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
067CE2  E8 6F FF              CALL   0x67c54 ; CALL_NEAR
067CE5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
067CE8  0B C0                 OR     ax, ax ; LOGIC
067CEA  74 03                 JE     0x67cef ; CJUMP
067CEC  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
067CEF  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
067CF2  C9                    LEAVE ; EPILOGUE
067CF3  C3                    RET ; RETURN
