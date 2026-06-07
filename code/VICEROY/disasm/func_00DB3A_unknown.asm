; ============================================================================
; func_00DB3A_unknown
; Region   : load_image
; Bytes    : file 0x00DB3A..0x00DB7F  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00DB3A  55                    PUSH   bp ; STACK_PUSH
00DB3B  8B EC                 MOV    bp, sp ; MOV
00DB3D  53                    PUSH   bx ; STACK_PUSH
00DB3E  50                    PUSH   ax ; STACK_PUSH
00DB3F  57                    PUSH   di ; STACK_PUSH
00DB40  56                    PUSH   si ; STACK_PUSH
00DB41  8B FA                 MOV    di, dx ; MOV
00DB43  9A CE 02 58 0A        LCALL  0xa58, 0x2ce ; LCALL
00DB48  9A BE 05 58 0A        LCALL  0xa58, 0x5be ; LCALL
00DB4D  8B F0                 MOV    si, ax ; MOV
00DB4F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00DB52  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00DB55  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00DB58  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00DB5B  57                    PUSH   di ; STACK_PUSH
00DB5C  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00DB5F  1E                    PUSH   ds ; STACK_PUSH
00DB60  68 A8 2D              PUSH   0x2da8 ; PUSH_CONST
00DB63  9A 1C 00 11 0D        LCALL  0xd11, 0x1c ; LCALL
00DB68  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
00DB6B  0B F6                 OR     si, si ; LOGIC
00DB6D  74 05                 JE     0xdb74 ; CJUMP
00DB6F  9A FD 06 58 0A        LCALL  0xa58, 0x6fd ; LCALL
00DB74  9A E0 02 58 0A        LCALL  0xa58, 0x2e0 ; LCALL
00DB79  5E                    POP    si ; STACK_POP
00DB7A  5F                    POP    di ; STACK_POP
00DB7B  C9                    LEAVE ; EPILOGUE
00DB7C  CA 06 00              RETF   6 ; RETURN
