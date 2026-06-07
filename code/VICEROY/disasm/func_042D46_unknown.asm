; ============================================================================
; func_042D46_unknown
; Region   : overlay
; Bytes    : file 0x042D46..0x042DA5  (95 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042D46  C8 50 00 00           ENTER  0x50, 0 ; PROLOGUE
042D4A  56                    PUSH   si ; STACK_PUSH
042D4B  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
042D4F  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
042D52  50                    PUSH   ax ; STACK_PUSH
042D53  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
042D58  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
042D5B  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
042D5E  D1 E3                 SHL    bx, 1 ; LOGIC
042D60  FF B7 B0 2D           PUSH   word ptr [bx + 0x2db0] ; PUSH_GLOBAL
042D64  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
042D67  50                    PUSH   ax ; STACK_PUSH
042D68  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
042D6D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
042D70  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
042D73  50                    PUSH   ax ; STACK_PUSH
042D74  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
042D79  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
042D7C  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
042D7F  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
042D81  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
042D84  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
042D86  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
042D89  16                    PUSH   ss ; STACK_PUSH
042D8A  50                    PUSH   ax ; STACK_PUSH
042D8B  9A 32 01 1F 18        LCALL  0x181f, 0x132 ; THUNK -> 0x004B:0x024E (thunk @file 0x01A722 type B) overlay @file 0x0605F6
042D90  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
042D93  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
042D97  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
042D9A  2A E4                 SUB    ah, ah ; ARITH
042D9C  40                    INC    ax ; ARITH
042D9D  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
042DA0  01 07                 ADD    word ptr [bx], ax ; ARITH
042DA2  5E                    POP    si ; STACK_POP
042DA3  C9                    LEAVE ; EPILOGUE
042DA4  CB                    RETF ; RETURN
