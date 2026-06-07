; ============================================================================
; func_060FBC_unknown
; Region   : overlay
; Bytes    : file 0x060FBC..0x061016  (90 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "TRADESELECT"  (auto-named via string xrefs)
; ============================================================================

060FBC  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
060FC0  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
060FC4  7D 1B                 JGE    0x60fe1 ; CJUMP
060FC6  68 5D 1D              PUSH   0x1d5d                       ; STRING: "TRADESELECT"
060FC9  A0 69 1D              MOV    al, byte ptr [0x1d69] ; GLOBAL_LOAD
060FCC  98                    CWDE ; ARITH
060FCD  50                    PUSH   ax ; STACK_PUSH
060FCE  6A 00                 PUSH   0 ; STACK_PUSH
060FD0  0E                    PUSH   cs ; STACK_PUSH
060FD1  E8 21 04              CALL   0x613f5 ; CALL_NEAR
060FD4  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
060FD7  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
060FDA  0B C0                 OR     ax, ax ; LOGIC
060FDC  7D 03                 JGE    0x60fe1 ; CJUMP
060FDE  E9 CC 00              JMP    0x610ad ; JUMP
060FE1  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
060FE4  A2 69 1D              MOV    byte ptr [0x1d69], al ; GLOBAL_LOAD
060FE7  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
060FEA  0E                    PUSH   cs ; STACK_PUSH
060FEB  E8 02 04              CALL   0x613f0 ; CALL_NEAR
060FEE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060FF1  6A 00                 PUSH   0 ; STACK_PUSH
060FF3  0E                    PUSH   cs ; STACK_PUSH
060FF4  E8 12 04              CALL   0x61409 ; CALL_NEAR
060FF7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060FFA  C4 1E 18 9E           LES    bx, ptr [0x9e18] ; MOV_FAR
060FFE  26 81 3F E7 03        CMP    word ptr es:[bx], 0x3e7 ; CMP
061003  75 0B                 JNE    0x61010 ; CJUMP
061005  A1 94 53              MOV    ax, word ptr [0x5394] ; GLOBAL_LOAD
061008  2D 14 00              SUB    ax, 0x14 ; ARITH
06100B  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06100E  EB 12                 JMP    0x61022 ; JUMP
061010  26 69 1F CA 00        IMUL   bx, word ptr es:[bx], 0xca ; ARITH
061015  8A                    DB     0x8A ; DATA_BYTE
