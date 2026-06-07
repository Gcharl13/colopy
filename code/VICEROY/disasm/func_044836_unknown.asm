; ============================================================================
; func_044836_unknown
; Region   : overlay
; Bytes    : file 0x044836..0x044861  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044836  C8 20 00 00           ENTER  0x20, 0 ; PROLOGUE
04483A  57                    PUSH   di ; STACK_PUSH
04483B  56                    PUSH   si ; STACK_PUSH
04483C  2B C0                 SUB    ax, ax ; ARITH
04483E  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
044841  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
044844  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
044847  05 4E 00              ADD    ax, 0x4e ; ARITH
04484A  99                    CDQ ; ARITH
04484B  9A 9A 02 1F 18        LCALL  0x181f, 0x29a ; THUNK -> 0x0000:0x01A0 (thunk @file 0x01A88A type A) overlay @file 0x025AA0
044850  8B F8                 MOV    di, ax ; MOV
044852  89 56 F2              MOV    word ptr [bp - 0xe], dx ; LOCAL_STORE
044855  0B D0                 OR     dx, ax ; LOGIC
044857  75 03                 JNE    0x4485c ; CJUMP
044859  E9 FD 00              JMP    0x44959 ; JUMP
04485C  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
04485F  8B CF                 MOV    cx, di ; MOV
