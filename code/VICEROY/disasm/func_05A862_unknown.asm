; ============================================================================
; func_05A862_unknown
; Region   : overlay
; Bytes    : file 0x05A862..0x05A8A1  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05A862  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
05A866  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
05A86B  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
05A86E  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
05A871  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05A874  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
05A879  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05A87C  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
05A880  80 BF 46 31 05        CMP    byte ptr [bx + 0x3146], 5 ; CMP
05A885  75 1B                 JNE    0x5a8a2 ; CJUMP
05A887  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05A88A  0E                    PUSH   cs ; STACK_PUSH
05A88B  E8 AF 00              CALL   0x5a93d ; CALL_NEAR
05A88E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05A891  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
05A894  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
05A897  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
05A89A  74 2C                 JE     0x5a8c8 ; CJUMP
05A89C  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
05A89F  C9                    LEAVE ; EPILOGUE
05A8A0  CB                    RETF ; RETURN
