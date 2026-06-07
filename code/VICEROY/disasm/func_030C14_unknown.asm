; ============================================================================
; func_030C14_unknown
; Region   : overlay
; Bytes    : file 0x030C14..0x030C67  (83 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030C14  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
030C18  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
030C1B  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
030C1E  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
030C21  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
030C24  2D 14 00              SUB    ax, 0x14 ; ARITH
030C27  8B D0                 MOV    dx, ax ; MOV
030C29  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
030C2E  EB 2B                 JMP    0x30c5b ; JUMP
030C30  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c ; ARITH
030C34  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
030C39  72 07                 JB     0x30c42 ; CJUMP
030C3B  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
030C40  76 11                 JBE    0x30c53 ; CJUMP
030C42  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
030C45  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
030C48  39 46 FA              CMP    word ptr [bp - 6], ax ; CMP
030C4B  75 06                 JNE    0x30c53 ; CJUMP
030C4D  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
030C50  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
030C53  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
030C56  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
030C5B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
030C5E  0B C0                 OR     ax, ax ; LOGIC
030C60  7D CE                 JGE    0x30c30 ; CJUMP
030C62  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
030C65  C9                    LEAVE ; EPILOGUE
030C66  CB                    RETF ; RETURN
