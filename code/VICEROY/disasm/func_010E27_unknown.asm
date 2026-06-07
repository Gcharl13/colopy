; ============================================================================
; func_010E27_unknown
; Region   : load_image
; Bytes    : file 0x010E27..0x010E66  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010E27  55                    PUSH   bp ; STACK_PUSH
010E28  8B EC                 MOV    bp, sp ; MOV
010E2A  56                    PUSH   si ; STACK_PUSH
010E2B  57                    PUSH   di ; STACK_PUSH
010E2C  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
010E2F  8B FE                 MOV    di, si ; MOV
010E31  81 EF 0E 29           SUB    di, 0x290e ; ARITH
010E35  81 C7 AE 29           ADD    di, 0x29ae ; ARITH
010E39  F6 05 10              TEST   byte ptr [di], 0x10 ; LOGIC
010E3C  74 24                 JE     0x10e62 ; CJUMP
010E3E  33 DB                 XOR    bx, bx ; LOGIC
010E40  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
010E43  F6 87 BB 27 40        TEST   byte ptr [bx + 0x27bb], 0x40 ; LOGIC
010E48  74 18                 JE     0x10e62 ; CJUMP
010E4A  56                    PUSH   si ; STACK_PUSH
010E4B  0E                    PUSH   cs ; STACK_PUSH
010E4C  E8 17 00              CALL   0x10e66 ; CALL_NEAR
010E4F  58                    POP    ax ; STACK_POP
010E50  83 7E 04 00           CMP    word ptr [bp + 4], 0 ; CMP
010E54  74 0C                 JE     0x10e62 ; CJUMP
010E56  33 C0                 XOR    ax, ax ; LOGIC
010E58  88 05                 MOV    byte ptr [di], al ; MOV
010E5A  89 45 02              MOV    word ptr [di + 2], ax ; MOV
010E5D  89 04                 MOV    word ptr [si], ax ; MOV
010E5F  89 44 04              MOV    word ptr [si + 4], ax ; MOV
010E62  5F                    POP    di ; STACK_POP
010E63  5E                    POP    si ; STACK_POP
010E64  5D                    POP    bp ; STACK_POP
010E65  C3                    RET ; RETURN
