; ============================================================================
; func_04458A_unknown
; Region   : overlay
; Bytes    : file 0x04458A..0x0445CE  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04458A  55                    PUSH   bp ; STACK_PUSH
04458B  8B EC                 MOV    bp, sp ; MOV
04458D  50                    PUSH   ax ; STACK_PUSH
04458E  83 3E BA 14 00        CMP    word ptr [0x14ba], 0 ; CMP
044593  74 39                 JE     0x445ce ; CJUMP
044595  80 7E 0A 07           CMP    byte ptr [bp + 0xa], 7 ; CMP
044599  75 33                 JNE    0x445ce ; CJUMP
04459B  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
04459E  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
0445A1  FF 76 12              PUSH   word ptr [bp + 0x12] ; PUSH_GLOBAL
0445A4  53                    PUSH   bx ; STACK_PUSH
0445A5  52                    PUSH   dx ; STACK_PUSH
0445A6  50                    PUSH   ax ; STACK_PUSH
0445A7  8B 1E BA 14           MOV    bx, word ptr [0x14ba] ; GLOBAL_LOAD
0445AB  FF 77 06              PUSH   word ptr [bx + 6] ; STACK_PUSH
0445AE  FF 77 04              PUSH   word ptr [bx + 4] ; STACK_PUSH
0445B1  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
0445B4  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
0445B6  FF 76 1A              PUSH   word ptr [bp + 0x1a] ; PUSH_GLOBAL
0445B9  FF 76 18              PUSH   word ptr [bp + 0x18] ; PUSH_GLOBAL
0445BC  FF 76 16              PUSH   word ptr [bp + 0x16] ; PUSH_GLOBAL
0445BF  FF 76 14              PUSH   word ptr [bp + 0x14] ; PUSH_GLOBAL
0445C2  9A C4 00 1F 18        LCALL  0x181f, 0xc4 ; THUNK -> 0x0BF5:0x0000 (thunk @file 0x01A6B4 type B)
0445C7  83 C4 1C              ADD    sp, 0x1c ; STACK_CLEANUP
0445CA  C9                    LEAVE ; EPILOGUE
0445CB  C2 18 00              RET    0x18 ; RETURN
