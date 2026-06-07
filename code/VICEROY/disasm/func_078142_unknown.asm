; ============================================================================
; func_078142_unknown
; Region   : overlay
; Bytes    : file 0x078142..0x078184  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078142  55                    PUSH   bp ; STACK_PUSH
078143  8B EC                 MOV    bp, sp ; MOV
078145  1E                    PUSH   ds ; STACK_PUSH
078146  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
078149  6A 00                 PUSH   0 ; STACK_PUSH
07814B  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
078150  8B E5                 MOV    sp, bp ; MOV
078152  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
078155  99                    CDQ ; ARITH
078156  A3 B0 9C              MOV    word ptr [0x9cb0], ax ; GLOBAL_LOAD
078159  89 16 B2 9C           MOV    word ptr [0x9cb2], dx ; GLOBAL_LOAD
07815D  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
078160  99                    CDQ ; ARITH
078161  A3 B4 9C              MOV    word ptr [0x9cb4], ax ; GLOBAL_LOAD
078164  89 16 B6 9C           MOV    word ptr [0x9cb6], dx ; GLOBAL_LOAD
078168  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
07816B  99                    CDQ ; ARITH
07816C  A3 B8 9C              MOV    word ptr [0x9cb8], ax ; GLOBAL_LOAD
07816F  89 16 BA 9C           MOV    word ptr [0x9cba], dx ; GLOBAL_LOAD
078173  8D 1E BB 25           LEA    bx, [0x25bb] ; ADDR
078177  8D 06 B4 25           LEA    ax, [0x25b4] ; ADDR
07817B  2B D2                 SUB    dx, dx ; ARITH
07817D  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
078182  C9                    LEAVE ; EPILOGUE
078183  CB                    RETF ; RETURN
