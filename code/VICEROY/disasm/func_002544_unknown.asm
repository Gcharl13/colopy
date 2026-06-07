; ============================================================================
; func_002544_unknown
; Region   : load_image
; Bytes    : file 0x002544..0x002580  (60 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002544  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
002548  0E                    PUSH   cs ; STACK_PUSH
002549  E8 7A FF              CALL   0x24c6 ; CALL_NEAR
00254C  80 3E 4A 00 00        CMP    byte ptr [0x4a], 0 ; CMP
002551  75 03                 JNE    0x2556 ; CJUMP
002553  E9 A7 00              JMP    0x25fd ; JUMP
002556  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
00255A  75 03                 JNE    0x255f ; CJUMP
00255C  E9 9E 00              JMP    0x25fd ; JUMP
00255F  83 3E BA 14 00        CMP    word ptr [0x14ba], 0 ; CMP
002564  75 28                 JNE    0x258e ; CJUMP
002566  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
00256A  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
00256E  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
002572  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
002576  FF 36 C8 2C           PUSH   word ptr [0x2cc8] ; PUSH_GLOBAL
00257A  6A 22                 PUSH   0x22 ; PUSH_CONST
00257C  A1 CA 2C              MOV    ax, word ptr [0x2cca] ; GLOBAL_LOAD
00257F  8B                    DB     0x8B ; DATA_BYTE
