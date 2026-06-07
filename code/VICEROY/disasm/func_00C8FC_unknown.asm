; ============================================================================
; func_00C8FC_unknown
; Region   : load_image
; Bytes    : file 0x00C8FC..0x00C954  (88 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C8FC  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00C900  52                    PUSH   dx ; STACK_PUSH
00C901  50                    PUSH   ax ; STACK_PUSH
00C902  53                    PUSH   bx ; STACK_PUSH
00C903  57                    PUSH   di ; STACK_PUSH
00C904  56                    PUSH   si ; STACK_PUSH
00C905  8B D8                 MOV    bx, ax ; MOV
00C907  83 3F 00              CMP    word ptr [bx], 0 ; CMP
00C90A  7D 0B                 JGE    0xc917 ; CJUMP
00C90C  8B 0F                 MOV    cx, word ptr [bx] ; MOV
00C90E  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
00C911  01 0C                 ADD    word ptr [si], cx ; ARITH
00C913  C7 07 00 00           MOV    word ptr [bx], 0 ; MOV
00C917  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
00C91A  83 3F 00              CMP    word ptr [bx], 0 ; CMP
00C91D  7D 0B                 JGE    0xc92a ; CJUMP
00C91F  8B 07                 MOV    ax, word ptr [bx] ; MOV
00C921  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00C924  01 04                 ADD    word ptr [si], ax ; ARITH
00C926  C7 07 00 00           MOV    word ptr [bx], 0 ; MOV
00C92A  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00C92D  8B 07                 MOV    ax, word ptr [bx] ; MOV
00C92F  8B 76 F8              MOV    si, word ptr [bp - 8] ; LOCAL_LOAD
00C932  03 04                 ADD    ax, word ptr [si] ; ARITH
00C934  48                    DEC    ax ; ARITH
00C935  8B 7E F6              MOV    di, word ptr [bp - 0xa] ; LOCAL_LOAD
00C938  8B 4D 02              MOV    cx, word ptr [di + 2] ; MOV
00C93B  49                    DEC    cx ; ARITH
00C93C  3B C1                 CMP    ax, cx ; CMP
00C93E  7E 02                 JLE    0xc942 ; CJUMP
00C940  8B C1                 MOV    ax, cx ; MOV
00C942  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00C945  8B 0F                 MOV    cx, word ptr [bx] ; MOV
00C947  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
00C94A  03 0F                 ADD    cx, word ptr [bx] ; ARITH
00C94C  49                    DEC    cx ; ARITH
00C94D  8B 15                 MOV    dx, word ptr [di] ; MOV
00C94F  4A                    DEC    dx ; ARITH
00C950  3B CA                 CMP    cx, dx ; CMP
00C952  7E 02                 JLE    0xc956 ; CJUMP
