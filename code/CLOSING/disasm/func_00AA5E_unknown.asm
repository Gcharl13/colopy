; ============================================================================
; func_00AA5E_unknown
; Region   : load_image
; Bytes    : file 0x00AA5E..0x00AAC4  (102 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00AA5E  55                    PUSH   bp ; STACK_PUSH
00AA5F  8B EC                 MOV    bp, sp ; MOV
00AA61  50                    PUSH   ax ; STACK_PUSH
00AA62  57                    PUSH   di ; STACK_PUSH
00AA63  56                    PUSH   si ; STACK_PUSH
00AA64  83 3E F4 3F 00        CMP    word ptr [0x3ff4], 0 ; CMP
00AA69  74 55                 JE     0xaac0 ; CJUMP
00AA6B  83 3E 0E 40 00        CMP    word ptr [0x400e], 0 ; CMP
00AA70  74 4E                 JE     0xaac0 ; CJUMP
00AA72  0B C0                 OR     ax, ax ; LOGIC
00AA74  74 4A                 JE     0xaac0 ; CJUMP
00AA76  0E                    PUSH   cs ; STACK_PUSH
00AA77  E8 50 FF              CALL   0xa9ca ; CALL_NEAR
00AA7A  0B C0                 OR     ax, ax ; LOGIC
00AA7C  75 42                 JNE    0xaac0 ; CJUMP
00AA7E  2B DB                 SUB    bx, bx ; ARITH
00AA80  39 06 BA 3F           CMP    word ptr [0x3fba], ax ; CMP
00AA84  7E 2E                 JLE    0xaab4 ; CJUMP
00AA86  8B 3E F6 3F           MOV    di, word ptr [0x3ff6] ; GLOBAL_LOAD
00AA8A  8B 0E F0 3F           MOV    cx, word ptr [0x3ff0] ; GLOBAL_LOAD
00AA8E  8E 06 F8 3F           MOV    es, word ptr [0x3ff8] ; GLOBAL_LOAD
00AA92  8B F7                 MOV    si, di ; MOV
00AA94  03 F3                 ADD    si, bx ; ARITH
00AA96  26 8A 04              MOV    al, byte ptr es:[si] ; MOV
00AA99  2A 46 FE              SUB    al, byte ptr [bp - 2] ; ARITH
00AA9C  FE C8                 DEC    al ; ARITH
00AA9E  75 09                 JNE    0xaaa9 ; CJUMP
00AAA0  8B F7                 MOV    si, di ; MOV
00AAA2  03 F3                 ADD    si, bx ; ARITH
00AAA4  26 C6 04 00           MOV    byte ptr es:[si], 0 ; MOV
00AAA8  41                    INC    cx ; ARITH
00AAA9  43                    INC    bx ; ARITH
00AAAA  39 1E BA 3F           CMP    word ptr [0x3fba], bx ; CMP
00AAAE  7F E2                 JG     0xaa92 ; CJUMP
00AAB0  89 0E F0 3F           MOV    word ptr [0x3ff0], cx ; GLOBAL_LOAD
00AAB4  6B 5E FE 5A           IMUL   bx, word ptr [bp - 2], 0x5a ; ARITH
00AAB8  C4 36 06 40           LES    si, ptr [0x4006] ; MOV_FAR
00AABC  26 C6 00 FF           MOV    byte ptr es:[bx + si], 0xff ; CONST_LOAD
00AAC0  5E                    POP    si ; STACK_POP
00AAC1  5F                    POP    di ; STACK_POP
00AAC2  C9                    LEAVE ; EPILOGUE
00AAC3  CB                    RETF ; RETURN
