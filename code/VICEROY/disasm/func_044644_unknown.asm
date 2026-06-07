; ============================================================================
; func_044644_unknown
; Region   : overlay
; Bytes    : file 0x044644..0x04477D  (313 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044644  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
044648  57                    PUSH   di ; STACK_PUSH
044649  56                    PUSH   si ; STACK_PUSH
04464A  83 7E 12 00           CMP    word ptr [bp + 0x12], 0 ; CMP
04464E  74 4A                 JE     0x4469a ; CJUMP
044650  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
044653  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
044656  26 FF 75 04           PUSH   word ptr es:[di + 4] ; STACK_PUSH
04465A  26 8B 5D 04           MOV    bx, word ptr es:[di + 4] ; MOV
04465E  8B D3                 MOV    dx, bx ; MOV
044660  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
044663  8C C6                 MOV    si, es ; MOV
044665  9A F0 01 1F 18        LCALL  0x181f, 0x1f0 ; THUNK -> 0x0C28:0x000A (thunk @file 0x01A7E0 type B)
04466A  8E C6                 MOV    es, si ; MOV
04466C  26 FF 75 0A           PUSH   word ptr es:[di + 0xa] ; PUSH_GLOBAL
044670  26 FF 75 08           PUSH   word ptr es:[di + 8] ; STACK_PUSH
044674  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
044677  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04467A  26 FF 35              PUSH   word ptr es:[di] ; STACK_PUSH
04467D  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
044681  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
044684  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
044687  8C C6                 MOV    si, es ; MOV
044689  9A FA 01 1F 18        LCALL  0x181f, 0x1fa ; THUNK -> 0x0C11:0x000C (thunk @file 0x01A7EA type B)
04468E  8E C6                 MOV    es, si ; MOV
044690  26 03 05              ADD    ax, word ptr es:[di] ; ARITH
044693  89 46 0E              MOV    word ptr [bp + 0xe], ax ; LOCAL_STORE
044696  E9 DD 00              JMP    0x44776 ; JUMP
044699  90                    NOP ; NOP
04469A  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
04469D  C6 46 FB 00           MOV    byte ptr [bp - 5], 0 ; LOCAL_STORE
0446A1  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
0446A4  26 FF 74 02           PUSH   word ptr es:[si + 2] ; STACK_PUSH
0446A8  26 8B 54 02           MOV    dx, word ptr es:[si + 2] ; MOV
0446AC  8B DA                 MOV    bx, dx ; MOV
0446AE  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0446B1  9A F0 01 1F 18        LCALL  0x181f, 0x1f0 ; THUNK -> 0x0C28:0x000A (thunk @file 0x01A7E0 type B)
0446B6  C4 5E 0A              LES    bx, ptr [bp + 0xa] ; MOV_FAR
0446B9  8B FB                 MOV    di, bx ; MOV
0446BB  8C 46 FE              MOV    word ptr [bp - 2], es ; LOCAL_STORE
0446BE  26 80 3F 00           CMP    byte ptr es:[bx], 0 ; CMP
0446C2  75 03                 JNE    0x446c7 ; CJUMP
0446C4  E9 AF 00              JMP    0x44776 ; JUMP
0446C7  26 80 3D 7E           CMP    byte ptr es:[di], 0x7e ; CMP
0446CB  75 65                 JNE    0x44732 ; CJUMP
0446CD  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
0446D0  26 FF 74 06           PUSH   word ptr es:[si + 6] ; STACK_PUSH
0446D4  26 8B 5C 06           MOV    bx, word ptr es:[si + 6] ; MOV
0446D8  8B D3                 MOV    dx, bx ; MOV
0446DA  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0446DD  89 76 F6              MOV    word ptr [bp - 0xa], si ; LOCAL_STORE
0446E0  8C 46 F8              MOV    word ptr [bp - 8], es ; LOCAL_STORE
0446E3  9A F0 01 1F 18        LCALL  0x181f, 0x1f0 ; THUNK -> 0x0C28:0x000A (thunk @file 0x01A7E0 type B)
0446E8  8E 46 FE              MOV    es, word ptr [bp - 2] ; LOCAL_LOAD
0446EB  47                    INC    di ; ARITH
0446EC  26 8A 05              MOV    al, byte ptr es:[di] ; MOV
0446EF  88 46 FA              MOV    byte ptr [bp - 6], al ; LOCAL_STORE
0446F2  C4 5E F6              LES    bx, ptr [bp - 0xa] ; MOV_FAR
0446F5  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa] ; PUSH_GLOBAL
0446F9  26 FF 77 08           PUSH   word ptr es:[bx + 8] ; STACK_PUSH
0446FD  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
044700  16                    PUSH   ss ; STACK_PUSH
044701  50                    PUSH   ax ; STACK_PUSH
044702  26 FF 37              PUSH   word ptr es:[bx] ; STACK_PUSH
044705  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
044709  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
04470C  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
04470F  9A FA 01 1F 18        LCALL  0x181f, 0x1fa ; THUNK -> 0x0C11:0x000C (thunk @file 0x01A7EA type B)
044714  C4 5E F6              LES    bx, ptr [bp - 0xa] ; MOV_FAR
044717  26 03 07              ADD    ax, word ptr es:[bx] ; ARITH
04471A  89 46 0E              MOV    word ptr [bp + 0xe], ax ; LOCAL_STORE
04471D  26 FF 77 02           PUSH   word ptr es:[bx + 2] ; STACK_PUSH
044721  26 8B 5F 02           MOV    bx, word ptr es:[bx + 2] ; MOV
044725  8B D3                 MOV    dx, bx ; MOV
044727  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
04472A  9A F0 01 1F 18        LCALL  0x181f, 0x1f0 ; THUNK -> 0x0C28:0x000A (thunk @file 0x01A7E0 type B)
04472F  EB 38                 JMP    0x44769 ; JUMP
044731  90                    NOP ; NOP
044732  26 8A 05              MOV    al, byte ptr es:[di] ; MOV
044735  88 46 FA              MOV    byte ptr [bp - 6], al ; LOCAL_STORE
044738  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
04473B  26 FF 74 0A           PUSH   word ptr es:[si + 0xa] ; PUSH_GLOBAL
04473F  26 FF 74 08           PUSH   word ptr es:[si + 8] ; STACK_PUSH
044743  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
044746  16                    PUSH   ss ; STACK_PUSH
044747  50                    PUSH   ax ; STACK_PUSH
044748  26 FF 34              PUSH   word ptr es:[si] ; STACK_PUSH
04474B  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
04474F  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
044752  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
044755  89 76 F2              MOV    word ptr [bp - 0xe], si ; LOCAL_STORE
044758  8C 46 F4              MOV    word ptr [bp - 0xc], es ; LOCAL_STORE
04475B  9A FA 01 1F 18        LCALL  0x181f, 0x1fa ; THUNK -> 0x0C11:0x000C (thunk @file 0x01A7EA type B)
044760  C4 5E F2              LES    bx, ptr [bp - 0xe] ; MOV_FAR
044763  26 03 07              ADD    ax, word ptr es:[bx] ; ARITH
044766  89 46 0E              MOV    word ptr [bp + 0xe], ax ; LOCAL_STORE
044769  8E 46 FE              MOV    es, word ptr [bp - 2] ; LOCAL_LOAD
04476C  47                    INC    di ; ARITH
04476D  26 80 3D 00           CMP    byte ptr es:[di], 0 ; CMP
044771  74 03                 JE     0x44776 ; CJUMP
044773  E9 51 FF              JMP    0x446c7 ; JUMP
044776  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
044779  5E                    POP    si ; STACK_POP
04477A  5F                    POP    di ; STACK_POP
04477B  C9                    LEAVE ; EPILOGUE
04477C  CB                    RETF ; RETURN
