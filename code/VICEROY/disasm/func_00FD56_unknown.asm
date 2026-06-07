; ============================================================================
; func_00FD56_unknown
; Region   : load_image
; Bytes    : file 0x00FD56..0x00FD74  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FD56  55                    PUSH   bp ; STACK_PUSH
00FD57  8B EC                 MOV    bp, sp ; MOV
00FD59  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00FD5C  FF 4F 02              DEC    word ptr [bx + 2] ; ARITH
00FD5F  78 0B                 JS     0xfd6c ; CJUMP
00FD61  FF 07                 INC    word ptr [bx] ; ARITH
00FD63  8B 1F                 MOV    bx, word ptr [bx] ; MOV
00FD65  8A 47 FF              MOV    al, byte ptr [bx - 1] ; MOV
00FD68  32 E4                 XOR    ah, ah ; LOGIC
00FD6A  EB 06                 JMP    0xfd72 ; JUMP
00FD6C  53                    PUSH   bx ; STACK_PUSH
00FD6D  0E                    PUSH   cs ; STACK_PUSH
00FD6E  E8 B5 0D              CALL   0x10b26 ; CALL_NEAR
00FD71  5B                    POP    bx ; STACK_POP
00FD72  5D                    POP    bp ; STACK_POP
00FD73  CB                    RETF ; RETURN
