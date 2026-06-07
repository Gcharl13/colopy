; ============================================================================
; func_022542_unknown
; Region   : overlay
; Bytes    : file 0x022542..0x022584  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "NOCOLONIESEITHER"  (auto-named via string xrefs)
; ============================================================================

022542  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
022546  56                    PUSH   si ; STACK_PUSH
022547  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
02254A  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
02254D  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
022550  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
022554  2A E4                 SUB    ah, ah ; ARITH
022556  50                    PUSH   ax ; STACK_PUSH
022557  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
02255B  50                    PUSH   ax ; STACK_PUSH
02255C  9A BE 07 1F 18        LCALL  0x181f, 0x7be ; THUNK -> 0x05EB:0x0A76 (thunk @file 0x01ADAE type B) overlay @file 0x027A66
022561  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022564  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
022567  8B 46 E8              MOV    ax, word ptr [bp - 0x18] ; LOCAL_LOAD
02256A  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
02256D  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
022572  74 10                 JE     0x22584 ; CJUMP
022574  6A 01                 PUSH   1 ; STACK_PUSH
022576  68 8A 09              PUSH   0x98a                        ; STRING: "NOCOLONIESEITHER"
022579  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
02257E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
022581  5E                    POP    si ; STACK_POP
022582  C9                    LEAVE ; EPILOGUE
022583  CB                    RETF ; RETURN
