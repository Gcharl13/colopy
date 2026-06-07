; ============================================================================
; func_0786FE_unknown
; Region   : overlay
; Bytes    : file 0x0786FE..0x078735  (55 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0786FE  55                    PUSH   bp ; STACK_PUSH
0786FF  8B EC                 MOV    bp, sp ; MOV
078701  53                    PUSH   bx ; STACK_PUSH
078702  56                    PUSH   si ; STACK_PUSH
078703  8B F0                 MOV    si, ax ; MOV
078705  8D 46 08              LEA    ax, [bp + 8] ; ADDR
078708  50                    PUSH   ax ; STACK_PUSH
078709  8D 46 06              LEA    ax, [bp + 6] ; ADDR
07870C  50                    PUSH   ax ; STACK_PUSH
07870D  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
078710  8D 46 0C              LEA    ax, [bp + 0xc] ; ADDR
078713  8D 56 0A              LEA    dx, [bp + 0xa] ; ADDR
078716  9A CC 0E 1F 18        LCALL  0x181f, 0xecc ; THUNK -> 0x0A4E:0x001C (thunk @file 0x01B4BC type B) overlay @file 0x0287C6
07871B  0B C0                 OR     ax, ax ; LOGIC
07871D  75 7D                 JNE    0x7879c ; CJUMP
07871F  8B C6                 MOV    ax, si ; MOV
078721  2D ED FF              SUB    ax, 0xffed ; ARITH
078724  7C 76                 JL     0x7879c ; CJUMP
078726  2D 09 00              SUB    ax, 9 ; ARITH
078729  7E 0B                 JLE    0x78736 ; CJUMP
07872B  2D 09 00              SUB    ax, 9 ; ARITH
07872E  74 2A                 JE     0x7875a ; CJUMP
078730  5E                    POP    si ; STACK_POP
078731  C9                    LEAVE ; EPILOGUE
078732  CA 08 00              RETF   8 ; RETURN
