; ============================================================================
; func_02B046_unknown
; Region   : overlay
; Bytes    : file 0x02B046..0x02B07E  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B046  C8 60 00 00           ENTER  0x60, 0 ; PROLOGUE
02B04A  56                    PUSH   si ; STACK_PUSH
02B04B  2B C0                 SUB    ax, ax ; ARITH
02B04D  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
02B050  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
02B053  A1 78 8D              MOV    ax, word ptr [0x8d78] ; GLOBAL_LOAD
02B056  8B 16 7A 8D           MOV    dx, word ptr [0x8d7a] ; GLOBAL_LOAD
02B05A  9A 2A 09 1F 18        LCALL  0x181f, 0x92a ; THUNK -> 0x0427:0x0180 (thunk @file 0x01AF1A type B) overlay @file 0x030E94
02B05F  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
02B062  0B C0                 OR     ax, ax ; LOGIC
02B064  7D 03                 JGE    0x2b069 ; CJUMP
02B066  E9 21 02              JMP    0x2b28a ; JUMP
02B069  9A 66 09 1F 18        LCALL  0x181f, 0x966 ; THUNK -> 0x0427:0x1330 (thunk @file 0x01AF56 type B) overlay @file 0x032044
02B06E  0B C0                 OR     ax, ax ; LOGIC
02B070  74 06                 JE     0x2b078 ; CJUMP
02B072  8B 46 A0              MOV    ax, word ptr [bp - 0x60] ; LOCAL_LOAD
02B075  A3 92 53              MOV    word ptr [0x5392], ax ; GLOBAL_LOAD
02B078  6B 5E A0 1C           IMUL   bx, word ptr [bp - 0x60], 0x1c ; ARITH
02B07C  8B C3                 MOV    ax, bx ; MOV
