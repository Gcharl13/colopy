; ============================================================================
; func_0026EA_unknown
; Region   : load_image
; Bytes    : file 0x0026EA..0x00272F  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0026EA  55                    PUSH   bp ; STACK_PUSH
0026EB  8B EC                 MOV    bp, sp ; MOV
0026ED  53                    PUSH   bx ; STACK_PUSH
0026EE  50                    PUSH   ax ; STACK_PUSH
0026EF  57                    PUSH   di ; STACK_PUSH
0026F0  56                    PUSH   si ; STACK_PUSH
0026F1  8B FA                 MOV    di, dx ; MOV
0026F3  9A C9 04 35 07        LCALL  0x735, 0x4c9 ; LCALL
0026F8  9A D7 07 35 07        LCALL  0x735, 0x7d7 ; LCALL
0026FD  8B F0                 MOV    si, ax ; MOV
0026FF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
002702  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
002705  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
002708  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00270B  57                    PUSH   di ; STACK_PUSH
00270C  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00270F  1E                    PUSH   ds ; STACK_PUSH
002710  68 BA 36              PUSH   0x36ba ; PUSH_CONST
002713  9A 1E 00 72 03        LCALL  0x372, 0x1e ; LCALL
002718  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
00271B  0B F6                 OR     si, si ; LOGIC
00271D  74 05                 JE     0x2724 ; CJUMP
00271F  9A 0D 09 35 07        LCALL  0x735, 0x90d ; LCALL
002724  9A DB 04 35 07        LCALL  0x735, 0x4db ; LCALL
002729  5E                    POP    si ; STACK_POP
00272A  5F                    POP    di ; STACK_POP
00272B  C9                    LEAVE ; EPILOGUE
00272C  CA 06 00              RETF   6 ; RETURN
