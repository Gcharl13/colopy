; ============================================================================
; func_0672E0_unknown
; Region   : overlay
; Bytes    : file 0x0672E0..0x0673A7  (199 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0672E0  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
0672E4  57                    PUSH   di ; STACK_PUSH
0672E5  56                    PUSH   si ; STACK_PUSH
0672E6  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
0672E9  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0672EC  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0672EF  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0672F2  0B FF                 OR     di, di ; LOGIC
0672F4  74 06                 JE     0x672fc ; CJUMP
0672F6  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
0672FA  75 1F                 JNE    0x6731b ; CJUMP
0672FC  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
067300  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
067304  2A E4                 SUB    ah, ah ; ARITH
067306  50                    PUSH   ax ; STACK_PUSH
067307  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
06730B  50                    PUSH   ax ; STACK_PUSH
06730C  9A BE 07 1F 18        LCALL  0x181f, 0x7be ; THUNK -> 0x05EB:0x0A76 (thunk @file 0x01ADAE type B) overlay @file 0x027A66
067311  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
067314  0B C0                 OR     ax, ax ; LOGIC
067316  7C 03                 JL     0x6731b ; CJUMP
067318  E9 83 00              JMP    0x6739e ; JUMP
06731B  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06731E  9A EE 02 1F 18        LCALL  0x181f, 0x2ee ; THUNK -> 0x0427:0x0002 (thunk @file 0x01A8DE type B) overlay @file 0x030D16
067323  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
067326  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
06732B  0B C0                 OR     ax, ax ; LOGIC
06732D  7C 05                 JL     0x67334 ; CJUMP
06732F  B8 01 00              MOV    ax, 1 ; MOV
067332  EB 02                 JMP    0x67336 ; JUMP
067334  2B C0                 SUB    ax, ax ; ARITH
067336  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
067339  89 07                 MOV    word ptr [bx], ax ; MOV
06733B  0B FF                 OR     di, di ; LOGIC
06733D  75 51                 JNE    0x67390 ; CJUMP
06733F  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
067342  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
067345  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
067348  0B F6                 OR     si, si ; LOGIC
06734A  7C 4C                 JL     0x67398 ; CJUMP
06734C  8B 7E FC              MOV    di, word ptr [bp - 4] ; LOCAL_LOAD
06734F  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
067352  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
067356  3C 0D                 CMP    al, 0xd ; CMP
067358  72 06                 JB     0x67360 ; CJUMP
06735A  3C 11                 CMP    al, 0x11 ; CMP
06735C  77 02                 JA     0x67360 ; CJUMP
06735E  8B FE                 MOV    di, si ; MOV
067360  8B C6                 MOV    ax, si ; MOV
067362  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
067367  8B F0                 MOV    si, ax ; MOV
067369  0B F6                 OR     si, si ; LOGIC
06736B  7D E2                 JGE    0x6734f ; CJUMP
06736D  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
067371  74 14                 JE     0x67387 ; CJUMP
067373  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
067377  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
06737B  3C 0D                 CMP    al, 0xd ; CMP
06737D  72 04                 JB     0x67383 ; CJUMP
06737F  3C 11                 CMP    al, 0x11 ; CMP
067381  76 1B                 JBE    0x6739e ; CJUMP
067383  0B FF                 OR     di, di ; LOGIC
067385  7C 17                 JL     0x6739e ; CJUMP
067387  0B FF                 OR     di, di ; LOGIC
067389  7C 1D                 JL     0x673a8 ; CJUMP
06738B  6B DF 1C              IMUL   bx, di, 0x1c ; ARITH
06738E  EB 1C                 JMP    0x673ac ; JUMP
067390  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
067394  74 AF                 JE     0x67345 ; CJUMP
067396  EB 10                 JMP    0x673a8 ; JUMP
067398  8B 7E FC              MOV    di, word ptr [bp - 4] ; LOCAL_LOAD
06739B  EB D0                 JMP    0x6736d ; JUMP
06739D  90                    NOP ; NOP
06739E  8B 76 FA              MOV    si, word ptr [bp - 6] ; LOCAL_LOAD
0673A1  8B C6                 MOV    ax, si ; MOV
0673A3  5E                    POP    si ; STACK_POP
0673A4  5F                    POP    di ; STACK_POP
0673A5  C9                    LEAVE ; EPILOGUE
0673A6  CB                    RETF ; RETURN
