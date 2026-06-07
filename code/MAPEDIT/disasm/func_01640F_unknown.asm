; ============================================================================
; func_01640F_unknown
; Region   : load_image
; Bytes    : file 0x01640F..0x01644E  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01640F  55                    PUSH   bp ; STACK_PUSH
016410  8B EC                 MOV    bp, sp ; MOV
016412  56                    PUSH   si ; STACK_PUSH
016413  57                    PUSH   di ; STACK_PUSH
016414  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
016417  8B FE                 MOV    di, si ; MOV
016419  81 EF C6 46           SUB    di, 0x46c6 ; ARITH
01641D  81 C7 66 47           ADD    di, 0x4766 ; ARITH
016421  F6 05 10              TEST   byte ptr [di], 0x10 ; LOGIC
016424  74 24                 JE     0x1644a ; CJUMP
016426  33 DB                 XOR    bx, bx ; LOGIC
016428  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
01642B  F6 87 77 45 40        TEST   byte ptr [bx + 0x4577], 0x40 ; LOGIC
016430  74 18                 JE     0x1644a ; CJUMP
016432  56                    PUSH   si ; STACK_PUSH
016433  0E                    PUSH   cs ; STACK_PUSH
016434  E8 17 00              CALL   0x1644e ; CALL_NEAR
016437  58                    POP    ax ; STACK_POP
016438  83 7E 04 00           CMP    word ptr [bp + 4], 0 ; CMP
01643C  74 0C                 JE     0x1644a ; CJUMP
01643E  33 C0                 XOR    ax, ax ; LOGIC
016440  88 05                 MOV    byte ptr [di], al ; MOV
016442  89 45 02              MOV    word ptr [di + 2], ax ; MOV
016445  89 04                 MOV    word ptr [si], ax ; MOV
016447  89 44 04              MOV    word ptr [si + 4], ax ; MOV
01644A  5F                    POP    di ; STACK_POP
01644B  5E                    POP    si ; STACK_POP
01644C  5D                    POP    bp ; STACK_POP
01644D  C3                    RET ; RETURN
