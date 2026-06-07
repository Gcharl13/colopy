; ============================================================================
; func_031F80_unknown
; Region   : overlay
; Bytes    : file 0x031F80..0x031FD7  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031F80  55                    PUSH   bp ; STACK_PUSH
031F81  8B EC                 MOV    bp, sp ; MOV
031F83  6A 01                 PUSH   1 ; STACK_PUSH
031F85  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
031F8A  8B E5                 MOV    sp, bp ; MOV
031F8C  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
031F90  74 04                 JE     0x31f96 ; CJUMP
031F92  6A 0D                 PUSH   0xd ; PUSH_CONST
031F94  EB 02                 JMP    0x31f98 ; JUMP
031F96  6A 0E                 PUSH   0xe ; PUSH_CONST
031F98  0E                    PUSH   cs ; STACK_PUSH
031F99  E8 B8 48              CALL   0x36854 ; CALL_NEAR
031F9C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031F9F  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
031FA2  D1 E3                 SHL    bx, 1 ; LOGIC
031FA4  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
031FA8  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
031FAD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031FB0  6A 0C                 PUSH   0xc ; PUSH_CONST
031FB2  0E                    PUSH   cs ; STACK_PUSH
031FB3  E8 9E 48              CALL   0x36854 ; CALL_NEAR
031FB6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031FB9  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
031FBC  F7 6E 08              IMUL   word ptr [bp + 8] ; ARITH
031FBF  50                    PUSH   ax ; STACK_PUSH
031FC0  9A 7E 00 1F 18        LCALL  0x181f, 0x7e ; THUNK -> 0x0009:0x01B8 (thunk @file 0x01A66E type B) overlay @file 0x022982
031FC5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031FC8  FF 36 A0 93           PUSH   word ptr [0x93a0] ; PUSH_GLOBAL
031FCC  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
031FD1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031FD4  1E                    PUSH   ds ; STACK_PUSH
031FD5  68                    DB     0x68 ; DATA_BYTE
031FD6  C3                    DB     0xC3 ; DATA_BYTE
