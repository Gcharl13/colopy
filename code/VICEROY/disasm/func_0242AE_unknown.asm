; ============================================================================
; func_0242AE_unknown
; Region   : overlay
; Bytes    : file 0x0242AE..0x024310  (98 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0242AE  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0242B2  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0242B7  83 3E E8 07 00        CMP    word ptr [0x7e8], 0 ; CMP
0242BC  7C 21                 JL     0x242df ; CJUMP
0242BE  83 3E EA 07 08        CMP    word ptr [0x7ea], 8 ; CMP
0242C3  7C 1A                 JL     0x242df ; CJUMP
0242C5  A1 50 85              MOV    ax, word ptr [0x8550] ; GLOBAL_LOAD
0242C8  39 06 E8 07           CMP    word ptr [0x7e8], ax ; CMP
0242CC  7D 11                 JGE    0x242df ; CJUMP
0242CE  A1 52 85              MOV    ax, word ptr [0x8552] ; GLOBAL_LOAD
0242D1  05 08 00              ADD    ax, 8 ; ARITH
0242D4  3B 06 EA 07           CMP    ax, word ptr [0x7ea] ; CMP
0242D8  7E 05                 JLE    0x242df ; CJUMP
0242DA  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0242DF  81 3E E8 07 FC 00     CMP    word ptr [0x7e8], 0xfc ; CMP
0242E5  7C 1B                 JL     0x24302 ; CJUMP
0242E7  83 3E EA 07 09        CMP    word ptr [0x7ea], 9 ; CMP
0242EC  7C 14                 JL     0x24302 ; CJUMP
0242EE  81 3E E8 07 34 01     CMP    word ptr [0x7e8], 0x134 ; CMP
0242F4  7D 0C                 JGE    0x24302 ; CJUMP
0242F6  83 3E EA 07 30        CMP    word ptr [0x7ea], 0x30 ; CMP
0242FB  7D 05                 JGE    0x24302 ; CJUMP
0242FD  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2 ; LOCAL_STORE
024302  68 96 00              PUSH   0x96 ; PUSH_CONST
024305  6A 4F                 PUSH   0x4f ; PUSH_CONST
024307  6A 32                 PUSH   0x32 ; PUSH_CONST
024309  68 F1 00              PUSH   0xf1 ; PUSH_CONST
02430C  9A                    DB     0x9A ; DATA_BYTE
02430D  CA                    DB     0xCA ; DATA_BYTE
02430E  03                    DB     0x03 ; DATA_BYTE
02430F  1F                    DB     0x1F ; DATA_BYTE
