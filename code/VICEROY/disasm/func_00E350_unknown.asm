; ============================================================================
; func_00E350_unknown
; Region   : load_image
; Bytes    : file 0x00E350..0x00E37B  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E350  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
00E354  56                    PUSH   si ; STACK_PUSH
00E355  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
00E358  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
00E35B  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
00E35E  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
00E361  0B C0                 OR     ax, ax ; LOGIC
00E363  75 03                 JNE    0xe368 ; CJUMP
00E365  E9 E8 00              JMP    0xe450 ; JUMP
00E368  83 7E F2 00           CMP    word ptr [bp - 0xe], 0 ; CMP
00E36C  75 03                 JNE    0xe371 ; CJUMP
00E36E  E9 DF 00              JMP    0xe450 ; JUMP
00E371  8B 56 1E              MOV    dx, word ptr [bp + 0x1e] ; LOCAL_LOAD
00E374  8B 46 16              MOV    ax, word ptr [bp + 0x16] ; LOCAL_LOAD
00E377  2B C2                 SUB    ax, dx ; ARITH
00E379  0B C0                 OR     ax, ax ; LOGIC
