; ============================================================================
; func_022A3A_unknown
; Region   : overlay
; Bytes    : file 0x022A3A..0x022B04  (202 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022A3A  C8 64 00 00           ENTER  0x64, 0 ; PROLOGUE
022A3E  56                    PUSH   si ; STACK_PUSH
022A3F  C7 46 A8 01 00        MOV    word ptr [bp - 0x58], 1 ; LOCAL_STORE
022A44  C7 46 AE 00 00        MOV    word ptr [bp - 0x52], 0 ; LOCAL_STORE
022A49  2B C0                 SUB    ax, ax ; ARITH
022A4B  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
022A4E  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
022A51  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
022A54  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
022A57  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
022A5C  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
022A5F  0B C0                 OR     ax, ax ; LOGIC
022A61  7D 03                 JGE    0x22a66 ; CJUMP
022A63  E9 5C 02              JMP    0x22cc2 ; JUMP
022A66  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
022A69  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
022A6D  24 0F                 AND    al, 0xf ; LOGIC
022A6F  3A 06 94 53           CMP    al, byte ptr [0x5394] ; CMP
022A73  74 03                 JE     0x22a78 ; CJUMP
022A75  E9 4A 02              JMP    0x22cc2 ; JUMP
022A78  6A 00                 PUSH   0 ; STACK_PUSH
022A7A  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
022A7D  9A EA 07 1F 18        LCALL  0x181f, 0x7ea ; THUNK -> 0x0427:0x04D6 (thunk @file 0x01ADDA type B) overlay @file 0x0311EA
022A82  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022A85  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
022A88  9A EE 02 1F 18        LCALL  0x181f, 0x2ee ; THUNK -> 0x0427:0x0002 (thunk @file 0x01A8DE type B) overlay @file 0x030D16
022A8D  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
022A90  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
022A93  83 BF 5E 31 00        CMP    word ptr [bx + 0x315e], 0 ; CMP
022A98  7D 24                 JGE    0x22abe ; CJUMP
022A9A  8B F3                 MOV    si, bx ; MOV
022A9C  9A 66 09 1F 18        LCALL  0x181f, 0x966 ; THUNK -> 0x0427:0x1330 (thunk @file 0x01AF56 type B) overlay @file 0x032044
022AA1  0B C0                 OR     ax, ax ; LOGIC
022AA3  75 07                 JNE    0x22aac ; CJUMP
022AA5  80 BC 4C 31 00        CMP    byte ptr [si + 0x314c], 0 ; CMP
022AAA  74 12                 JE     0x22abe ; CJUMP
022AAC  6B 5E AA 1C           IMUL   bx, word ptr [bp - 0x56], 0x1c ; ARITH
022AB0  C6 87 4C 31 00        MOV    byte ptr [bx + 0x314c], 0 ; MOV
022AB5  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
022AB8  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
022ABB  E9 A8 01              JMP    0x22c66 ; JUMP
022ABE  FF 36 8C 26           PUSH   word ptr [0x268c] ; PUSH_GLOBAL
022AC2  FF 36 8A 26           PUSH   word ptr [0x268a] ; PUSH_GLOBAL
022AC6  68 00 08              PUSH   0x800 ; PUSH_CONST
022AC9  9A 3C 02 1F 19        LCALL  0x191f, 0x23c ; THUNK -> 0x0000:0x06D0 (thunk @file 0x01B82C type A) overlay @file 0x025FD0
022ACE  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
022AD1  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
022AD4  89 56 A6              MOV    word ptr [bp - 0x5a], dx ; LOCAL_STORE
022AD7  0B D0                 OR     dx, ax ; LOGIC
022AD9  75 03                 JNE    0x22ade ; CJUMP
022ADB  E9 E4 01              JMP    0x22cc2 ; JUMP
022ADE  C4 5E A4              LES    bx, ptr [bp - 0x5c] ; MOV_FAR
022AE1  26 C7 47 46 00 00     MOV    word ptr es:[bx + 0x46], 0 ; MOV
022AE7  B8 02 00              MOV    ax, 2 ; MOV
022AEA  26 89 47 4A           MOV    word ptr es:[bx + 0x4a], ax ; MOV
022AEE  0C 80                 OR     al, 0x80 ; LOGIC
022AF0  26 09 47 0A           OR     word ptr es:[bx + 0xa], ax ; LOGIC
022AF4  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
022AF7  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
022AFA  C7 46 9E 01 00        MOV    word ptr [bp - 0x62], 1 ; LOCAL_STORE
022AFF  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
022B02  8B C3                 MOV    ax, bx ; MOV
