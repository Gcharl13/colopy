; ============================================================================
; func_00B20A_unknown
; Region   : load_image
; Bytes    : file 0x00B20A..0x00B23C  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B20A  55                    PUSH   bp ; STACK_PUSH
00B20B  8B EC                 MOV    bp, sp ; MOV
00B20D  56                    PUSH   si ; STACK_PUSH
00B20E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00B211  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B214  9A 12 01 AB 02        LCALL  0x2ab, 0x112 ; LCALL
00B219  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B21C  2A E4                 SUB    ah, ah ; ARITH
00B21E  24 1F                 AND    al, 0x1f ; LOGIC
00B220  8B F0                 MOV    si, ax ; MOV
00B222  83 FE 08              CMP    si, 8 ; CMP
00B225  7C 05                 JL     0xb22c ; CJUMP
00B227  83 FE 10              CMP    si, 0x10 ; CMP
00B22A  7C 0A                 JL     0xb236 ; CJUMP
00B22C  83 FE 10              CMP    si, 0x10 ; CMP
00B22F  7C 0B                 JL     0xb23c ; CJUMP
00B231  83 FE 18              CMP    si, 0x18 ; CMP
00B234  7D 06                 JGE    0xb23c ; CJUMP
00B236  B8 01 00              MOV    ax, 1 ; MOV
00B239  5E                    POP    si ; STACK_POP
00B23A  C9                    LEAVE ; EPILOGUE
00B23B  CB                    RETF ; RETURN
