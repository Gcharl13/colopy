; ============================================================================
; func_03F946_unknown
; Region   : overlay
; Bytes    : file 0x03F946..0x03F981  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03F946  C8 4E 00 00           ENTER  0x4e, 0 ; PROLOGUE
03F94A  56                    PUSH   si ; STACK_PUSH
03F94B  2B C0                 SUB    ax, ax ; ARITH
03F94D  89 46 BA              MOV    word ptr [bp - 0x46], ax ; LOCAL_STORE
03F950  89 46 B6              MOV    word ptr [bp - 0x4a], ax ; LOCAL_STORE
03F953  39 46 0A              CMP    word ptr [bp + 0xa], ax ; CMP
03F956  74 0B                 JE     0x3f963 ; CJUMP
03F958  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03F95B  9A C6 08 1F 18        LCALL  0x181f, 0x8c6 ; THUNK -> 0x0427:0x03A0 (thunk @file 0x01AEB6 type B) overlay @file 0x0310B4
03F960  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03F963  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
03F966  9A EE 02 1F 18        LCALL  0x181f, 0x2ee ; THUNK -> 0x0427:0x0002 (thunk @file 0x01A8DE type B) overlay @file 0x030D16
03F96B  EB 4A                 JMP    0x3f9b7 ; JUMP
03F96D  90                    NOP ; NOP
03F96E  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
03F971  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
03F976  72 37                 JB     0x3f9af ; CJUMP
03F978  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
03F97D  77 30                 JA     0x3f9af ; CJUMP
03F97F  8B C3                 MOV    ax, bx ; MOV
