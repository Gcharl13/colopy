; ============================================================================
; func_0393F4_unknown
; Region   : overlay
; Bytes    : file 0x0393F4..0x03954C  (344 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0393F4  C8 58 00 00           ENTER  0x58, 0 ; PROLOGUE
0393F8  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0393FB  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
039400  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
039403  6A 07                 PUSH   7 ; STACK_PUSH
039405  0E                    PUSH   cs ; STACK_PUSH
039406  E8 4A 0A              CALL   0x39e53 ; CALL_NEAR
039409  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03940C  68 90 00              PUSH   0x90 ; PUSH_CONST
03940F  6A 05                 PUSH   5 ; STACK_PUSH
039411  68 40 01              PUSH   0x140 ; PUSH_CONST
039414  6A 00                 PUSH   0 ; STACK_PUSH
039416  FF 36 22 2E           PUSH   word ptr [0x2e22] ; PUSH_GLOBAL
03941A  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
03941F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
039422  52                    PUSH   dx ; STACK_PUSH
039423  50                    PUSH   ax ; STACK_PUSH
039424  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
039429  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
03942C  C7 46 AC 19 00        MOV    word ptr [bp - 0x54], 0x19 ; LOCAL_STORE
039431  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
039435  FF 36 34 2E           PUSH   word ptr [0x2e34] ; PUSH_GLOBAL
039439  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
03943C  50                    PUSH   ax ; STACK_PUSH
03943D  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
039442  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
039445  68 92 00              PUSH   0x92 ; PUSH_CONST
039448  B8 1B 00              MOV    ax, 0x1b ; CONST_LOAD
03944B  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
03944E  50                    PUSH   ax ; STACK_PUSH
03944F  6A 50                 PUSH   0x50 ; PUSH_CONST
039451  B8 02 00              MOV    ax, 2 ; MOV
039454  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
039457  50                    PUSH   ax ; STACK_PUSH
039458  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
03945B  16                    PUSH   ss ; STACK_PUSH
03945C  50                    PUSH   ax ; STACK_PUSH
03945D  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
039462  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
039465  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
039469  FF 36 36 2E           PUSH   word ptr [0x2e36] ; PUSH_GLOBAL
03946D  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
039470  50                    PUSH   ax ; STACK_PUSH
039471  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
039476  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
039479  68 92 00              PUSH   0x92 ; PUSH_CONST
03947C  6A 1B                 PUSH   0x1b ; PUSH_CONST
03947E  6A 50                 PUSH   0x50 ; PUSH_CONST
039480  6A 52                 PUSH   0x52 ; PUSH_CONST
039482  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
039485  16                    PUSH   ss ; STACK_PUSH
039486  50                    PUSH   ax ; STACK_PUSH
039487  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
03948C  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
03948F  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
039493  FF 36 38 2E           PUSH   word ptr [0x2e38] ; PUSH_GLOBAL
039497  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
03949A  50                    PUSH   ax ; STACK_PUSH
03949B  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
0394A0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0394A3  68 92 00              PUSH   0x92 ; PUSH_CONST
0394A6  6A 1B                 PUSH   0x1b ; PUSH_CONST
0394A8  6A 50                 PUSH   0x50 ; PUSH_CONST
0394AA  68 A2 00              PUSH   0xa2 ; PUSH_CONST
0394AD  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0394B0  16                    PUSH   ss ; STACK_PUSH
0394B1  50                    PUSH   ax ; STACK_PUSH
0394B2  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
0394B7  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0394BA  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
0394BE  FF 36 3A 2E           PUSH   word ptr [0x2e3a] ; PUSH_GLOBAL
0394C2  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0394C5  50                    PUSH   ax ; STACK_PUSH
0394C6  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
0394CB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0394CE  68 92 00              PUSH   0x92 ; PUSH_CONST
0394D1  6A 1B                 PUSH   0x1b ; PUSH_CONST
0394D3  6A 4C                 PUSH   0x4c ; PUSH_CONST
0394D5  68 F2 00              PUSH   0xf2 ; PUSH_CONST
0394D8  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0394DB  16                    PUSH   ss ; STACK_PUSH
0394DC  50                    PUSH   ax ; STACK_PUSH
0394DD  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
0394E2  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0394E5  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1 ; LOCAL_STORE
0394EA  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0394EE  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0394F2  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0394F6  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0394FA  6A 77                 PUSH   0x77 ; PUSH_CONST
0394FC  6B 46 AA 50           IMUL   ax, word ptr [bp - 0x56], 0x50 ; ARITH
039500  03 46 AE              ADD    ax, word ptr [bp - 0x52] ; ARITH
039503  BA 19 00              MOV    dx, 0x19 ; CONST_LOAD
039506  BB B4 00              MOV    bx, 0xb4 ; CONST_LOAD
039509  9A B2 08 1F 19        LCALL  0x191f, 0x8b2 ; THUNK -> 0x0BC3:0x0006 (thunk @file 0x01BEA2 type B)
03950E  FF 46 AA              INC    word ptr [bp - 0x56] ; ARITH
039511  83 7E AA 03           CMP    word ptr [bp - 0x56], 3 ; CMP
039515  7E D3                 JLE    0x394ea ; CJUMP
039517  C7 46 AA 00 00        MOV    word ptr [bp - 0x56], 0 ; LOCAL_STORE
03951C  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
039520  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
039524  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
039528  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
03952C  6A 77                 PUSH   0x77 ; PUSH_CONST
03952E  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
039531  40                    INC    ax ; ARITH
039532  40                    INC    ax ; ARITH
039533  6B D8 14              IMUL   bx, ax, 0x14 ; ARITH
039536  B8 02 00              MOV    ax, 2 ; MOV
039539  BA 3A 01              MOV    dx, 0x13a ; CONST_LOAD
03953C  9A BC 08 1F 19        LCALL  0x191f, 0x8bc ; THUNK -> 0x0BBC:0x000C (thunk @file 0x01BEAC type B)
039541  FF 46 AA              INC    word ptr [bp - 0x56] ; ARITH
039544  83 7E AA 08           CMP    word ptr [bp - 0x56], 8 ; CMP
039548  7C D2                 JL     0x3951c ; CJUMP
03954A  C9                    LEAVE ; EPILOGUE
03954B  CB                    RETF ; RETURN
