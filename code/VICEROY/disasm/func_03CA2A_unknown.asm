; ============================================================================
; func_03CA2A_unknown
; Region   : overlay
; Bytes    : file 0x03CA2A..0x03CAC5  (155 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CA2A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
03CA2E  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03CA32  8B 87 B8 00           MOV    ax, word ptr [bx + 0xb8] ; MOV
03CA36  05 32 00              ADD    ax, 0x32 ; ARITH
03CA39  B9 64 00              MOV    cx, 0x64 ; CONST_LOAD
03CA3C  99                    CDQ ; ARITH
03CA3D  F7 F9                 IDIV   cx ; ARITH
03CA3F  40                    INC    ax ; ARITH
03CA40  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03CA43  8A 07                 MOV    al, byte ptr [bx] ; MOV
03CA45  2A E4                 SUB    ah, ah ; ARITH
03CA47  8A 57 01              MOV    dl, byte ptr [bx + 1] ; MOV
03CA4A  2A F6                 SUB    dh, dh ; ARITH
03CA4C  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
03CA51  EB 2E                 JMP    0x3ca81 ; JUMP
03CA53  90                    NOP ; NOP
03CA54  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
03CA58  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
03CA5D  72 07                 JB     0x3ca66 ; CJUMP
03CA5F  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
03CA64  76 13                 JBE    0x3ca79 ; CJUMP
03CA66  6A 01                 PUSH   1 ; STACK_PUSH
03CA68  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
03CA6B  9A C8 09 1F 18        LCALL  0x181f, 0x9c8 ; THUNK -> 0x057E:0x004A (thunk @file 0x01AFB8 type B) overlay @file 0x0305A8
03CA70  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03CA73  C1 F8 04              SAR    ax, 4 ; LOGIC
03CA76  01 46 FC              ADD    word ptr [bp - 4], ax ; ARITH
03CA79  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
03CA7C  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
03CA81  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03CA84  0B C0                 OR     ax, ax ; LOGIC
03CA86  7D CC                 JGE    0x3ca54 ; CJUMP
03CA88  6A 02                 PUSH   2 ; STACK_PUSH
03CA8A  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
03CA8F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03CA92  0B C0                 OR     ax, ax ; LOGIC
03CA94  74 06                 JE     0x3ca9c ; CJUMP
03CA96  D1 66 FC              SHL    word ptr [bp - 4], 1 ; LOGIC
03CA99  EB 1D                 JMP    0x3cab8 ; JUMP
03CA9B  90                    NOP ; NOP
03CA9C  6A 01                 PUSH   1 ; STACK_PUSH
03CA9E  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
03CAA3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03CAA6  0B C0                 OR     ax, ax ; LOGIC
03CAA8  74 0E                 JE     0x3cab8 ; CJUMP
03CAAA  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
03CAAD  8B C8                 MOV    cx, ax ; MOV
03CAAF  D1 E0                 SHL    ax, 1 ; LOGIC
03CAB1  03 C1                 ADD    ax, cx ; ARITH
03CAB3  D1 F8                 SAR    ax, 1 ; LOGIC
03CAB5  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03CAB8  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
03CABB  3D 01 00              CMP    ax, 1 ; CMP
03CABE  7D 03                 JGE    0x3cac3 ; CJUMP
03CAC0  B8 01 00              MOV    ax, 1 ; MOV
03CAC3  C9                    LEAVE ; EPILOGUE
03CAC4  CB                    RETF ; RETURN
