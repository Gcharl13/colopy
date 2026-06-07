; ============================================================================
; func_006206_unknown
; Region   : load_image
; Bytes    : file 0x006206..0x006234  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006206  55                    PUSH   bp ; STACK_PUSH
006207  8B EC                 MOV    bp, sp ; MOV
006209  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
00620C  B4 41                 MOV    ah, 0x41 ; CONST_LOAD
00620E  CD 21                 INT    0x21 ; SYS
006210  E9 41 F1              JMP    0x5354 ; JUMP
006213  00 53 06              ADD    byte ptr [bp + di + 6], dl ; ARITH
006216  51                    PUSH   cx ; STACK_PUSH
006217  B9 00 04              MOV    cx, 0x400 ; CONST_LOAD
00621A  87 0E 9A 43           XCHG   word ptr [0x439a], cx ; MOV
00621E  51                    PUSH   cx ; STACK_PUSH
00621F  50                    PUSH   ax ; STACK_PUSH
006220  9A 8E 24 7D 03        LCALL  0x37d, 0x248e ; LCALL
006225  5B                    POP    bx ; STACK_POP
006226  8F 06 9A 43           POP    word ptr [0x439a] ; POP_GLOBAL
00622A  59                    POP    cx ; STACK_POP
00622B  8C DA                 MOV    dx, ds ; MOV
00622D  0B C0                 OR     ax, ax ; LOGIC
00622F  74 03                 JE     0x6234 ; CJUMP
006231  07                    POP    es ; STACK_POP
006232  5B                    POP    bx ; STACK_POP
006233  C3                    RET ; RETURN
