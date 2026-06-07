; ============================================================================
; func_075594_unknown
; Region   : overlay
; Bytes    : file 0x075594..0x0755CB  (55 bytes)
; Purpose  : VICEROY.EXE entry/control function  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "VICEROY"  (auto-named via string xrefs)
; ============================================================================

075594  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
075598  68 34 23              PUSH   0x2334                       ; STRING: "VICEROY"
07559B  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
07559E  50                    PUSH   ax ; STACK_PUSH
07559F  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
0755A4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0755A7  83 3E 98 53 03        CMP    word ptr [0x5398], 3 ; CMP
0755AC  75 0F                 JNE    0x755bd ; CJUMP
0755AE  6A 02                 PUSH   2 ; STACK_PUSH
0755B0  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
0755B3  16                    PUSH   ss ; STACK_PUSH
0755B4  50                    PUSH   ax ; STACK_PUSH
0755B5  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
0755BA  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0755BD  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
0755C0  50                    PUSH   ax ; STACK_PUSH
0755C1  6A 01                 PUSH   1 ; STACK_PUSH
0755C3  6A 01                 PUSH   1 ; STACK_PUSH
0755C5  0E                    PUSH   cs ; STACK_PUSH
0755C6  E8 A7 0D              CALL   0x76370 ; CALL_NEAR
0755C9  C9                    LEAVE ; EPILOGUE
0755CA  CB                    RETF ; RETURN
