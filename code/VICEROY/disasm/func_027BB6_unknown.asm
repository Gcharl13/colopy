; ============================================================================
; func_027BB6_unknown
; Region   : overlay
; Bytes    : file 0x027BB6..0x027C62  (172 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "BUILD"  (auto-named via string xrefs)
; ============================================================================

027BB6  C8 74 00 00           ENTER  0x74, 0 ; PROLOGUE
027BBA  C6 46 A4 00           MOV    byte ptr [bp - 0x5c], 0 ; LOCAL_STORE
027BBE  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
027BC1  50                    PUSH   ax ; STACK_PUSH
027BC2  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
027BC6  8A 87 94 00           MOV    al, byte ptr [bx + 0x94] ; MOV
027BCA  98                    CWDE ; ARITH
027BCB  50                    PUSH   ax ; STACK_PUSH
027BCC  9A C4 0A 1F 18        LCALL  0x181f, 0xac4 ; THUNK -> 0x05EB:0x33AA (thunk @file 0x01B0B4 type B) overlay @file 0x02A39A
027BD1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
027BD4  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
027BD7  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
027BDB  8A 87 94 00           MOV    al, byte ptr [bx + 0x94] ; MOV
027BDF  98                    CWDE ; ARITH
027BE0  50                    PUSH   ax ; STACK_PUSH
027BE1  9A 4E 0D 1F 18        LCALL  0x181f, 0xd4e ; THUNK -> 0x05EB:0x334A (thunk @file 0x01B33E type B) overlay @file 0x02A33A
027BE6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
027BE9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
027BEC  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
027BEF  0B D0                 OR     dx, ax ; LOGIC
027BF1  74 11                 JE     0x27c04 ; CJUMP
027BF3  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
027BF6  50                    PUSH   ax ; STACK_PUSH
027BF7  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
027BFA  16                    PUSH   ss ; STACK_PUSH
027BFB  50                    PUSH   ax ; STACK_PUSH
027BFC  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
027C01  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
027C04  6A 39                 PUSH   0x39 ; PUSH_CONST
027C06  68 84 00              PUSH   0x84                         ; STRING: "BUILD"
027C09  6A 5B                 PUSH   0x5b ; PUSH_CONST
027C0B  68 D3 00              PUSH   0xd3 ; PUSH_CONST
027C0E  8D 46 A4              LEA    ax, [bp - 0x5c] ; ADDR
027C11  16                    PUSH   ss ; STACK_PUSH
027C12  50                    PUSH   ax ; STACK_PUSH
027C13  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
027C18  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
027C1B  0E                    PUSH   cs ; STACK_PUSH
027C1C  E8 45 4E              CALL   0x2ca64 ; CALL_NEAR
027C1F  B8 5A 00              MOV    ax, 0x5a ; CONST_LOAD
027C22  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
027C26  26 8B 8F D2 02        MOV    cx, word ptr es:[bx + 0x2d2] ; MOV
027C2B  89 4E 92              MOV    word ptr [bp - 0x6e], cx ; LOCAL_STORE
027C2E  41                    INC    cx ; ARITH
027C2F  99                    CDQ ; ARITH
027C30  F7 F9                 IDIV   cx ; ARITH
027C32  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
027C35  C7 46 96 04 00        MOV    word ptr [bp - 0x6a], 4 ; LOCAL_STORE
027C3A  26 8B 8F D4 02        MOV    cx, word ptr es:[bx + 0x2d4] ; MOV
027C3F  D1 F9                 SAR    cx, 1 ; LOGIC
027C41  89 4E 90              MOV    word ptr [bp - 0x70], cx ; LOCAL_STORE
027C44  89 46 8E              MOV    word ptr [bp - 0x72], ax ; LOCAL_STORE
027C47  8B C8                 MOV    cx, ax ; MOV
027C49  8B 46 9C              MOV    ax, word ptr [bp - 0x64] ; LOCAL_LOAD
027C4C  48                    DEC    ax ; ARITH
027C4D  8B D8                 MOV    bx, ax ; MOV
027C4F  99                    CDQ ; ARITH
027C50  F7 F9                 IDIV   cx ; ARITH
027C52  40                    INC    ax ; ARITH
027C53  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
027C56  3D 04 00              CMP    ax, 4 ; CMP
027C59  7E 17                 JLE    0x27c72 ; CJUMP
027C5B  C7 46 98 04 00        MOV    word ptr [bp - 0x68], 4 ; LOCAL_STORE
027C60  8B C3                 MOV    ax, bx ; MOV
