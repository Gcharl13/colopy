; ============================================================================
; func_046E18_unknown
; Region   : overlay
; Bytes    : file 0x046E18..0x046E68  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046E18  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
046E1C  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
046E21  83 3E 9A 53 54        CMP    word ptr [0x539a], 0x54 ; CMP
046E26  7C 03                 JL     0x46e2b ; CJUMP
046E28  E9 8F 00              JMP    0x46eba ; JUMP
046E2B  A1 9A 53              MOV    ax, word ptr [0x539a] ; GLOBAL_LOAD
046E2E  FF 06 9A 53           INC    word ptr [0x539a] ; ARITH
046E32  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
046E35  50                    PUSH   ax ; STACK_PUSH
046E36  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
046E3B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
046E3E  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
046E41  2D 04 00              SUB    ax, 4 ; ARITH
046E44  50                    PUSH   ax ; STACK_PUSH
046E45  9A 42 0A 1F 18        LCALL  0x181f, 0xa42 ; THUNK -> 0x05DC:0x0006 (thunk @file 0x01B032 type B) overlay @file 0x0219E8
046E4A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
046E4D  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
046E50  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
046E54  88 47 02              MOV    byte ptr [bx + 2], al ; MOV
046E57  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
046E5A  88 07                 MOV    byte ptr [bx], al ; MOV
046E5C  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
046E5F  88 47 01              MOV    byte ptr [bx + 1], al ; MOV
046E62  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
046E65  0E                    PUSH   cs ; STACK_PUSH
046E66  E8                    DB     0xE8 ; DATA_BYTE
046E67  CB                    DB     0xCB ; DATA_BYTE
