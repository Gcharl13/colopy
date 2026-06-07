; ============================================================================
; func_0418AA_unknown
; Region   : overlay
; Bytes    : file 0x0418AA..0x04198D  (227 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0418AA  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0418AE  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
0418B3  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
0418B7  2A E4                 SUB    ah, ah ; ARITH
0418B9  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0418BC  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
0418C0  2A ED                 SUB    ch, ch ; ARITH
0418C2  89 4E FA              MOV    word ptr [bp - 6], cx ; LOCAL_STORE
0418C5  8A 97 47 31           MOV    dl, byte ptr [bx + 0x3147] ; MOV
0418C9  83 E2 0F              AND    dx, 0xf ; LOGIC
0418CC  69 DA 3C 01           IMUL   bx, dx, 0x13c ; ARITH
0418D0  88 87 3A 88           MOV    byte ptr [bx - 0x77c6], al ; MOV
0418D4  88 8F 3B 88           MOV    byte ptr [bx - 0x77c5], cl ; MOV
0418D8  FF 36 92 53           PUSH   word ptr [0x5392] ; PUSH_GLOBAL
0418DC  9A 16 09 1F 18        LCALL  0x181f, 0x916 ; THUNK -> 0x0427:0x12F6 (thunk @file 0x01AF06 type B) overlay @file 0x03200A
0418E1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0418E4  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
0418E7  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0418EA  FF 36 92 53           PUSH   word ptr [0x5392] ; PUSH_GLOBAL
0418EE  0E                    PUSH   cs ; STACK_PUSH
0418EF  E8 1A 08              CALL   0x4210c ; CALL_NEAR
0418F2  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0418F5  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0418F8  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
0418FB  9A EE 02 1F 18        LCALL  0x181f, 0x2ee ; THUNK -> 0x0427:0x0002 (thunk @file 0x01A8DE type B) overlay @file 0x030D16
041900  EB 2A                 JMP    0x4192c ; JUMP
041902  6B 5E F8 1C           IMUL   bx, word ptr [bp - 8], 0x1c ; ARITH
041906  C6 87 4C 31 01        MOV    byte ptr [bx + 0x314c], 1 ; MOV
04190B  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
04190E  6B 5E F8 1C           IMUL   bx, word ptr [bp - 8], 0x1c ; ARITH
041912  88 87 4D 31           MOV    byte ptr [bx + 0x314d], al ; MOV
041916  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
041919  88 87 4E 31           MOV    byte ptr [bx + 0x314e], al ; MOV
04191D  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
041920  88 87 5A 31           MOV    byte ptr [bx + 0x315a], al ; MOV
041924  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
041927  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
04192C  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
04192F  0B C0                 OR     ax, ax ; LOGIC
041931  7C 1B                 JL     0x4194e ; CJUMP
041933  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
041936  39 46 F8              CMP    word ptr [bp - 8], ax ; CMP
041939  75 C7                 JNE    0x41902 ; CJUMP
04193B  6B 5E F8 1C           IMUL   bx, word ptr [bp - 8], 0x1c ; ARITH
04193F  80 BF 4C 31 02        CMP    byte ptr [bx + 0x314c], 2 ; CMP
041944  74 C5                 JE     0x4190b ; CJUMP
041946  C6 87 4C 31 00        MOV    byte ptr [bx + 0x314c], 0 ; MOV
04194B  EB BE                 JMP    0x4190b ; JUMP
04194D  90                    NOP ; NOP
04194E  FF 36 92 53           PUSH   word ptr [0x5392] ; PUSH_GLOBAL
041952  9A DA 08 1F 18        LCALL  0x181f, 0x8da ; THUNK -> 0x0427:0x0968 (thunk @file 0x01AECA type B) overlay @file 0x03167C
041957  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04195A  A1 94 53              MOV    ax, word ptr [0x5394] ; GLOBAL_LOAD
04195D  2D 0C 00              SUB    ax, 0xc ; ARITH
041960  50                    PUSH   ax ; STACK_PUSH
041961  50                    PUSH   ax ; STACK_PUSH
041962  FF 36 92 53           PUSH   word ptr [0x5392] ; PUSH_GLOBAL
041966  9A 48 09 1F 18        LCALL  0x181f, 0x948 ; THUNK -> 0x0427:0x040C (thunk @file 0x01AF38 type B) overlay @file 0x031120
04196B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
04196E  FF 36 92 53           PUSH   word ptr [0x5392] ; PUSH_GLOBAL
041972  9A 4E 08 1F 18        LCALL  0x181f, 0x84e ; THUNK -> 0x0427:0x0CE6 (thunk @file 0x01AE3E type B) overlay @file 0x0319FA
041977  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04197A  6A 01                 PUSH   1 ; STACK_PUSH
04197C  6A 01                 PUSH   1 ; STACK_PUSH
04197E  6A 01                 PUSH   1 ; STACK_PUSH
041980  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
041983  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
041986  9A BA 09 1F 18        LCALL  0x181f, 0x9ba ; THUNK -> 0x0000:0x0004 (thunk @file 0x01AFAA type A) overlay @file 0x025904
04198B  C9                    LEAVE ; EPILOGUE
04198C  CB                    RETF ; RETURN
