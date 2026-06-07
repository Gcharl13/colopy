; ============================================================================
; func_046004_unknown
; Region   : overlay
; Bytes    : file 0x046004..0x046055  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046004  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
046008  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
04600D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
046010  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
046013  9A F0 06 1F 18        LCALL  0x181f, 0x6f0 ; THUNK -> 0x037F:0x0392 (thunk @file 0x01ACE0 type B) overlay @file 0x02EECE
046018  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04601B  0B C0                 OR     ax, ax ; LOGIC
04601D  7C 31                 JL     0x46050 ; CJUMP
04601F  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
046024  EB 24                 JMP    0x4604a ; JUMP
046026  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
046029  39 06 9A 53           CMP    word ptr [0x539a], ax ; CMP
04602D  7E 21                 JLE    0x46050 ; CJUMP
04602F  6B D8 12              IMUL   bx, ax, 0x12 ; ARITH
046032  8A 4E 06              MOV    cl, byte ptr [bp + 6] ; LOCAL_LOAD
046035  38 8F EC 54           CMP    byte ptr [bx + 0x54ec], cl ; CMP
046039  75 0C                 JNE    0x46047 ; CJUMP
04603B  8A 4E 08              MOV    cl, byte ptr [bp + 8] ; LOCAL_LOAD
04603E  38 8F ED 54           CMP    byte ptr [bx + 0x54ed], cl ; CMP
046042  75 03                 JNE    0x46047 ; CJUMP
046044  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
046047  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
04604A  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
04604E  7C D6                 JL     0x46026 ; CJUMP
046050  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
046053  C9                    LEAVE ; EPILOGUE
046054  CB                    RETF ; RETURN
