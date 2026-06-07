; ============================================================================
; func_00965C_unknown
; Region   : load_image
; Bytes    : file 0x00965C..0x009691  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00965C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
009660  2B C0                 SUB    ax, ax ; ARITH
009662  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
009665  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
009668  EB 15                 JMP    0x967f ; JUMP
00966A  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00966D  0E                    PUSH   cs ; STACK_PUSH
00966E  E8 91 FA              CALL   0x9102 ; CALL_NEAR
009671  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
009674  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
009677  75 03                 JNE    0x967c ; CJUMP
009679  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
00967C  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
00967F  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
009683  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
009686  98                    CWDE ; ARITH
009687  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
00968A  7F DE                 JG     0x966a ; CJUMP
00968C  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00968F  C9                    LEAVE ; EPILOGUE
009690  CB                    RETF ; RETURN
