; ============================================================================
; func_041E7E_unknown
; Region   : overlay
; Bytes    : file 0x041E7E..0x041EEA  (108 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041E7E  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
041E82  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
041E87  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
041E8B  74 10                 JE     0x41e9d ; CJUMP
041E8D  A1 94 53              MOV    ax, word ptr [0x5394] ; GLOBAL_LOAD
041E90  2D 20 00              SUB    ax, 0x20 ; ARITH
041E93  8B D0                 MOV    dx, ax ; MOV
041E95  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
041E9A  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
041E9D  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
041EA1  7C 3F                 JL     0x41ee2 ; CJUMP
041EA3  6B 5E FC 1C           IMUL   bx, word ptr [bp - 4], 0x1c ; ARITH
041EA7  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
041EAC  72 24                 JB     0x41ed2 ; CJUMP
041EAE  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
041EB3  77 1D                 JA     0x41ed2 ; CJUMP
041EB5  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
041EB8  9A 20 09 1F 18        LCALL  0x181f, 0x920 ; THUNK -> 0x0427:0x10BE (thunk @file 0x01AF10 type B) overlay @file 0x031DD2
041EBD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
041EC0  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
041EC3  0E                    PUSH   cs ; STACK_PUSH
041EC4  E8 59 02              CALL   0x42120 ; CALL_NEAR
041EC7  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
041ECA  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
041ECF  EB 11                 JMP    0x41ee2 ; JUMP
041ED1  90                    NOP ; NOP
041ED2  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
041ED5  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
041EDA  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
041EDD  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
041EE2  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
041EE6  7D 9F                 JGE    0x41e87 ; CJUMP
041EE8  C9                    LEAVE ; EPILOGUE
041EE9  CB                    RETF ; RETURN
