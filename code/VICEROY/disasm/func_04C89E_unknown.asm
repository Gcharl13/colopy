; ============================================================================
; func_04C89E_unknown
; Region   : overlay
; Bytes    : file 0x04C89E..0x04CA86  (488 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C89E  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
04C8A2  56                    PUSH   si ; STACK_PUSH
04C8A3  C7 46 E8 FF FF        MOV    word ptr [bp - 0x18], 0xffff ; LOCAL_STORE
04C8A8  C7 46 F2 08 00        MOV    word ptr [bp - 0xe], 8 ; LOCAL_STORE
04C8AD  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
04C8B2  E9 8F 01              JMP    0x4ca44 ; JUMP
04C8B5  90                    NOP ; NOP
04C8B6  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
04C8B9  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
04C8BC  9A BE 06 1F 18        LCALL  0x181f, 0x6be ; THUNK -> 0x037F:0x03E4 (thunk @file 0x01ACAE type B) overlay @file 0x02EF20
04C8C1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C8C4  0B C0                 OR     ax, ax ; LOGIC
04C8C6  7D 40                 JGE    0x4c908 ; CJUMP
04C8C8  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
04C8CB  39 46 06              CMP    word ptr [bp + 6], ax ; CMP
04C8CE  75 38                 JNE    0x4c908 ; CJUMP
04C8D0  6A 02                 PUSH   2 ; STACK_PUSH
04C8D2  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
04C8D5  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
04C8D8  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
04C8DD  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
04C8E0  50                    PUSH   ax ; STACK_PUSH
04C8E1  9A BC 08 1F 18        LCALL  0x181f, 0x8bc ; THUNK -> 0x0427:0x0D38 (thunk @file 0x01AEAC type B) overlay @file 0x031A4C
04C8E6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C8E9  48                    DEC    ax ; ARITH
04C8EA  75 1C                 JNE    0x4c908 ; CJUMP
04C8EC  6B 5E EC 1C           IMUL   bx, word ptr [bp - 0x14], 0x1c ; ARITH
04C8F0  80 BF 46 31 0B        CMP    byte ptr [bx + 0x3146], 0xb ; CMP
04C8F5  75 05                 JNE    0x4c8fc ; CJUMP
04C8F7  B8 01 00              MOV    ax, 1 ; MOV
04C8FA  EB 02                 JMP    0x4c8fe ; JUMP
04C8FC  2B C0                 SUB    ax, ax ; ARITH
04C8FE  3B 46 0E              CMP    ax, word ptr [bp + 0xe] ; CMP
04C901  74 05                 JE     0x4c908 ; CJUMP
04C903  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
04C908  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
04C90B  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
04C90E  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
04C913  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C916  0B C0                 OR     ax, ax ; LOGIC
04C918  75 03                 JNE    0x4c91d ; CJUMP
04C91A  E9 24 01              JMP    0x4ca41 ; JUMP
04C91D  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
04C920  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
04C923  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
04C928  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C92B  0B C0                 OR     ax, ax ; LOGIC
04C92D  74 03                 JE     0x4c932 ; CJUMP
04C92F  E9 0F 01              JMP    0x4ca41 ; JUMP
04C932  83 7E F6 08           CMP    word ptr [bp - 0xa], 8 ; CMP
04C936  74 08                 JE     0x4c940 ; CJUMP
04C938  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
04C93B  75 03                 JNE    0x4c940 ; CJUMP
04C93D  E9 01 01              JMP    0x4ca41 ; JUMP
04C940  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
04C943  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
04C946  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
04C94B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C94E  8B D8                 MOV    bx, ax ; MOV
04C950  C1 E3 04              SHL    bx, 4 ; LOGIC
04C953  8A 87 77 2F           MOV    al, byte ptr [bx + 0x2f77] ; MOV
04C957  2A E4                 SUB    ah, ah ; ARITH
04C959  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
04C95C  C7 46 F4 00 00        MOV    word ptr [bp - 0xc], 0 ; LOCAL_STORE
04C961  8B 5E F4              MOV    bx, word ptr [bp - 0xc] ; LOCAL_LOAD
04C964  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
04C968  98                    CWDE ; ARITH
04C969  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
04C96C  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
04C96F  50                    PUSH   ax ; STACK_PUSH
04C970  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
04C974  98                    CWDE ; ARITH
04C975  03 46 FC              ADD    ax, word ptr [bp - 4] ; ARITH
04C978  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
04C97B  50                    PUSH   ax ; STACK_PUSH
04C97C  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
04C981  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C984  0B C0                 OR     ax, ax ; LOGIC
04C986  75 03                 JNE    0x4c98b ; CJUMP
04C988  E9 99 00              JMP    0x4ca24 ; JUMP
04C98B  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
04C98E  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
04C991  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
04C996  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C999  0B C0                 OR     ax, ax ; LOGIC
04C99B  74 03                 JE     0x4c9a0 ; CJUMP
04C99D  E9 84 00              JMP    0x4ca24 ; JUMP
04C9A0  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
04C9A3  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
04C9A6  9A 82 06 1F 18        LCALL  0x181f, 0x682 ; THUNK -> 0x037F:0x0314 (thunk @file 0x01AC72 type B) overlay @file 0x02EE50
04C9AB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C9AE  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
04C9B1  0B C0                 OR     ax, ax ; LOGIC
04C9B3  7D 6F                 JGE    0x4ca24 ; CJUMP
04C9B5  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
04C9B8  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
04C9BB  9A DC 06 1F 18        LCALL  0x181f, 0x6dc ; THUNK -> 0x037F:0x0200 (thunk @file 0x01ACCC type B) overlay @file 0x02ED3C
04C9C0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C9C3  98                    CWDE ; ARITH
04C9C4  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
04C9C7  0B C0                 OR     ax, ax ; LOGIC
04C9C9  7C 1F                 JL     0x4c9ea ; CJUMP
04C9CB  3D 04 00              CMP    ax, 4 ; CMP
04C9CE  7D 1A                 JGE    0x4c9ea ; CJUMP
04C9D0  6B D8 34              IMUL   bx, ax, 0x34 ; ARITH
04C9D3  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
04C9D8  75 10                 JNE    0x4c9ea ; CJUMP
04C9DA  50                    PUSH   ax ; STACK_PUSH
04C9DB  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04C9DE  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
04C9E3  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C9E6  A8 40                 TEST   al, 0x40 ; LOGIC
04C9E8  75 3A                 JNE    0x4ca24 ; CJUMP
04C9EA  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
04C9EE  74 34                 JE     0x4ca24 ; CJUMP
04C9F0  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
04C9F3  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
04C9F6  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
04C9FB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C9FE  50                    PUSH   ax ; STACK_PUSH
04C9FF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04CA02  0E                    PUSH   cs ; STACK_PUSH
04CA03  E8 E3 6A              CALL   0x534e9 ; CALL_NEAR
04CA06  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04CA09  C1 E0 04              SHL    ax, 4 ; LOGIC
04CA0C  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
04CA0F  FF 76 EE              PUSH   word ptr [bp - 0x12] ; PUSH_GLOBAL
04CA12  8B F0                 MOV    si, ax ; MOV
04CA14  9A 4A 07 1F 18        LCALL  0x181f, 0x74a ; THUNK -> 0x037F:0x02F8 (thunk @file 0x01AD3A type B) overlay @file 0x02EE34
04CA19  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04CA1C  25 0F 00              AND    ax, 0xf ; LOGIC
04CA1F  03 F0                 ADD    si, ax ; ARITH
04CA21  01 76 F8              ADD    word ptr [bp - 8], si ; ARITH
04CA24  FF 46 F4              INC    word ptr [bp - 0xc] ; ARITH
04CA27  83 7E F4 08           CMP    word ptr [bp - 0xc], 8 ; CMP
04CA2B  7D 03                 JGE    0x4ca30 ; CJUMP
04CA2D  E9 31 FF              JMP    0x4c961 ; JUMP
04CA30  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
04CA33  39 46 E8              CMP    word ptr [bp - 0x18], ax ; CMP
04CA36  7D 09                 JGE    0x4ca41 ; CJUMP
04CA38  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
04CA3B  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
04CA3E  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
04CA41  FF 46 F6              INC    word ptr [bp - 0xa] ; ARITH
04CA44  83 7E F6 09           CMP    word ptr [bp - 0xa], 9 ; CMP
04CA48  7D 36                 JGE    0x4ca80 ; CJUMP
04CA4A  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
04CA4D  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
04CA51  98                    CWDE ; ARITH
04CA52  03 46 0A              ADD    ax, word ptr [bp + 0xa] ; ARITH
04CA55  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
04CA58  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04CA5D  50                    PUSH   ax ; STACK_PUSH
04CA5E  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
04CA62  98                    CWDE ; ARITH
04CA63  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
04CA66  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
04CA69  50                    PUSH   ax ; STACK_PUSH
04CA6A  9A D2 06 1F 18        LCALL  0x181f, 0x6d2 ; THUNK -> 0x037F:0x0428 (thunk @file 0x01ACC2 type B) overlay @file 0x02EF64
04CA6F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04CA72  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
04CA75  0B C0                 OR     ax, ax ; LOGIC
04CA77  7C 03                 JL     0x4ca7c ; CJUMP
04CA79  E9 3A FE              JMP    0x4c8b6 ; JUMP
04CA7C  E9 84 FE              JMP    0x4c903 ; JUMP
04CA7F  90                    NOP ; NOP
04CA80  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
04CA83  5E                    POP    si ; STACK_POP
04CA84  C9                    LEAVE ; EPILOGUE
04CA85  CB                    RETF ; RETURN
