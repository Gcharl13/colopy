; ============================================================================
; func_0783E4_unknown
; Region   : overlay
; Bytes    : file 0x0783E4..0x078422  (62 bytes)
; Purpose  : CYCLE.DAT color-cycling animation loader  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "CYCLE.DAT"  (auto-named via string xrefs)
; ============================================================================

0783E4  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0783E8  C7 06 9E 92 00 00     MOV    word ptr [0x929e], 0 ; GLOBAL_LOAD
0783EE  1E                    PUSH   ds ; STACK_PUSH
0783EF  68 F9 25              PUSH   0x25f9                       ; STRING: "CYCLE.DAT"
0783F2  8D 1E F6 25           LEA    bx, [0x25f6] ; ADDR
0783F6  9A 86 0E 1F 18        LCALL  0x181f, 0xe86 ; THUNK -> 0x09F6:0x00FA (thunk @file 0x01B476 type B) overlay @file 0x030D60
0783FB  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0783FE  0B C0                 OR     ax, ax ; LOGIC
078400  74 10                 JE     0x78412 ; CJUMP
078402  50                    PUSH   ax ; STACK_PUSH
078403  6A 01                 PUSH   1 ; STACK_PUSH
078405  6A 22                 PUSH   0x22 ; PUSH_CONST
078407  68 9E 92              PUSH   0x929e ; PUSH_CONST
07840A  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
07840F  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
078412  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
078416  74 08                 JE     0x78420 ; CJUMP
078418  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
07841B  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
078420  C9                    LEAVE ; EPILOGUE
078421  CB                    RETF ; RETURN
