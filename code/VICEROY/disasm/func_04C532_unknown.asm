; ============================================================================
; func_04C532_unknown
; Region   : overlay
; Bytes    : file 0x04C532..0x04C596  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C532  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C536  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04C53B  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
04C53E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04C541  0E                    PUSH   cs ; STACK_PUSH
04C542  E8 90 6F              CALL   0x534d5 ; CALL_NEAR
04C545  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C548  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
04C54B  83 7E FE 40           CMP    word ptr [bp - 2], 0x40 ; CMP
04C54F  7C EA                 JL     0x4c53b ; CJUMP
04C551  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04C556  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C559  C1 E3 04              SHL    bx, 4 ; LOGIC
04C55C  03 5E FE              ADD    bx, word ptr [bp - 2] ; ARITH
04C55F  C1 E3 02              SHL    bx, 2 ; LOGIC
04C562  80 BF AC 9E 00        CMP    byte ptr [bx - 0x6154], 0 ; CMP
04C567  7C 22                 JL     0x4c58b ; CJUMP
04C569  8A 87 AD 9E           MOV    al, byte ptr [bx - 0x6153] ; MOV
04C56D  98                    CWDE ; ARITH
04C56E  50                    PUSH   ax ; STACK_PUSH
04C56F  8A 87 AC 9E           MOV    al, byte ptr [bx - 0x6154] ; MOV
04C573  98                    CWDE ; ARITH
04C574  50                    PUSH   ax ; STACK_PUSH
04C575  8A 87 AB 9E           MOV    al, byte ptr [bx - 0x6155] ; MOV
04C579  98                    CWDE ; ARITH
04C57A  50                    PUSH   ax ; STACK_PUSH
04C57B  8A 87 AA 9E           MOV    al, byte ptr [bx - 0x6156] ; MOV
04C57F  98                    CWDE ; ARITH
04C580  50                    PUSH   ax ; STACK_PUSH
04C581  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04C584  0E                    PUSH   cs ; STACK_PUSH
04C585  E8 39 6F              CALL   0x534c1 ; CALL_NEAR
04C588  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
04C58B  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
04C58E  83 7E FE 10           CMP    word ptr [bp - 2], 0x10 ; CMP
04C592  7C C2                 JL     0x4c556 ; CJUMP
04C594  C9                    LEAVE ; EPILOGUE
04C595  CB                    RETF ; RETURN
