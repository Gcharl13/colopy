; ============================================================================
; func_022E16_unknown
; Region   : overlay
; Bytes    : file 0x022E16..0x022EB1  (155 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022E16  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
022E1A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
022E1F  EB 16                 JMP    0x22e37 ; JUMP
022E21  90                    NOP ; NOP
022E22  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
022E25  9A A4 02 1F 19        LCALL  0x191f, 0x2a4 ; THUNK -> 0x0000:0x1028 (thunk @file 0x01B894 type A) overlay @file 0x026928
022E2A  9A 96 02 1F 19        LCALL  0x191f, 0x296 ; THUNK -> 0x0000:0x0132 (thunk @file 0x01B886 type A) overlay @file 0x025A32
022E2F  9A 88 02 1F 19        LCALL  0x191f, 0x288 ; THUNK -> 0x0000:0x0168 (thunk @file 0x01B878 type A) overlay @file 0x025A68
022E34  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
022E37  83 7E FE 03           CMP    word ptr [bp - 2], 3 ; CMP
022E3B  7F 13                 JG     0x22e50 ; CJUMP
022E3D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
022E40  A3 8E 01              MOV    word ptr [0x18e], ax ; GLOBAL_LOAD
022E43  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
022E48  74 D8                 JE     0x22e22 ; CJUMP
022E4A  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
022E4D  EB D6                 JMP    0x22e25 ; JUMP
022E4F  90                    NOP ; NOP
022E50  C7 06 8E 01 00 00     MOV    word ptr [0x18e], 0 ; GLOBAL_LOAD
022E56  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
022E5B  8B D8                 MOV    bx, ax ; MOV
022E5D  89 5E FC              MOV    word ptr [bp - 4], bx ; LOCAL_STORE
022E60  F6 87 ED 27 02        TEST   byte ptr [bx + 0x27ed], 2 ; LOGIC
022E65  74 06                 JE     0x22e6d ; CJUMP
022E67  8D 47 E0              LEA    ax, [bx - 0x20] ; ADDR
022E6A  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
022E6D  83 7E FC 48           CMP    word ptr [bp - 4], 0x48 ; CMP
022E71  75 35                 JNE    0x22ea8 ; CJUMP
022E73  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2 ; LOCAL_STORE
022E78  EB 15                 JMP    0x22e8f ; JUMP
022E7A  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
022E7D  9A A4 02 1F 19        LCALL  0x191f, 0x2a4 ; THUNK -> 0x0000:0x1028 (thunk @file 0x01B894 type A) overlay @file 0x026928
022E82  9A 96 02 1F 19        LCALL  0x191f, 0x296 ; THUNK -> 0x0000:0x0132 (thunk @file 0x01B886 type A) overlay @file 0x025A32
022E87  9A 88 02 1F 19        LCALL  0x191f, 0x288 ; THUNK -> 0x0000:0x0168 (thunk @file 0x01B878 type A) overlay @file 0x025A68
022E8C  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
022E8F  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
022E93  7C 13                 JL     0x22ea8 ; CJUMP
022E95  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
022E98  A3 8E 01              MOV    word ptr [0x18e], ax ; GLOBAL_LOAD
022E9B  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
022EA0  74 D8                 JE     0x22e7a ; CJUMP
022EA2  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
022EA5  EB D6                 JMP    0x22e7d ; JUMP
022EA7  90                    NOP ; NOP
022EA8  6A 01                 PUSH   1 ; STACK_PUSH
022EAA  9A 1C 0E 1F 18        LCALL  0x181f, 0xe1c ; THUNK -> 0x0000:0x00C0 (thunk @file 0x01B40C type A) overlay @file 0x0259C0
022EAF  C9                    LEAVE ; EPILOGUE
022EB0  CB                    RETF ; RETURN
