; ============================================================================
; func_03C528_unknown
; Region   : overlay
; Bytes    : file 0x03C528..0x03C5A8  (128 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C528  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
03C52C  6A 0B                 PUSH   0xb ; PUSH_CONST
03C52E  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
03C532  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03C535  9A 10 0A 1F 18        LCALL  0x181f, 0xa10 ; THUNK -> 0x05B3:0x00D0 (thunk @file 0x01B000 type B) overlay @file 0x05FCFC
03C53A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03C53D  6A 0B                 PUSH   0xb ; PUSH_CONST
03C53F  FF 36 D2 53           PUSH   word ptr [0x53d2] ; PUSH_GLOBAL
03C543  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03C546  9A 10 0A 1F 18        LCALL  0x181f, 0xa10 ; THUNK -> 0x05B3:0x00D0 (thunk @file 0x01B000 type B) overlay @file 0x05FCFC
03C54B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03C54E  6A 60                 PUSH   0x60 ; PUSH_CONST
03C550  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
03C554  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03C557  9A 06 0A 1F 18        LCALL  0x181f, 0xa06 ; THUNK -> 0x05B3:0x0066 (thunk @file 0x01AFF6 type B) overlay @file 0x05FC92
03C55C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03C55F  6A 60                 PUSH   0x60 ; PUSH_CONST
03C561  FF 36 D2 53           PUSH   word ptr [0x53d2] ; PUSH_GLOBAL
03C565  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03C568  9A 06 0A 1F 18        LCALL  0x181f, 0xa06 ; THUNK -> 0x05B3:0x0066 (thunk @file 0x01AFF6 type B) overlay @file 0x05FC92
03C56D  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03C570  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
03C573  48                    DEC    ax ; ARITH
03C574  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03C577  EB 1E                 JMP    0x3c597 ; JUMP
03C579  90                    NOP ; NOP
03C57A  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
03C57E  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
03C582  24 0F                 AND    al, 0xf ; LOGIC
03C584  3A 46 06              CMP    al, byte ptr [bp + 6] ; CMP
03C587  75 0B                 JNE    0x3c594 ; CJUMP
03C589  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
03C58C  9A 08 08 1F 18        LCALL  0x181f, 0x808 ; THUNK -> 0x0427:0x0824 (thunk @file 0x01ADF8 type B) overlay @file 0x031538
03C591  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03C594  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
03C597  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
03C59B  7D DD                 JGE    0x3c57a ; CJUMP
03C59D  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34 ; ARITH
03C5A1  C6 87 3F 54 02        MOV    byte ptr [bx + 0x543f], 2 ; MOV
03C5A6  C9                    LEAVE ; EPILOGUE
03C5A7  CB                    RETF ; RETURN
