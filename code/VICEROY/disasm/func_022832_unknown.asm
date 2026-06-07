; ============================================================================
; func_022832_unknown
; Region   : overlay
; Bytes    : file 0x022832..0x02287D  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022832  C8 28 00 00           ENTER  0x28, 0 ; PROLOGUE
022836  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
022839  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
02283C  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
02283F  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
022843  2A E4                 SUB    ah, ah ; ARITH
022845  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
022849  2A ED                 SUB    ch, ch ; ARITH
02284B  51                    PUSH   cx ; STACK_PUSH
02284C  50                    PUSH   ax ; STACK_PUSH
02284D  9A BE 07 1F 18        LCALL  0x181f, 0x7be ; THUNK -> 0x05EB:0x0A76 (thunk @file 0x01ADAE type B) overlay @file 0x027A66
022852  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022855  0B C0                 OR     ax, ax ; LOGIC
022857  7C 22                 JL     0x2287b ; CJUMP
022859  50                    PUSH   ax ; STACK_PUSH
02285A  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
02285F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
022862  6A 00                 PUSH   0 ; STACK_PUSH
022864  FF 76 DA              PUSH   word ptr [bp - 0x26] ; PUSH_GLOBAL
022867  9A D0 01 1F 19        LCALL  0x191f, 0x1d0 ; THUNK -> 0x0000:0x0F60 (thunk @file 0x01B7C0 type A) overlay @file 0x026860
02286C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02286F  0B C0                 OR     ax, ax ; LOGIC
022871  75 08                 JNE    0x2287b ; CJUMP
022873  50                    PUSH   ax ; STACK_PUSH
022874  6A 01                 PUSH   1 ; STACK_PUSH
022876  9A 5E 05 1F 18        LCALL  0x181f, 0x55e ; THUNK -> 0x0000:0x0424 (thunk @file 0x01AB4E type A) overlay @file 0x025D24
02287B  C9                    LEAVE ; EPILOGUE
02287C  CB                    RETF ; RETURN
