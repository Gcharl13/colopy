; ============================================================================
; func_00D984_unknown
; Region   : load_image
; Bytes    : file 0x00D984..0x00D9C9  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D984  55                    PUSH   bp ; STACK_PUSH
00D985  8B EC                 MOV    bp, sp ; MOV
00D987  53                    PUSH   bx ; STACK_PUSH
00D988  50                    PUSH   ax ; STACK_PUSH
00D989  57                    PUSH   di ; STACK_PUSH
00D98A  56                    PUSH   si ; STACK_PUSH
00D98B  8B FA                 MOV    di, dx ; MOV
00D98D  9A BF 04 65 0F        LCALL  0xf65, 0x4bf ; LCALL
00D992  9A CD 07 65 0F        LCALL  0xf65, 0x7cd ; LCALL
00D997  8B F0                 MOV    si, ax ; MOV
00D999  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00D99C  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00D99F  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00D9A2  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00D9A5  57                    PUSH   di ; STACK_PUSH
00D9A6  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00D9A9  1E                    PUSH   ds ; STACK_PUSH
00D9AA  68 F4 3A              PUSH   0x3af4 ; PUSH_CONST
00D9AD  9A 24 00 C5 0E        LCALL  0xec5, 0x24 ; LCALL
00D9B2  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
00D9B5  0B F6                 OR     si, si ; LOGIC
00D9B7  74 05                 JE     0xd9be ; CJUMP
00D9B9  9A 03 09 65 0F        LCALL  0xf65, 0x903 ; LCALL
00D9BE  9A D1 04 65 0F        LCALL  0xf65, 0x4d1 ; LCALL
00D9C3  5E                    POP    si ; STACK_POP
00D9C4  5F                    POP    di ; STACK_POP
00D9C5  C9                    LEAVE ; EPILOGUE
00D9C6  CA 06 00              RETF   6 ; RETURN
