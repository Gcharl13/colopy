; ============================================================================
; func_066CD6_unknown
; Region   : overlay
; Bytes    : file 0x066CD6..0x066D7A  (164 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066CD6  55                    PUSH   bp ; STACK_PUSH
066CD7  8B EC                 MOV    bp, sp ; MOV
066CD9  0E                    PUSH   cs ; STACK_PUSH
066CDA  E8 15 01              CALL   0x66df2 ; CALL_NEAR
066CDD  83 3E 2C 08 00        CMP    word ptr [0x82c], 0 ; CMP
066CE2  75 24                 JNE    0x66d08 ; CJUMP
066CE4  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
066CE8  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
066CEC  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
066CF0  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
066CF4  6A 29                 PUSH   0x29 ; PUSH_CONST
066CF6  6A 00                 PUSH   0 ; STACK_PUSH
066CF8  B8 F1 00              MOV    ax, 0xf1 ; CONST_LOAD
066CFB  BA 08 00              MOV    dx, 8 ; MOV
066CFE  BB 4F 00              MOV    bx, 0x4f ; CONST_LOAD
066D01  9A BA 00 1F 18        LCALL  0x181f, 0xba ; THUNK -> 0x0B9E:0x000A (thunk @file 0x01A6AA type B)
066D06  EB 33                 JMP    0x66d3b ; JUMP
066D08  6A 00                 PUSH   0 ; STACK_PUSH
066D0A  6A 00                 PUSH   0 ; STACK_PUSH
066D0C  6A 29                 PUSH   0x29 ; PUSH_CONST
066D0E  6A 4F                 PUSH   0x4f ; PUSH_CONST
066D10  6A 08                 PUSH   8 ; STACK_PUSH
066D12  68 F1 00              PUSH   0xf1 ; PUSH_CONST
066D15  8B 1E 2C 08           MOV    bx, word ptr [0x82c] ; GLOBAL_LOAD
066D19  FF 77 06              PUSH   word ptr [bx + 6] ; STACK_PUSH
066D1C  FF 77 04              PUSH   word ptr [bx + 4] ; STACK_PUSH
066D1F  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
066D22  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
066D24  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
066D28  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
066D2C  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
066D30  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
066D34  9A C4 00 1F 18        LCALL  0x181f, 0xc4 ; THUNK -> 0x0BF5:0x0000 (thunk @file 0x01A6B4 type B)
066D39  8B E5                 MOV    sp, bp ; MOV
066D3B  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
066D3F  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
066D43  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
066D47  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
066D4B  6A 30                 PUSH   0x30 ; PUSH_CONST
066D4D  6A 06                 PUSH   6 ; STACK_PUSH
066D4F  B8 FB 00              MOV    ax, 0xfb ; CONST_LOAD
066D52  BA 08 00              MOV    dx, 8 ; MOV
066D55  BB 34 01              MOV    bx, 0x134 ; CONST_LOAD
066D58  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
066D5D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
066D60  0E                    PUSH   cs ; STACK_PUSH
066D61  E8 A2 00              CALL   0x66e06 ; CALL_NEAR
066D64  8B E5                 MOV    sp, bp ; MOV
066D66  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
066D6A  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
066D6E  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
066D72  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
066D76  A1 CA 9C              MOV    ax, word ptr [0x9cca] ; GLOBAL_LOAD
066D79  05                    DB     0x05 ; DATA_BYTE
