; ============================================================================
; func_0062E2_unknown
; Region   : load_image
; Bytes    : file 0x0062E2..0x006314  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0062E2  55                    PUSH   bp ; STACK_PUSH
0062E3  8B EC                 MOV    bp, sp ; MOV
0062E5  56                    PUSH   si ; STACK_PUSH
0062E6  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0062E9  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0062EC  9A 0E 01 7F 03        LCALL  0x37f, 0x10e ; LCALL
0062F1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0062F4  2A E4                 SUB    ah, ah ; ARITH
0062F6  24 1F                 AND    al, 0x1f ; LOGIC
0062F8  8B F0                 MOV    si, ax ; MOV
0062FA  83 FE 08              CMP    si, 8 ; CMP
0062FD  7C 05                 JL     0x6304 ; CJUMP
0062FF  83 FE 10              CMP    si, 0x10 ; CMP
006302  7C 0A                 JL     0x630e ; CJUMP
006304  83 FE 10              CMP    si, 0x10 ; CMP
006307  7C 0B                 JL     0x6314 ; CJUMP
006309  83 FE 18              CMP    si, 0x18 ; CMP
00630C  7D 06                 JGE    0x6314 ; CJUMP
00630E  B8 01 00              MOV    ax, 1 ; MOV
006311  5E                    POP    si ; STACK_POP
006312  C9                    LEAVE ; EPILOGUE
006313  CB                    RETF ; RETURN
