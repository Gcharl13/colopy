; ============================================================================
; func_027746_unknown
; Region   : overlay
; Bytes    : file 0x027746..0x02791D  (471 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "BUILD"  (auto-named via string xrefs)
; ============================================================================

027746  C8 76 00 00           ENTER  0x76, 0 ; PROLOGUE
02774A  83 3E 98 0B 00        CMP    word ptr [0xb98], 0 ; CMP
02774F  74 5B                 JE     0x277ac ; CJUMP
027751  C6 46 A0 00           MOV    byte ptr [bp - 0x60], 0 ; LOCAL_STORE
027755  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
027758  50                    PUSH   ax ; STACK_PUSH
027759  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02775D  8A 87 94 00           MOV    al, byte ptr [bx + 0x94] ; MOV
027761  98                    CWDE ; ARITH
027762  50                    PUSH   ax ; STACK_PUSH
027763  9A C4 0A 1F 18        LCALL  0x181f, 0xac4 ; THUNK -> 0x05EB:0x33AA (thunk @file 0x01B0B4 type B) overlay @file 0x02A39A
027768  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02776B  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
02776E  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
027772  8A 87 94 00           MOV    al, byte ptr [bx + 0x94] ; MOV
027776  98                    CWDE ; ARITH
027777  50                    PUSH   ax ; STACK_PUSH
027778  9A 4E 0D 1F 18        LCALL  0x181f, 0xd4e ; THUNK -> 0x05EB:0x334A (thunk @file 0x01B33E type B) overlay @file 0x02A33A
02777D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
027780  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
027783  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
027786  0B D0                 OR     dx, ax ; LOGIC
027788  74 11                 JE     0x2779b ; CJUMP
02778A  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
02778D  50                    PUSH   ax ; STACK_PUSH
02778E  8D 46 A0              LEA    ax, [bp - 0x60] ; ADDR
027791  16                    PUSH   ss ; STACK_PUSH
027792  50                    PUSH   ax ; STACK_PUSH
027793  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
027798  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
02779B  6A 39                 PUSH   0x39 ; PUSH_CONST
02779D  68 84 00              PUSH   0x84                         ; STRING: "BUILD"
0277A0  6A 5B                 PUSH   0x5b ; PUSH_CONST
0277A2  68 D3 00              PUSH   0xd3 ; PUSH_CONST
0277A5  8D 46 A0              LEA    ax, [bp - 0x60] ; ADDR
0277A8  16                    PUSH   ss ; STACK_PUSH
0277A9  EB 18                 JMP    0x277c3 ; JUMP
0277AB  90                    NOP ; NOP
0277AC  6A 39                 PUSH   0x39 ; PUSH_CONST
0277AE  68 84 00              PUSH   0x84                         ; STRING: "BUILD"
0277B1  6A 5B                 PUSH   0x5b ; PUSH_CONST
0277B3  68 D3 00              PUSH   0xd3 ; PUSH_CONST
0277B6  FF 36 9A 93           PUSH   word ptr [0x939a] ; PUSH_GLOBAL
0277BA  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
0277BF  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0277C2  52                    PUSH   dx ; STACK_PUSH
0277C3  50                    PUSH   ax ; STACK_PUSH
0277C4  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
0277C9  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0277CC  C7 46 9C 9E 00        MOV    word ptr [bp - 0x64], 0x9e ; LOCAL_STORE
0277D1  B8 D5 00              MOV    ax, 0xd5 ; CONST_LOAD
0277D4  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
0277D7  89 46 92              MOV    word ptr [bp - 0x6e], ax ; LOCAL_STORE
0277DA  C7 46 94 12 00        MOV    word ptr [bp - 0x6c], 0x12 ; LOCAL_STORE
0277DF  C7 46 8C 05 00        MOV    word ptr [bp - 0x74], 5 ; LOCAL_STORE
0277E4  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
0277E7  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
0277EA  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
0277ED  2B C0                 SUB    ax, ax ; ARITH
0277EF  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
0277F2  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
0277F5  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
0277F8  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0277FB  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0277FF  8A 07                 MOV    al, byte ptr [bx] ; MOV
027801  2A E4                 SUB    ah, ah ; ARITH
027803  8A 57 01              MOV    dl, byte ptr [bx + 1] ; MOV
027806  2A F6                 SUB    dh, dh ; ARITH
027808  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
02780D  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
027810  E9 F8 00              JMP    0x2790b ; JUMP
027813  90                    NOP ; NOP
027814  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
027818  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
02781C  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
02781F  03 46 90              ADD    ax, word ptr [bp - 0x70] ; ARITH
027822  48                    DEC    ax ; ARITH
027823  50                    PUSH   ax ; STACK_PUSH
027824  6A 23                 PUSH   0x23 ; PUSH_CONST
027826  8B 46 8E              MOV    ax, word ptr [bp - 0x72] ; LOCAL_LOAD
027829  9A DA 02 1F 18        LCALL  0x181f, 0x2da ; THUNK -> 0x012B:0x0060 (thunk @file 0x01A8CA type B) overlay @file 0x0235CA
02782E  8B 56 F6              MOV    dx, word ptr [bp - 0xa] ; LOCAL_LOAD
027831  D1 FA                 SAR    dx, 1 ; LOGIC
027833  03 56 92              ADD    dx, word ptr [bp - 0x6e] ; ARITH
027836  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
02783A  9A F8 02 1F 18        LCALL  0x181f, 0x2f8 ; THUNK -> 0x0C56:0x0004 (thunk @file 0x01A8E8 type B)
02783F  A1 7A 8D              MOV    ax, word ptr [0x8d7a] ; GLOBAL_LOAD
027842  39 46 9A              CMP    word ptr [bp - 0x66], ax ; CMP
027845  75 68                 JNE    0x278af ; CJUMP
027847  C7 46 8A 0A 00        MOV    word ptr [bp - 0x76], 0xa ; LOCAL_STORE
02784C  83 3E EE 07 00        CMP    word ptr [0x7ee], 0 ; CMP
027851  74 0C                 JE     0x2785f ; CJUMP
027853  83 3E 54 8D 04        CMP    word ptr [0x8d54], 4 ; CMP
027858  75 05                 JNE    0x2785f ; CJUMP
02785A  C7 46 8A 0F 00        MOV    word ptr [bp - 0x76], 0xf ; LOCAL_STORE
02785F  83 3E 2E 03 03        CMP    word ptr [0x32e], 3 ; CMP
027864  75 0C                 JNE    0x27872 ; CJUMP
027866  83 3E 34 03 00        CMP    word ptr [0x334], 0 ; CMP
02786B  74 05                 JE     0x27872 ; CJUMP
02786D  C7 46 8A 0F 00        MOV    word ptr [bp - 0x76], 0xf ; LOCAL_STORE
027872  83 7E 8A 00           CMP    word ptr [bp - 0x76], 0 ; CMP
027876  74 37                 JE     0x278af ; CJUMP
027878  83 3E 98 0B 00        CMP    word ptr [0xb98], 0 ; CMP
02787D  75 30                 JNE    0x278af ; CJUMP
02787F  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
027883  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
027887  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
02788B  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
02788F  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
027892  03 46 9C              ADD    ax, word ptr [bp - 0x64] ; ARITH
027895  50                    PUSH   ax ; STACK_PUSH
027896  8A 46 8A              MOV    al, byte ptr [bp - 0x76] ; LOCAL_LOAD
027899  50                    PUSH   ax ; STACK_PUSH
02789A  8B 46 92              MOV    ax, word ptr [bp - 0x6e] ; LOCAL_LOAD
02789D  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
0278A0  03 D8                 ADD    bx, ax ; ARITH
0278A2  48                    DEC    ax ; ARITH
0278A3  8B 56 9C              MOV    dx, word ptr [bp - 0x64] ; LOCAL_LOAD
0278A6  2B 56 F8              SUB    dx, word ptr [bp - 8] ; ARITH
0278A9  4A                    DEC    dx ; ARITH
0278AA  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
0278AF  8B 46 94              MOV    ax, word ptr [bp - 0x6c] ; LOCAL_LOAD
0278B2  01 46 92              ADD    word ptr [bp - 0x6e], ax ; ARITH
0278B5  8B 46 8C              MOV    ax, word ptr [bp - 0x74] ; LOCAL_LOAD
0278B8  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
0278BB  39 46 F0              CMP    word ptr [bp - 0x10], ax ; CMP
0278BE  7C 40                 JL     0x27900 ; CJUMP
0278C0  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
0278C5  FF 46 98              INC    word ptr [bp - 0x68] ; ARITH
0278C8  83 7E 98 03           CMP    word ptr [bp - 0x68], 3 ; CMP
0278CC  7C 03                 JL     0x278d1 ; CJUMP
0278CE  E9 81 00              JMP    0x27952 ; JUMP
0278D1  83 7E 98 01           CMP    word ptr [bp - 0x68], 1 ; CMP
0278D5  75 07                 JNE    0x278de ; CJUMP
0278D7  C7 46 9C 98 00        MOV    word ptr [bp - 0x64], 0x98 ; LOCAL_STORE
0278DC  EB 05                 JMP    0x278e3 ; JUMP
0278DE  C7 46 9C 90 00        MOV    word ptr [bp - 0x64], 0x90 ; LOCAL_STORE
0278E3  C7 46 92 D5 00        MOV    word ptr [bp - 0x6e], 0xd5 ; LOCAL_STORE
0278E8  C7 46 8C 11 00        MOV    word ptr [bp - 0x74], 0x11 ; LOCAL_STORE
0278ED  C7 46 F6 03 00        MOV    word ptr [bp - 0xa], 3 ; LOCAL_STORE
0278F2  B8 05 00              MOV    ax, 5 ; MOV
0278F5  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
0278F8  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
0278FB  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
027900  FF 46 9A              INC    word ptr [bp - 0x66] ; ARITH
027903  8B 46 8E              MOV    ax, word ptr [bp - 0x72] ; LOCAL_LOAD
027906  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
02790B  89 46 8E              MOV    word ptr [bp - 0x72], ax ; LOCAL_STORE
02790E  0B C0                 OR     ax, ax ; LOGIC
027910  7C 40                 JL     0x27952 ; CJUMP
027912  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
027915  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
027919  2A FF                 SUB    bh, bh ; ARITH
02791B  8B C3                 MOV    ax, bx ; MOV
