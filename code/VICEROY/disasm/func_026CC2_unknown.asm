; ============================================================================
; func_026CC2_unknown
; Region   : overlay
; Bytes    : file 0x026CC2..0x026DD3  (273 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026CC2  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
026CC6  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
026CCB  2B C0                 SUB    ax, ax ; ARITH
026CCD  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
026CD0  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
026CD3  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
026CD6  83 7E 06 13           CMP    word ptr [bp + 6], 0x13 ; CMP
026CDA  74 06                 JE     0x26ce2 ; CJUMP
026CDC  83 7E 06 14           CMP    word ptr [bp + 6], 0x14 ; CMP
026CE0  75 10                 JNE    0x26cf2 ; CJUMP
026CE2  A0 92 A8              MOV    al, byte ptr [0xa892] ; GLOBAL_LOAD
026CE5  2A E4                 SUB    ah, ah ; ARITH
026CE7  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
026CEA  C7 46 FC 3F 00        MOV    word ptr [bp - 4], 0x3f ; LOCAL_STORE
026CEF  E9 B2 00              JMP    0x26da4 ; JUMP
026CF2  83 7E 06 11           CMP    word ptr [bp + 6], 0x11 ; CMP
026CF6  75 0E                 JNE    0x26d06 ; CJUMP
026CF8  A1 D8 8D              MOV    ax, word ptr [0x8dd8] ; GLOBAL_LOAD
026CFB  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
026CFE  C7 46 FC 1F 00        MOV    word ptr [bp - 4], 0x1f ; LOCAL_STORE
026D03  E9 9E 00              JMP    0x26da4 ; JUMP
026D06  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
026D09  9A CE 0A 1F 18        LCALL  0x181f, 0xace ; THUNK -> 0x05EB:0x14D6 (thunk @file 0x01B0BE type B) overlay @file 0x0284C6
026D0E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026D11  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
026D14  0B C0                 OR     ax, ax ; LOGIC
026D16  7D 03                 JGE    0x26d1b ; CJUMP
026D18  E9 89 00              JMP    0x26da4 ; JUMP
026D1B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
026D1E  9A AA 0B 1F 18        LCALL  0x181f, 0xbaa ; THUNK -> 0x05EB:0x1568 (thunk @file 0x01B19A type B) overlay @file 0x028558
026D23  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026D26  0B C0                 OR     ax, ax ; LOGIC
026D28  7C 7A                 JL     0x26da4 ; CJUMP
026D2A  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
026D2D  EB 33                 JMP    0x26d62 ; JUMP
026D2F  90                    NOP ; NOP
026D30  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
026D33  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
026D36  05 17 00              ADD    ax, 0x17 ; ARITH
026D39  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
026D3C  EB 46                 JMP    0x26d84 ; JUMP
026D3E  C7 46 FA 10 00        MOV    word ptr [bp - 6], 0x10 ; LOCAL_STORE
026D43  C7 46 FC 37 00        MOV    word ptr [bp - 4], 0x37 ; LOCAL_STORE
026D48  EB 3A                 JMP    0x26d84 ; JUMP
026D4A  C7 46 FA 11 00        MOV    word ptr [bp - 6], 0x11 ; LOCAL_STORE
026D4F  C7 46 FC 39 00        MOV    word ptr [bp - 4], 0x39 ; LOCAL_STORE
026D54  EB 2E                 JMP    0x26d84 ; JUMP
026D56  C7 46 FA 12 00        MOV    word ptr [bp - 6], 0x12 ; LOCAL_STORE
026D5B  C7 46 FC 3F 00        MOV    word ptr [bp - 4], 0x3f ; LOCAL_STORE
026D60  EB 22                 JMP    0x26d84 ; JUMP
026D62  2D 09 00              SUB    ax, 9 ; ARITH
026D65  3D 08 00              CMP    ax, 8 ; CMP
026D68  77 1A                 JA     0x26d84 ; CJUMP
026D6A  D1 E0                 SHL    ax, 1 ; LOGIC
026D6C  93                    XCHG   bx, ax ; MOV
026D6D  2E FF A7 72 14        JMP    word ptr cs:[bx + 0x1472] ; JUMP
026D72  30 14                 XOR    byte ptr [si], dl ; LOGIC
026D74  30 14                 XOR    byte ptr [si], dl ; LOGIC
026D76  30 14                 XOR    byte ptr [si], dl ; LOGIC
026D78  30 14                 XOR    byte ptr [si], dl ; LOGIC
026D7A  3E 14 30              ADC    al, 0x30 ; ARITH
026D7D  14 30                 ADC    al, 0x30 ; ARITH
026D7F  14 4A                 ADC    al, 0x4a ; ARITH
026D81  14 56                 ADC    al, 0x56 ; ARITH
026D83  14 83                 ADC    al, 0x83 ; ARITH
026D85  7E FA                 JLE    0x26d81 ; CJUMP
026D87  00 7E 0C              ADD    byte ptr [bp + 0xc], bh ; ARITH
026D8A  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
026D8D  D1 E3                 SHL    bx, 1 ; LOGIC
026D8F  8B 87 C8 8D           MOV    ax, word ptr [bx - 0x7238] ; MOV
026D93  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
026D96  83 7E F4 11           CMP    word ptr [bp - 0xc], 0x11 ; CMP
026D9A  75 08                 JNE    0x26da4 ; CJUMP
026D9C  A0 92 A8              MOV    al, byte ptr [0xa892] ; GLOBAL_LOAD
026D9F  2A E4                 SUB    ah, ah ; ARITH
026DA1  29 46 FE              SUB    word ptr [bp - 2], ax ; ARITH
026DA4  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
026DA8  74 08                 JE     0x26db2 ; CJUMP
026DAA  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
026DAD  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
026DB0  89 07                 MOV    word ptr [bx], ax ; MOV
026DB2  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
026DB6  74 08                 JE     0x26dc0 ; CJUMP
026DB8  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
026DBB  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
026DBE  89 07                 MOV    word ptr [bx], ax ; MOV
026DC0  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
026DC4  74 08                 JE     0x26dce ; CJUMP
026DC6  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
026DC9  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
026DCC  89 07                 MOV    word ptr [bx], ax ; MOV
026DCE  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
026DD1  C9                    LEAVE ; EPILOGUE
026DD2  CB                    RETF ; RETURN
