; ============================================================================
; func_0450BA_unknown
; Region   : overlay
; Bytes    : file 0x0450BA..0x0451B2  (248 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0450BA  C8 24 00 00           ENTER  0x24, 0 ; PROLOGUE
0450BE  57                    PUSH   di ; STACK_PUSH
0450BF  56                    PUSH   si ; STACK_PUSH
0450C0  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
0450C3  26 8B 47 12           MOV    ax, word ptr es:[bx + 0x12] ; MOV
0450C7  26 8B 57 14           MOV    dx, word ptr es:[bx + 0x14] ; MOV
0450CB  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
0450CE  89 56 EA              MOV    word ptr [bp - 0x16], dx ; LOCAL_STORE
0450D1  8D 46 DC              LEA    ax, [bp - 0x24] ; ADDR
0450D4  50                    PUSH   ax ; STACK_PUSH
0450D5  8D 4E E0              LEA    cx, [bp - 0x20] ; ADDR
0450D8  51                    PUSH   cx ; STACK_PUSH
0450D9  8D 56 DE              LEA    dx, [bp - 0x22] ; ADDR
0450DC  52                    PUSH   dx ; STACK_PUSH
0450DD  8D 76 E2              LEA    si, [bp - 0x1e] ; ADDR
0450E0  56                    PUSH   si ; STACK_PUSH
0450E1  8D 7E E6              LEA    di, [bp - 0x1a] ; ADDR
0450E4  57                    PUSH   di ; STACK_PUSH
0450E5  8D 46 E4              LEA    ax, [bp - 0x1c] ; ADDR
0450E8  50                    PUSH   ax ; STACK_PUSH
0450E9  06                    PUSH   es ; STACK_PUSH
0450EA  53                    PUSH   bx ; STACK_PUSH
0450EB  0E                    PUSH   cs ; STACK_PUSH
0450EC  E8 08 0B              CALL   0x45bf7 ; CALL_NEAR
0450EF  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
0450F2  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0450F6  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0450FA  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0450FE  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
045102  8B 46 DE              MOV    ax, word ptr [bp - 0x22] ; LOCAL_LOAD
045105  03 46 E6              ADD    ax, word ptr [bp - 0x1a] ; ARITH
045108  48                    DEC    ax ; ARITH
045109  50                    PUSH   ax ; STACK_PUSH
04510A  C4 5E E8              LES    bx, ptr [bp - 0x18] ; MOV_FAR
04510D  26 8A 47 1E           MOV    al, byte ptr es:[bx + 0x1e] ; MOV
045111  50                    PUSH   ax ; STACK_PUSH
045112  8B 46 E4              MOV    ax, word ptr [bp - 0x1c] ; LOCAL_LOAD
045115  8B 5E E2              MOV    bx, word ptr [bp - 0x1e] ; LOCAL_LOAD
045118  03 D8                 ADD    bx, ax ; ARITH
04511A  8D 5F FF              LEA    bx, [bx - 1] ; ADDR
04511D  8B 56 E6              MOV    dx, word ptr [bp - 0x1a] ; LOCAL_LOAD
045120  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
045125  8B 46 E4              MOV    ax, word ptr [bp - 0x1c] ; LOCAL_LOAD
045128  40                    INC    ax ; ARITH
045129  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
04512C  8B 4E E6              MOV    cx, word ptr [bp - 0x1a] ; LOCAL_LOAD
04512F  41                    INC    cx ; ARITH
045130  89 4E DC              MOV    word ptr [bp - 0x24], cx ; LOCAL_STORE
045133  8B 56 E2              MOV    dx, word ptr [bp - 0x1e] ; LOCAL_LOAD
045136  4A                    DEC    dx ; ARITH
045137  4A                    DEC    dx ; ARITH
045138  89 56 F2              MOV    word ptr [bp - 0xe], dx ; LOCAL_STORE
04513B  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
04513F  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
045143  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
045147  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
04514B  8B 5E DE              MOV    bx, word ptr [bp - 0x22] ; LOCAL_LOAD
04514E  4B                    DEC    bx ; ARITH
04514F  4B                    DEC    bx ; ARITH
045150  53                    PUSH   bx ; STACK_PUSH
045151  FF 76 E4              PUSH   word ptr [bp - 0x1c] ; PUSH_GLOBAL
045154  FF 76 E6              PUSH   word ptr [bp - 0x1a] ; PUSH_GLOBAL
045157  FF 76 E2              PUSH   word ptr [bp - 0x1e] ; PUSH_GLOBAL
04515A  C4 5E E8              LES    bx, ptr [bp - 0x18] ; MOV_FAR
04515D  26 8A 5F 12           MOV    bl, byte ptr es:[bx + 0x12] ; MOV
045161  53                    PUSH   bx ; STACK_PUSH
045162  8B 5E E8              MOV    bx, word ptr [bp - 0x18] ; LOCAL_LOAD
045165  26 8A 5F 14           MOV    bl, byte ptr es:[bx + 0x14] ; MOV
045169  53                    PUSH   bx ; STACK_PUSH
04516A  6A 00                 PUSH   0 ; STACK_PUSH
04516C  6A 00                 PUSH   0 ; STACK_PUSH
04516E  8B DA                 MOV    bx, dx ; MOV
045170  8B D1                 MOV    dx, cx ; MOV
045172  8B F0                 MOV    si, ax ; MOV
045174  8B F9                 MOV    di, cx ; MOV
045176  E8 11 F4              CALL   0x4458a ; CALL_NEAR
045179  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
04517C  26 8B 47 1E           MOV    ax, word ptr es:[bx + 0x1e] ; MOV
045180  26 8B 57 20           MOV    dx, word ptr es:[bx + 0x20] ; MOV
045184  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
045187  89 56 EE              MOV    word ptr [bp - 0x12], dx ; LOCAL_STORE
04518A  C4 5E E8              LES    bx, ptr [bp - 0x18] ; MOV_FAR
04518D  26 03 77 0C           ADD    si, word ptr es:[bx + 0xc] ; ARITH
045191  89 76 F0              MOV    word ptr [bp - 0x10], si ; LOCAL_STORE
045194  26 03 7F 08           ADD    di, word ptr es:[bx + 8] ; ARITH
045198  89 7E F4              MOV    word ptr [bp - 0xc], di ; LOCAL_STORE
04519B  0B D0                 OR     dx, ax ; LOGIC
04519D  75 03                 JNE    0x451a2 ; CJUMP
04519F  E9 17 01              JMP    0x452b9 ; JUMP
0451A2  C4 5E EC              LES    bx, ptr [bp - 0x14] ; MOV_FAR
0451A5  26 F6 07 02           TEST   byte ptr es:[bx], 2 ; LOGIC
0451A9  74 03                 JE     0x451ae ; CJUMP
0451AB  E9 F3 00              JMP    0x452a1 ; JUMP
0451AE  8C C2                 MOV    dx, es ; MOV
0451B0  39                    DB     0x39 ; DATA_BYTE
0451B1  46                    DB     0x46 ; DATA_BYTE
