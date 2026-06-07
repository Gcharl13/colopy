; ============================================================================
; func_00CF14_unknown
; Region   : load_image
; Bytes    : file 0x00CF14..0x00CFB8  (164 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CF14  55                    PUSH   bp ; STACK_PUSH
00CF15  8B EC                 MOV    bp, sp ; MOV
00CF17  0E                    PUSH   cs ; STACK_PUSH
00CF18  E8 21 FD              CALL   0xcc3c ; CALL_NEAR
00CF1B  83 3E 90 00 00        CMP    word ptr [0x90], 0 ; CMP
00CF20  75 24                 JNE    0xcf46 ; CJUMP
00CF22  FF 36 FA 3A           PUSH   word ptr [0x3afa] ; PUSH_GLOBAL
00CF26  FF 36 F8 3A           PUSH   word ptr [0x3af8] ; PUSH_GLOBAL
00CF2A  FF 36 F6 3A           PUSH   word ptr [0x3af6] ; PUSH_GLOBAL
00CF2E  FF 36 F4 3A           PUSH   word ptr [0x3af4] ; PUSH_GLOBAL
00CF32  6A 29                 PUSH   0x29 ; PUSH_CONST
00CF34  6A 00                 PUSH   0 ; STACK_PUSH
00CF36  B8 F1 00              MOV    ax, 0xf1 ; CONST_LOAD
00CF39  BA 08 00              MOV    dx, 8 ; MOV
00CF3C  BB 4F 00              MOV    bx, 0x4f ; CONST_LOAD
00CF3F  9A 04 00 5B 0C        LCALL  0xc5b, 4 ; LCALL
00CF44  EB 33                 JMP    0xcf79 ; JUMP
00CF46  6A 00                 PUSH   0 ; STACK_PUSH
00CF48  6A 00                 PUSH   0 ; STACK_PUSH
00CF4A  6A 29                 PUSH   0x29 ; PUSH_CONST
00CF4C  6A 4F                 PUSH   0x4f ; PUSH_CONST
00CF4E  6A 08                 PUSH   8 ; STACK_PUSH
00CF50  68 F1 00              PUSH   0xf1 ; PUSH_CONST
00CF53  8B 1E 90 00           MOV    bx, word ptr [0x90] ; GLOBAL_LOAD
00CF57  FF 77 06              PUSH   word ptr [bx + 6] ; STACK_PUSH
00CF5A  FF 77 04              PUSH   word ptr [bx + 4] ; STACK_PUSH
00CF5D  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
00CF60  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
00CF62  FF 36 FA 3A           PUSH   word ptr [0x3afa] ; PUSH_GLOBAL
00CF66  FF 36 F8 3A           PUSH   word ptr [0x3af8] ; PUSH_GLOBAL
00CF6A  FF 36 F6 3A           PUSH   word ptr [0x3af6] ; PUSH_GLOBAL
00CF6E  FF 36 F4 3A           PUSH   word ptr [0x3af4] ; PUSH_GLOBAL
00CF72  9A 00 00 B9 0C        LCALL  0xcb9, 0 ; LCALL
00CF77  8B E5                 MOV    sp, bp ; MOV
00CF79  FF 36 FA 3A           PUSH   word ptr [0x3afa] ; PUSH_GLOBAL
00CF7D  FF 36 F8 3A           PUSH   word ptr [0x3af8] ; PUSH_GLOBAL
00CF81  FF 36 F6 3A           PUSH   word ptr [0x3af6] ; PUSH_GLOBAL
00CF85  FF 36 F4 3A           PUSH   word ptr [0x3af4] ; PUSH_GLOBAL
00CF89  6A 30                 PUSH   0x30 ; PUSH_CONST
00CF8B  6A 06                 PUSH   6 ; STACK_PUSH
00CF8D  B8 FB 00              MOV    ax, 0xfb ; CONST_LOAD
00CF90  BA 08 00              MOV    dx, 8 ; MOV
00CF93  BB 34 01              MOV    bx, 0x134 ; CONST_LOAD
00CF96  9A 0C 00 86 0C        LCALL  0xc86, 0xc ; LCALL
00CF9B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00CF9E  0E                    PUSH   cs ; STACK_PUSH
00CF9F  E8 32 FE              CALL   0xcdd4 ; CALL_NEAR
00CFA2  8B E5                 MOV    sp, bp ; MOV
00CFA4  FF 36 FA 3A           PUSH   word ptr [0x3afa] ; PUSH_GLOBAL
00CFA8  FF 36 F8 3A           PUSH   word ptr [0x3af8] ; PUSH_GLOBAL
00CFAC  FF 36 F6 3A           PUSH   word ptr [0x3af6] ; PUSH_GLOBAL
00CFB0  FF 36 F4 3A           PUSH   word ptr [0x3af4] ; PUSH_GLOBAL
00CFB4  A1 C2 49              MOV    ax, word ptr [0x49c2] ; GLOBAL_LOAD
00CFB7  05                    DB     0x05 ; DATA_BYTE
