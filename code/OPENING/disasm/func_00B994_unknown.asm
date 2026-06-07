; ============================================================================
; func_00B994_unknown
; Region   : load_image
; Bytes    : file 0x00B994..0x00B9FA  (102 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B994  55                    PUSH   bp ; STACK_PUSH
00B995  8B EC                 MOV    bp, sp ; MOV
00B997  50                    PUSH   ax ; STACK_PUSH
00B998  57                    PUSH   di ; STACK_PUSH
00B999  56                    PUSH   si ; STACK_PUSH
00B99A  83 3E 4A 42 00        CMP    word ptr [0x424a], 0 ; CMP
00B99F  74 55                 JE     0xb9f6 ; CJUMP
00B9A1  83 3E 64 42 00        CMP    word ptr [0x4264], 0 ; CMP
00B9A6  74 4E                 JE     0xb9f6 ; CJUMP
00B9A8  0B C0                 OR     ax, ax ; LOGIC
00B9AA  74 4A                 JE     0xb9f6 ; CJUMP
00B9AC  0E                    PUSH   cs ; STACK_PUSH
00B9AD  E8 50 FF              CALL   0xb900 ; CALL_NEAR
00B9B0  0B C0                 OR     ax, ax ; LOGIC
00B9B2  75 42                 JNE    0xb9f6 ; CJUMP
00B9B4  2B DB                 SUB    bx, bx ; ARITH
00B9B6  39 06 10 42           CMP    word ptr [0x4210], ax ; CMP
00B9BA  7E 2E                 JLE    0xb9ea ; CJUMP
00B9BC  8B 3E 4C 42           MOV    di, word ptr [0x424c] ; GLOBAL_LOAD
00B9C0  8B 0E 46 42           MOV    cx, word ptr [0x4246] ; GLOBAL_LOAD
00B9C4  8E 06 4E 42           MOV    es, word ptr [0x424e] ; GLOBAL_LOAD
00B9C8  8B F7                 MOV    si, di ; MOV
00B9CA  03 F3                 ADD    si, bx ; ARITH
00B9CC  26 8A 04              MOV    al, byte ptr es:[si] ; MOV
00B9CF  2A 46 FE              SUB    al, byte ptr [bp - 2] ; ARITH
00B9D2  FE C8                 DEC    al ; ARITH
00B9D4  75 09                 JNE    0xb9df ; CJUMP
00B9D6  8B F7                 MOV    si, di ; MOV
00B9D8  03 F3                 ADD    si, bx ; ARITH
00B9DA  26 C6 04 00           MOV    byte ptr es:[si], 0 ; MOV
00B9DE  41                    INC    cx ; ARITH
00B9DF  43                    INC    bx ; ARITH
00B9E0  39 1E 10 42           CMP    word ptr [0x4210], bx ; CMP
00B9E4  7F E2                 JG     0xb9c8 ; CJUMP
00B9E6  89 0E 46 42           MOV    word ptr [0x4246], cx ; GLOBAL_LOAD
00B9EA  6B 5E FE 5A           IMUL   bx, word ptr [bp - 2], 0x5a ; ARITH
00B9EE  C4 36 5C 42           LES    si, ptr [0x425c] ; MOV_FAR
00B9F2  26 C6 00 FF           MOV    byte ptr es:[bx + si], 0xff ; CONST_LOAD
00B9F6  5E                    POP    si ; STACK_POP
00B9F7  5F                    POP    di ; STACK_POP
00B9F8  C9                    LEAVE ; EPILOGUE
00B9F9  CB                    RETF ; RETURN
