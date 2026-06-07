; ============================================================================
; func_00FD28_unknown
; Region   : load_image
; Bytes    : file 0x00FD28..0x00FD4D  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FD28  55                    PUSH   bp ; STACK_PUSH
00FD29  8B EC                 MOV    bp, sp ; MOV
00FD2B  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00FD2E  FF 4F 02              DEC    word ptr [bx + 2] ; ARITH
00FD31  78 0E                 JS     0xfd41 ; CJUMP
00FD33  FF 07                 INC    word ptr [bx] ; ARITH
00FD35  8B 1F                 MOV    bx, word ptr [bx] ; MOV
00FD37  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
00FD3A  88 47 FF              MOV    byte ptr [bx - 1], al ; MOV
00FD3D  32 E4                 XOR    ah, ah ; LOGIC
00FD3F  EB 0A                 JMP    0xfd4b ; JUMP
00FD41  53                    PUSH   bx ; STACK_PUSH
00FD42  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00FD45  0E                    PUSH   cs ; STACK_PUSH
00FD46  E8 73 0E              CALL   0x10bbc ; CALL_NEAR
00FD49  5B                    POP    bx ; STACK_POP
00FD4A  5B                    POP    bx ; STACK_POP
00FD4B  5D                    POP    bp ; STACK_POP
00FD4C  CB                    RETF ; RETURN
