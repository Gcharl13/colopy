; ============================================================================
; func_00BD4A_unknown
; Region   : load_image
; Bytes    : file 0x00BD4A..0x00BE27  (221 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BD4A  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
00BD4E  83 3E 9C 92 01        CMP    word ptr [0x929c], 1 ; CMP
00BD53  1B C0                 SBB    ax, ax ; ARITH
00BD55  F7 D8                 NEG    ax ; ARITH
00BD57  A3 9C 92              MOV    word ptr [0x929c], ax ; GLOBAL_LOAD
00BD5A  83 3E 90 53 00        CMP    word ptr [0x5390], 0 ; CMP
00BD5F  75 18                 JNE    0xbd79 ; CJUMP
00BD61  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
00BD66  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
00BD6A  2A E4                 SUB    ah, ah ; ARITH
00BD6C  50                    PUSH   ax ; STACK_PUSH
00BD6D  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
00BD71  50                    PUSH   ax ; STACK_PUSH
00BD72  0E                    PUSH   cs ; STACK_PUSH
00BD73  E8 B2 FF              CALL   0xbd28 ; CALL_NEAR
00BD76  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00BD79  83 3E C6 53 00        CMP    word ptr [0x53c6], 0 ; CMP
00BD7E  74 0A                 JE     0xbd8a ; CJUMP
00BD80  6A 01                 PUSH   1 ; STACK_PUSH
00BD82  9A 46 0E 1F 18        LCALL  0x181f, 0xe46 ; THUNK -> 0x0000:0x0156 (thunk @file 0x01B436 type A) overlay @file 0x025A56
00BD87  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00BD8A  FF 36 3E 85           PUSH   word ptr [0x853e] ; PUSH_GLOBAL
00BD8E  FF 36 40 85           PUSH   word ptr [0x8540] ; PUSH_GLOBAL
00BD92  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
00BD97  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00BD9A  0B C0                 OR     ax, ax ; LOGIC
00BD9C  74 2A                 JE     0xbdc8 ; CJUMP
00BD9E  FF 36 9C 92           PUSH   word ptr [0x929c] ; PUSH_GLOBAL
00BDA2  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
00BDA7  74 05                 JE     0xbdae ; CJUMP
00BDA9  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
00BDAC  EB 03                 JMP    0xbdb1 ; JUMP
00BDAE  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
00BDB1  50                    PUSH   ax ; STACK_PUSH
00BDB2  6A 01                 PUSH   1 ; STACK_PUSH
00BDB4  6A 01                 PUSH   1 ; STACK_PUSH
00BDB6  6A 01                 PUSH   1 ; STACK_PUSH
00BDB8  FF 36 3E 85           PUSH   word ptr [0x853e] ; PUSH_GLOBAL
00BDBC  FF 36 40 85           PUSH   word ptr [0x8540] ; PUSH_GLOBAL
00BDC0  9A 38 0E 1F 18        LCALL  0x181f, 0xe38 ; THUNK -> 0x0000:0x0360 (thunk @file 0x01B428 type A) overlay @file 0x025C60
00BDC5  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
00BDC8  A1 40 85              MOV    ax, word ptr [0x8540] ; GLOBAL_LOAD
00BDCB  39 06 28 83           CMP    word ptr [0x8328], ax ; CMP
00BDCF  7E 03                 JLE    0xbdd4 ; CJUMP
00BDD1  E9 08 01              JMP    0xbedc ; JUMP
00BDD4  A1 44 85              MOV    ax, word ptr [0x8544] ; GLOBAL_LOAD
00BDD7  03 06 28 83           ADD    ax, word ptr [0x8328] ; ARITH
00BDDB  3B 06 40 85           CMP    ax, word ptr [0x8540] ; CMP
00BDDF  7F 03                 JG     0xbde4 ; CJUMP
00BDE1  E9 F8 00              JMP    0xbedc ; JUMP
00BDE4  A1 3E 85              MOV    ax, word ptr [0x853e] ; GLOBAL_LOAD
00BDE7  39 06 2E 83           CMP    word ptr [0x832e], ax ; CMP
00BDEB  7E 03                 JLE    0xbdf0 ; CJUMP
00BDED  E9 EC 00              JMP    0xbedc ; JUMP
00BDF0  A1 2E 83              MOV    ax, word ptr [0x832e] ; GLOBAL_LOAD
00BDF3  03 06 46 85           ADD    ax, word ptr [0x8546] ; ARITH
00BDF7  3B 06 3E 85           CMP    ax, word ptr [0x853e] ; CMP
00BDFB  7F 03                 JG     0xbe00 ; CJUMP
00BDFD  E9 DC 00              JMP    0xbedc ; JUMP
00BE00  A1 3E 85              MOV    ax, word ptr [0x853e] ; GLOBAL_LOAD
00BE03  2B 06 2E 83           SUB    ax, word ptr [0x832e] ; ARITH
00BE07  8B C8                 MOV    cx, ax ; MOV
00BE09  A1 40 85              MOV    ax, word ptr [0x8540] ; GLOBAL_LOAD
00BE0C  2B 06 28 83           SUB    ax, word ptr [0x8328] ; ARITH
00BE10  03 06 2A 83           ADD    ax, word ptr [0x832a] ; ARITH
00BE14  F7 2E D4 5A           IMUL   word ptr [0x5ad4] ; ARITH
00BE18  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00BE1B  8B D0                 MOV    dx, ax ; MOV
00BE1D  8B C1                 MOV    ax, cx ; MOV
00BE1F  03 06 2C 83           ADD    ax, word ptr [0x832c] ; ARITH
00BE23  8B CA                 MOV    cx, dx ; MOV
00BE25  F7                    DB     0xF7 ; DATA_BYTE
00BE26  2E                    DB     0x2E ; DATA_BYTE
