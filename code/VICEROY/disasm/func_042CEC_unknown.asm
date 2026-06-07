; ============================================================================
; func_042CEC_unknown
; Region   : overlay
; Bytes    : file 0x042CEC..0x042D45  (89 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042CEC  C8 50 00 00           ENTER  0x50, 0 ; PROLOGUE
042CF0  56                    PUSH   si ; STACK_PUSH
042CF1  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
042CF5  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
042CF8  50                    PUSH   ax ; STACK_PUSH
042CF9  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
042CFE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
042D01  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
042D04  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
042D07  50                    PUSH   ax ; STACK_PUSH
042D08  9A E6 01 1F 18        LCALL  0x181f, 0x1e6 ; THUNK -> 0x004B:0x0478 (thunk @file 0x01A7D6 type B) overlay @file 0x060820
042D0D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
042D10  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
042D13  50                    PUSH   ax ; STACK_PUSH
042D14  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
042D19  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
042D1C  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
042D1F  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
042D21  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
042D24  FF 34                 PUSH   word ptr [si] ; STACK_PUSH
042D26  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
042D29  16                    PUSH   ss ; STACK_PUSH
042D2A  50                    PUSH   ax ; STACK_PUSH
042D2B  9A 32 01 1F 18        LCALL  0x181f, 0x132 ; THUNK -> 0x004B:0x024E (thunk @file 0x01A722 type B) overlay @file 0x0605F6
042D30  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
042D33  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
042D37  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
042D3A  2A E4                 SUB    ah, ah ; ARITH
042D3C  40                    INC    ax ; ARITH
042D3D  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
042D40  01 07                 ADD    word ptr [bx], ax ; ARITH
042D42  5E                    POP    si ; STACK_POP
042D43  C9                    LEAVE ; EPILOGUE
042D44  CB                    RETF ; RETURN
