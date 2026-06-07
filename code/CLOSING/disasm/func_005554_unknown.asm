; ============================================================================
; func_005554_unknown
; Region   : load_image
; Bytes    : file 0x005554..0x0055C7  (115 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005554  55                    PUSH   bp ; STACK_PUSH
005555  8B EC                 MOV    bp, sp ; MOV
005557  56                    PUSH   si ; STACK_PUSH
005558  57                    PUSH   di ; STACK_PUSH
005559  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
00555C  BB EA 42              MOV    bx, 0x42ea ; CONST_LOAD
00555F  81 FE B0 41           CMP    si, 0x41b0 ; CMP
005563  74 12                 JE     0x5577 ; CJUMP
005565  BB EC 42              MOV    bx, 0x42ec ; CONST_LOAD
005568  81 FE B8 41           CMP    si, 0x41b8 ; CMP
00556C  74 09                 JE     0x5577 ; CJUMP
00556E  BB EE 42              MOV    bx, 0x42ee ; CONST_LOAD
005571  81 FE C8 41           CMP    si, 0x41c8 ; CMP
005575  75 4A                 JNE    0x55c1 ; CJUMP
005577  8B FE                 MOV    di, si ; MOV
005579  81 EF A8 41           SUB    di, 0x41a8 ; ARITH
00557D  81 C7 48 42           ADD    di, 0x4248 ; ARITH
005581  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc ; LOGIC
005585  75 3A                 JNE    0x55c1 ; CJUMP
005587  F6 05 01              TEST   byte ptr [di], 1 ; LOGIC
00558A  75 35                 JNE    0x55c1 ; CJUMP
00558C  8B 07                 MOV    ax, word ptr [bx] ; MOV
00558E  0B C0                 OR     ax, ax ; LOGIC
005590  74 1B                 JE     0x55ad ; CJUMP
005592  89 44 04              MOV    word ptr [si + 4], ax ; MOV
005595  89 04                 MOV    word ptr [si], ax ; MOV
005597  C7 44 02 00 02        MOV    word ptr [si + 2], 0x200 ; CONST_LOAD
00559C  C7 45 02 00 02        MOV    word ptr [di + 2], 0x200 ; CONST_LOAD
0055A1  80 4C 06 02           OR     byte ptr [si + 6], 2 ; LOGIC
0055A5  C6 05 11              MOV    byte ptr [di], 0x11 ; CONST_LOAD
0055A8  B8 01 00              MOV    ax, 1 ; MOV
0055AB  EB 16                 JMP    0x55c3 ; JUMP
0055AD  53                    PUSH   bx ; STACK_PUSH
0055AE  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
0055B1  50                    PUSH   ax ; STACK_PUSH
0055B2  9A 8E 24 7D 03        LCALL  0x37d, 0x248e ; LCALL
0055B7  5B                    POP    bx ; STACK_POP
0055B8  5B                    POP    bx ; STACK_POP
0055B9  0B C0                 OR     ax, ax ; LOGIC
0055BB  74 04                 JE     0x55c1 ; CJUMP
0055BD  89 07                 MOV    word ptr [bx], ax ; MOV
0055BF  EB D1                 JMP    0x5592 ; JUMP
0055C1  33 C0                 XOR    ax, ax ; LOGIC
0055C3  5F                    POP    di ; STACK_POP
0055C4  5E                    POP    si ; STACK_POP
0055C5  5D                    POP    bp ; STACK_POP
0055C6  C3                    RET ; RETURN
