; ============================================================================
; func_02814C_unknown
; Region   : overlay
; Bytes    : file 0x02814C..0x02819E  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02814C  55                    PUSH   bp ; STACK_PUSH
02814D  8B EC                 MOV    bp, sp ; MOV
02814F  6A 30                 PUSH   0x30 ; PUSH_CONST
028151  6A 5B                 PUSH   0x5b ; PUSH_CONST
028153  68 82 00              PUSH   0x82 ; PUSH_CONST
028156  68 D3 00              PUSH   0xd3 ; PUSH_CONST
028159  0E                    PUSH   cs ; STACK_PUSH
02815A  E8 66 49              CALL   0x2cac3 ; CALL_NEAR
02815D  8B E5                 MOV    sp, bp ; MOV
02815F  A0 37 03              MOV    al, byte ptr [0x337] ; GLOBAL_LOAD
028162  2A E4                 SUB    ah, ah ; ARITH
028164  EB 12                 JMP    0x28178 ; JUMP
028166  0E                    PUSH   cs ; STACK_PUSH
028167  E8 46 48              CALL   0x2c9b0 ; CALL_NEAR
02816A  EB 16                 JMP    0x28182 ; JUMP
02816C  0E                    PUSH   cs ; STACK_PUSH
02816D  E8 E0 48              CALL   0x2ca50 ; CALL_NEAR
028170  EB 10                 JMP    0x28182 ; JUMP
028172  0E                    PUSH   cs ; STACK_PUSH
028173  E8 2A 49              CALL   0x2caa0 ; CALL_NEAR
028176  EB 0A                 JMP    0x28182 ; JUMP
028178  0B C0                 OR     ax, ax ; LOGIC
02817A  74 EA                 JE     0x28166 ; CJUMP
02817C  48                    DEC    ax ; ARITH
02817D  74 ED                 JE     0x2816c ; CJUMP
02817F  48                    DEC    ax ; ARITH
028180  74 F0                 JE     0x28172 ; CJUMP
028182  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
028186  74 14                 JE     0x2819c ; CJUMP
028188  68 82 00              PUSH   0x82 ; PUSH_CONST
02818B  6A 5B                 PUSH   0x5b ; PUSH_CONST
02818D  6A 30                 PUSH   0x30 ; PUSH_CONST
02818F  B8 D3 00              MOV    ax, 0xd3 ; CONST_LOAD
028192  BA 82 00              MOV    dx, 0x82 ; CONST_LOAD
028195  8B D8                 MOV    bx, ax ; MOV
028197  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
02819C  C9                    LEAVE ; EPILOGUE
02819D  CB                    RETF ; RETURN
