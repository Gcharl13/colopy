; ============================================================================
; func_03BAA6_unknown
; Region   : overlay
; Bytes    : file 0x03BAA6..0x03BB49  (163 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03BAA6  C8 58 00 00           ENTER  0x58, 0 ; PROLOGUE
03BAAA  2B C0                 SUB    ax, ax ; ARITH
03BAAC  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03BAAF  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03BAB2  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
03BAB5  8B 5E A8              MOV    bx, word ptr [bp - 0x58] ; LOCAL_LOAD
03BAB8  8A 87 3A 12           MOV    al, byte ptr [bx + 0x123a] ; MOV
03BABC  2A E4                 SUB    ah, ah ; ARITH
03BABE  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
03BAC1  50                    PUSH   ax ; STACK_PUSH
03BAC2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03BAC5  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
03BACA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03BACD  0B C0                 OR     ax, ax ; LOGIC
03BACF  74 6A                 JE     0x3bb3b ; CJUMP
03BAD1  68 34 12              PUSH   0x1234 ; PUSH_CONST
03BAD4  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
03BAD7  50                    PUSH   ax ; STACK_PUSH
03BAD8  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
03BADD  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03BAE0  83 7E AA 0A           CMP    word ptr [bp - 0x56], 0xa ; CMP
03BAE4  7D 0F                 JGE    0x3baf5 ; CJUMP
03BAE6  68 38 12              PUSH   0x1238 ; PUSH_CONST
03BAE9  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
03BAEC  50                    PUSH   ax ; STACK_PUSH
03BAED  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
03BAF2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03BAF5  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
03BAF8  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
03BAFB  16                    PUSH   ss ; STACK_PUSH
03BAFC  50                    PUSH   ax ; STACK_PUSH
03BAFD  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
03BB02  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03BB05  9A DE 0F 1F 19        LCALL  0x191f, 0xfde ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C5CE type A) overlay @file 0x025900
03BB0A  8D 5E AC              LEA    bx, [bp - 0x54] ; ADDR
03BB0D  2B C0                 SUB    ax, ax ; ARITH
03BB0F  9A D0 0F 1F 19        LCALL  0x191f, 0xfd0 ; THUNK -> 0x0000:0x0054 (thunk @file 0x01C5C0 type A) overlay @file 0x025954
03BB14  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03BB17  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
03BB1A  0B D0                 OR     dx, ax ; LOGIC
03BB1C  74 1D                 JE     0x3bb3b ; CJUMP
03BB1E  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
03BB21  50                    PUSH   ax ; STACK_PUSH
03BB22  C4 5E FC              LES    bx, ptr [bp - 4] ; MOV_FAR
03BB25  26 FF 77 48           PUSH   word ptr es:[bx + 0x48] ; PUSH_GLOBAL
03BB29  6A 64                 PUSH   0x64 ; PUSH_CONST
03BB2B  26 8B 57 46           MOV    dx, word ptr es:[bx + 0x46] ; MOV
03BB2F  B8 01 00              MOV    ax, 1 ; MOV
03BB32  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
03BB36  9A F8 02 1F 18        LCALL  0x181f, 0x2f8 ; THUNK -> 0x0C56:0x0004 (thunk @file 0x01A8E8 type B)
03BB3B  FF 46 A8              INC    word ptr [bp - 0x58] ; ARITH
03BB3E  83 7E A8 19           CMP    word ptr [bp - 0x58], 0x19 ; CMP
03BB42  7D 03                 JGE    0x3bb47 ; CJUMP
03BB44  E9 6E FF              JMP    0x3bab5 ; JUMP
03BB47  C9                    LEAVE ; EPILOGUE
03BB48  CB                    RETF ; RETURN
