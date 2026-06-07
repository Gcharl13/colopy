; ============================================================================
; func_041C00_unknown
; Region   : overlay
; Bytes    : file 0x041C00..0x041C64  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041C00  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
041C04  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
041C07  03 06 94 53           ADD    ax, word ptr [0x5394] ; ARITH
041C0B  8B D0                 MOV    dx, ax ; MOV
041C0D  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
041C12  EB 47                 JMP    0x41c5b ; JUMP
041C14  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
041C17  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
041C1C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
041C1F  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c ; ARITH
041C23  80 BF 5A 31 00        CMP    byte ptr [bx + 0x315a], 0 ; CMP
041C28  74 04                 JE     0x41c2e ; CJUMP
041C2A  FE 8F 5A 31           DEC    byte ptr [bx + 0x315a] ; ARITH
041C2E  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c ; ARITH
041C32  80 BF 5A 31 00        CMP    byte ptr [bx + 0x315a], 0 ; CMP
041C37  75 1F                 JNE    0x41c58 ; CJUMP
041C39  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
041C3C  03 06 94 53           ADD    ax, word ptr [0x5394] ; ARITH
041C40  50                    PUSH   ax ; STACK_PUSH
041C41  50                    PUSH   ax ; STACK_PUSH
041C42  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
041C45  9A 80 08 1F 18        LCALL  0x181f, 0x880 ; THUNK -> 0x0427:0x0362 (thunk @file 0x01AE70 type B) overlay @file 0x031076
041C4A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
041C4D  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
041C50  9A C6 08 1F 18        LCALL  0x181f, 0x8c6 ; THUNK -> 0x0427:0x03A0 (thunk @file 0x01AEB6 type B) overlay @file 0x0310B4
041C55  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
041C58  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
041C5B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
041C5E  0B C0                 OR     ax, ax ; LOGIC
041C60  7D B2                 JGE    0x41c14 ; CJUMP
041C62  C9                    LEAVE ; EPILOGUE
041C63  CB                    RETF ; RETURN
