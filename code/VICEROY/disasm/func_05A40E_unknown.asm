; ============================================================================
; func_05A40E_unknown
; Region   : overlay
; Bytes    : file 0x05A40E..0x05A463  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05A40E  C8 74 00 00           ENTER  0x74, 0 ; PROLOGUE
05A412  56                    PUSH   si ; STACK_PUSH
05A413  C7 46 98 01 00        MOV    word ptr [bp - 0x68], 1 ; LOCAL_STORE
05A418  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
05A41C  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
05A420  25 0F 00              AND    ax, 0xf ; LOGIC
05A423  89 46 8C              MOV    word ptr [bp - 0x74], ax ; LOCAL_STORE
05A426  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
05A42A  8A 4F 1A              MOV    cl, byte ptr [bx + 0x1a] ; MOV
05A42D  2A ED                 SUB    ch, ch ; ARITH
05A42F  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
05A432  3D 04 00              CMP    ax, 4 ; CMP
05A435  7C 03                 JL     0x5a43a ; CJUMP
05A437  E9 21 04              JMP    0x5a85b ; JUMP
05A43A  6B D8 34              IMUL   bx, ax, 0x34 ; ARITH
05A43D  38 AF 3F 54           CMP    byte ptr [bx + 0x543f], ch ; CMP
05A441  74 03                 JE     0x5a446 ; CJUMP
05A443  E9 15 04              JMP    0x5a85b ; JUMP
05A446  51                    PUSH   cx ; STACK_PUSH
05A447  50                    PUSH   ax ; STACK_PUSH
05A448  9A 38 0A 1F 18        LCALL  0x181f, 0xa38 ; THUNK -> 0x05B3:0x0004 (thunk @file 0x01B028 type B) overlay @file 0x05FC30
05A44D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05A450  A8 40                 TEST   al, 0x40 ; LOGIC
05A452  75 10                 JNE    0x5a464 ; CJUMP
05A454  8D 1E A0 1A           LEA    bx, [0x1aa0] ; ADDR
05A458  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
05A45D  8B 46 98              MOV    ax, word ptr [bp - 0x68] ; LOCAL_LOAD
05A460  5E                    POP    si ; STACK_POP
05A461  C9                    LEAVE ; EPILOGUE
05A462  CB                    RETF ; RETURN
