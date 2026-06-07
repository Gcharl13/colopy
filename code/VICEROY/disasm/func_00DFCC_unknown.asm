; ============================================================================
; func_00DFCC_unknown
; Region   : load_image
; Bytes    : file 0x00DFCC..0x00DFF3  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DFCC  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00DFD0  53                    PUSH   bx ; STACK_PUSH
00DFD1  52                    PUSH   dx ; STACK_PUSH
00DFD2  50                    PUSH   ax ; STACK_PUSH
00DFD3  57                    PUSH   di ; STACK_PUSH
00DFD4  0B DB                 OR     bx, bx ; LOGIC
00DFD6  7C 59                 JL     0xe031 ; CJUMP
00DFD8  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00DFDB  3B D8                 CMP    bx, ax ; CMP
00DFDD  7D 52                 JGE    0xe031 ; CJUMP
00DFDF  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
00DFE2  0B C0                 OR     ax, ax ; LOGIC
00DFE4  7D 02                 JGE    0xdfe8 ; CJUMP
00DFE6  2B C0                 SUB    ax, ax ; ARITH
00DFE8  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
00DFEB  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00DFEE  48                    DEC    ax ; ARITH
00DFEF  3B C2                 CMP    ax, dx ; CMP
00DFF1  7E 02                 JLE    0xdff5 ; CJUMP
