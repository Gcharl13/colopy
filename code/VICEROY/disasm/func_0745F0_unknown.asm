; ============================================================================
; func_0745F0_unknown
; Region   : overlay
; Bytes    : file 0x0745F0..0x07464B  (91 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0745F0  55                    PUSH   bp ; STACK_PUSH
0745F1  8B EC                 MOV    bp, sp ; MOV
0745F3  57                    PUSH   di ; STACK_PUSH
0745F4  56                    PUSH   si ; STACK_PUSH
0745F5  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0745F8  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
0745FD  9A 22 0B 1F 1A        LCALL  0x1a1f, 0xb22 ; THUNK -> 0x0000:0x01C8 (thunk @file 0x01D112 type A) overlay @file 0x025AC8
074602  8B DF                 MOV    bx, di ; MOV
074604  C1 E3 04              SHL    bx, 4 ; LOGIC
074607  89 87 74 2F           MOV    word ptr [bx + 0x2f74], ax ; MOV
07460B  8B F3                 MOV    si, bx ; MOV
07460D  9A 8A 08 1F 1A        LCALL  0x1a1f, 0x88a ; THUNK -> 0x0000:0x0198 (thunk @file 0x01CE7A type A) overlay @file 0x025A98
074612  88 84 76 2F           MOV    byte ptr [si + 0x2f76], al ; MOV
074616  9A 8A 08 1F 1A        LCALL  0x1a1f, 0x88a ; THUNK -> 0x0000:0x0198 (thunk @file 0x01CE7A type A) overlay @file 0x025A98
07461B  88 84 77 2F           MOV    byte ptr [si + 0x2f77], al ; MOV
07461F  9A 8A 08 1F 1A        LCALL  0x1a1f, 0x88a ; THUNK -> 0x0000:0x0198 (thunk @file 0x01CE7A type A) overlay @file 0x025A98
074624  88 84 78 2F           MOV    byte ptr [si + 0x2f78], al ; MOV
074628  9A 8A 08 1F 1A        LCALL  0x1a1f, 0x88a ; THUNK -> 0x0000:0x0198 (thunk @file 0x01CE7A type A) overlay @file 0x025A98
07462D  88 84 79 2F           MOV    byte ptr [si + 0x2f79], al ; MOV
074631  2B F6                 SUB    si, si ; ARITH
074633  9A 8A 08 1F 1A        LCALL  0x1a1f, 0x88a ; THUNK -> 0x0000:0x0198 (thunk @file 0x01CE7A type A) overlay @file 0x025A98
074638  8B DF                 MOV    bx, di ; MOV
07463A  C1 E3 04              SHL    bx, 4 ; LOGIC
07463D  88 80 7B 2F           MOV    byte ptr [bx + si + 0x2f7b], al ; MOV
074641  46                    INC    si ; ARITH
074642  83 FE 09              CMP    si, 9 ; CMP
074645  7C EC                 JL     0x74633 ; CJUMP
074647  5E                    POP    si ; STACK_POP
074648  5F                    POP    di ; STACK_POP
074649  C9                    LEAVE ; EPILOGUE
07464A  CB                    RETF ; RETURN
