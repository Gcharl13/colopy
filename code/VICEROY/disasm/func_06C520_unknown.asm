; ============================================================================
; func_06C520_unknown
; Region   : overlay
; Bytes    : file 0x06C520..0x06C6EA  (458 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C520  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
06C524  2B C0                 SUB    ax, ax ; ARITH
06C526  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
06C529  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
06C52C  A3 6E 1F              MOV    word ptr [0x1f6e], ax ; GLOBAL_LOAD
06C52F  A3 70 1F              MOV    word ptr [0x1f70], ax ; GLOBAL_LOAD
06C532  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06C535  05 96 00              ADD    ax, 0x96 ; ARITH
06C538  2B D2                 SUB    dx, dx ; ARITH
06C53A  9A 9A 02 1F 18        LCALL  0x181f, 0x29a ; THUNK -> 0x0000:0x01A0 (thunk @file 0x01A88A type A) overlay @file 0x025AA0
06C53F  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
06C542  89 56 F2              MOV    word ptr [bp - 0xe], dx ; LOCAL_STORE
06C545  0B D0                 OR     dx, ax ; LOGIC
06C547  75 03                 JNE    0x6c54c ; CJUMP
06C549  E9 73 01              JMP    0x6c6bf ; JUMP
06C54C  8B 56 F2              MOV    dx, word ptr [bp - 0xe] ; LOCAL_LOAD
06C54F  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
06C552  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
06C555  05 96 00              ADD    ax, 0x96 ; ARITH
06C558  8B 4E F8              MOV    cx, word ptr [bp - 8] ; LOCAL_LOAD
06C55B  8B DA                 MOV    bx, dx ; MOV
06C55D  81 C1 84 00           ADD    cx, 0x84 ; ARITH
06C561  53                    PUSH   bx ; STACK_PUSH
06C562  51                    PUSH   cx ; STACK_PUSH
06C563  52                    PUSH   dx ; STACK_PUSH
06C564  50                    PUSH   ax ; STACK_PUSH
06C565  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06C568  99                    CDQ ; ARITH
06C569  52                    PUSH   dx ; STACK_PUSH
06C56A  50                    PUSH   ax ; STACK_PUSH
06C56B  B8 29 00              MOV    ax, 0x29 ; CONST_LOAD
06C56E  9A 56 03 1F 1A        LCALL  0x1a1f, 0x356 ; THUNK -> 0x0000:0x009E (thunk @file 0x01C946 type A) overlay @file 0x02599E
06C573  C4 5E F8              LES    bx, ptr [bp - 8] ; MOV_FAR
06C576  2B C0                 SUB    ax, ax ; ARITH
06C578  26 89 47 4E           MOV    word ptr es:[bx + 0x4e], ax ; MOV
06C57C  26 89 47 4C           MOV    word ptr es:[bx + 0x4c], ax ; MOV
06C580  26 89 47 52           MOV    word ptr es:[bx + 0x52], ax ; MOV
06C584  26 89 47 50           MOV    word ptr es:[bx + 0x50], ax ; MOV
06C588  A1 56 1F              MOV    ax, word ptr [0x1f56] ; GLOBAL_LOAD
06C58B  26 89 47 0A           MOV    word ptr es:[bx + 0xa], ax ; MOV
06C58F  A1 58 1F              MOV    ax, word ptr [0x1f58] ; GLOBAL_LOAD
06C592  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax ; MOV
06C596  A1 5A 1F              MOV    ax, word ptr [0x1f5a] ; GLOBAL_LOAD
06C599  26 89 47 0E           MOV    word ptr es:[bx + 0xe], ax ; MOV
06C59D  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
06C5A0  A3 58 1F              MOV    word ptr [0x1f58], ax ; GLOBAL_LOAD
06C5A3  A3 5A 1F              MOV    word ptr [0x1f5a], ax ; GLOBAL_LOAD
06C5A6  26 C7 47 28 50 00     MOV    word ptr es:[bx + 0x28], 0x50 ; CONST_LOAD
06C5AC  B8 04 00              MOV    ax, 4 ; MOV
06C5AF  26 89 47 22           MOV    word ptr es:[bx + 0x22], ax ; MOV
06C5B3  26 89 47 32           MOV    word ptr es:[bx + 0x32], ax ; MOV
06C5B7  A1 3C 1F              MOV    ax, word ptr [0x1f3c] ; GLOBAL_LOAD
06C5BA  26 89 47 3C           MOV    word ptr es:[bx + 0x3c], ax ; MOV
06C5BE  A1 3E 1F              MOV    ax, word ptr [0x1f3e] ; GLOBAL_LOAD
06C5C1  26 89 47 3E           MOV    word ptr es:[bx + 0x3e], ax ; MOV
06C5C5  A1 40 1F              MOV    ax, word ptr [0x1f40] ; GLOBAL_LOAD
06C5C8  26 89 47 40           MOV    word ptr es:[bx + 0x40], ax ; MOV
06C5CC  A1 42 1F              MOV    ax, word ptr [0x1f42] ; GLOBAL_LOAD
06C5CF  26 89 47 42           MOV    word ptr es:[bx + 0x42], ax ; MOV
06C5D3  A1 44 1F              MOV    ax, word ptr [0x1f44] ; GLOBAL_LOAD
06C5D6  26 89 47 44           MOV    word ptr es:[bx + 0x44], ax ; MOV
06C5DA  26 8A 47 0A           MOV    al, byte ptr es:[bx + 0xa] ; MOV
06C5DE  25 10 00              AND    ax, 0x10 ; LOGIC
06C5E1  3D 01 00              CMP    ax, 1 ; CMP
06C5E4  1B C9                 SBB    cx, cx ; ARITH
06C5E6  83 E1 03              AND    cx, 3 ; LOGIC
06C5E9  26 89 4F 46           MOV    word ptr es:[bx + 0x46], cx ; MOV
06C5ED  3D 01 00              CMP    ax, 1 ; CMP
06C5F0  1B C0                 SBB    ax, ax ; ARITH
06C5F2  25 02 00              AND    ax, 2 ; LOGIC
06C5F5  26 89 47 48           MOV    word ptr es:[bx + 0x48], ax ; MOV
06C5F9  2B C0                 SUB    ax, ax ; ARITH
06C5FB  26 89 47 56           MOV    word ptr es:[bx + 0x56], ax ; MOV
06C5FF  26 89 47 54           MOV    word ptr es:[bx + 0x54], ax ; MOV
06C603  26 89 47 5A           MOV    word ptr es:[bx + 0x5a], ax ; MOV
06C607  26 89 47 58           MOV    word ptr es:[bx + 0x58], ax ; MOV
06C60B  26 89 47 5E           MOV    word ptr es:[bx + 0x5e], ax ; MOV
06C60F  26 89 47 5C           MOV    word ptr es:[bx + 0x5c], ax ; MOV
06C613  26 89 47 62           MOV    word ptr es:[bx + 0x62], ax ; MOV
06C617  26 89 47 60           MOV    word ptr es:[bx + 0x60], ax ; MOV
06C61B  26 89 47 72           MOV    word ptr es:[bx + 0x72], ax ; MOV
06C61F  26 89 47 70           MOV    word ptr es:[bx + 0x70], ax ; MOV
06C623  26 89 47 66           MOV    word ptr es:[bx + 0x66], ax ; MOV
06C627  26 89 47 64           MOV    word ptr es:[bx + 0x64], ax ; MOV
06C62B  26 89 47 6A           MOV    word ptr es:[bx + 0x6a], ax ; MOV
06C62F  26 89 47 68           MOV    word ptr es:[bx + 0x68], ax ; MOV
06C633  26 89 47 6E           MOV    word ptr es:[bx + 0x6e], ax ; MOV
06C637  26 89 47 6C           MOV    word ptr es:[bx + 0x6c], ax ; MOV
06C63B  FF 36 52 1F           PUSH   word ptr [0x1f52] ; PUSH_GLOBAL
06C63F  FF 36 50 1F           PUSH   word ptr [0x1f50] ; PUSH_GLOBAL
06C643  FF 36 4E 1F           PUSH   word ptr [0x1f4e] ; PUSH_GLOBAL
06C647  FF 36 4C 1F           PUSH   word ptr [0x1f4c] ; PUSH_GLOBAL
06C64B  FF 36 4A 1F           PUSH   word ptr [0x1f4a] ; PUSH_GLOBAL
06C64F  26 89 07              MOV    word ptr es:[bx], ax ; MOV
06C652  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
06C656  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
06C65A  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
06C65E  26 89 47 08           MOV    word ptr es:[bx + 8], ax ; MOV
06C662  A3 56 1F              MOV    word ptr [0x1f56], ax ; GLOBAL_LOAD
06C665  26 89 47 20           MOV    word ptr es:[bx + 0x20], ax ; MOV
06C669  26 89 47 24           MOV    word ptr es:[bx + 0x24], ax ; MOV
06C66D  26 89 47 26           MOV    word ptr es:[bx + 0x26], ax ; MOV
06C671  26 89 47 2A           MOV    word ptr es:[bx + 0x2a], ax ; MOV
06C675  26 89 47 2C           MOV    word ptr es:[bx + 0x2c], ax ; MOV
06C679  26 89 47 2E           MOV    word ptr es:[bx + 0x2e], ax ; MOV
06C67D  26 89 47 30           MOV    word ptr es:[bx + 0x30], ax ; MOV
06C681  26 89 47 34           MOV    word ptr es:[bx + 0x34], ax ; MOV
06C685  26 89 47 36           MOV    word ptr es:[bx + 0x36], ax ; MOV
06C689  26 89 47 38           MOV    word ptr es:[bx + 0x38], ax ; MOV
06C68D  26 89 47 4A           MOV    word ptr es:[bx + 0x4a], ax ; MOV
06C691  50                    PUSH   ax ; STACK_PUSH
06C692  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
06C695  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06C698  8D 47 74              LEA    ax, [bx + 0x74] ; ADDR
06C69B  06                    PUSH   es ; STACK_PUSH
06C69C  50                    PUSH   ax ; STACK_PUSH
06C69D  0E                    PUSH   cs ; STACK_PUSH
06C69E  E8 9E 31              CALL   0x6f83f ; CALL_NEAR
06C6A1  83 C4 14              ADD    sp, 0x14 ; STACK_CLEANUP
06C6A4  83 3E AC 83 00        CMP    word ptr [0x83ac], 0 ; CMP
06C6A9  75 08                 JNE    0x6c6b3 ; CJUMP
06C6AB  C4 5E F8              LES    bx, ptr [bp - 8] ; MOV_FAR
06C6AE  26 80 4F 0A 80        OR     byte ptr es:[bx + 0xa], 0x80 ; LOGIC
06C6B3  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
06C6B6  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
06C6B9  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
06C6BC  89 56 EE              MOV    word ptr [bp - 0x12], dx ; LOCAL_STORE
06C6BF  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
06C6C2  0B 46 F0              OR     ax, word ptr [bp - 0x10] ; LOGIC
06C6C5  74 1B                 JE     0x6c6e2 ; CJUMP
06C6C7  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
06C6CA  8B 56 EE              MOV    dx, word ptr [bp - 0x12] ; LOCAL_LOAD
06C6CD  39 46 F0              CMP    word ptr [bp - 0x10], ax ; CMP
06C6D0  75 05                 JNE    0x6c6d7 ; CJUMP
06C6D2  39 56 F2              CMP    word ptr [bp - 0xe], dx ; CMP
06C6D5  74 0B                 JE     0x6c6e2 ; CJUMP
06C6D7  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
06C6DA  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
06C6DD  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
06C6E2  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
06C6E5  8B 56 EE              MOV    dx, word ptr [bp - 0x12] ; LOCAL_LOAD
06C6E8  C9                    LEAVE ; EPILOGUE
06C6E9  CB                    RETF ; RETURN
