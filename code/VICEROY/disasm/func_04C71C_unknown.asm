; ============================================================================
; func_04C71C_unknown
; Region   : overlay
; Bytes    : file 0x04C71C..0x04C7EF  (211 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C71C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C720  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04C725  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C728  80 BF 98 92 00        CMP    byte ptr [bx - 0x6d68], 0 ; CMP
04C72D  74 34                 JE     0x4c763 ; CJUMP
04C72F  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04C732  53                    PUSH   bx ; STACK_PUSH
04C733  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
04C737  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
04C73B  2A E4                 SUB    ah, ah ; ARITH
04C73D  50                    PUSH   ax ; STACK_PUSH
04C73E  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
04C742  50                    PUSH   ax ; STACK_PUSH
04C743  9A 14 06 1F 18        LCALL  0x181f, 0x614 ; THUNK -> 0x05EB:0x0142 (thunk @file 0x01AC04 type B) overlay @file 0x027132
04C748  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
04C74B  0B C0                 OR     ax, ax ; LOGIC
04C74D  7C 0F                 JL     0x4c75e ; CJUMP
04C74F  A1 B8 8D              MOV    ax, word ptr [0x8db8] ; GLOBAL_LOAD
04C752  B9 05 00              MOV    cx, 5 ; MOV
04C755  99                    CDQ ; ARITH
04C756  F7 F9                 IDIV   cx ; ARITH
04C758  48                    DEC    ax ; ARITH
04C759  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
04C75C  EB 05                 JMP    0x4c763 ; JUMP
04C75E  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2 ; LOCAL_STORE
04C763  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
04C767  80 BF 46 31 02        CMP    byte ptr [bx + 0x3146], 2 ; CMP
04C76C  75 04                 JNE    0x4c772 ; CJUMP
04C76E  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
04C772  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
04C776  80 BF 46 31 01        CMP    byte ptr [bx + 0x3146], 1 ; CMP
04C77B  75 04                 JNE    0x4c781 ; CJUMP
04C77D  83 6E FE 02           SUB    word ptr [bp - 2], 2 ; ARITH
04C781  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
04C785  80 BF 46 31 04        CMP    byte ptr [bx + 0x3146], 4 ; CMP
04C78A  75 04                 JNE    0x4c790 ; CJUMP
04C78C  83 6E FE 03           SUB    word ptr [bp - 2], 3 ; ARITH
04C790  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
04C794  80 BF 46 31 00        CMP    byte ptr [bx + 0x3146], 0 ; CMP
04C799  75 29                 JNE    0x4c7c4 ; CJUMP
04C79B  83 6E FE 02           SUB    word ptr [bp - 2], 2 ; ARITH
04C79F  8A 87 5B 31           MOV    al, byte ptr [bx + 0x315b] ; MOV
04C7A3  98                    CWDE ; ARITH
04C7A4  50                    PUSH   ax ; STACK_PUSH
04C7A5  9A 9A 0C 1F 18        LCALL  0x181f, 0xc9a ; THUNK -> 0x05EB:0x0002 (thunk @file 0x01B28A type B) overlay @file 0x026FF2
04C7AA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04C7AD  0B C0                 OR     ax, ax ; LOGIC
04C7AF  74 04                 JE     0x4c7b5 ; CJUMP
04C7B1  83 6E FE 02           SUB    word ptr [bp - 2], 2 ; ARITH
04C7B5  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
04C7B9  80 BF 5B 31 1B        CMP    byte ptr [bx + 0x315b], 0x1b ; CMP
04C7BE  75 04                 JNE    0x4c7c4 ; CJUMP
04C7C0  83 6E FE 14           SUB    word ptr [bp - 2], 0x14 ; ARITH
04C7C4  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04C7C7  0E                    PUSH   cs ; STACK_PUSH
04C7C8  E8 05 6D              CALL   0x534d0 ; CALL_NEAR
04C7CB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04C7CE  0B C0                 OR     ax, ax ; LOGIC
04C7D0  74 12                 JE     0x4c7e4 ; CJUMP
04C7D2  A1 8E 53              MOV    ax, word ptr [0x538e] ; GLOBAL_LOAD
04C7D5  69 5E 06 3C 01        IMUL   bx, word ptr [bp + 6], 0x13c ; ARITH
04C7DA  2B 87 4E 88           SUB    ax, word ptr [bx - 0x77b2] ; ARITH
04C7DE  C1 F8 04              SAR    ax, 4 ; LOGIC
04C7E1  01 46 FE              ADD    word ptr [bp - 2], ax ; ARITH
04C7E4  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
04C7E7  0B C0                 OR     ax, ax ; LOGIC
04C7E9  7E 02                 JLE    0x4c7ed ; CJUMP
04C7EB  2B C0                 SUB    ax, ax ; ARITH
04C7ED  C9                    LEAVE ; EPILOGUE
04C7EE  CB                    RETF ; RETURN
