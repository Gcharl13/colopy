; ============================================================================
; func_0335FA_unknown
; Region   : overlay
; Bytes    : file 0x0335FA..0x033697  (157 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0335FA  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0335FE  56                    PUSH   si ; STACK_PUSH
0335FF  83 3E A2 0F 00        CMP    word ptr [0xfa2], 0 ; CMP
033604  75 03                 JNE    0x33609 ; CJUMP
033606  E9 09 01              JMP    0x33712 ; JUMP
033609  6A 47                 PUSH   0x47 ; PUSH_CONST
03360B  6A 00                 PUSH   0 ; STACK_PUSH
03360D  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
033610  2D 93 00              SUB    ax, 0x93 ; ARITH
033613  50                    PUSH   ax ; STACK_PUSH
033614  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
033619  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03361C  B9 0C 00              MOV    cx, 0xc ; CONST_LOAD
03361F  99                    CDQ ; ARITH
033620  F7 F9                 IDIV   cx ; ARITH
033622  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
033625  FF 36 1C 9E           PUSH   word ptr [0x9e1c] ; PUSH_GLOBAL
033629  8B F0                 MOV    si, ax ; MOV
03362B  0E                    PUSH   cs ; STACK_PUSH
03362C  E8 D4 32              CALL   0x36903 ; CALL_NEAR
03362F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033632  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
033635  56                    PUSH   si ; STACK_PUSH
033636  50                    PUSH   ax ; STACK_PUSH
033637  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
03363C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03363F  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
033642  83 3E 3A 9E 0A        CMP    word ptr [0x9e3a], 0xa ; CMP
033647  75 4F                 JNE    0x33698 ; CJUMP
033649  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
03364E  75 03                 JNE    0x33653 ; CJUMP
033650  E9 BF 00              JMP    0x33712 ; JUMP
033653  83 3E 22 9E 01        CMP    word ptr [0x9e22], 1 ; CMP
033658  74 03                 JE     0x3365d ; CJUMP
03365A  E9 B5 00              JMP    0x33712 ; JUMP
03365D  FF 36 24 9E           PUSH   word ptr [0x9e24] ; PUSH_GLOBAL
033661  0E                    PUSH   cs ; STACK_PUSH
033662  E8 62 32              CALL   0x368c7 ; CALL_NEAR
033665  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033668  0B C0                 OR     ax, ax ; LOGIC
03366A  74 12                 JE     0x3367e ; CJUMP
03366C  FF 36 24 9E           PUSH   word ptr [0x9e24] ; PUSH_GLOBAL
033670  0E                    PUSH   cs ; STACK_PUSH
033671  E8 08 32              CALL   0x3687c ; CALL_NEAR
033674  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
033677  0B C0                 OR     ax, ax ; LOGIC
033679  75 03                 JNE    0x3367e ; CJUMP
03367B  E9 94 00              JMP    0x33712 ; JUMP
03367E  9A A2 03 1F 18        LCALL  0x181f, 0x3a2 ; THUNK -> 0x0262:0x0002 (thunk @file 0x01A992 type B) overlay @file 0x021D32
033683  50                    PUSH   ax ; STACK_PUSH
033684  6A 01                 PUSH   1 ; STACK_PUSH
033686  FF 36 24 9E           PUSH   word ptr [0x9e24] ; PUSH_GLOBAL
03368A  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
03368D  0E                    PUSH   cs ; STACK_PUSH
03368E  E8 AA 31              CALL   0x3683b ; CALL_NEAR
033691  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
033694  5E                    POP    si ; STACK_POP
033695  C9                    LEAVE ; EPILOGUE
033696  CB                    RETF ; RETURN
