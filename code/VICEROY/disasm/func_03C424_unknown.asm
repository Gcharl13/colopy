; ============================================================================
; func_03C424_unknown
; Region   : overlay
; Bytes    : file 0x03C424..0x03C4A2  (126 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C424  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
03C428  57                    PUSH   di ; STACK_PUSH
03C429  56                    PUSH   si ; STACK_PUSH
03C42A  2B C0                 SUB    ax, ax ; ARITH
03C42C  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
03C42F  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
03C432  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03C435  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03C438  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
03C43B  EB 3F                 JMP    0x3c47c ; JUMP
03C43D  90                    NOP ; NOP
03C43E  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
03C441  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
03C446  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03C449  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
03C44C  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03C450  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
03C453  75 24                 JNE    0x3c479 ; CJUMP
03C455  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
03C458  98                    CWDE ; ARITH
03C459  99                    CDQ ; ARITH
03C45A  01 46 F6              ADD    word ptr [bp - 0xa], ax ; ARITH
03C45D  11 56 F8              ADC    word ptr [bp - 8], dx ; ARITH
03C460  8B F0                 MOV    si, ax ; MOV
03C462  8B FA                 MOV    di, dx ; MOV
03C464  9A 86 0C 1F 18        LCALL  0x181f, 0xc86 ; THUNK -> 0x05EB:0x0274 (thunk @file 0x01B276 type B) overlay @file 0x027264
03C469  99                    CDQ ; ARITH
03C46A  52                    PUSH   dx ; STACK_PUSH
03C46B  50                    PUSH   ax ; STACK_PUSH
03C46C  57                    PUSH   di ; STACK_PUSH
03C46D  56                    PUSH   si ; STACK_PUSH
03C46E  9A 60 0F 1D 0D        LCALL  0xd1d, 0xf60 ; LCALL
03C473  01 46 FC              ADD    word ptr [bp - 4], ax ; ARITH
03C476  11 56 FE              ADC    word ptr [bp - 2], dx ; ARITH
03C479  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
03C47C  A1 9E 53              MOV    ax, word ptr [0x539e] ; GLOBAL_LOAD
03C47F  39 46 FA              CMP    word ptr [bp - 6], ax ; CMP
03C482  7C BA                 JL     0x3c43e ; CJUMP
03C484  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
03C487  0B 46 F6              OR     ax, word ptr [bp - 0xa] ; LOGIC
03C48A  74 0F                 JE     0x3c49b ; CJUMP
03C48C  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
03C48F  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
03C492  8D 46 FC              LEA    ax, [bp - 4] ; ADDR
03C495  50                    PUSH   ax ; STACK_PUSH
03C496  9A 92 0F 1D 0D        LCALL  0xd1d, 0xf92 ; LCALL
03C49B  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
03C49E  5E                    POP    si ; STACK_POP
03C49F  5F                    POP    di ; STACK_POP
03C4A0  C9                    LEAVE ; EPILOGUE
03C4A1  CB                    RETF ; RETURN
