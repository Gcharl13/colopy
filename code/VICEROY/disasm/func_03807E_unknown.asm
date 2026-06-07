; ============================================================================
; func_03807E_unknown
; Region   : overlay
; Bytes    : file 0x03807E..0x0380E7  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03807E  C8 CE 00 00           ENTER  0xce, 0 ; PROLOGUE
038082  56                    PUSH   si ; STACK_PUSH
038083  6A 60                 PUSH   0x60 ; PUSH_CONST
038085  2B C0                 SUB    ax, ax ; ARITH
038087  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03808A  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
03808D  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
038090  50                    PUSH   ax ; STACK_PUSH
038091  8D 86 34 FF           LEA    ax, [bp - 0xcc] ; ADDR
038095  50                    PUSH   ax ; STACK_PUSH
038096  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
03809B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03809E  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0380A1  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
0380A4  3D 13 00              CMP    ax, 0x13 ; CMP
0380A7  75 05                 JNE    0x380ae ; CJUMP
0380A9  C7 46 A6 1C 00        MOV    word ptr [bp - 0x5a], 0x1c ; LOCAL_STORE
0380AE  C7 46 9C 00 00        MOV    word ptr [bp - 0x64], 0 ; LOCAL_STORE
0380B3  EB 36                 JMP    0x380eb ; JUMP
0380B5  90                    NOP ; NOP
0380B6  FF 46 AA              INC    word ptr [bp - 0x56] ; ARITH
0380B9  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0380BD  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
0380C0  98                    CWDE ; ARITH
0380C1  3B 46 AA              CMP    ax, word ptr [bp - 0x56] ; CMP
0380C4  7E 22                 JLE    0x380e8 ; CJUMP
0380C6  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
0380C9  9A 54 0C 1F 18        LCALL  0x181f, 0xc54 ; THUNK -> 0x05EB:0x0E52 (thunk @file 0x01B244 type B) overlay @file 0x027E42
0380CE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0380D1  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
0380D4  3B 46 A6              CMP    ax, word ptr [bp - 0x5a] ; CMP
0380D7  75 DD                 JNE    0x380b6 ; CJUMP
0380D9  FF 46 9A              INC    word ptr [bp - 0x66] ; ARITH
0380DC  8B 76 9C              MOV    si, word ptr [bp - 0x64] ; LOCAL_LOAD
0380DF  D1 E6                 SHL    si, 1 ; LOGIC
0380E1  FF 82 34 FF           INC    word ptr [bp + si - 0xcc] ; ARITH
0380E5  EB CF                 JMP    0x380b6 ; JUMP
