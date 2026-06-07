; ============================================================================
; func_05FEF4_unknown
; Region   : overlay
; Bytes    : file 0x05FEF4..0x05FFDC  (232 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05FEF4  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
05FEF8  56                    PUSH   si ; STACK_PUSH
05FEF9  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
05FEFE  81 7E 06 E7 03        CMP    word ptr [bp + 6], 0x3e7 ; CMP
05FF03  74 1A                 JE     0x5ff1f ; CJUMP
05FF05  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05FF08  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
05FF0D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05FF10  A0 94 53              MOV    al, byte ptr [0x5394] ; GLOBAL_LOAD
05FF13  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
05FF17  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
05FF1A  74 03                 JE     0x5ff1f ; CJUMP
05FF1C  E9 01 01              JMP    0x60020 ; JUMP
05FF1F  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
05FF23  7D 03                 JGE    0x5ff28 ; CJUMP
05FF25  E9 F3 00              JMP    0x6001b ; JUMP
05FF28  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
05FF2C  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
05FF31  73 03                 JAE    0x5ff36 ; CJUMP
05FF33  E9 B0 00              JMP    0x5ffe6 ; JUMP
05FF36  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
05FF3B  76 03                 JBE    0x5ff40 ; CJUMP
05FF3D  E9 A6 00              JMP    0x5ffe6 ; JUMP
05FF40  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
05FF44  2A E4                 SUB    ah, ah ; ARITH
05FF46  50                    PUSH   ax ; STACK_PUSH
05FF47  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
05FF4B  50                    PUSH   ax ; STACK_PUSH
05FF4C  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
05FF51  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05FF54  0B C0                 OR     ax, ax ; LOGIC
05FF56  75 0A                 JNE    0x5ff62 ; CJUMP
05FF58  6A 01                 PUSH   1 ; STACK_PUSH
05FF5A  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
05FF5D  48                    DEC    ax ; ARITH
05FF5E  48                    DEC    ax ; ARITH
05FF5F  50                    PUSH   ax ; STACK_PUSH
05FF60  EB 34                 JMP    0x5ff96 ; JUMP
05FF62  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
05FF66  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
05FF6A  2A E4                 SUB    ah, ah ; ARITH
05FF6C  50                    PUSH   ax ; STACK_PUSH
05FF6D  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
05FF71  50                    PUSH   ax ; STACK_PUSH
05FF72  8B F3                 MOV    si, bx ; MOV
05FF74  9A 12 0D 1F 18        LCALL  0x181f, 0xd12 ; THUNK -> 0x05EB:0x00A2 (thunk @file 0x01B302 type B) overlay @file 0x027092
05FF79  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05FF7C  0B C0                 OR     ax, ax ; LOGIC
05FF7E  75 0E                 JNE    0x5ff8e ; CJUMP
05FF80  8A 84 45 31           MOV    al, byte ptr [si + 0x3145] ; MOV
05FF84  2A E4                 SUB    ah, ah ; ARITH
05FF86  50                    PUSH   ax ; STACK_PUSH
05FF87  8A 84 44 31           MOV    al, byte ptr [si + 0x3144] ; MOV
05FF8B  EB D2                 JMP    0x5ff5f ; JUMP
05FF8D  90                    NOP ; NOP
05FF8E  FF 36 BC 8D           PUSH   word ptr [0x8dbc] ; PUSH_GLOBAL
05FF92  FF 36 BA 8D           PUSH   word ptr [0x8dba] ; PUSH_GLOBAL
05FF96  9A B4 06 1F 18        LCALL  0x181f, 0x6b4 ; THUNK -> 0x037F:0x01CA (thunk @file 0x01ACA4 type B) overlay @file 0x02ED06
05FF9B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05FF9E  2A E4                 SUB    ah, ah ; ARITH
05FFA0  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
05FFA3  81 7E 06 E7 03        CMP    word ptr [bp + 6], 0x3e7 ; CMP
05FFA8  74 32                 JE     0x5ffdc ; CJUMP
05FFAA  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
05FFAE  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
05FFB1  50                    PUSH   ax ; STACK_PUSH
05FFB2  8A 07                 MOV    al, byte ptr [bx] ; MOV
05FFB4  50                    PUSH   ax ; STACK_PUSH
05FFB5  9A 12 0D 1F 18        LCALL  0x181f, 0xd12 ; THUNK -> 0x05EB:0x00A2 (thunk @file 0x01B302 type B) overlay @file 0x027092
05FFBA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05FFBD  0B C0                 OR     ax, ax ; LOGIC
05FFBF  74 5F                 JE     0x60020 ; CJUMP
05FFC1  FF 36 BC 8D           PUSH   word ptr [0x8dbc] ; PUSH_GLOBAL
05FFC5  FF 36 BA 8D           PUSH   word ptr [0x8dba] ; PUSH_GLOBAL
05FFC9  9A B4 06 1F 18        LCALL  0x181f, 0x6b4 ; THUNK -> 0x037F:0x01CA (thunk @file 0x01ACA4 type B) overlay @file 0x02ED06
05FFCE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05FFD1  3A 46 FC              CMP    al, byte ptr [bp - 4] ; CMP
05FFD4  74 45                 JE     0x6001b ; CJUMP
05FFD6  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
05FFD9  5E                    POP    si ; STACK_POP
05FFDA  C9                    LEAVE ; EPILOGUE
05FFDB  CB                    RETF ; RETURN
