; ============================================================================
; func_071350_unknown
; Region   : overlay
; Bytes    : file 0x071350..0x0713D3  (131 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

071350  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
071354  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
071359  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
07135C  A3 3A 85              MOV    word ptr [0x853a], ax ; GLOBAL_LOAD
07135F  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
071362  89 0E 3C 85           MOV    word ptr [0x853c], cx ; GLOBAL_LOAD
071366  8B D8                 MOV    bx, ax ; MOV
071368  8B C1                 MOV    ax, cx ; MOV
07136A  F7 EB                 IMUL   bx ; ARITH
07136C  A3 A4 85              MOV    word ptr [0x85a4], ax ; GLOBAL_LOAD
07136F  89 16 A6 85           MOV    word ptr [0x85a6], dx ; GLOBAL_LOAD
071373  0E                    PUSH   cs ; STACK_PUSH
071374  E8 05 01              CALL   0x7147c ; CALL_NEAR
071377  0B C0                 OR     ax, ax ; LOGIC
071379  75 53                 JNE    0x713ce ; CJUMP
07137B  39 06 5A 01           CMP    word ptr [0x15a], ax ; CMP
07137F  75 3F                 JNE    0x713c0 ; CJUMP
071381  FF 36 A4 85           PUSH   word ptr [0x85a4] ; PUSH_GLOBAL
071385  6A 19                 PUSH   0x19 ; PUSH_CONST
071387  FF 36 5E 01           PUSH   word ptr [0x15e] ; PUSH_GLOBAL
07138B  FF 36 5C 01           PUSH   word ptr [0x15c] ; PUSH_GLOBAL
07138F  9A FA 11 1D 0D        LCALL  0xd1d, 0x11fa ; LCALL
071394  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
071397  FF 36 A4 85           PUSH   word ptr [0x85a4] ; PUSH_GLOBAL
07139B  6A 00                 PUSH   0 ; STACK_PUSH
07139D  FF 36 62 01           PUSH   word ptr [0x162] ; PUSH_GLOBAL
0713A1  FF 36 60 01           PUSH   word ptr [0x160] ; PUSH_GLOBAL
0713A5  9A FA 11 1D 0D        LCALL  0xd1d, 0x11fa ; LCALL
0713AA  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0713AD  FF 36 A4 85           PUSH   word ptr [0x85a4] ; PUSH_GLOBAL
0713B1  6A 00                 PUSH   0 ; STACK_PUSH
0713B3  FF 36 66 01           PUSH   word ptr [0x166] ; PUSH_GLOBAL
0713B7  FF 36 64 01           PUSH   word ptr [0x164] ; PUSH_GLOBAL
0713BB  9A FA 11 1D 0D        LCALL  0xd1d, 0x11fa ; LCALL
0713C0  2B C0                 SUB    ax, ax ; ARITH
0713C2  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0713C5  A3 58 01              MOV    word ptr [0x158], ax ; GLOBAL_LOAD
0713C8  C7 06 52 01 04 00     MOV    word ptr [0x152], 4 ; GLOBAL_LOAD
0713CE  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0713D1  C9                    LEAVE ; EPILOGUE
0713D2  CB                    RETF ; RETURN
