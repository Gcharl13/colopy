; ============================================================================
; func_02853C_unknown
; Region   : overlay
; Bytes    : file 0x02853C..0x028591  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "BUILD"  (auto-named via string xrefs)
; ============================================================================

02853C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
028540  6A 2D                 PUSH   0x2d ; PUSH_CONST
028542  6A 11                 PUSH   0x11 ; PUSH_CONST
028544  68 84 00              PUSH   0x84                         ; STRING: "BUILD"
028547  68 2F 01              PUSH   0x12f ; PUSH_CONST
02854A  0E                    PUSH   cs ; STACK_PUSH
02854B  E8 75 45              CALL   0x2cac3 ; CALL_NEAR
02854E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
028551  83 3E 98 0B 00        CMP    word ptr [0xb98], 0 ; CMP
028556  75 1D                 JNE    0x28575 ; CJUMP
028558  6A 44                 PUSH   0x44 ; PUSH_CONST
02855A  6A 03                 PUSH   3 ; STACK_PUSH
02855C  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
028560  74 06                 JE     0x28568 ; CJUMP
028562  A0 39 03              MOV    al, byte ptr [0x339] ; GLOBAL_LOAD
028565  EB 04                 JMP    0x2856b ; JUMP
028567  90                    NOP ; NOP
028568  A0 37 03              MOV    al, byte ptr [0x337] ; GLOBAL_LOAD
02856B  2A E4                 SUB    ah, ah ; ARITH
02856D  50                    PUSH   ax ; STACK_PUSH
02856E  0E                    PUSH   cs ; STACK_PUSH
02856F  E8 07 44              CALL   0x2c979 ; CALL_NEAR
028572  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
028575  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
028579  74 14                 JE     0x2858f ; CJUMP
02857B  68 84 00              PUSH   0x84                         ; STRING: "BUILD"
02857E  6A 11                 PUSH   0x11 ; PUSH_CONST
028580  6A 2D                 PUSH   0x2d ; PUSH_CONST
028582  B8 2F 01              MOV    ax, 0x12f ; CONST_LOAD
028585  BA 84 00              MOV    dx, 0x84 ; CONST_LOAD
028588  8B D8                 MOV    bx, ax ; MOV
02858A  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
02858F  C9                    LEAVE ; EPILOGUE
028590  CB                    RETF ; RETURN
