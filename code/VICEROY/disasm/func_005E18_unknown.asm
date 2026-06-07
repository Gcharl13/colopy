; ============================================================================
; func_005E18_unknown
; Region   : load_image
; Bytes    : file 0x005E18..0x005E90  (120 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "Illegal entry into village"  (auto-named via string xrefs)
; ============================================================================

005E18  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
005E1C  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4 ; CMP
005E20  7D 49                 JGE    0x5e6b ; CJUMP
005E22  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005E25  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005E28  0E                    PUSH   cs ; STACK_PUSH
005E29  E8 56 01              CALL   0x5f82 ; CALL_NEAR
005E2C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005E2F  0B C0                 OR     ax, ax ; LOGIC
005E31  7C 38                 JL     0x5e6b ; CJUMP
005E33  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005E36  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005E39  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
005E3C  68 CC 01              PUSH   0x1cc                        ; STRING: "Illegal entry into village"
005E3F  9A 7E 07 1F 18        LCALL  0x181f, 0x77e ; THUNK -> 0x0000:0x00E2 (thunk @file 0x01AD6E type A) overlay @file 0x0259E2
005E44  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
005E47  6A 05                 PUSH   5 ; STACK_PUSH
005E49  9A B6 05 1F 18        LCALL  0x181f, 0x5b6 ; THUNK -> 0x0000:0x0034 (thunk @file 0x01ABA6 type A) overlay @file 0x025934
005E4E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
005E51  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005E54  99                    CDQ ; ARITH
005E55  52                    PUSH   dx ; STACK_PUSH
005E56  50                    PUSH   ax ; STACK_PUSH
005E57  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005E5A  99                    CDQ ; ARITH
005E5B  52                    PUSH   dx ; STACK_PUSH
005E5C  50                    PUSH   ax ; STACK_PUSH
005E5D  B8 AC FF              MOV    ax, 0xffac ; CONST_LOAD
005E60  BA 01 00              MOV    dx, 1 ; MOV
005E63  BB 2D 00              MOV    bx, 0x2d ; CONST_LOAD
005E66  9A 72 07 1F 18        LCALL  0x181f, 0x772 ; THUNK -> 0x0000:0x03CE (thunk @file 0x01AD62 type A) overlay @file 0x025CCE
005E6B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005E6E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005E71  0E                    PUSH   cs ; STACK_PUSH
005E72  E8 0F FF              CALL   0x5d84 ; CALL_NEAR
005E75  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
005E78  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
005E7B  C4 5E FC              LES    bx, ptr [bp - 4] ; MOV_FAR
005E7E  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
005E81  24 0F                 AND    al, 0xf ; LOGIC
005E83  8A 4E 0A              MOV    cl, byte ptr [bp + 0xa] ; LOCAL_LOAD
005E86  C0 E1 04              SHL    cl, 4 ; LOGIC
005E89  0A C1                 OR     al, cl ; LOGIC
005E8B  26 88 07              MOV    byte ptr es:[bx], al ; MOV
005E8E  C9                    LEAVE ; EPILOGUE
005E8F  CB                    RETF ; RETURN
