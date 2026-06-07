; ============================================================================
; func_06F6DA_unknown
; Region   : overlay
; Bytes    : file 0x06F6DA..0x06F7E9  (271 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F6DA  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
06F6DE  B8 01 00              MOV    ax, 1 ; MOV
06F6E1  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
06F6E4  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
06F6E7  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
06F6EA  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06F6ED  8C 56 F8              MOV    word ptr [bp - 8], ss ; LOCAL_STORE
06F6F0  8D 1E 0A 20           LEA    bx, [0x200a] ; ADDR
06F6F4  2B C0                 SUB    ax, ax ; ARITH
06F6F6  9A 72 03 1F 1A        LCALL  0x1a1f, 0x372 ; THUNK -> 0x0000:0x0002 (thunk @file 0x01C962 type A) overlay @file 0x025902
06F6FB  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06F6FE  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
06F701  0B D0                 OR     dx, ax ; LOGIC
06F703  75 03                 JNE    0x6f708 ; CJUMP
06F705  E9 DF 00              JMP    0x6f7e7 ; JUMP
06F708  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06F70B  50                    PUSH   ax ; STACK_PUSH
06F70C  6A 00                 PUSH   0 ; STACK_PUSH
06F70E  B8 01 00              MOV    ax, 1 ; MOV
06F711  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
06F714  2B D2                 SUB    dx, dx ; ARITH
06F716  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06F71B  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
06F71E  2A E4                 SUB    ah, ah ; ARITH
06F720  A3 3C 1F              MOV    word ptr [0x1f3c], ax ; GLOBAL_LOAD
06F723  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06F726  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F729  6A 00                 PUSH   0 ; STACK_PUSH
06F72B  B8 02 00              MOV    ax, 2 ; MOV
06F72E  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
06F731  2B D2                 SUB    dx, dx ; ARITH
06F733  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06F738  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
06F73B  2A E4                 SUB    ah, ah ; ARITH
06F73D  A3 3E 1F              MOV    word ptr [0x1f3e], ax ; GLOBAL_LOAD
06F740  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06F743  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F746  6A 00                 PUSH   0 ; STACK_PUSH
06F748  B8 03 00              MOV    ax, 3 ; MOV
06F74B  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
06F74E  2B D2                 SUB    dx, dx ; ARITH
06F750  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06F755  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
06F758  2A E4                 SUB    ah, ah ; ARITH
06F75A  A3 40 1F              MOV    word ptr [0x1f40], ax ; GLOBAL_LOAD
06F75D  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06F760  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F763  6A 00                 PUSH   0 ; STACK_PUSH
06F765  B8 04 00              MOV    ax, 4 ; MOV
06F768  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
06F76B  2B D2                 SUB    dx, dx ; ARITH
06F76D  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06F772  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
06F775  2A E4                 SUB    ah, ah ; ARITH
06F777  A3 42 1F              MOV    word ptr [0x1f42], ax ; GLOBAL_LOAD
06F77A  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06F77D  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F780  6A 00                 PUSH   0 ; STACK_PUSH
06F782  B8 05 00              MOV    ax, 5 ; MOV
06F785  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
06F788  2B D2                 SUB    dx, dx ; ARITH
06F78A  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06F78F  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
06F792  2A E4                 SUB    ah, ah ; ARITH
06F794  A3 4A 1F              MOV    word ptr [0x1f4a], ax ; GLOBAL_LOAD
06F797  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06F79A  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F79D  6A 00                 PUSH   0 ; STACK_PUSH
06F79F  B8 06 00              MOV    ax, 6 ; MOV
06F7A2  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
06F7A5  2B D2                 SUB    dx, dx ; ARITH
06F7A7  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06F7AC  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
06F7AF  2A E4                 SUB    ah, ah ; ARITH
06F7B1  A3 4E 1F              MOV    word ptr [0x1f4e], ax ; GLOBAL_LOAD
06F7B4  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06F7B7  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F7BA  6A 00                 PUSH   0 ; STACK_PUSH
06F7BC  B8 07 00              MOV    ax, 7 ; MOV
06F7BF  8D 5E F2              LEA    bx, [bp - 0xe] ; ADDR
06F7C2  2B D2                 SUB    dx, dx ; ARITH
06F7C4  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06F7C9  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
06F7CC  2A E4                 SUB    ah, ah ; ARITH
06F7CE  A3 4C 1F              MOV    word ptr [0x1f4c], ax ; GLOBAL_LOAD
06F7D1  68 00 A0              PUSH   0xa000 ; PUSH_CONST
06F7D4  68 00 FC              PUSH   0xfc00 ; PUSH_CONST
06F7D7  9A F4 03 1F 18        LCALL  0x181f, 0x3f4 ; THUNK -> 0x0ADE:0x0004 (thunk @file 0x01A9E4 type B)
06F7DC  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06F7DF  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06F7E2  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
06F7E7  C9                    LEAVE ; EPILOGUE
06F7E8  CB                    RETF ; RETURN
