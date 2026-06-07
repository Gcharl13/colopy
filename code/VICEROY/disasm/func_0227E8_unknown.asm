; ============================================================================
; func_0227E8_unknown
; Region   : overlay
; Bytes    : file 0x0227E8..0x022831  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0227E8  C8 44 00 00           ENTER  0x44, 0 ; PROLOGUE
0227EC  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
0227EF  89 46 C0              MOV    word ptr [bp - 0x40], ax ; LOCAL_STORE
0227F2  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
0227F5  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
0227F9  2A E4                 SUB    ah, ah ; ARITH
0227FB  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
0227FF  2A ED                 SUB    ch, ch ; ARITH
022801  51                    PUSH   cx ; STACK_PUSH
022802  50                    PUSH   ax ; STACK_PUSH
022803  9A BE 07 1F 18        LCALL  0x181f, 0x7be ; THUNK -> 0x05EB:0x0A76 (thunk @file 0x01ADAE type B) overlay @file 0x027A66
022808  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02280B  0B C0                 OR     ax, ax ; LOGIC
02280D  7C 20                 JL     0x2282f ; CJUMP
02280F  50                    PUSH   ax ; STACK_PUSH
022810  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
022815  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
022818  FF 76 C0              PUSH   word ptr [bp - 0x40] ; PUSH_GLOBAL
02281B  9A DE 01 1F 19        LCALL  0x191f, 0x1de ; THUNK -> 0x0000:0x11A4 (thunk @file 0x01B7CE type A) overlay @file 0x026AA4
022820  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
022823  0B C0                 OR     ax, ax ; LOGIC
022825  75 08                 JNE    0x2282f ; CJUMP
022827  50                    PUSH   ax ; STACK_PUSH
022828  6A 01                 PUSH   1 ; STACK_PUSH
02282A  9A 5E 05 1F 18        LCALL  0x181f, 0x55e ; THUNK -> 0x0000:0x0424 (thunk @file 0x01AB4E type A) overlay @file 0x025D24
02282F  C9                    LEAVE ; EPILOGUE
022830  CB                    RETF ; RETURN
