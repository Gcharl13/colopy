; ============================================================================
; func_0460F8_unknown
; Region   : overlay
; Bytes    : file 0x0460F8..0x046173  (123 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0460F8  C8 48 00 00           ENTER  0x48, 0 ; PROLOGUE
0460FC  56                    PUSH   si ; STACK_PUSH
0460FD  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
046100  89 46 C8              MOV    word ptr [bp - 0x38], ax ; LOCAL_STORE
046103  89 46 D0              MOV    word ptr [bp - 0x30], ax ; LOCAL_STORE
046106  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12 ; ARITH
04610A  8A 87 EC 54           MOV    al, byte ptr [bx + 0x54ec] ; MOV
04610E  2A E4                 SUB    ah, ah ; ARITH
046110  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
046113  8A 8F ED 54           MOV    cl, byte ptr [bx + 0x54ed] ; MOV
046117  2A ED                 SUB    ch, ch ; ARITH
046119  89 4E D4              MOV    word ptr [bp - 0x2c], cx ; LOCAL_STORE
04611C  51                    PUSH   cx ; STACK_PUSH
04611D  50                    PUSH   ax ; STACK_PUSH
04611E  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
046123  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
046126  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
046129  2B C0                 SUB    ax, ax ; ARITH
04612B  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
04612E  89 46 C0              MOV    word ptr [bp - 0x40], ax ; LOCAL_STORE
046131  89 46 D2              MOV    word ptr [bp - 0x2e], ax ; LOCAL_STORE
046134  EB 0D                 JMP    0x46143 ; JUMP
046136  8B 76 D2              MOV    si, word ptr [bp - 0x2e] ; LOCAL_LOAD
046139  D1 E6                 SHL    si, 1 ; LOGIC
04613B  C7 42 E2 00 00        MOV    word ptr [bp + si - 0x1e], 0 ; LOCAL_STORE
046140  FF 46 D2              INC    word ptr [bp - 0x2e] ; ARITH
046143  83 7E D2 04           CMP    word ptr [bp - 0x2e], 4 ; CMP
046147  7C ED                 JL     0x46136 ; CJUMP
046149  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12 ; ARITH
04614D  8A 87 EE 54           MOV    al, byte ptr [bx + 0x54ee] ; MOV
046151  2A E4                 SUB    ah, ah ; ARITH
046153  6B F0 4E              IMUL   si, ax, 0x4e ; ARITH
046156  8A 84 A0 59           MOV    al, byte ptr [si + 0x59a0] ; MOV
04615A  89 46 D8              MOV    word ptr [bp - 0x28], ax ; LOCAL_STORE
04615D  8A 87 F1 54           MOV    al, byte ptr [bx + 0x54f1] ; MOV
046161  98                    CWDE ; ARITH
046162  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
046165  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0 ; LOCAL_STORE
04616A  E9 AB 00              JMP    0x46218 ; JUMP
04616D  90                    NOP ; NOP
04616E  6B 5E CA 1C           IMUL   bx, word ptr [bp - 0x36], 0x1c ; ARITH
046172  80                    DB     0x80 ; DATA_BYTE
