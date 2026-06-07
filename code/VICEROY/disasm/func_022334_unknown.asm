; ============================================================================
; func_022334_unknown
; Region   : overlay
; Bytes    : file 0x022334..0x022389  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "NOROAD"  (auto-named via string xrefs)
; ============================================================================

022334  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
022338  2B C0                 SUB    ax, ax ; ARITH
02233A  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02233D  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
022340  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
022343  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
022346  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
022349  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
02234D  2A E4                 SUB    ah, ah ; ARITH
02234F  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
022352  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
022356  2A ED                 SUB    ch, ch ; ARITH
022358  89 4E F0              MOV    word ptr [bp - 0x10], cx ; LOCAL_STORE
02235B  51                    PUSH   cx ; STACK_PUSH
02235C  50                    PUSH   ax ; STACK_PUSH
02235D  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
022362  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022365  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
022368  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
02236B  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
02236E  9A 54 07 1F 18        LCALL  0x181f, 0x754 ; THUNK -> 0x037F:0x0142 (thunk @file 0x01AD44 type B) overlay @file 0x02EC7E
022373  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022376  A8 0A                 TEST   al, 0xa ; LOGIC
022378  74 10                 JE     0x2238a ; CJUMP
02237A  6A 03                 PUSH   3 ; STACK_PUSH
02237C  68 5D 09              PUSH   0x95d                        ; STRING: "NOROAD"
02237F  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
022384  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022387  C9                    LEAVE ; EPILOGUE
022388  CB                    RETF ; RETURN
