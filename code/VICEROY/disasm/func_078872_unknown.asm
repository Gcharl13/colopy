; ============================================================================
; func_078872_unknown
; Region   : overlay
; Bytes    : file 0x078872..0x0789EF  (381 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078872  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
078876  52                    PUSH   dx ; STACK_PUSH
078877  50                    PUSH   ax ; STACK_PUSH
078878  2B C9                 SUB    cx, cx ; ARITH
07887A  89 4E FA              MOV    word ptr [bp - 6], cx ; LOCAL_STORE
07887D  89 4E F8              MOV    word ptr [bp - 8], cx ; LOCAL_STORE
078880  0B D2                 OR     dx, dx ; LOGIC
078882  7F 0C                 JG     0x78890 ; CJUMP
078884  7D 03                 JGE    0x78889 ; CJUMP
078886  E9 4B 01              JMP    0x789d4 ; JUMP
078889  0B C0                 OR     ax, ax ; LOGIC
07888B  75 03                 JNE    0x78890 ; CJUMP
07888D  E9 44 01              JMP    0x789d4 ; JUMP
078890  9A C6 0F 1F 1A        LCALL  0x1a1f, 0xfc6 ; THUNK -> 0x0000:0x0002 (thunk @file 0x01D5B6 type A) overlay @file 0x025902
078895  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
078898  89 56 EE              MOV    word ptr [bp - 0x12], dx ; LOCAL_STORE
07889B  9A BC 0F 1F 1A        LCALL  0x1a1f, 0xfbc ; THUNK -> 0x1100:0x000E (thunk @file 0x01D5AC type B)
0788A0  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0788A3  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
0788A6  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
0788A9  8B 56 EA              MOV    dx, word ptr [bp - 0x16] ; LOCAL_LOAD
0788AC  A3 52 26              MOV    word ptr [0x2652], ax ; GLOBAL_LOAD
0788AF  89 16 54 26           MOV    word ptr [0x2654], dx ; GLOBAL_LOAD
0788B3  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
0788B6  8B 56 EE              MOV    dx, word ptr [bp - 0x12] ; LOCAL_LOAD
0788B9  A3 56 26              MOV    word ptr [0x2656], ax ; GLOBAL_LOAD
0788BC  89 16 58 26           MOV    word ptr [0x2658], dx ; GLOBAL_LOAD
0788C0  8B 4E FC              MOV    cx, word ptr [bp - 4] ; LOCAL_LOAD
0788C3  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
0788C6  89 0E 5A 26           MOV    word ptr [0x265a], cx ; GLOBAL_LOAD
0788CA  89 1E 5C 26           MOV    word ptr [0x265c], bx ; GLOBAL_LOAD
0788CE  80 3E 4D 26 00        CMP    byte ptr [0x264d], 0 ; CMP
0788D3  75 13                 JNE    0x788e8 ; CJUMP
0788D5  A3 5E 26              MOV    word ptr [0x265e], ax ; GLOBAL_LOAD
0788D8  89 16 60 26           MOV    word ptr [0x2660], dx ; GLOBAL_LOAD
0788DC  A3 62 26              MOV    word ptr [0x2662], ax ; GLOBAL_LOAD
0788DF  89 16 64 26           MOV    word ptr [0x2664], dx ; GLOBAL_LOAD
0788E3  C6 06 4D 26 01        MOV    byte ptr [0x264d], 1 ; GLOBAL_LOAD
0788E8  80 3E 4E 26 00        CMP    byte ptr [0x264e], 0 ; CMP
0788ED  75 17                 JNE    0x78906 ; CJUMP
0788EF  8B C1                 MOV    ax, cx ; MOV
0788F1  8B D3                 MOV    dx, bx ; MOV
0788F3  A3 66 26              MOV    word ptr [0x2666], ax ; GLOBAL_LOAD
0788F6  89 16 68 26           MOV    word ptr [0x2668], dx ; GLOBAL_LOAD
0788FA  A3 6A 26              MOV    word ptr [0x266a], ax ; GLOBAL_LOAD
0788FD  89 16 6C 26           MOV    word ptr [0x266c], dx ; GLOBAL_LOAD
078901  C6 06 4E 26 01        MOV    byte ptr [0x264e], 1 ; GLOBAL_LOAD
078906  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
078909  8B 56 EA              MOV    dx, word ptr [bp - 0x16] ; LOCAL_LOAD
07890C  3B DA                 CMP    bx, dx ; CMP
07890E  7C 0C                 JL     0x7891c ; CJUMP
078910  7F 04                 JG     0x78916 ; CJUMP
078912  3B C8                 CMP    cx, ax ; CMP
078914  72 06                 JB     0x7891c ; CJUMP
078916  B8 01 00              MOV    ax, 1 ; MOV
078919  EB 03                 JMP    0x7891e ; JUMP
07891B  90                    NOP ; NOP
07891C  2B C0                 SUB    ax, ax ; ARITH
07891E  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
078921  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
078924  3B DA                 CMP    bx, dx ; CMP
078926  7C 0C                 JL     0x78934 ; CJUMP
078928  7F 04                 JG     0x7892e ; CJUMP
07892A  3B C8                 CMP    cx, ax ; CMP
07892C  72 06                 JB     0x78934 ; CJUMP
07892E  8B C1                 MOV    ax, cx ; MOV
078930  8B D3                 MOV    dx, bx ; MOV
078932  EB 06                 JMP    0x7893a ; JUMP
078934  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
078937  8B 56 EE              MOV    dx, word ptr [bp - 0x12] ; LOCAL_LOAD
07893A  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
07893D  89 56 F2              MOV    word ptr [bp - 0xe], dx ; LOCAL_STORE
078940  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
078943  8B 56 EA              MOV    dx, word ptr [bp - 0x16] ; LOCAL_LOAD
078946  D1 FA                 SAR    dx, 1 ; LOGIC
078948  D1 D8                 RCR    ax, 1 ; LOGIC
07894A  D1 FA                 SAR    dx, 1 ; LOGIC
07894C  D1 D8                 RCR    ax, 1 ; LOGIC
07894E  D1 FA                 SAR    dx, 1 ; LOGIC
078950  D1 D8                 RCR    ax, 1 ; LOGIC
078952  D1 FA                 SAR    dx, 1 ; LOGIC
078954  D1 D8                 RCR    ax, 1 ; LOGIC
078956  40                    INC    ax ; ARITH
078957  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
07895A  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
07895D  8B 56 EA              MOV    dx, word ptr [bp - 0x16] ; LOCAL_LOAD
078960  3B DA                 CMP    bx, dx ; CMP
078962  7C 42                 JL     0x789a6 ; CJUMP
078964  7F 04                 JG     0x7896a ; CJUMP
078966  3B C8                 CMP    cx, ax ; CMP
078968  72 3C                 JB     0x789a6 ; CJUMP
07896A  52                    PUSH   dx ; STACK_PUSH
07896B  50                    PUSH   ax ; STACK_PUSH
07896C  9A DE 0F 1F 1A        LCALL  0x1a1f, 0xfde ; THUNK -> 0x1103:0x000A (thunk @file 0x01D5CE type B) overlay @file 0x030566
078971  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
078974  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
078977  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
07897A  0B D0                 OR     dx, ax ; LOGIC
07897C  74 28                 JE     0x789a6 ; CJUMP
07897E  9A BC 0F 1F 1A        LCALL  0x1a1f, 0xfbc ; THUNK -> 0x1100:0x000E (thunk @file 0x01D5AC type B)
078983  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
078986  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
078989  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
07898C  89 56 F2              MOV    word ptr [bp - 0xe], dx ; LOCAL_STORE
07898F  3B 16 6C 26           CMP    dx, word ptr [0x266c] ; CMP
078993  7F 3F                 JG     0x789d4 ; CJUMP
078995  7C 06                 JL     0x7899d ; CJUMP
078997  3B 06 6A 26           CMP    ax, word ptr [0x266a] ; CMP
07899B  73 37                 JAE    0x789d4 ; CJUMP
07899D  A3 6A 26              MOV    word ptr [0x266a], ax ; GLOBAL_LOAD
0789A0  89 16 6C 26           MOV    word ptr [0x266c], dx ; GLOBAL_LOAD
0789A4  EB 2E                 JMP    0x789d4 ; JUMP
0789A6  8B 5E F4              MOV    bx, word ptr [bp - 0xc] ; LOCAL_LOAD
0789A9  B4 48                 MOV    ah, 0x48 ; CONST_LOAD
0789AB  CD 21                 INT    0x21 ; SYS
0789AD  72 0B                 JB     0x789ba ; CJUMP
0789AF  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
0789B4  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0789B7  EB 01                 JMP    0x789ba ; JUMP
0789B9  90                    NOP ; NOP
0789BA  9A C6 0F 1F 1A        LCALL  0x1a1f, 0xfc6 ; THUNK -> 0x0000:0x0002 (thunk @file 0x01D5B6 type A) overlay @file 0x025902
0789BF  3B 16 64 26           CMP    dx, word ptr [0x2664] ; CMP
0789C3  7F 0F                 JG     0x789d4 ; CJUMP
0789C5  7C 06                 JL     0x789cd ; CJUMP
0789C7  3B 06 62 26           CMP    ax, word ptr [0x2662] ; CMP
0789CB  73 07                 JAE    0x789d4 ; CJUMP
0789CD  A3 62 26              MOV    word ptr [0x2662], ax ; GLOBAL_LOAD
0789D0  89 16 64 26           MOV    word ptr [0x2664], dx ; GLOBAL_LOAD
0789D4  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0789D7  0B 46 F8              OR     ax, word ptr [bp - 8] ; LOGIC
0789DA  75 04                 JNE    0x789e0 ; CJUMP
0789DC  B0 01                 MOV    al, 1 ; MOV
0789DE  EB 02                 JMP    0x789e2 ; JUMP
0789E0  2A C0                 SUB    al, al ; ARITH
0789E2  A2 4F 26              MOV    byte ptr [0x264f], al ; GLOBAL_LOAD
0789E5  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
0789E8  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
0789EB  C9                    LEAVE ; EPILOGUE
0789EC  CA 04 00              RETF   4 ; RETURN
