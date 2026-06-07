; ============================================================================
; func_042726_unknown
; Region   : overlay
; Bytes    : file 0x042726..0x0427D6  (176 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042726  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
04272A  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
04272F  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
042732  C6 87 30 94 00        MOV    byte ptr [bx - 0x6bd0], 0 ; MOV
042737  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
04273A  83 7E FC 1D           CMP    word ptr [bp - 4], 0x1d ; CMP
04273E  7C EF                 JL     0x4272f ; CJUMP
042740  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
042745  EB 30                 JMP    0x42777 ; JUMP
042747  90                    NOP ; NOP
042748  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
04274B  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
04274F  24 0F                 AND    al, 0xf ; LOGIC
042751  3A 46 06              CMP    al, byte ptr [bp + 6] ; CMP
042754  75 1E                 JNE    0x42774 ; CJUMP
042756  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
042759  9A 78 0B 1F 18        LCALL  0x181f, 0xb78 ; THUNK -> 0x05EB:0x0902 (thunk @file 0x01B168 type B) overlay @file 0x0278F2
04275E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
042761  0B C0                 OR     ax, ax ; LOGIC
042763  7C 0F                 JL     0x42774 ; CJUMP
042765  6B 5E F8 1C           IMUL   bx, word ptr [bp - 8], 0x1c ; ARITH
042769  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b] ; MOV
04276D  98                    CWDE ; ARITH
04276E  8B D8                 MOV    bx, ax ; MOV
042770  FE 87 30 94           INC    byte ptr [bx - 0x6bd0] ; ARITH
042774  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
042777  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
04277A  39 06 9C 53           CMP    word ptr [0x539c], ax ; CMP
04277E  7F C8                 JG     0x42748 ; CJUMP
042780  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
042785  EB 28                 JMP    0x427af ; JUMP
042787  90                    NOP ; NOP
042788  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
04278B  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
04278F  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
042792  98                    CWDE ; ARITH
042793  3B 46 FE              CMP    ax, word ptr [bp - 2] ; CMP
042796  7E 14                 JLE    0x427ac ; CJUMP
042798  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
04279B  9A 54 0C 1F 18        LCALL  0x181f, 0xc54 ; THUNK -> 0x05EB:0x0E52 (thunk @file 0x01B244 type B) overlay @file 0x027E42
0427A0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0427A3  8B D8                 MOV    bx, ax ; MOV
0427A5  FE 87 30 94           INC    byte ptr [bx - 0x6bd0] ; ARITH
0427A9  EB DD                 JMP    0x42788 ; JUMP
0427AB  90                    NOP ; NOP
0427AC  FF 46 F6              INC    word ptr [bp - 0xa] ; ARITH
0427AF  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
0427B2  39 06 9E 53           CMP    word ptr [0x539e], ax ; CMP
0427B6  7E 1C                 JLE    0x427d4 ; CJUMP
0427B8  50                    PUSH   ax ; STACK_PUSH
0427B9  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
0427BE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0427C1  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
0427C4  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0427C8  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
0427CB  75 DF                 JNE    0x427ac ; CJUMP
0427CD  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0427D2  EB B7                 JMP    0x4278b ; JUMP
0427D4  C9                    LEAVE ; EPILOGUE
0427D5  CB                    RETF ; RETURN
