; ============================================================================
; func_075FB6_unknown
; Region   : overlay
; Bytes    : file 0x075FB6..0x0760D6  (288 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

075FB6  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
075FBA  C7 46 F8 13 00        MOV    word ptr [bp - 8], 0x13 ; LOCAL_STORE
075FBF  9A 40 0E 1F 1A        LCALL  0x1a1f, 0xe40 ; THUNK -> 0x0000:0x006A (thunk @file 0x01D430 type A) overlay @file 0x02596A
075FC4  9A B8 0E 1F 18        LCALL  0x181f, 0xeb8 ; THUNK -> 0x0A29:0x015B (thunk @file 0x01B4A8 type B) overlay @file 0x030C68
075FC9  9A 5E 0E 1F 18        LCALL  0x181f, 0xe5e ; THUNK -> 0x09EF:0x0004 (thunk @file 0x01B44E type B) overlay @file 0x027D84
075FCE  A3 A6 83              MOV    word ptr [0x83a6], ax ; GLOBAL_LOAD
075FD1  9A 68 0E 1F 18        LCALL  0x181f, 0xe68 ; THUNK -> 0x09EF:0x0008 (thunk @file 0x01B458 type B) overlay @file 0x027D88
075FD6  9A 5E 0E 1F 18        LCALL  0x181f, 0xe5e ; THUNK -> 0x09EF:0x0004 (thunk @file 0x01B44E type B) overlay @file 0x027D84
075FDB  A3 7A 91              MOV    word ptr [0x917a], ax ; GLOBAL_LOAD
075FDE  9A 68 0E 1F 18        LCALL  0x181f, 0xe68 ; THUNK -> 0x09EF:0x0008 (thunk @file 0x01B458 type B) overlay @file 0x027D88
075FE3  9A 5E 0E 1F 18        LCALL  0x181f, 0xe5e ; THUNK -> 0x09EF:0x0004 (thunk @file 0x01B44E type B) overlay @file 0x027D84
075FE8  A3 A8 83              MOV    word ptr [0x83a8], ax ; GLOBAL_LOAD
075FEB  9A 68 0E 1F 18        LCALL  0x181f, 0xe68 ; THUNK -> 0x09EF:0x0008 (thunk @file 0x01B458 type B) overlay @file 0x027D88
075FF0  9A 72 0E 1F 18        LCALL  0x181f, 0xe72 ; THUNK -> 0x0C0C:0x0012 (thunk @file 0x01B462 type B)
075FF5  A3 80 8D              MOV    word ptr [0x8d80], ax ; GLOBAL_LOAD
075FF8  89 16 82 8D           MOV    word ptr [0x8d82], dx ; GLOBAL_LOAD
075FFC  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
075FFF  9A 36 0E 1F 1A        LCALL  0x1a1f, 0xe36 ; THUNK -> 0x0B8B:0x0004 (thunk @file 0x01D426 type B)
076004  80 3E 2A 08 00        CMP    byte ptr [0x82a], 0 ; CMP
076009  75 1B                 JNE    0x76026 ; CJUMP
07600B  83 7E F8 03           CMP    word ptr [bp - 8], 3 ; CMP
07600F  74 05                 JE     0x76016 ; CJUMP
076011  B8 01 00              MOV    ax, 1 ; MOV
076014  EB 02                 JMP    0x76018 ; JUMP
076016  2B C0                 SUB    ax, ax ; ARITH
076018  50                    PUSH   ax ; STACK_PUSH
076019  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
07601C  9A D6 0E 1F 18        LCALL  0x181f, 0xed6 ; THUNK -> 0x0D11:0x0000 (thunk @file 0x01B4C6 type B)
076021  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
076024  EB 06                 JMP    0x7602c ; JUMP
076026  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
076029  A3 AA 83              MOV    word ptr [0x83aa], ax ; GLOBAL_LOAD
07602C  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
07602F  6A 01                 PUSH   1 ; STACK_PUSH
076031  9A C4 05 1F 18        LCALL  0x181f, 0x5c4 ; THUNK -> 0x0A58:0x008C (thunk @file 0x01ABB4 type B)
076036  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
076039  68 00 A0              PUSH   0xa000 ; PUSH_CONST
07603C  68 00 FC              PUSH   0xfc00 ; PUSH_CONST
07603F  8D 1E 7D 23           LEA    bx, [0x237d] ; ADDR
076043  9A 28 0E 1F 1A        LCALL  0x1a1f, 0xe28 ; THUNK -> 0x0000:0x000E (thunk @file 0x01D418 type A) overlay @file 0x02590E
076048  0B C0                 OR     ax, ax ; LOGIC
07604A  74 0A                 JE     0x76056 ; CJUMP
07604C  C7 06 22 08 13 00     MOV    word ptr [0x822], 0x13 ; GLOBAL_LOAD
076052  E9 E0 02              JMP    0x76335 ; JUMP
076055  90                    NOP ; NOP
076056  8D 1E 30 83           LEA    bx, [0x8330] ; ADDR
07605A  B8 20 00              MOV    ax, 0x20 ; CONST_LOAD
07605D  8B D0                 MOV    dx, ax ; MOV
07605F  9A 02 0E 1F 1A        LCALL  0x1a1f, 0xe02 ; THUNK -> 0x0000:0x0002 (thunk @file 0x01D3F2 type A) overlay @file 0x025902
076064  A1 36 83              MOV    ax, word ptr [0x8336] ; GLOBAL_LOAD
076067  0B 06 34 83           OR     ax, word ptr [0x8334] ; LOGIC
07606B  75 09                 JNE    0x76076 ; CJUMP
07606D  C7 06 22 08 14 00     MOV    word ptr [0x822], 0x14 ; GLOBAL_LOAD
076073  E9 BF 02              JMP    0x76335 ; JUMP
076076  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
07607A  B8 40 01              MOV    ax, 0x140 ; CONST_LOAD
07607D  BA C8 00              MOV    dx, 0xc8 ; CONST_LOAD
076080  9A 02 0E 1F 1A        LCALL  0x1a1f, 0xe02 ; THUNK -> 0x0000:0x0002 (thunk @file 0x01D3F2 type A) overlay @file 0x025902
076085  A1 AE 2D              MOV    ax, word ptr [0x2dae] ; GLOBAL_LOAD
076088  0B 06 AC 2D           OR     ax, word ptr [0x2dac] ; LOGIC
07608C  74 DF                 JE     0x7606d ; CJUMP
07608E  8D 1E 9E 83           LEA    bx, [0x839e] ; ADDR
076092  B8 40 01              MOV    ax, 0x140 ; CONST_LOAD
076095  BA C8 00              MOV    dx, 0xc8 ; CONST_LOAD
076098  9A 02 0E 1F 1A        LCALL  0x1a1f, 0xe02 ; THUNK -> 0x0000:0x0002 (thunk @file 0x01D3F2 type A) overlay @file 0x025902
07609D  A1 A4 83              MOV    ax, word ptr [0x83a4] ; GLOBAL_LOAD
0760A0  0B 06 A2 83           OR     ax, word ptr [0x83a2] ; LOGIC
0760A4  74 C7                 JE     0x7606d ; CJUMP
0760A6  9A 1E 0E 1F 1A        LCALL  0x1a1f, 0xe1e ; THUNK -> 0x0B70:0x0002 (thunk @file 0x01D40E type B) overlay @file 0x027954
0760AB  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0760AF  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0760B3  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0760B7  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0760BB  2A C0                 SUB    al, al ; ARITH
0760BD  9A 84 04 1F 18        LCALL  0x181f, 0x484 ; THUNK -> 0x0B8D:0x0004 (thunk @file 0x01AA74 type B)
0760C2  8D 1E 89 23           LEA    bx, [0x2389] ; ADDR
0760C6  9A 86 0A 1F 1A        LCALL  0x1a1f, 0xa86 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01D076 type A) overlay @file 0x025900
0760CB  A3 8A 26              MOV    word ptr [0x268a], ax ; GLOBAL_LOAD
0760CE  89 16 8C 26           MOV    word ptr [0x268c], dx ; GLOBAL_LOAD
0760D2  8B C2                 MOV    ax, dx ; MOV
0760D4  0B                    DB     0x0B ; DATA_BYTE
0760D5  06                    DB     0x06 ; DATA_BYTE
