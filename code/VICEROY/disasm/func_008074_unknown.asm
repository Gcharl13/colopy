; ============================================================================
; func_008074_unknown
; Region   : load_image
; Bytes    : file 0x008074..0x0080C7  (83 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008074  55                    PUSH   bp ; STACK_PUSH
008075  8B EC                 MOV    bp, sp ; MOV
008077  56                    PUSH   si ; STACK_PUSH
008078  83 7E 06 03           CMP    word ptr [bp + 6], 3 ; CMP
00807C  75 32                 JNE    0x80b0 ; CJUMP
00807E  FF 36 02 2E           PUSH   word ptr [0x2e02] ; PUSH_GLOBAL
008082  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
008085  9A E2 00 4B 00        LCALL  0x4b, 0xe2 ; LCALL
00808A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00808D  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
008090  9A 00 00 4B 00        LCALL  0x4b, 0 ; LCALL
008095  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
008098  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
00809C  75 12                 JNE    0x80b0 ; CJUMP
00809E  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
0080A1  8A 07                 MOV    al, byte ptr [bx] ; MOV
0080A3  98                    CWDE ; ARITH
0080A4  8B F0                 MOV    si, ax ; MOV
0080A6  F6 84 ED 27 01        TEST   byte ptr [si + 0x27ed], 1 ; LOGIC
0080AB  74 03                 JE     0x80b0 ; CJUMP
0080AD  80 07 20              ADD    byte ptr [bx], 0x20 ; ARITH
0080B0  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0080B3  D1 E3                 SHL    bx, 1 ; LOGIC
0080B5  FF B7 42 8D           PUSH   word ptr [bx - 0x72be] ; PUSH_GLOBAL
0080B9  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0080BC  9A E2 00 4B 00        LCALL  0x4b, 0xe2 ; LCALL
0080C1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0080C4  5E                    POP    si ; STACK_POP
0080C5  C9                    LEAVE ; EPILOGUE
0080C6  CB                    RETF ; RETURN
