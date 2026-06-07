; ============================================================================
; func_066E52_unknown
; Region   : overlay
; Bytes    : file 0x066E52..0x066EB3  (97 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066E52  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
066E56  57                    PUSH   di ; STACK_PUSH
066E57  56                    PUSH   si ; STACK_PUSH
066E58  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
066E5B  8B 07                 MOV    ax, word ptr [bx] ; MOV
066E5D  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
066E60  03 04                 ADD    ax, word ptr [si] ; ARITH
066E62  48                    DEC    ax ; ARITH
066E63  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
066E66  8B 7E 0C              MOV    di, word ptr [bp + 0xc] ; LOCAL_LOAD
066E69  8B 05                 MOV    ax, word ptr [di] ; MOV
066E6B  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
066E6E  03 07                 ADD    ax, word ptr [bx] ; ARITH
066E70  48                    DEC    ax ; ARITH
066E71  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
066E74  A1 04 88              MOV    ax, word ptr [0x8804] ; GLOBAL_LOAD
066E77  3B 46 FE              CMP    ax, word ptr [bp - 2] ; CMP
066E7A  7E 03                 JLE    0x66e7f ; CJUMP
066E7C  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
066E7F  8B 0C                 MOV    cx, word ptr [si] ; MOV
066E81  3B 0E 28 83           CMP    cx, word ptr [0x8328] ; CMP
066E85  7D 04                 JGE    0x66e8b ; CJUMP
066E87  8B 0E 28 83           MOV    cx, word ptr [0x8328] ; GLOBAL_LOAD
066E8B  89 0C                 MOV    word ptr [si], cx ; MOV
066E8D  2B C1                 SUB    ax, cx ; ARITH
066E8F  40                    INC    ax ; ARITH
066E90  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
066E93  89 04                 MOV    word ptr [si], ax ; MOV
066E95  8B 0E 06 88           MOV    cx, word ptr [0x8806] ; GLOBAL_LOAD
066E99  3B 4E FC              CMP    cx, word ptr [bp - 4] ; CMP
066E9C  7E 03                 JLE    0x66ea1 ; CJUMP
066E9E  8B 4E FC              MOV    cx, word ptr [bp - 4] ; LOCAL_LOAD
066EA1  8B 17                 MOV    dx, word ptr [bx] ; MOV
066EA3  3B 16 2E 83           CMP    dx, word ptr [0x832e] ; CMP
066EA7  7D 04                 JGE    0x66ead ; CJUMP
066EA9  8B 16 2E 83           MOV    dx, word ptr [0x832e] ; GLOBAL_LOAD
066EAD  89 17                 MOV    word ptr [bx], dx ; MOV
066EAF  2B CA                 SUB    cx, dx ; ARITH
066EB1  41                    INC    cx ; ARITH
066EB2  89                    DB     0x89 ; DATA_BYTE
