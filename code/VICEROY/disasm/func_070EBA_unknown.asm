; ============================================================================
; func_070EBA_unknown
; Region   : overlay
; Bytes    : file 0x070EBA..0x070F8B  (209 bytes)
; Purpose  : VICEROY.EXE entry/control function  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "MULTI", "viceroy", "COLONIZE"  (auto-named via string xrefs)
; ============================================================================

070EBA  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
070EBE  57                    PUSH   di ; STACK_PUSH
070EBF  56                    PUSH   si ; STACK_PUSH
070EC0  C7 46 F8 03 00        MOV    word ptr [bp - 8], 3 ; LOCAL_STORE
070EC5  C7 06 E6 26 01 00     MOV    word ptr [0x26e6], 1 ; GLOBAL_LOAD
070ECB  9A E0 0E 1F 18        LCALL  0x181f, 0xee0 ; THUNK -> 0x0AE3:0x0006 (thunk @file 0x01B4D0 type B)
070ED0  9A 46 0C 1F 1A        LCALL  0x1a1f, 0xc46 ; THUNK -> 0x1085:0x0004 (thunk @file 0x01D236 type B)
070ED5  2B C0                 SUB    ax, ax ; ARITH
070ED7  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
070EDA  A3 1C 08              MOV    word ptr [0x81c], ax ; GLOBAL_LOAD
070EDD  68 64 20              PUSH   0x2064                       ; STRING: "COLONIZE"
070EE0  9A 42 09 1D 0D        LCALL  0xd1d, 0x942 ; LCALL
070EE5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
070EE8  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
070EEB  68 6D 20              PUSH   0x206d                       ; STRING: "MULTI"
070EEE  50                    PUSH   ax ; STACK_PUSH
070EEF  9A 80 0C 1D 0D        LCALL  0xd1d, 0xc80 ; LCALL
070EF4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
070EF7  0B C0                 OR     ax, ax ; LOGIC
070EF9  75 06                 JNE    0x70f01 ; CJUMP
070EFB  C7 06 1E 20 01 00     MOV    word ptr [0x201e], 1 ; GLOBAL_LOAD
070F01  0E                    PUSH   cs ; STACK_PUSH
070F02  E8 87 00              CALL   0x70f8c ; CALL_NEAR
070F05  0E                    PUSH   cs ; STACK_PUSH
070F06  E8 92 00              CALL   0x70f9b ; CALL_NEAR
070F09  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
070F0E  EB 1E                 JMP    0x70f2e ; JUMP
070F10  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
070F13  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
070F15  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
070F18  50                    PUSH   ax ; STACK_PUSH
070F19  0E                    PUSH   cs ; STACK_PUSH
070F1A  E8 79 00              CALL   0x70f96 ; CALL_NEAR
070F1D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
070F20  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
070F23  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
070F26  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
070F29  75 E5                 JNE    0x70f10 ; CJUMP
070F2B  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
070F2E  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
070F31  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
070F34  7D 28                 JGE    0x70f5e ; CJUMP
070F36  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
070F39  D1 E3                 SHL    bx, 1 ; LOGIC
070F3B  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
070F3E  8B 38                 MOV    di, word ptr [bx + si] ; MOV
070F40  8A 05                 MOV    al, byte ptr [di] ; MOV
070F42  98                    CWDE ; ARITH
070F43  50                    PUSH   ax ; STACK_PUSH
070F44  68 73 20              PUSH   0x2073 ; PUSH_CONST
070F47  8B FB                 MOV    di, bx ; MOV
070F49  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
070F4E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
070F51  0B C0                 OR     ax, ax ; LOGIC
070F53  74 D6                 JE     0x70f2b ; CJUMP
070F55  03 F7                 ADD    si, di ; ARITH
070F57  8B 04                 MOV    ax, word ptr [si] ; MOV
070F59  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
070F5C  EB C5                 JMP    0x70f23 ; JUMP
070F5E  68 76 20              PUSH   0x2076                       ; STRING: "viceroy"
070F61  68 54 85              PUSH   0x8554 ; PUSH_CONST
070F64  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
070F69  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
070F6C  9A 38 0C 1F 1A        LCALL  0x1a1f, 0xc38 ; THUNK -> 0x0000:0x2D46 (thunk @file 0x01D228 type A) overlay @file 0x028646
070F71  83 3E 22 08 00        CMP    word ptr [0x822], 0 ; CMP
070F76  74 0F                 JE     0x70f87 ; CJUMP
070F78  FF 36 22 08           PUSH   word ptr [0x822] ; PUSH_GLOBAL
070F7C  68 7E 20              PUSH   0x207e ; PUSH_CONST
070F7F  9A 12 07 1D 0D        LCALL  0xd1d, 0x712 ; LCALL
070F84  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
070F87  5E                    POP    si ; STACK_POP
070F88  5F                    POP    di ; STACK_POP
070F89  C9                    LEAVE ; EPILOGUE
070F8A  CB                    RETF ; RETURN
