; ============================================================================
; func_0287EA_unknown
; Region   : overlay
; Bytes    : file 0x0287EA..0x028826  (60 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0287EA  55                    PUSH   bp ; STACK_PUSH
0287EB  8B EC                 MOV    bp, sp ; MOV
0287ED  6A 01                 PUSH   1 ; STACK_PUSH
0287EF  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
0287F4  8B E5                 MOV    sp, bp ; MOV
0287F6  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
0287FA  74 04                 JE     0x28800 ; CJUMP
0287FC  6A 0F                 PUSH   0xf ; PUSH_CONST
0287FE  EB 02                 JMP    0x28802 ; JUMP
028800  6A 10                 PUSH   0x10 ; PUSH_CONST
028802  0E                    PUSH   cs ; STACK_PUSH
028803  E8 B3 42              CALL   0x2cab9 ; CALL_NEAR
028806  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
028809  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
02880C  D1 E3                 SHL    bx, 1 ; LOGIC
02880E  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
028812  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
028817  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02881A  6A 00                 PUSH   0 ; STACK_PUSH
02881C  6A 00                 PUSH   0 ; STACK_PUSH
02881E  6A 01                 PUSH   1 ; STACK_PUSH
028820  0E                    PUSH   cs ; STACK_PUSH
028821  E8 86 42              CALL   0x2caaa ; CALL_NEAR
028824  C9                    LEAVE ; EPILOGUE
028825  CB                    RETF ; RETURN
