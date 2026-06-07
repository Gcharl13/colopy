; ============================================================================
; func_0677CA_unknown
; Region   : overlay
; Bytes    : file 0x0677CA..0x067836  (108 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0677CA  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0677CE  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
0677D3  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
0677D7  2A E4                 SUB    ah, ah ; ARITH
0677D9  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0677DC  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
0677E0  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0677E3  B8 01 00              MOV    ax, 1 ; MOV
0677E6  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0677E9  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0677EC  8D 46 F8              LEA    ax, [bp - 8] ; ADDR
0677EF  50                    PUSH   ax ; STACK_PUSH
0677F0  8D 4E FA              LEA    cx, [bp - 6] ; ADDR
0677F3  51                    PUSH   cx ; STACK_PUSH
0677F4  8D 56 FC              LEA    dx, [bp - 4] ; ADDR
0677F7  52                    PUSH   dx ; STACK_PUSH
0677F8  8D 5E FE              LEA    bx, [bp - 2] ; ADDR
0677FB  53                    PUSH   bx ; STACK_PUSH
0677FC  9A 14 09 1F 1A        LCALL  0x1a1f, 0x914 ; THUNK -> 0x0000:0x0052 (thunk @file 0x01CF04 type A) overlay @file 0x025952
067801  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
067804  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
067807  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
06780A  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06780D  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
067810  9A 2C 03 1F 18        LCALL  0x181f, 0x32c ; THUNK -> 0x0000:0x00C8 (thunk @file 0x01A91C type A) overlay @file 0x0259C8
067815  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
067818  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06781B  9A 2A 0E 1F 18        LCALL  0x181f, 0xe2a ; THUNK -> 0x0000:0x03F6 (thunk @file 0x01B41A type A) overlay @file 0x025CF6
067820  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
067823  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
067826  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
067829  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06782C  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
06782F  9A F8 08 1F 1A        LCALL  0x1a1f, 0x8f8 ; THUNK -> 0x0000:0x023C (thunk @file 0x01CEE8 type A) overlay @file 0x025B3C
067834  C9                    LEAVE ; EPILOGUE
067835  CB                    RETF ; RETURN
