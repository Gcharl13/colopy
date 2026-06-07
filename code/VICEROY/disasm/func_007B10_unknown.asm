; ============================================================================
; func_007B10_unknown
; Region   : load_image
; Bytes    : file 0x007B10..0x007B5C  (76 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007B10  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
007B14  57                    PUSH   di ; STACK_PUSH
007B15  56                    PUSH   si ; STACK_PUSH
007B16  39 06 9C 53           CMP    word ptr [0x539c], ax ; CMP
007B1A  7E 08                 JLE    0x7b24 ; CJUMP
007B1C  0B C0                 OR     ax, ax ; LOGIC
007B1E  7C 04                 JL     0x7b24 ; CJUMP
007B20  8B D0                 MOV    dx, ax ; MOV
007B22  EB 0F                 JMP    0x7b33 ; JUMP
007B24  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
007B27  8B 16 9C 53           MOV    dx, word ptr [0x539c] ; GLOBAL_LOAD
007B2B  4A                    DEC    dx ; ARITH
007B2C  83 3E 9C 53 00        CMP    word ptr [0x539c], 0 ; CMP
007B31  74 2C                 JE     0x7b5f ; CJUMP
007B33  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
007B36  8B F0                 MOV    si, ax ; MOV
007B38  46                    INC    si ; ARITH
007B39  39 36 9C 53           CMP    word ptr [0x539c], si ; CMP
007B3D  7F 02                 JG     0x7b41 ; CJUMP
007B3F  2B F6                 SUB    si, si ; ARITH
007B41  8B C6                 MOV    ax, si ; MOV
007B43  0E                    PUSH   cs ; STACK_PUSH
007B44  E8 39 FF              CALL   0x7a80 ; CALL_NEAR
007B47  8B F8                 MOV    di, ax ; MOV
007B49  0B FF                 OR     di, di ; LOGIC
007B4B  75 05                 JNE    0x7b52 ; CJUMP
007B4D  39 76 FE              CMP    word ptr [bp - 2], si ; CMP
007B50  75 E6                 JNE    0x7b38 ; CJUMP
007B52  0B FF                 OR     di, di ; LOGIC
007B54  74 06                 JE     0x7b5c ; CJUMP
007B56  8B C6                 MOV    ax, si ; MOV
007B58  5E                    POP    si ; STACK_POP
007B59  5F                    POP    di ; STACK_POP
007B5A  C9                    LEAVE ; EPILOGUE
007B5B  CB                    RETF ; RETURN
