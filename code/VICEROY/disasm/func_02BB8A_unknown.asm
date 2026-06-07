; ============================================================================
; func_02BB8A_unknown
; Region   : overlay
; Bytes    : file 0x02BB8A..0x02BBF4  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02BB8A  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
02BB8E  83 3E EC 07 00        CMP    word ptr [0x7ec], 0 ; CMP
02BB93  75 07                 JNE    0x2bb9c ; CJUMP
02BB95  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
02BB9A  75 0A                 JNE    0x2bba6 ; CJUMP
02BB9C  0E                    PUSH   cs ; STACK_PUSH
02BB9D  E8 AB 0E              CALL   0x2ca4b ; CALL_NEAR
02BBA0  A3 54 8D              MOV    word ptr [0x8d54], ax ; GLOBAL_LOAD
02BBA3  A3 56 8D              MOV    word ptr [0x8d56], ax ; GLOBAL_LOAD
02BBA6  A1 54 8D              MOV    ax, word ptr [0x8d54] ; GLOBAL_LOAD
02BBA9  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02BBAC  3D 06 00              CMP    ax, 6 ; CMP
02BBAF  74 05                 JE     0x2bbb6 ; CJUMP
02BBB1  3D 07 00              CMP    ax, 7 ; CMP
02BBB4  75 28                 JNE    0x2bbde ; CJUMP
02BBB6  0E                    PUSH   cs ; STACK_PUSH
02BBB7  E8 91 0E              CALL   0x2ca4b ; CALL_NEAR
02BBBA  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02BBBD  3D 08 00              CMP    ax, 8 ; CMP
02BBC0  74 32                 JE     0x2bbf4 ; CJUMP
02BBC2  77 15                 JA     0x2bbd9 ; CJUMP
02BBC4  0A C0                 OR     al, al ; LOGIC
02BBC6  7C 11                 JL     0x2bbd9 ; CJUMP
02BBC8  2C 02                 SUB    al, 2 ; ARITH
02BBCA  7E 06                 JLE    0x2bbd2 ; CJUMP
02BBCC  2C 03                 SUB    al, 3 ; ARITH
02BBCE  74 24                 JE     0x2bbf4 ; CJUMP
02BBD0  EB 07                 JMP    0x2bbd9 ; JUMP
02BBD2  83 3E 54 8D 06        CMP    word ptr [0x8d54], 6 ; CMP
02BBD7  74 05                 JE     0x2bbde ; CJUMP
02BBD9  C7 46 FE 14 00        MOV    word ptr [bp - 2], 0x14 ; LOCAL_STORE
02BBDE  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
02BBE3  75 17                 JNE    0x2bbfc ; CJUMP
02BBE5  83 7E FE 02           CMP    word ptr [bp - 2], 2 ; CMP
02BBE9  75 17                 JNE    0x2bc02 ; CJUMP
02BBEB  F6 06 84 53 02        TEST   byte ptr [0x5384], 2 ; LOGIC
02BBF0  74 0A                 JE     0x2bbfc ; CJUMP
02BBF2  C9                    LEAVE ; EPILOGUE
02BBF3  CB                    RETF ; RETURN
