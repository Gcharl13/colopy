; ============================================================================
; func_032DAC_unknown
; Region   : overlay
; Bytes    : file 0x032DAC..0x032E32  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032DAC  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
032DB0  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
032DB5  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
032DB8  50                    PUSH   ax ; STACK_PUSH
032DB9  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
032DBC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
032DBF  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
032DC4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
032DC7  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
032DCA  50                    PUSH   ax ; STACK_PUSH
032DCB  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
032DCE  9A 96 0B 1F 18        LCALL  0x181f, 0xb96 ; THUNK -> 0x05EB:0x3208 (thunk @file 0x01B186 type B) overlay @file 0x02A1F8
032DD3  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
032DD6  0B C0                 OR     ax, ax ; LOGIC
032DD8  75 58                 JNE    0x32e32 ; CJUMP
032DDA  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
032DDD  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
032DE0  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
032DE5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
032DE8  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
032DEB  6A 01                 PUSH   1 ; STACK_PUSH
032DED  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
032DF2  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
032DF5  6A 04                 PUSH   4 ; STACK_PUSH
032DF7  0E                    PUSH   cs ; STACK_PUSH
032DF8  E8 59 3A              CALL   0x36854 ; CALL_NEAR
032DFB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
032DFE  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
032E01  D1 E3                 SHL    bx, 1 ; LOGIC
032E03  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
032E07  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
032E0C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
032E0F  9A 88 00 1F 18        LCALL  0x181f, 0x88 ; THUNK -> 0x0009:0x0222 (thunk @file 0x01A678 type B) overlay @file 0x0229EC
032E14  1E                    PUSH   ds ; STACK_PUSH
032E15  68 F1 0F              PUSH   0xff1 ; PUSH_CONST
032E18  9A 6A 00 1F 18        LCALL  0x181f, 0x6a ; THUNK -> 0x0009:0x017E (thunk @file 0x01A65A type B) overlay @file 0x022948
032E1D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
032E20  6A 00                 PUSH   0 ; STACK_PUSH
032E22  6A 78                 PUSH   0x78 ; PUSH_CONST
032E24  6A 03                 PUSH   3 ; STACK_PUSH
032E26  0E                    PUSH   cs ; STACK_PUSH
032E27  E8 16 3A              CALL   0x36840 ; CALL_NEAR
032E2A  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
032E2D  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
032E30  C9                    LEAVE ; EPILOGUE
032E31  CB                    RETF ; RETURN
