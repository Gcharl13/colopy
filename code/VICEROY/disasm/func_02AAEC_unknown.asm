; ============================================================================
; func_02AAEC_unknown
; Region   : overlay
; Bytes    : file 0x02AAEC..0x02AB2B  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AAEC  C8 64 00 00           ENTER  0x64, 0 ; PROLOGUE
02AAF0  57                    PUSH   di ; STACK_PUSH
02AAF1  56                    PUSH   si ; STACK_PUSH
02AAF2  2B C0                 SUB    ax, ax ; ARITH
02AAF4  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
02AAF7  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
02AAFA  FF 36 3E 03           PUSH   word ptr [0x33e] ; PUSH_GLOBAL
02AAFE  9A 32 0B 1F 18        LCALL  0x181f, 0xb32 ; THUNK -> 0x05EB:0x2F8E (thunk @file 0x01B122 type B) overlay @file 0x029F7E
02AB03  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02AB06  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
02AB09  0B C0                 OR     ax, ax ; LOGIC
02AB0B  7D 03                 JGE    0x2ab10 ; CJUMP
02AB0D  E9 67 02              JMP    0x2ad77 ; JUMP
02AB10  9A 66 09 1F 18        LCALL  0x181f, 0x966 ; THUNK -> 0x0427:0x1330 (thunk @file 0x01AF56 type B) overlay @file 0x032044
02AB15  0B C0                 OR     ax, ax ; LOGIC
02AB17  74 06                 JE     0x2ab1f ; CJUMP
02AB19  8B 46 A0              MOV    ax, word ptr [bp - 0x60] ; LOCAL_LOAD
02AB1C  A3 92 53              MOV    word ptr [0x5392], ax ; GLOBAL_LOAD
02AB1F  6B 5E A0 1C           IMUL   bx, word ptr [bp - 0x60], 0x1c ; ARITH
02AB23  8D 87 46 31           LEA    ax, [bx + 0x3146] ; ADDR
02AB27  8B F0                 MOV    si, ax ; MOV
02AB29  8B CB                 MOV    cx, bx ; MOV
