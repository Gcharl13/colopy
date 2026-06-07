; ============================================================================
; func_066F68_unknown
; Region   : overlay
; Bytes    : file 0x066F68..0x066FBE  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066F68  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
066F6C  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1 ; LOCAL_STORE
066F71  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
066F76  2B C0                 SUB    ax, ax ; ARITH
066F78  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
066F7B  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
066F7E  A1 46 85              MOV    ax, word ptr [0x8546] ; GLOBAL_LOAD
066F81  F7 2E 44 85           IMUL   word ptr [0x8544] ; ARITH
066F85  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
066F88  2B C0                 SUB    ax, ax ; ARITH
066F8A  A3 3A 83              MOV    word ptr [0x833a], ax ; GLOBAL_LOAD
066F8D  A3 38 83              MOV    word ptr [0x8338], ax ; GLOBAL_LOAD
066F90  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
066F93  D1 E8                 SHR    ax, 1 ; LOGIC
066F95  73 03                 JAE    0x66f9a ; CJUMP
066F97  35 00 B4              XOR    ax, 0xb400 ; LOGIC
066F9A  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
066F9D  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
066FA0  48                    DEC    ax ; ARITH
066FA1  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
066FA4  3B 46 F6              CMP    ax, word ptr [bp - 0xa] ; CMP
066FA7  73 70                 JAE    0x67019 ; CJUMP
066FA9  2B D2                 SUB    dx, dx ; ARITH
066FAB  F7 36 44 85           DIV    word ptr [0x8544] ; ARITH
066FAF  8B C8                 MOV    cx, ax ; MOV
066FB1  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
066FB4  2B D2                 SUB    dx, dx ; ARITH
066FB6  F7 36 44 85           DIV    word ptr [0x8544] ; ARITH
066FBA  8B C2                 MOV    ax, dx ; MOV
066FBC  03                    DB     0x03 ; DATA_BYTE
066FBD  06                    DB     0x06 ; DATA_BYTE
