; ============================================================================
; func_066EC8_unknown
; Region   : overlay
; Bytes    : file 0x066EC8..0x066F24  (92 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066EC8  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
066ECC  A1 2C 83              MOV    ax, word ptr [0x832c] ; GLOBAL_LOAD
066ECF  2B 06 2E 83           SUB    ax, word ptr [0x832e] ; ARITH
066ED3  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
066ED6  F7 2E 26 83           IMUL   word ptr [0x8326] ; ARITH
066EDA  8B C8                 MOV    cx, ax ; MOV
066EDC  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
066EDF  F7 2E D4 5A           IMUL   word ptr [0x5ad4] ; ARITH
066EE3  8B D0                 MOV    dx, ax ; MOV
066EE5  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
066EE8  8B DA                 MOV    bx, dx ; MOV
066EEA  F7 2E 26 83           IMUL   word ptr [0x8326] ; ARITH
066EEE  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
066EF2  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
066EF6  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
066EFA  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
066EFE  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
066F02  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
066F06  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
066F0A  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
066F0E  8B D1                 MOV    dx, cx ; MOV
066F10  83 C1 08              ADD    cx, 8 ; ARITH
066F13  51                    PUSH   cx ; STACK_PUSH
066F14  53                    PUSH   bx ; STACK_PUSH
066F15  50                    PUSH   ax ; STACK_PUSH
066F16  A1 2A 83              MOV    ax, word ptr [0x832a] ; GLOBAL_LOAD
066F19  2B 06 28 83           SUB    ax, word ptr [0x8328] ; ARITH
066F1D  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
066F20  8B CA                 MOV    cx, dx ; MOV
066F22  F7                    DB     0xF7 ; DATA_BYTE
066F23  2E                    DB     0x2E ; DATA_BYTE
