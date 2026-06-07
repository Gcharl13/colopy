; ============================================================================
; func_059B3E_unknown
; Region   : overlay
; Bytes    : file 0x059B3E..0x059B8F  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

059B3E  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
059B42  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
059B45  9A 0C 09 1F 18        LCALL  0x181f, 0x90c ; THUNK -> 0x0427:0x065A (thunk @file 0x01AEFC type B) overlay @file 0x03136E
059B4A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
059B4D  2A E4                 SUB    ah, ah ; ARITH
059B4F  05 03 00              ADD    ax, 3 ; ARITH
059B52  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
059B55  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
059B59  80 BF 46 31 10        CMP    byte ptr [bx + 0x3146], 0x10 ; CMP
059B5E  75 03                 JNE    0x59b63 ; CJUMP
059B60  D1 66 FE              SHL    word ptr [bp - 2], 1 ; LOGIC
059B63  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
059B67  80 BF 46 31 0F        CMP    byte ptr [bx + 0x3146], 0xf ; CMP
059B6C  75 04                 JNE    0x59b72 ; CJUMP
059B6E  83 46 FE 03           ADD    word ptr [bp - 2], 3 ; ARITH
059B72  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
059B76  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150] ; MOV
059B7A  2A E4                 SUB    ah, ah ; ARITH
059B7C  C1 E0 02              SHL    ax, 2 ; LOGIC
059B7F  29 46 FE              SUB    word ptr [bp - 2], ax ; ARITH
059B82  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
059B85  3D 01 00              CMP    ax, 1 ; CMP
059B88  7D 03                 JGE    0x59b8d ; CJUMP
059B8A  B8 01 00              MOV    ax, 1 ; MOV
059B8D  C9                    LEAVE ; EPILOGUE
059B8E  CB                    RETF ; RETURN
