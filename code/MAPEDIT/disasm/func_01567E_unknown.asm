; ============================================================================
; func_01567E_unknown
; Region   : load_image
; Bytes    : file 0x01567E..0x0156FD  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01567E  55                    PUSH   bp ; STACK_PUSH
01567F  8B EC                 MOV    bp, sp ; MOV
015681  56                    PUSH   si ; STACK_PUSH
015682  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
015685  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
015689  74 0C                 JE     0x15697 ; CJUMP
01568B  83 7E 0C 02           CMP    word ptr [bp + 0xc], 2 ; CMP
01568F  7F 06                 JG     0x15697 ; CJUMP
015691  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
015695  7D 09                 JGE    0x156a0 ; CJUMP
015697  C7 06 68 45 16 00     MOV    word ptr [0x4568], 0x16 ; GLOBAL_LOAD
01569D  EB 52                 JMP    0x156f1 ; JUMP
01569F  90                    NOP ; NOP
0156A0  80 64 06 EF           AND    byte ptr [si + 6], 0xef ; LOGIC
0156A4  83 7E 0C 01           CMP    word ptr [bp + 0xc], 1 ; CMP
0156A8  75 14                 JNE    0x156be ; CJUMP
0156AA  56                    PUSH   si ; STACK_PUSH
0156AB  9A F6 1E 88 13        LCALL  0x1388, 0x1ef6 ; LCALL
0156B0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0156B3  01 46 08              ADD    word ptr [bp + 8], ax ; ARITH
0156B6  11 56 0A              ADC    word ptr [bp + 0xa], dx ; ARITH
0156B9  C7 46 0C 00 00        MOV    word ptr [bp + 0xc], 0 ; LOCAL_STORE
0156BE  56                    PUSH   si ; STACK_PUSH
0156BF  9A CE 15 88 13        LCALL  0x1388, 0x15ce ; LCALL
0156C4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0156C7  F6 44 06 80           TEST   byte ptr [si + 6], 0x80 ; LOGIC
0156CB  74 04                 JE     0x156d1 ; CJUMP
0156CD  80 64 06 FC           AND    byte ptr [si + 6], 0xfc ; LOGIC
0156D1  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0156D4  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0156D7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0156DA  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
0156DD  2A E4                 SUB    ah, ah ; ARITH
0156DF  50                    PUSH   ax ; STACK_PUSH
0156E0  9A D2 1B 88 13        LCALL  0x1388, 0x1bd2 ; LCALL
0156E5  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0156E8  3D FF FF              CMP    ax, 0xffff ; CMP
0156EB  75 09                 JNE    0x156f6 ; CJUMP
0156ED  3B D0                 CMP    dx, ax ; CMP
0156EF  75 05                 JNE    0x156f6 ; CJUMP
0156F1  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0156F4  EB 02                 JMP    0x156f8 ; JUMP
0156F6  2B C0                 SUB    ax, ax ; ARITH
0156F8  5E                    POP    si ; STACK_POP
0156F9  8B E5                 MOV    sp, bp ; MOV
0156FB  5D                    POP    bp ; STACK_POP
0156FC  CB                    RETF ; RETURN
