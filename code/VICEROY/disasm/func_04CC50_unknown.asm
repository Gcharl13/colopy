; ============================================================================
; func_04CC50_unknown
; Region   : overlay
; Bytes    : file 0x04CC50..0x04CD2F  (223 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04CC50  C8 E4 01 00           ENTER  0x1e4, 0 ; PROLOGUE
04CC54  56                    PUSH   si ; STACK_PUSH
04CC55  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04CC58  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
04CC5D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04CC60  68 0E 01              PUSH   0x10e ; PUSH_CONST
04CC63  6A 00                 PUSH   0 ; STACK_PUSH
04CC65  68 AA 9F              PUSH   0x9faa ; PUSH_CONST
04CC68  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
04CC6D  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
04CC70  6A 10                 PUSH   0x10 ; PUSH_CONST
04CC72  6A 00                 PUSH   0 ; STACK_PUSH
04CC74  68 3C A1              PUSH   0xa13c ; PUSH_CONST
04CC77  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
04CC7C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
04CC7F  6A 10                 PUSH   0x10 ; PUSH_CONST
04CC81  6A 00                 PUSH   0 ; STACK_PUSH
04CC83  68 98 9E              PUSH   0x9e98 ; PUSH_CONST
04CC86  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
04CC8B  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
04CC8E  68 00 01              PUSH   0x100 ; PUSH_CONST
04CC91  6A 00                 PUSH   0 ; STACK_PUSH
04CC93  8D 86 B4 FE           LEA    ax, [bp - 0x14c] ; ADDR
04CC97  50                    PUSH   ax ; STACK_PUSH
04CC98  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
04CC9D  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
04CCA0  6A 63                 PUSH   0x63 ; PUSH_CONST
04CCA2  6A 03                 PUSH   3 ; STACK_PUSH
04CCA4  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04CCA7  8A 87 FC 8C           MOV    al, byte ptr [bx - 0x7304] ; MOV
04CCAB  C0 E8 03              SHR    al, 3 ; LOGIC
04CCAE  2A E4                 SUB    ah, ah ; ARITH
04CCB0  50                    PUSH   ax ; STACK_PUSH
04CCB1  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
04CCB6  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
04CCB9  89 46 C6              MOV    word ptr [bp - 0x3a], ax ; LOCAL_STORE
04CCBC  C7 46 C4 00 00        MOV    word ptr [bp - 0x3c], 0 ; LOCAL_STORE
04CCC1  8B 46 C6              MOV    ax, word ptr [bp - 0x3a] ; LOCAL_LOAD
04CCC4  8B 76 C4              MOV    si, word ptr [bp - 0x3c] ; LOCAL_LOAD
04CCC7  D1 E6                 SHL    si, 1 ; LOGIC
04CCC9  89 82 28 FE           MOV    word ptr [bp + si - 0x1d8], ax ; LOCAL_STORE
04CCCD  FF 46 C4              INC    word ptr [bp - 0x3c] ; ARITH
04CCD0  83 7E C4 40           CMP    word ptr [bp - 0x3c], 0x40 ; CMP
04CCD4  7C EB                 JL     0x4ccc1 ; CJUMP
04CCD6  2B C0                 SUB    ax, ax ; ARITH
04CCD8  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
04CCDB  89 86 AE FE           MOV    word ptr [bp - 0x152], ax ; LOCAL_STORE
04CCDF  E9 8F 01              JMP    0x4ce71 ; JUMP
04CCE2  C7 46 E4 00 00        MOV    word ptr [bp - 0x1c], 0 ; LOCAL_STORE
04CCE7  6A 03                 PUSH   3 ; STACK_PUSH
04CCE9  FF B6 AE FE           PUSH   word ptr [bp - 0x152] ; PUSH_GLOBAL
04CCED  9A BC 08 1F 18        LCALL  0x181f, 0x8bc ; THUNK -> 0x0427:0x0D38 (thunk @file 0x01AEAC type B) overlay @file 0x031A4C
04CCF2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04CCF5  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
04CCF8  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0 ; CMP
04CCFC  75 07                 JNE    0x4cd05 ; CJUMP
04CCFE  0B C0                 OR     ax, ax ; LOGIC
04CD00  75 03                 JNE    0x4cd05 ; CJUMP
04CD02  E9 DC 00              JMP    0x4cde1 ; JUMP
04CD05  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
04CD0A  6B 9E AE FE 1C        IMUL   bx, word ptr [bp - 0x152], 0x1c ; ARITH
04CD0F  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
04CD14  73 03                 JAE    0x4cd19 ; CJUMP
04CD16  E9 A2 00              JMP    0x4cdbb ; JUMP
04CD19  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
04CD1E  76 03                 JBE    0x4cd23 ; CJUMP
04CD20  E9 98 00              JMP    0x4cdbb ; JUMP
04CD23  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150] ; MOV
04CD27  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
04CD2B  2A FF                 SUB    bh, bh ; ARITH
04CD2D  8B CB                 MOV    cx, bx ; MOV
