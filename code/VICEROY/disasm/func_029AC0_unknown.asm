; ============================================================================
; func_029AC0_unknown
; Region   : overlay
; Bytes    : file 0x029AC0..0x029B84  (196 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029AC0  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
029AC4  56                    PUSH   si ; STACK_PUSH
029AC5  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
029AC9  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
029ACC  98                    CWDE ; ARITH
029ACD  03 06 72 8D           ADD    ax, word ptr [0x8d72] ; ARITH
029AD1  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
029AD4  48                    DEC    ax ; ARITH
029AD5  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
029AD8  C7 46 FA 02 00        MOV    word ptr [bp - 6], 2 ; LOCAL_STORE
029ADD  2B C0                 SUB    ax, ax ; ARITH
029ADF  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
029AE2  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
029AE5  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
029AE8  EB 40                 JMP    0x29b2a ; JUMP
029AEA  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
029AEE  7E 0C                 JLE    0x29afc ; CJUMP
029AF0  FF 4E F4              DEC    word ptr [bp - 0xc] ; ARITH
029AF3  FF 4E FC              DEC    word ptr [bp - 4] ; ARITH
029AF6  83 7E F4 01           CMP    word ptr [bp - 0xc], 1 ; CMP
029AFA  7F EE                 JG     0x29aea ; CJUMP
029AFC  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
029AFF  01 46 FA              ADD    word ptr [bp - 6], ax ; ARITH
029B02  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
029B06  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
029B09  98                    CWDE ; ARITH
029B0A  2B 46 F2              SUB    ax, word ptr [bp - 0xe] ; ARITH
029B0D  48                    DEC    ax ; ARITH
029B0E  75 04                 JNE    0x29b14 ; CJUMP
029B10  83 46 FA 04           ADD    word ptr [bp - 6], 4 ; ARITH
029B14  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
029B17  39 46 FA              CMP    word ptr [bp - 6], ax ; CMP
029B1A  7E 0B                 JLE    0x29b27 ; CJUMP
029B1C  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
029B1F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
029B22  C7 46 F0 01 00        MOV    word ptr [bp - 0x10], 1 ; LOCAL_STORE
029B27  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
029B2A  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
029B2E  75 4E                 JNE    0x29b7e ; CJUMP
029B30  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
029B33  39 46 F2              CMP    word ptr [bp - 0xe], ax ; CMP
029B36  7D 46                 JGE    0x29b7e ; CJUMP
029B38  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
029B3B  9A 74 0A 1F 18        LCALL  0x181f, 0xa74 ; THUNK -> 0x05EB:0x0F1C (thunk @file 0x01B064 type B) overlay @file 0x027F0C
029B40  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029B43  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
029B46  A0 90 A8              MOV    al, byte ptr [0xa890] ; GLOBAL_LOAD
029B49  98                    CWDE ; ARITH
029B4A  8B 76 F8              MOV    si, word ptr [bp - 8] ; LOCAL_LOAD
029B4D  8B CE                 MOV    cx, si ; MOV
029B4F  D1 E6                 SHL    si, 1 ; LOGIC
029B51  03 F1                 ADD    si, cx ; ARITH
029B53  C1 E6 02              SHL    si, 2 ; LOGIC
029B56  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
029B5A  26 03 40 3E           ADD    ax, word ptr es:[bx + si + 0x3e] ; ARITH
029B5E  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
029B61  3D 01 00              CMP    ax, 1 ; CMP
029B64  7D 06                 JGE    0x29b6c ; CJUMP
029B66  48                    DEC    ax ; ARITH
029B67  F7 D8                 NEG    ax ; ARITH
029B69  01 46 FC              ADD    word ptr [bp - 4], ax ; ARITH
029B6C  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
029B6F  3D 01 00              CMP    ax, 1 ; CMP
029B72  7D 03                 JGE    0x29b77 ; CJUMP
029B74  B8 01 00              MOV    ax, 1 ; MOV
029B77  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
029B7A  E9 79 FF              JMP    0x29af6 ; JUMP
029B7D  90                    NOP ; NOP
029B7E  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
029B81  5E                    POP    si ; STACK_POP
029B82  C9                    LEAVE ; EPILOGUE
029B83  CB                    RETF ; RETURN
