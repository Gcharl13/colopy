; ============================================================================
; func_03FDDE_unknown
; Region   : overlay
; Bytes    : file 0x03FDDE..0x03FE30  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FDDE  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
03FDE2  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
03FDE7  6B 1E 92 53 1C        IMUL   bx, word ptr [0x5392], 0x1c ; ARITH
03FDEC  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
03FDF0  2A E4                 SUB    ah, ah ; ARITH
03FDF2  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
03FDF5  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
03FDF8  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
03FDFC  2A ED                 SUB    ch, ch ; ARITH
03FDFE  03 4E 08              ADD    cx, word ptr [bp + 8] ; ARITH
03FE01  89 4E F2              MOV    word ptr [bp - 0xe], cx ; LOCAL_STORE
03FE04  8B D0                 MOV    dx, ax ; MOV
03FE06  8B D9                 MOV    bx, cx ; MOV
03FE08  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
03FE0B  0E                    PUSH   cs ; STACK_PUSH
03FE0C  E8 EE 01              CALL   0x3fffd ; CALL_NEAR
03FE0F  0B C0                 OR     ax, ax ; LOGIC
03FE11  74 03                 JE     0x3fe16 ; CJUMP
03FE13  E9 46 01              JMP    0x3ff5c ; JUMP
03FE16  A1 4E 9E              MOV    ax, word ptr [0x9e4e] ; GLOBAL_LOAD
03FE19  E9 1C 01              JMP    0x3ff38 ; JUMP
03FE1C  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
03FE20  8D 06 E2 13           LEA    ax, [0x13e2] ; ADDR
03FE24  2B D2                 SUB    dx, dx ; ARITH
03FE26  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
03FE2B  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
03FE2E  C9                    LEAVE ; EPILOGUE
03FE2F  CB                    RETF ; RETURN
