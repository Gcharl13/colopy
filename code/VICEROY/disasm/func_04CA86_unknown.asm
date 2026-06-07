; ============================================================================
; func_04CA86_unknown
; Region   : overlay
; Bytes    : file 0x04CA86..0x04CAF5  (111 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04CA86  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
04CA8A  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
04CA8F  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
04CA93  7C 55                 JL     0x4caea ; CJUMP
04CA95  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
04CA99  74 55                 JE     0x4caf0 ; CJUMP
04CA9B  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04CAA0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04CAA3  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
04CAA6  2D 04 00              SUB    ax, 4 ; ARITH
04CAA9  50                    PUSH   ax ; STACK_PUSH
04CAAA  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
04CAAF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04CAB2  3D 4B 00              CMP    ax, 0x4b ; CMP
04CAB5  7C 05                 JL     0x4cabc ; CJUMP
04CAB7  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
04CABC  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
04CAC0  7C 22                 JL     0x4cae4 ; CJUMP
04CAC2  6B 5E 0C 1C           IMUL   bx, word ptr [bp + 0xc], 0x1c ; ARITH
04CAC6  8A 87 4A 31           MOV    al, byte ptr [bx + 0x314a] ; MOV
04CACA  98                    CWDE ; ARITH
04CACB  8B D8                 MOV    bx, ax ; MOV
04CACD  C1 E3 03              SHL    bx, 3 ; LOGIC
04CAD0  03 D8                 ADD    bx, ax ; ARITH
04CAD2  03 5E 06              ADD    bx, word ptr [bp + 6] ; ARITH
04CAD5  D1 E3                 SHL    bx, 1 ; LOGIC
04CAD7  81 BF F6 54 80 00     CMP    word ptr [bx + 0x54f6], 0x80 ; CMP
04CADD  7C 05                 JL     0x4cae4 ; CJUMP
04CADF  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
04CAE4  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
04CAE8  74 06                 JE     0x4caf0 ; CJUMP
04CAEA  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
04CAED  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
04CAF0  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
04CAF3  C9                    LEAVE ; EPILOGUE
04CAF4  CB                    RETF ; RETURN
