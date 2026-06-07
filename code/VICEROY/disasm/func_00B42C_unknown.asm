; ============================================================================
; func_00B42C_unknown
; Region   : load_image
; Bytes    : file 0x00B42C..0x00B4B7  (139 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B42C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00B430  56                    PUSH   si ; STACK_PUSH
00B431  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00B434  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B437  0E                    PUSH   cs ; STACK_PUSH
00B438  E8 67 FE              CALL   0xb2a2 ; CALL_NEAR
00B43B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B43E  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00B441  0B C0                 OR     ax, ax ; LOGIC
00B443  7C 6C                 JL     0xb4b1 ; CJUMP
00B445  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00B448  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B44B  0E                    PUSH   cs ; STACK_PUSH
00B44C  E8 A1 FE              CALL   0xb2f0 ; CALL_NEAR
00B44F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B452  A3 C4 8D              MOV    word ptr [0x8dc4], ax ; GLOBAL_LOAD
00B455  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00B458  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00B45B  EB 3C                 JMP    0xb499 ; JUMP
00B45D  90                    NOP ; NOP
00B45E  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00B461  40                    INC    ax ; ARITH
00B462  50                    PUSH   ax ; STACK_PUSH
00B463  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B466  8B F0                 MOV    si, ax ; MOV
00B468  0E                    PUSH   cs ; STACK_PUSH
00B469  E8 36 FE              CALL   0xb2a2 ; CALL_NEAR
00B46C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B46F  50                    PUSH   ax ; STACK_PUSH
00B470  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00B473  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B476  0E                    PUSH   cs ; STACK_PUSH
00B477  E8 A0 FE              CALL   0xb31a ; CALL_NEAR
00B47A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00B47D  56                    PUSH   si ; STACK_PUSH
00B47E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B481  0E                    PUSH   cs ; STACK_PUSH
00B482  E8 6B FE              CALL   0xb2f0 ; CALL_NEAR
00B485  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B488  50                    PUSH   ax ; STACK_PUSH
00B489  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00B48C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B48F  0E                    PUSH   cs ; STACK_PUSH
00B490  E8 71 FE              CALL   0xb304 ; CALL_NEAR
00B493  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00B496  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
00B499  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00B49D  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150] ; MOV
00B4A1  2A E4                 SUB    ah, ah ; ARITH
00B4A3  48                    DEC    ax ; ARITH
00B4A4  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
00B4A7  7F B5                 JG     0xb45e ; CJUMP
00B4A9  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00B4AD  FE 8F 50 31           DEC    byte ptr [bx + 0x3150] ; ARITH
00B4B1  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00B4B4  5E                    POP    si ; STACK_POP
00B4B5  C9                    LEAVE ; EPILOGUE
00B4B6  CB                    RETF ; RETURN
