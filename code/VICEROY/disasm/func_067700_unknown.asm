; ============================================================================
; func_067700_unknown
; Region   : overlay
; Bytes    : file 0x067700..0x0677CA  (202 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067700  C8 50 00 00           ENTER  0x50, 0 ; PROLOGUE
067704  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
067708  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06770C  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
067710  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
067714  A1 52 85              MOV    ax, word ptr [0x8552] ; GLOBAL_LOAD
067717  05 08 00              ADD    ax, 8 ; ARITH
06771A  50                    PUSH   ax ; STACK_PUSH
06771B  6A 00                 PUSH   0 ; STACK_PUSH
06771D  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
067720  BA 07 00              MOV    dx, 7 ; MOV
067723  8B 1E 50 85           MOV    bx, word ptr [0x8550] ; GLOBAL_LOAD
067727  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
06772C  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
067731  74 05                 JE     0x67738 ; CJUMP
067733  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
067736  EB 03                 JMP    0x6773b ; JUMP
067738  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
06773B  9A A4 02 1F 19        LCALL  0x191f, 0x2a4 ; THUNK -> 0x0000:0x1028 (thunk @file 0x01B894 type A) overlay @file 0x026928
067740  9A 88 08 1F 19        LCALL  0x191f, 0x888 ; THUNK -> 0x0000:0x00EA (thunk @file 0x01BE78 type A) overlay @file 0x0259EA
067745  9A 96 08 1F 19        LCALL  0x191f, 0x896 ; THUNK -> 0x0000:0x0248 (thunk @file 0x01BE86 type A) overlay @file 0x025B48
06774A  9A 96 02 1F 19        LCALL  0x191f, 0x296 ; THUNK -> 0x0000:0x0132 (thunk @file 0x01B886 type A) overlay @file 0x025A32
06774F  9A 3E 09 1F 1A        LCALL  0x1a1f, 0x93e ; THUNK -> 0x0000:0x058E (thunk @file 0x01CF2E type A) overlay @file 0x025E8E
067754  83 3E 84 01 03        CMP    word ptr [0x184], 3 ; CMP
067759  75 46                 JNE    0x677a1 ; CJUMP
06775B  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
06775F  6B 06 96 53 34        IMUL   ax, word ptr [0x5396], 0x34 ; ARITH
067764  05 26 54              ADD    ax, 0x5426 ; ARITH
067767  50                    PUSH   ax ; STACK_PUSH
067768  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06776B  50                    PUSH   ax ; STACK_PUSH
06776C  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
067771  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
067774  6A 0F                 PUSH   0xf ; PUSH_CONST
067776  A1 2C 83              MOV    ax, word ptr [0x832c] ; GLOBAL_LOAD
067779  F7 2E 26 83           IMUL   word ptr [0x8326] ; ARITH
06777D  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
067781  26 8A 0F              MOV    cl, byte ptr es:[bx] ; MOV
067784  2A ED                 SUB    ch, ch ; ARITH
067786  03 C1                 ADD    ax, cx ; ARITH
067788  D1 F8                 SAR    ax, 1 ; LOGIC
06778A  05 08 00              ADD    ax, 8 ; ARITH
06778D  50                    PUSH   ax ; STACK_PUSH
06778E  FF 36 50 85           PUSH   word ptr [0x8550] ; PUSH_GLOBAL
067792  6A 00                 PUSH   0 ; STACK_PUSH
067794  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
067797  16                    PUSH   ss ; STACK_PUSH
067798  50                    PUSH   ax ; STACK_PUSH
067799  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
06779E  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0677A1  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
0677A6  74 06                 JE     0x677ae ; CJUMP
0677A8  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0677AB  EB 04                 JMP    0x677b1 ; JUMP
0677AD  90                    NOP ; NOP
0677AE  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
0677B1  50                    PUSH   ax ; STACK_PUSH
0677B2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0677B5  9A A4 08 1F 1A        LCALL  0x1a1f, 0x8a4 ; THUNK -> 0x0000:0x0486 (thunk @file 0x01CE94 type A) overlay @file 0x025D86
0677BA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0677BD  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0677C1  74 05                 JE     0x677c8 ; CJUMP
0677C3  9A EA 08 1F 1A        LCALL  0x1a1f, 0x8ea ; THUNK -> 0x0000:0x0224 (thunk @file 0x01CEDA type A) overlay @file 0x025B24
0677C8  C9                    LEAVE ; EPILOGUE
0677C9  CB                    RETF ; RETURN
