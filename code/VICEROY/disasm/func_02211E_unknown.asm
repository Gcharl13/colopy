; ============================================================================
; func_02211E_unknown
; Region   : overlay
; Bytes    : file 0x02211E..0x022184  (102 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "NOPLOW"  (auto-named via string xrefs)
; ============================================================================

02211E  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
022122  2B C0                 SUB    ax, ax ; ARITH
022124  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
022127  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
02212A  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
02212D  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
022130  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
022133  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
022137  2A E4                 SUB    ah, ah ; ARITH
022139  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
02213C  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
022140  2A ED                 SUB    ch, ch ; ARITH
022142  89 4E F0              MOV    word ptr [bp - 0x10], cx ; LOCAL_STORE
022145  51                    PUSH   cx ; STACK_PUSH
022146  50                    PUSH   ax ; STACK_PUSH
022147  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
02214C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02214F  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
022152  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
022155  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
022158  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
02215D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022160  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
022163  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
022166  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
022169  9A 54 07 1F 18        LCALL  0x181f, 0x754 ; THUNK -> 0x037F:0x0142 (thunk @file 0x01AD44 type B) overlay @file 0x02EC7E
02216E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022171  A8 40                 TEST   al, 0x40 ; LOGIC
022173  74 0F                 JE     0x22184 ; CJUMP
022175  6A 03                 PUSH   3 ; STACK_PUSH
022177  68 3D 09              PUSH   0x93d                        ; STRING: "NOPLOW"
02217A  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
02217F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022182  C9                    LEAVE ; EPILOGUE
022183  CB                    RETF ; RETURN
