; ============================================================================
; func_0055C7_unknown
; Region   : load_image
; Bytes    : file 0x0055C7..0x005606  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0055C7  55                    PUSH   bp ; STACK_PUSH
0055C8  8B EC                 MOV    bp, sp ; MOV
0055CA  56                    PUSH   si ; STACK_PUSH
0055CB  57                    PUSH   di ; STACK_PUSH
0055CC  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0055CF  8B FE                 MOV    di, si ; MOV
0055D1  81 EF A8 41           SUB    di, 0x41a8 ; ARITH
0055D5  81 C7 48 42           ADD    di, 0x4248 ; ARITH
0055D9  F6 05 10              TEST   byte ptr [di], 0x10 ; LOGIC
0055DC  74 24                 JE     0x5602 ; CJUMP
0055DE  33 DB                 XOR    bx, bx ; LOGIC
0055E0  8A 5C 07              MOV    bl, byte ptr [si + 7] ; MOV
0055E3  F6 87 59 40 40        TEST   byte ptr [bx + 0x4059], 0x40 ; LOGIC
0055E8  74 18                 JE     0x5602 ; CJUMP
0055EA  56                    PUSH   si ; STACK_PUSH
0055EB  0E                    PUSH   cs ; STACK_PUSH
0055EC  E8 17 00              CALL   0x5606 ; CALL_NEAR
0055EF  58                    POP    ax ; STACK_POP
0055F0  83 7E 04 00           CMP    word ptr [bp + 4], 0 ; CMP
0055F4  74 0C                 JE     0x5602 ; CJUMP
0055F6  33 C0                 XOR    ax, ax ; LOGIC
0055F8  88 05                 MOV    byte ptr [di], al ; MOV
0055FA  89 45 02              MOV    word ptr [di + 2], ax ; MOV
0055FD  89 04                 MOV    word ptr [si], ax ; MOV
0055FF  89 44 04              MOV    word ptr [si + 4], ax ; MOV
005602  5F                    POP    di ; STACK_POP
005603  5E                    POP    si ; STACK_POP
005604  5D                    POP    bp ; STACK_POP
005605  C3                    RET ; RETURN
