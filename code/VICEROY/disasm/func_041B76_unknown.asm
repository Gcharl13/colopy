; ============================================================================
; func_041B76_unknown
; Region   : overlay
; Bytes    : file 0x041B76..0x041BFF  (137 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041B76  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
041B7A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
041B7D  9A 20 09 1F 18        LCALL  0x181f, 0x920 ; THUNK -> 0x0427:0x10BE (thunk @file 0x01AF10 type B) overlay @file 0x031DD2
041B82  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
041B85  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041B89  8A 87 4E 31           MOV    al, byte ptr [bx + 0x314e] ; MOV
041B8D  2A E4                 SUB    ah, ah ; ARITH
041B8F  50                    PUSH   ax ; STACK_PUSH
041B90  8A 87 4D 31           MOV    al, byte ptr [bx + 0x314d] ; MOV
041B94  50                    PUSH   ax ; STACK_PUSH
041B95  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
041B98  0E                    PUSH   cs ; STACK_PUSH
041B99  E8 70 05              CALL   0x4210c ; CALL_NEAR
041B9C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
041B9F  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
041BA2  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
041BA5  9A EE 02 1F 18        LCALL  0x181f, 0x2ee ; THUNK -> 0x0427:0x0002 (thunk @file 0x01A8DE type B) overlay @file 0x030D16
041BAA  EB 32                 JMP    0x41bde ; JUMP
041BAC  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
041BAF  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
041BB4  72 07                 JB     0x41bbd ; CJUMP
041BB6  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
041BBB  76 0E                 JBE    0x41bcb ; CJUMP
041BBD  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
041BC0  8A 9F 47 31           MOV    bl, byte ptr [bx + 0x3147] ; MOV
041BC4  83 E3 0F              AND    bx, 0xf ; LOGIC
041BC7  FE 8F 5A 94           DEC    byte ptr [bx - 0x6ba6] ; ARITH
041BCB  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
041BCE  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
041BD2  88 87 5A 31           MOV    byte ptr [bx + 0x315a], al ; MOV
041BD6  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
041BD9  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
041BDE  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
041BE1  0B C0                 OR     ax, ax ; LOGIC
041BE3  7D C7                 JGE    0x41bac ; CJUMP
041BE5  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041BE9  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
041BED  25 0F 00              AND    ax, 0xf ; LOGIC
041BF0  2D 18 00              SUB    ax, 0x18 ; ARITH
041BF3  50                    PUSH   ax ; STACK_PUSH
041BF4  50                    PUSH   ax ; STACK_PUSH
041BF5  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
041BF8  9A 48 09 1F 18        LCALL  0x181f, 0x948 ; THUNK -> 0x0427:0x040C (thunk @file 0x01AF38 type B) overlay @file 0x031120
041BFD  C9                    LEAVE ; EPILOGUE
041BFE  CB                    RETF ; RETURN
