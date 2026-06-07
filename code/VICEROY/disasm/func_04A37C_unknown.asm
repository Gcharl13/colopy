; ============================================================================
; func_04A37C_unknown
; Region   : overlay
; Bytes    : file 0x04A37C..0x04A3C8  (76 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04A37C  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
04A380  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04A383  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04A387  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
04A38C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A38F  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
04A392  68 F4 01              PUSH   0x1f4 ; PUSH_CONST
04A395  2B C0                 SUB    ax, ax ; ARITH
04A397  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
04A39A  50                    PUSH   ax ; STACK_PUSH
04A39B  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
04A3A0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A3A3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
04A3A6  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
04A3A9  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
04A3AE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04A3B1  50                    PUSH   ax ; STACK_PUSH
04A3B2  6A 00                 PUSH   0 ; STACK_PUSH
04A3B4  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
04A3B9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A3BC  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
04A3BF  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
04A3C2  7F 22                 JG     0x4a3e6 ; CJUMP
04A3C4  6A 03                 PUSH   3 ; STACK_PUSH
04A3C6  68                    DB     0x68 ; DATA_BYTE
04A3C7  C3                    DB     0xC3 ; DATA_BYTE
