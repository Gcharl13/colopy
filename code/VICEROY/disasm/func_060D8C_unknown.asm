; ============================================================================
; func_060D8C_unknown
; Region   : overlay
; Bytes    : file 0x060D8C..0x060EC4  (312 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "CARGOLOAD", "CARGOUNLOAD"  (auto-named via string xrefs)
; ============================================================================

060D8C  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
060D90  56                    PUSH   si ; STACK_PUSH
060D91  C7 46 F2 FF FF        MOV    word ptr [bp - 0xe], 0xffff ; LOCAL_STORE
060D96  C4 1E 14 9E           LES    bx, ptr [0x9e14] ; MOV_FAR
060D9A  26 8A 47 21           MOV    al, byte ptr es:[bx + 0x21] ; MOV
060D9E  2A E4                 SUB    ah, ah ; ARITH
060DA0  3B 06 5E A1           CMP    ax, word ptr [0xa15e] ; CMP
060DA4  7F 03                 JG     0x60da9 ; CJUMP
060DA6  E9 14 01              JMP    0x60ebd ; JUMP
060DA9  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
060DAD  F5                    CMC ; FLAG
060DAE  1B C0                 SBB    ax, ax ; ARITH
060DB0  25 06 00              AND    ax, 6 ; LOGIC
060DB3  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
060DB6  83 7E 06 01           CMP    word ptr [bp + 6], 1 ; CMP
060DBA  1B C0                 SBB    ax, ax ; ARITH
060DBC  24 AD                 AND    al, 0xad ; LOGIC
060DBE  05 D0 00              ADD    ax, 0xd0 ; ARITH
060DC1  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
060DC4  8B F0                 MOV    si, ax ; MOV
060DC6  0E                    PUSH   cs ; STACK_PUSH
060DC7  E8 49 06              CALL   0x61413 ; CALL_NEAR
060DCA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060DCD  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
060DD0  89 76 F4              MOV    word ptr [bp - 0xc], si ; LOCAL_STORE
060DD3  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
060DD8  EB 3F                 JMP    0x60e19 ; JUMP
060DDA  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
060DDE  7D 41                 JGE    0x60e21 ; CJUMP
060DE0  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
060DE3  50                    PUSH   ax ; STACK_PUSH
060DE4  0E                    PUSH   cs ; STACK_PUSH
060DE5  E8 26 06              CALL   0x6140e ; CALL_NEAR
060DE8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060DEB  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
060DEE  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
060DF1  8B 76 F0              MOV    si, word ptr [bp - 0x10] ; LOCAL_LOAD
060DF4  8B CE                 MOV    cx, si ; MOV
060DF6  D1 E6                 SHL    si, 1 ; LOGIC
060DF8  03 F1                 ADD    si, cx ; ARITH
060DFA  C1 E6 02              SHL    si, 2 ; LOGIC
060DFD  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
060E01  26 8B 88 52 01        MOV    cx, word ptr es:[bx + si + 0x152] ; MOV
060E06  41                    INC    cx ; ARITH
060E07  41                    INC    cx ; ARITH
060E08  01 4E F4              ADD    word ptr [bp - 0xc], cx ; ARITH
060E0B  39 46 F4              CMP    word ptr [bp - 0xc], ax ; CMP
060E0E  7E 06                 JLE    0x60e16 ; CJUMP
060E10  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
060E13  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
060E16  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
060E19  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
060E1C  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
060E1F  7F B9                 JG     0x60dda ; CJUMP
060E21  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
060E25  7D 09                 JGE    0x60e30 ; CJUMP
060E27  83 7E FE 06           CMP    word ptr [bp - 2], 6 ; CMP
060E2B  7C 03                 JL     0x60e30 ; CJUMP
060E2D  E9 8D 00              JMP    0x60ebd ; JUMP
060E30  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
060E34  7C 36                 JL     0x60e6c ; CJUMP
060E36  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
060E39  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
060E3C  EB 1F                 JMP    0x60e5d ; JUMP
060E3E  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
060E41  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
060E44  8B C8                 MOV    cx, ax ; MOV
060E46  40                    INC    ax ; ARITH
060E47  50                    PUSH   ax ; STACK_PUSH
060E48  8B F1                 MOV    si, cx ; MOV
060E4A  0E                    PUSH   cs ; STACK_PUSH
060E4B  E8 C0 05              CALL   0x6140e ; CALL_NEAR
060E4E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060E51  50                    PUSH   ax ; STACK_PUSH
060E52  56                    PUSH   si ; STACK_PUSH
060E53  0E                    PUSH   cs ; STACK_PUSH
060E54  E8 C6 05              CALL   0x6141d ; CALL_NEAR
060E57  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
060E5A  FF 46 F6              INC    word ptr [bp - 0xa] ; ARITH
060E5D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
060E60  48                    DEC    ax ; ARITH
060E61  3B 46 F6              CMP    ax, word ptr [bp - 0xa] ; CMP
060E64  7F D8                 JG     0x60e3e ; CJUMP
060E66  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
060E69  48                    DEC    ax ; ARITH
060E6A  EB 46                 JMP    0x60eb2 ; JUMP
060E6C  FF 36 5E A1           PUSH   word ptr [0xa15e] ; PUSH_GLOBAL
060E70  0E                    PUSH   cs ; STACK_PUSH
060E71  E8 B8 05              CALL   0x6142c ; CALL_NEAR
060E74  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060E77  52                    PUSH   dx ; STACK_PUSH
060E78  50                    PUSH   ax ; STACK_PUSH
060E79  6A 00                 PUSH   0 ; STACK_PUSH
060E7B  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
060E80  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
060E83  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
060E87  74 05                 JE     0x60e8e ; CJUMP
060E89  68 3D 1D              PUSH   0x1d3d                       ; STRING: "CARGOLOAD"
060E8C  EB 03                 JMP    0x60e91 ; JUMP
060E8E  68 47 1D              PUSH   0x1d47                       ; STRING: "CARGOUNLOAD"
060E91  0E                    PUSH   cs ; STACK_PUSH
060E92  E8 83 05              CALL   0x61418 ; CALL_NEAR
060E95  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060E98  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
060E9B  0B C0                 OR     ax, ax ; LOGIC
060E9D  7C 1E                 JL     0x60ebd ; CJUMP
060E9F  50                    PUSH   ax ; STACK_PUSH
060EA0  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
060EA3  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
060EA6  50                    PUSH   ax ; STACK_PUSH
060EA7  0E                    PUSH   cs ; STACK_PUSH
060EA8  E8 72 05              CALL   0x6141d ; CALL_NEAR
060EAB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
060EAE  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
060EB1  40                    INC    ax ; ARITH
060EB2  50                    PUSH   ax ; STACK_PUSH
060EB3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
060EB6  0E                    PUSH   cs ; STACK_PUSH
060EB7  E8 95 05              CALL   0x6144f ; CALL_NEAR
060EBA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
060EBD  0E                    PUSH   cs ; STACK_PUSH
060EBE  E8 75 05              CALL   0x61436 ; CALL_NEAR
060EC1  5E                    POP    si ; STACK_POP
060EC2  C9                    LEAVE ; EPILOGUE
060EC3  CB                    RETF ; RETURN
