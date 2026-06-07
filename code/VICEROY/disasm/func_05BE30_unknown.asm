; ============================================================================
; func_05BE30_unknown
; Region   : overlay
; Bytes    : file 0x05BE30..0x05BE83  (83 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05BE30  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
05BE34  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
05BE37  9A EE 02 1F 18        LCALL  0x181f, 0x2ee ; THUNK -> 0x0427:0x0002 (thunk @file 0x01A8DE type B) overlay @file 0x030D16
05BE3C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
05BE3F  EB 39                 JMP    0x5be7a ; JUMP
05BE41  90                    NOP ; NOP
05BE42  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
05BE47  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
05BE4A  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
05BE4D  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
05BE50  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
05BE53  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05BE56  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05BE59  0E                    PUSH   cs ; STACK_PUSH
05BE5A  E8 C6 28              CALL   0x5e723 ; CALL_NEAR
05BE5D  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
05BE60  0B C0                 OR     ax, ax ; LOGIC
05BE62  74 13                 JE     0x5be77 ; CJUMP
05BE64  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
05BE67  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
05BE6A  7E 03                 JLE    0x5be6f ; CJUMP
05BE6C  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
05BE6F  39 46 08              CMP    word ptr [bp + 8], ax ; CMP
05BE72  7E 03                 JLE    0x5be77 ; CJUMP
05BE74  FF 4E 08              DEC    word ptr [bp + 8] ; ARITH
05BE77  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
05BE7A  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
05BE7D  0B C0                 OR     ax, ax ; LOGIC
05BE7F  7D C1                 JGE    0x5be42 ; CJUMP
05BE81  C9                    LEAVE ; EPILOGUE
05BE82  CB                    RETF ; RETURN
