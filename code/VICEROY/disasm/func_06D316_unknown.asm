; ============================================================================
; func_06D316_unknown
; Region   : overlay
; Bytes    : file 0x06D316..0x06D40F  (249 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06D316  C8 2C 00 00           ENTER  0x2c, 0 ; PROLOGUE
06D31A  56                    PUSH   si ; STACK_PUSH
06D31B  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
06D320  2B C0                 SUB    ax, ax ; ARITH
06D322  89 46 D4              MOV    word ptr [bp - 0x2c], ax ; LOCAL_STORE
06D325  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
06D328  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
06D32B  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06D32E  26 39 47 08           CMP    word ptr es:[bx + 8], ax ; CMP
06D332  74 12                 JE     0x6d346 ; CJUMP
06D334  26 39 47 02           CMP    word ptr es:[bx + 2], ax ; CMP
06D338  74 0C                 JE     0x6d346 ; CJUMP
06D33A  26 89 47 08           MOV    word ptr es:[bx + 8], ax ; MOV
06D33E  26 89 47 62           MOV    word ptr es:[bx + 0x62], ax ; MOV
06D342  26 89 47 60           MOV    word ptr es:[bx + 0x60], ax ; MOV
06D346  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06D349  26 8B 47 0C           MOV    ax, word ptr es:[bx + 0xc] ; MOV
06D34D  26 89 47 10           MOV    word ptr es:[bx + 0x10], ax ; MOV
06D351  26 8B 47 0E           MOV    ax, word ptr es:[bx + 0xe] ; MOV
06D355  26 89 47 12           MOV    word ptr es:[bx + 0x12], ax ; MOV
06D359  26 C7 47 14 00 00     MOV    word ptr es:[bx + 0x14], 0 ; MOV
06D35F  26 8B 47 4A           MOV    ax, word ptr es:[bx + 0x4a] ; MOV
06D363  D1 E0                 SHL    ax, 1 ; LOGIC
06D365  26 03 47 46           ADD    ax, word ptr es:[bx + 0x46] ; ARITH
06D369  26 89 47 16           MOV    word ptr es:[bx + 0x16], ax ; MOV
06D36D  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa] ; MOV
06D371  25 10 00              AND    ax, 0x10 ; LOGIC
06D374  3D 01 00              CMP    ax, 1 ; CMP
06D377  1B C0                 SBB    ax, ax ; ARITH
06D379  25 03 00              AND    ax, 3 ; LOGIC
06D37C  26 89 47 2A           MOV    word ptr es:[bx + 0x2a], ax ; MOV
06D380  8B C8                 MOV    cx, ax ; MOV
06D382  26 03 47 46           ADD    ax, word ptr es:[bx + 0x46] ; ARITH
06D386  26 89 47 2C           MOV    word ptr es:[bx + 0x2c], ax ; MOV
06D38A  26 89 4F 24           MOV    word ptr es:[bx + 0x24], cx ; MOV
06D38E  26 89 47 26           MOV    word ptr es:[bx + 0x26], ax ; MOV
06D392  26 8B 47 28           MOV    ax, word ptr es:[bx + 0x28] ; MOV
06D396  26 3B 47 20           CMP    ax, word ptr es:[bx + 0x20] ; CMP
06D39A  7D 04                 JGE    0x6d3a0 ; CJUMP
06D39C  26 8B 47 20           MOV    ax, word ptr es:[bx + 0x20] ; MOV
06D3A0  26 3B 47 34           CMP    ax, word ptr es:[bx + 0x34] ; CMP
06D3A4  7D 04                 JGE    0x6d3aa ; CJUMP
06D3A6  26 8B 47 34           MOV    ax, word ptr es:[bx + 0x34] ; MOV
06D3AA  26 89 47 28           MOV    word ptr es:[bx + 0x28], ax ; MOV
06D3AE  26 89 47 34           MOV    word ptr es:[bx + 0x34], ax ; MOV
06D3B2  26 89 47 20           MOV    word ptr es:[bx + 0x20], ax ; MOV
06D3B6  26 8B 47 02           MOV    ax, word ptr es:[bx + 2] ; MOV
06D3BA  26 03 47 04           ADD    ax, word ptr es:[bx + 4] ; ARITH
06D3BE  26 03 47 06           ADD    ax, word ptr es:[bx + 6] ; ARITH
06D3C2  26 03 47 08           ADD    ax, word ptr es:[bx + 8] ; ARITH
06D3C6  75 03                 JNE    0x6d3cb ; CJUMP
06D3C8  E9 B9 04              JMP    0x6d884 ; JUMP
06D3CB  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
06D3D0  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06D3D3  26 8B 47 5E           MOV    ax, word ptr es:[bx + 0x5e] ; MOV
06D3D7  26 0B 47 5C           OR     ax, word ptr es:[bx + 0x5c] ; LOGIC
06D3DB  74 49                 JE     0x6d426 ; CJUMP
06D3DD  26 8B 47 48           MOV    ax, word ptr es:[bx + 0x48] ; MOV
06D3E1  26 03 47 2E           ADD    ax, word ptr es:[bx + 0x2e] ; ARITH
06D3E5  26 03 47 30           ADD    ax, word ptr es:[bx + 0x30] ; ARITH
06D3E9  26 03 47 32           ADD    ax, word ptr es:[bx + 0x32] ; ARITH
06D3ED  26 01 47 14           ADD    word ptr es:[bx + 0x14], ax ; ARITH
06D3F1  26 01 47 2A           ADD    word ptr es:[bx + 0x2a], ax ; ARITH
06D3F5  26 01 47 24           ADD    word ptr es:[bx + 0x24], ax ; ARITH
06D3F9  26 01 47 36           ADD    word ptr es:[bx + 0x36], ax ; ARITH
06D3FD  26 8B 47 5C           MOV    ax, word ptr es:[bx + 0x5c] ; MOV
06D401  26 8B 57 5E           MOV    dx, word ptr es:[bx + 0x5e] ; MOV
06D405  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
06D408  89 56 F0              MOV    word ptr [bp - 0x10], dx ; LOCAL_STORE
06D40B  8B C2                 MOV    ax, dx ; MOV
06D40D  0B                    DB     0x0B ; DATA_BYTE
06D40E  46                    DB     0x46 ; DATA_BYTE
