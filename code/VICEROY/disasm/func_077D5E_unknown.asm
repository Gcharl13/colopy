; ============================================================================
; func_077D5E_unknown
; Region   : overlay
; Bytes    : file 0x077D5E..0x077DF6  (152 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

077D5E  C8 6A 00 00           ENTER  0x6a, 0 ; PROLOGUE
077D62  53                    PUSH   bx ; STACK_PUSH
077D63  52                    PUSH   dx ; STACK_PUSH
077D64  50                    PUSH   ax ; STACK_PUSH
077D65  57                    PUSH   di ; STACK_PUSH
077D66  56                    PUSH   si ; STACK_PUSH
077D67  8B FB                 MOV    di, bx ; MOV
077D69  8B F0                 MOV    si, ax ; MOV
077D6B  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
077D70  A1 76 24              MOV    ax, word ptr [0x2476] ; GLOBAL_LOAD
077D73  3B D0                 CMP    dx, ax ; CMP
077D75  7C 79                 JL     0x77df0 ; CJUMP
077D77  6A 0A                 PUSH   0xa ; PUSH_CONST
077D79  8D 46 BE              LEA    ax, [bp - 0x42] ; ADDR
077D7C  50                    PUSH   ax ; STACK_PUSH
077D7D  56                    PUSH   si ; STACK_PUSH
077D7E  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
077D83  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
077D86  6A 0A                 PUSH   0xa ; PUSH_CONST
077D88  8D 46 96              LEA    ax, [bp - 0x6a] ; ADDR
077D8B  50                    PUSH   ax ; STACK_PUSH
077D8C  57                    PUSH   di ; STACK_PUSH
077D8D  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
077D92  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
077D95  6A 0A                 PUSH   0xa ; PUSH_CONST
077D97  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
077D9A  50                    PUSH   ax ; STACK_PUSH
077D9B  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
077D9E  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
077DA1  9A 16 09 1D 0D        LCALL  0xd1d, 0x916 ; LCALL
077DA6  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
077DA9  6A 0A                 PUSH   0xa ; PUSH_CONST
077DAB  8D 46 E6              LEA    ax, [bp - 0x1a] ; ADDR
077DAE  50                    PUSH   ax ; STACK_PUSH
077DAF  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
077DB2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
077DB5  9A 16 09 1D 0D        LCALL  0xd1d, 0x916 ; LCALL
077DBA  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
077DBD  8B D6                 MOV    dx, si ; MOV
077DBF  F7 D2                 NOT    dx ; LOGIC
077DC1  42                    INC    dx ; ARITH
077DC2  8D 5E BE              LEA    bx, [bp - 0x42] ; ADDR
077DC5  8D 06 92 25           LEA    ax, [0x2592] ; ADDR
077DC9  E8 C4 FB              CALL   0x77990 ; CALL_NEAR
077DCC  8B D7                 MOV    dx, di ; MOV
077DCE  8D 5E 96              LEA    bx, [bp - 0x6a] ; ADDR
077DD1  8D 06 9D 25           LEA    ax, [0x259d] ; ADDR
077DD5  E8 B8 FB              CALL   0x77990 ; CALL_NEAR
077DD8  8D 46 E6              LEA    ax, [bp - 0x1a] ; ADDR
077DDB  50                    PUSH   ax ; STACK_PUSH
077DDC  9A 7A 02 1F 19        LCALL  0x191f, 0x27a ; THUNK -> 0x0000:0x001E (thunk @file 0x01B86A type A) overlay @file 0x02591E
077DE1  52                    PUSH   dx ; STACK_PUSH
077DE2  50                    PUSH   ax ; STACK_PUSH
077DE3  56                    PUSH   si ; STACK_PUSH
077DE4  8D 5E BE              LEA    bx, [bp - 0x42] ; ADDR
077DE7  8D 46 96              LEA    ax, [bp - 0x6a] ; ADDR
077DEA  8D 56 F2              LEA    dx, [bp - 0xe] ; ADDR
077DED  E8 20 FD              CALL   0x77b10 ; CALL_NEAR
077DF0  5E                    POP    si ; STACK_POP
077DF1  5F                    POP    di ; STACK_POP
077DF2  C9                    LEAVE ; EPILOGUE
077DF3  CA 08 00              RETF   8 ; RETURN
