; ============================================================================
; func_00ACD6_unknown
; Region   : load_image
; Bytes    : file 0x00ACD6..0x00AD4F  (121 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00ACD6  55                    PUSH   bp ; STACK_PUSH
00ACD7  8B EC                 MOV    bp, sp ; MOV
00ACD9  56                    PUSH   si ; STACK_PUSH
00ACDA  83 3E F6 4F 00        CMP    word ptr [0x4ff6], 0 ; CMP
00ACDF  7C 21                 JL     0xad02 ; CJUMP
00ACE1  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
00ACE4  26 8B 07              MOV    ax, word ptr es:[bx] ; MOV
00ACE7  2B D2                 SUB    dx, dx ; ARITH
00ACE9  3B 16 F6 4F           CMP    dx, word ptr [0x4ff6] ; CMP
00ACED  7C 0F                 JL     0xacfe ; CJUMP
00ACEF  7F 06                 JG     0xacf7 ; CJUMP
00ACF1  3B 06 F4 4F           CMP    ax, word ptr [0x4ff4] ; CMP
00ACF5  76 07                 JBE    0xacfe ; CJUMP
00ACF7  8B 16 F6 4F           MOV    dx, word ptr [0x4ff6] ; GLOBAL_LOAD
00ACFB  A1 F4 4F              MOV    ax, word ptr [0x4ff4] ; GLOBAL_LOAD
00ACFE  8B F0                 MOV    si, ax ; MOV
00AD00  EB 06                 JMP    0xad08 ; JUMP
00AD02  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
00AD05  26 8B 37              MOV    si, word ptr es:[bx] ; MOV
00AD08  0B F6                 OR     si, si ; LOGIC
00AD0A  74 3C                 JE     0xad48 ; CJUMP
00AD0C  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00AD0F  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00AD12  6A 00                 PUSH   0 ; STACK_PUSH
00AD14  56                    PUSH   si ; STACK_PUSH
00AD15  B8 01 00              MOV    ax, 1 ; MOV
00AD18  99                    CDQ ; ARITH
00AD19  8B 1E 52 4F           MOV    bx, word ptr [0x4f52] ; GLOBAL_LOAD
00AD1D  9A 06 00 D5 07        LCALL  0x7d5, 6 ; LCALL
00AD22  8B F0                 MOV    si, ax ; MOV
00AD24  83 3E F6 4F 00        CMP    word ptr [0x4ff6], 0 ; CMP
00AD29  7C 13                 JL     0xad3e ; CJUMP
00AD2B  7F 07                 JG     0xad34 ; CJUMP
00AD2D  83 3E F4 4F 00        CMP    word ptr [0x4ff4], 0 ; CMP
00AD32  74 0A                 JE     0xad3e ; CJUMP
00AD34  2B C0                 SUB    ax, ax ; ARITH
00AD36  29 36 F4 4F           SUB    word ptr [0x4ff4], si ; ARITH
00AD3A  19 06 F6 4F           SBB    word ptr [0x4ff6], ax ; ARITH
00AD3E  2B C0                 SUB    ax, ax ; ARITH
00AD40  01 36 8A 4C           ADD    word ptr [0x4c8a], si ; ARITH
00AD44  11 06 8C 4C           ADC    word ptr [0x4c8c], ax ; ARITH
00AD48  8B C6                 MOV    ax, si ; MOV
00AD4A  5E                    POP    si ; STACK_POP
00AD4B  C9                    LEAVE ; EPILOGUE
00AD4C  CA 08 00              RETF   8 ; RETURN
