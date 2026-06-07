; ============================================================================
; func_06F0F4_unknown
; Region   : overlay
; Bytes    : file 0x06F0F4..0x06F144  (80 bytes)
; Purpose  : Dialog framework root (CHECKBOX/DEFAULT/LENGTH/OPTIONS/PROMPT/SMALLFONT/TEXT/WIDTH parser dispatcher)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

06F0F4  C8 68 01 00           ENTER  0x168, 0 ; PROLOGUE
06F0F8  52                    PUSH   dx ; STACK_PUSH
06F0F9  50                    PUSH   ax ; STACK_PUSH
06F0FA  53                    PUSH   bx ; STACK_PUSH
06F0FB  57                    PUSH   di ; STACK_PUSH
06F0FC  56                    PUSH   si ; STACK_PUSH
06F0FD  B9 01 00              MOV    cx, 1 ; MOV
06F100  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
06F103  89 8E 9E FE           MOV    word ptr [bp - 0x162], cx ; LOCAL_STORE
06F107  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
06F10C  2B C9                 SUB    cx, cx ; ARITH
06F10E  89 4E F6              MOV    word ptr [bp - 0xa], cx ; LOCAL_STORE
06F111  89 4E F4              MOV    word ptr [bp - 0xc], cx ; LOCAL_STORE
06F114  50                    PUSH   ax ; STACK_PUSH
06F115  68 78 24              PUSH   0x2478 ; PUSH_CONST
06F118  8B F0                 MOV    si, ax ; MOV
06F11A  8B FB                 MOV    di, bx ; MOV
06F11C  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06F121  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06F124  56                    PUSH   si ; STACK_PUSH
06F125  57                    PUSH   di ; STACK_PUSH
06F126  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
06F12B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06F12E  0B C0                 OR     ax, ax ; LOGIC
06F130  74 03                 JE     0x6f135 ; CJUMP
06F132  E9 C0 03              JMP    0x6f4f5 ; JUMP
06F135  FF 36 A0 1F           PUSH   word ptr [0x1fa0] ; PUSH_GLOBAL
06F139  FF 36 9E 1F           PUSH   word ptr [0x1f9e] ; PUSH_GLOBAL
06F13D  FF 36 A2 1F           PUSH   word ptr [0x1fa2] ; PUSH_GLOBAL
06F141  0E                    PUSH   cs ; STACK_PUSH
06F142  E8                    DB     0xE8 ; DATA_BYTE
06F143  C3                    DB     0xC3 ; DATA_BYTE
