; ============================================================================
; func_03E442_unknown
; Region   : overlay
; Bytes    : file 0x03E442..0x03E4D4  (146 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03E442  C8 5A 00 00           ENTER  0x5a, 0 ; PROLOGUE
03E446  57                    PUSH   di ; STACK_PUSH
03E447  56                    PUSH   si ; STACK_PUSH
03E448  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03E44B  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
03E450  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03E453  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
03E456  39 06 D2 53           CMP    word ptr [0x53d2], ax ; CMP
03E45A  75 5C                 JNE    0x3e4b8 ; CJUMP
03E45C  69 1E 98 53 3C 01     IMUL   bx, word ptr [0x5398], 0x13c ; ARITH
03E462  F6 87 08 88 08        TEST   byte ptr [bx - 0x77f8], 8 ; LOGIC
03E467  74 08                 JE     0x3e471 ; CJUMP
03E469  50                    PUSH   ax ; STACK_PUSH
03E46A  0E                    PUSH   cs ; STACK_PUSH
03E46B  E8 A7 05              CALL   0x3ea15 ; CALL_NEAR
03E46E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03E471  83 3E E0 53 00        CMP    word ptr [0x53e0], 0 ; CMP
03E476  7E 06                 JLE    0x3e47e ; CJUMP
03E478  B8 01 00              MOV    ax, 1 ; MOV
03E47B  EB 03                 JMP    0x3e480 ; JUMP
03E47D  90                    NOP ; NOP
03E47E  2B C0                 SUB    ax, ax ; ARITH
03E480  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
03E483  83 3E DC 53 00        CMP    word ptr [0x53dc], 0 ; CMP
03E488  7E 06                 JLE    0x3e490 ; CJUMP
03E48A  B8 01 00              MOV    ax, 1 ; MOV
03E48D  EB 03                 JMP    0x3e492 ; JUMP
03E48F  90                    NOP ; NOP
03E490  2B C0                 SUB    ax, ax ; ARITH
03E492  03 46 A6              ADD    ax, word ptr [bp - 0x5a] ; ARITH
03E495  03 06 DA 53           ADD    ax, word ptr [0x53da] ; ARITH
03E499  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
03E49C  0B C0                 OR     ax, ax ; LOGIC
03E49E  74 0C                 JE     0x3e4ac ; CJUMP
03E4A0  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
03E4A4  0E                    PUSH   cs ; STACK_PUSH
03E4A5  E8 95 05              CALL   0x3ea3d ; CALL_NEAR
03E4A8  E9 B2 01              JMP    0x3e65d ; JUMP
03E4AB  90                    NOP ; NOP
03E4AC  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
03E4B0  0E                    PUSH   cs ; STACK_PUSH
03E4B1  E8 93 05              CALL   0x3ea47 ; CALL_NEAR
03E4B4  E9 A6 01              JMP    0x3e65d ; JUMP
03E4B7  90                    NOP ; NOP
03E4B8  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03E4BC  F6 07 08              TEST   byte ptr [bx], 8 ; LOGIC
03E4BF  75 13                 JNE    0x3e4d4 ; CJUMP
03E4C1  50                    PUSH   ax ; STACK_PUSH
03E4C2  0E                    PUSH   cs ; STACK_PUSH
03E4C3  E8 68 05              CALL   0x3ea2e ; CALL_NEAR
03E4C6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03E4C9  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
03E4CD  80 0F 08              OR     byte ptr [bx], 8 ; LOGIC
03E4D0  5E                    POP    si ; STACK_POP
03E4D1  5F                    POP    di ; STACK_POP
03E4D2  C9                    LEAVE ; EPILOGUE
03E4D3  CB                    RETF ; RETURN
