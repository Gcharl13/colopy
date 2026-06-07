; ============================================================================
; func_0083C2_unknown
; Region   : load_image
; Bytes    : file 0x0083C2..0x008406  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0083C2  55                    PUSH   bp ; STACK_PUSH
0083C3  8B EC                 MOV    bp, sp ; MOV
0083C5  50                    PUSH   ax ; STACK_PUSH
0083C6  83 3E 32 06 00        CMP    word ptr [0x632], 0 ; CMP
0083CB  74 39                 JE     0x8406 ; CJUMP
0083CD  80 7E 0A 07           CMP    byte ptr [bp + 0xa], 7 ; CMP
0083D1  75 33                 JNE    0x8406 ; CJUMP
0083D3  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
0083D6  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
0083D9  FF 76 12              PUSH   word ptr [bp + 0x12] ; PUSH_GLOBAL
0083DC  53                    PUSH   bx ; STACK_PUSH
0083DD  52                    PUSH   dx ; STACK_PUSH
0083DE  50                    PUSH   ax ; STACK_PUSH
0083DF  8B 1E 32 06           MOV    bx, word ptr [0x632] ; GLOBAL_LOAD
0083E3  FF 77 06              PUSH   word ptr [bx + 6] ; STACK_PUSH
0083E6  FF 77 04              PUSH   word ptr [bx + 4] ; STACK_PUSH
0083E9  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
0083EC  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
0083EE  FF 76 1A              PUSH   word ptr [bp + 0x1a] ; PUSH_GLOBAL
0083F1  FF 76 18              PUSH   word ptr [bp + 0x18] ; PUSH_GLOBAL
0083F4  FF 76 16              PUSH   word ptr [bp + 0x16] ; PUSH_GLOBAL
0083F7  FF 76 14              PUSH   word ptr [bp + 0x14] ; PUSH_GLOBAL
0083FA  9A 00 00 B9 0C        LCALL  0xcb9, 0 ; LCALL
0083FF  83 C4 1C              ADD    sp, 0x1c ; STACK_CLEANUP
008402  C9                    LEAVE ; EPILOGUE
008403  C2 18 00              RET    0x18 ; RETURN
