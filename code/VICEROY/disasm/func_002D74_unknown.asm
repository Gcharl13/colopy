; ============================================================================
; func_002D74_unknown
; Region   : load_image
; Bytes    : file 0x002D74..0x002E4E  (218 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002D74  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
002D78  52                    PUSH   dx ; STACK_PUSH
002D79  50                    PUSH   ax ; STACK_PUSH
002D7A  56                    PUSH   si ; STACK_PUSH
002D7B  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
002D80  0B D2                 OR     dx, dx ; LOGIC
002D82  75 03                 JNE    0x2d87 ; CJUMP
002D84  E9 BF 00              JMP    0x2e46 ; JUMP
002D87  0B DB                 OR     bx, bx ; LOGIC
002D89  75 03                 JNE    0x2d8e ; CJUMP
002D8B  E9 B8 00              JMP    0x2e46 ; JUMP
002D8E  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
002D91  C7 07 00 00           MOV    word ptr [bx], 0 ; MOV
002D95  8B 76 F0              MOV    si, word ptr [bp - 0x10] ; LOCAL_LOAD
002D98  8B C6                 MOV    ax, si ; MOV
002D9A  D1 E6                 SHL    si, 1 ; LOGIC
002D9C  03 F0                 ADD    si, ax ; ARITH
002D9E  C1 E6 02              SHL    si, 2 ; LOGIC
002DA1  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
002DA5  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; MOV
002DA9  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
002DAC  F6 46 06 02           TEST   byte ptr [bp + 6], 2 ; LOGIC
002DB0  74 05                 JE     0x2db7 ; CJUMP
002DB2  40                    INC    ax ; ARITH
002DB3  40                    INC    ax ; ARITH
002DB4  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
002DB7  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
002DBA  2B 46 FE              SUB    ax, word ptr [bp - 2] ; ARITH
002DBD  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
002DC0  83 7E F2 01           CMP    word ptr [bp - 0xe], 1 ; CMP
002DC4  7E 1E                 JLE    0x2de4 ; CJUMP
002DC6  8B 4E F2              MOV    cx, word ptr [bp - 0xe] ; LOCAL_LOAD
002DC9  49                    DEC    cx ; ARITH
002DCA  99                    CDQ ; ARITH
002DCB  F7 F9                 IDIV   cx ; ARITH
002DCD  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
002DD0  41                    INC    cx ; ARITH
002DD1  3B C1                 CMP    ax, cx ; CMP
002DD3  7E 02                 JLE    0x2dd7 ; CJUMP
002DD5  8B C1                 MOV    ax, cx ; MOV
002DD7  3D 01 00              CMP    ax, 1 ; CMP
002DDA  7D 03                 JGE    0x2ddf ; CJUMP
002DDC  B8 01 00              MOV    ax, 1 ; MOV
002DDF  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
002DE2  EB 05                 JMP    0x2de9 ; JUMP
002DE4  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1 ; LOCAL_STORE
002DE9  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
002DEC  48                    DEC    ax ; ARITH
002DED  F7 6E F6              IMUL   word ptr [bp - 0xa] ; ARITH
002DF0  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
002DF3  EB 0A                 JMP    0x2dff ; JUMP
002DF5  90                    NOP ; NOP
002DF6  FF 07                 INC    word ptr [bx] ; ARITH
002DF8  8A 0F                 MOV    cl, byte ptr [bx] ; MOV
002DFA  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
002DFD  D3 F8                 SAR    ax, cl ; LOGIC
002DFF  03 46 FE              ADD    ax, word ptr [bp - 2] ; ARITH
002E02  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
002E05  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
002E08  8A 0F                 MOV    cl, byte ptr [bx] ; MOV
002E0A  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
002E0D  D3 F8                 SAR    ax, cl ; LOGIC
002E0F  3B 46 F4              CMP    ax, word ptr [bp - 0xc] ; CMP
002E12  7F E2                 JG     0x2df6 ; CJUMP
002E14  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
002E17  48                    DEC    ax ; ARITH
002E18  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
002E1B  7E 05                 JLE    0x2e22 ; CJUMP
002E1D  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
002E20  EB 03                 JMP    0x2e25 ; JUMP
002E22  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
002E25  2B 46 FA              SUB    ax, word ptr [bp - 6] ; ARITH
002E28  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
002E2B  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
002E2F  74 05                 JE     0x2e36 ; CJUMP
002E31  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
002E34  89 07                 MOV    word ptr [bx], ax ; MOV
002E36  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
002E3A  74 0A                 JE     0x2e46 ; CJUMP
002E3C  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
002E3F  D1 F8                 SAR    ax, 1 ; LOGIC
002E41  8B 5E 12              MOV    bx, word ptr [bp + 0x12] ; LOCAL_LOAD
002E44  01 07                 ADD    word ptr [bx], ax ; ARITH
002E46  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
002E49  5E                    POP    si ; STACK_POP
002E4A  C9                    LEAVE ; EPILOGUE
002E4B  CA 0E 00              RETF   0xe ; RETURN
