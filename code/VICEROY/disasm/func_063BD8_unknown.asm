; ============================================================================
; func_063BD8_unknown
; Region   : overlay
; Bytes    : file 0x063BD8..0x063C57  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063BD8  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
063BDC  53                    PUSH   bx ; STACK_PUSH
063BDD  52                    PUSH   dx ; STACK_PUSH
063BDE  50                    PUSH   ax ; STACK_PUSH
063BDF  57                    PUSH   di ; STACK_PUSH
063BE0  56                    PUSH   si ; STACK_PUSH
063BE1  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
063BE6  C7 46 F8 FF FF        MOV    word ptr [bp - 8], 0xffff ; LOCAL_STORE
063BEB  8B F8                 MOV    di, ax ; MOV
063BED  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
063BF0  40                    INC    ax ; ARITH
063BF1  3B C7                 CMP    ax, di ; CMP
063BF3  7C 59                 JL     0x63c4e ; CJUMP
063BF5  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
063BF8  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
063BFC  75 49                 JNE    0x63c47 ; CJUMP
063BFE  8B F0                 MOV    si, ax ; MOV
063C00  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
063C03  40                    INC    ax ; ARITH
063C04  3B C6                 CMP    ax, si ; CMP
063C06  7C 3F                 JL     0x63c47 ; CJUMP
063C08  56                    PUSH   si ; STACK_PUSH
063C09  57                    PUSH   di ; STACK_PUSH
063C0A  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
063C0F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
063C12  3B 46 04              CMP    ax, word ptr [bp + 4] ; CMP
063C15  75 29                 JNE    0x63c40 ; CJUMP
063C17  56                    PUSH   si ; STACK_PUSH
063C18  57                    PUSH   di ; STACK_PUSH
063C19  9A B4 06 1F 18        LCALL  0x181f, 0x6b4 ; THUNK -> 0x037F:0x01CA (thunk @file 0x01ACA4 type B) overlay @file 0x02ED06
063C1E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
063C21  2A E4                 SUB    ah, ah ; ARITH
063C23  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
063C26  83 7E 04 00           CMP    word ptr [bp + 4], 0 ; CMP
063C2A  74 05                 JE     0x63c31 ; CJUMP
063C2C  3D 01 00              CMP    ax, 1 ; CMP
063C2F  75 0F                 JNE    0x63c40 ; CJUMP
063C31  8B 5E F4              MOV    bx, word ptr [bp - 0xc] ; LOCAL_LOAD
063C34  89 3F                 MOV    word ptr [bx], di ; MOV
063C36  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
063C39  89 37                 MOV    word ptr [bx], si ; MOV
063C3B  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
063C40  46                    INC    si ; ARITH
063C41  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
063C45  74 B9                 JE     0x63c00 ; CJUMP
063C47  47                    INC    di ; ARITH
063C48  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
063C4C  74 9F                 JE     0x63bed ; CJUMP
063C4E  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
063C51  5E                    POP    si ; STACK_POP
063C52  5F                    POP    di ; STACK_POP
063C53  C9                    LEAVE ; EPILOGUE
063C54  C2 04 00              RET    4 ; RETURN
