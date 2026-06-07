; ============================================================================
; func_06F8FA_unknown
; Region   : overlay
; Bytes    : file 0x06F8FA..0x06F986  (140 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F8FA  C8 A2 00 00           ENTER  0xa2, 0 ; PROLOGUE
06F8FE  57                    PUSH   di ; STACK_PUSH
06F8FF  56                    PUSH   si ; STACK_PUSH
06F900  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
06F903  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
06F908  2B FF                 SUB    di, di ; ARITH
06F90A  C6 46 AE 40           MOV    byte ptr [bp - 0x52], 0x40 ; LOCAL_STORE
06F90E  C6 46 AF 00           MOV    byte ptr [bp - 0x51], 0 ; LOCAL_STORE
06F912  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06F915  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06F918  50                    PUSH   ax ; STACK_PUSH
06F919  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
06F91E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06F921  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06F924  50                    PUSH   ax ; STACK_PUSH
06F925  9A 64 0D 1D 0D        LCALL  0xd1d, 0xd64 ; LCALL
06F92A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06F92D  0B F6                 OR     si, si ; LOGIC
06F92F  74 3D                 JE     0x6f96e ; CJUMP
06F931  0E                    PUSH   cs ; STACK_PUSH
06F932  E8 F3 01              CALL   0x6fb28 ; CALL_NEAR
06F935  56                    PUSH   si ; STACK_PUSH
06F936  8D 86 5E FF           LEA    ax, [bp - 0xa2] ; ADDR
06F93A  50                    PUSH   ax ; STACK_PUSH
06F93B  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06F940  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06F943  8D 86 5E FF           LEA    ax, [bp - 0xa2] ; ADDR
06F947  16                    PUSH   ss ; STACK_PUSH
06F948  50                    PUSH   ax ; STACK_PUSH
06F949  1E                    PUSH   ds ; STACK_PUSH
06F94A  68 16 20              PUSH   0x2016 ; PUSH_CONST
06F94D  9A 94 0A 1F 1A        LCALL  0x1a1f, 0xa94 ; THUNK -> 0x0B32:0x000E (thunk @file 0x01D084 type B) overlay @file 0x040608
06F952  8D 86 5E FF           LEA    ax, [bp - 0xa2] ; ADDR
06F956  16                    PUSH   ss ; STACK_PUSH
06F957  50                    PUSH   ax ; STACK_PUSH
06F958  8D 1E 1A 20           LEA    bx, [0x201a] ; ADDR
06F95C  9A 86 0E 1F 18        LCALL  0x181f, 0xe86 ; THUNK -> 0x09F6:0x00FA (thunk @file 0x01B476 type B) overlay @file 0x030D60
06F961  A3 14 20              MOV    word ptr [0x2014], ax ; GLOBAL_LOAD
06F964  0B C0                 OR     ax, ax ; LOGIC
06F966  75 09                 JNE    0x6f971 ; CJUMP
06F968  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
06F96B  EB 6B                 JMP    0x6f9d8 ; JUMP
06F96D  90                    NOP ; NOP
06F96E  BF 01 00              MOV    di, 1 ; MOV
06F971  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
06F975  74 5F                 JE     0x6f9d6 ; CJUMP
06F977  2B F6                 SUB    si, si ; ARITH
06F979  FF 36 14 20           PUSH   word ptr [0x2014] ; PUSH_GLOBAL
06F97D  6A 50                 PUSH   0x50 ; PUSH_CONST
06F97F  68 3C 83              PUSH   0x833c ; PUSH_CONST
06F982  9A                    DB     0x9A ; DATA_BYTE
06F983  CA                    DB     0xCA ; DATA_BYTE
06F984  09                    DB     0x09 ; DATA_BYTE
06F985  1D                    DB     0x1D ; DATA_BYTE
