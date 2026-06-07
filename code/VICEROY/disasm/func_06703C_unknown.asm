; ============================================================================
; func_06703C_unknown
; Region   : overlay
; Bytes    : file 0x06703C..0x067081  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06703C  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
067040  A1 2C 83              MOV    ax, word ptr [0x832c] ; GLOBAL_LOAD
067043  2B 06 2E 83           SUB    ax, word ptr [0x832e] ; ARITH
067047  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
06704A  F7 2E 26 83           IMUL   word ptr [0x8326] ; ARITH
06704E  05 08 00              ADD    ax, 8 ; ARITH
067051  8B C8                 MOV    cx, ax ; MOV
067053  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
067056  F7 2E D4 5A           IMUL   word ptr [0x5ad4] ; ARITH
06705A  8B D0                 MOV    dx, ax ; MOV
06705C  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
06705F  8B DA                 MOV    bx, dx ; MOV
067061  F7 2E 26 83           IMUL   word ptr [0x8326] ; ARITH
067065  51                    PUSH   cx ; STACK_PUSH
067066  53                    PUSH   bx ; STACK_PUSH
067067  50                    PUSH   ax ; STACK_PUSH
067068  A1 2A 83              MOV    ax, word ptr [0x832a] ; GLOBAL_LOAD
06706B  2B 06 28 83           SUB    ax, word ptr [0x8328] ; ARITH
06706F  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
067072  F7 2E D4 5A           IMUL   word ptr [0x5ad4] ; ARITH
067076  8B D8                 MOV    bx, ax ; MOV
067078  8B D1                 MOV    dx, cx ; MOV
06707A  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
06707F  C9                    LEAVE ; EPILOGUE
067080  CB                    RETF ; RETURN
