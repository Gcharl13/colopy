; ============================================================================
; func_029B84_unknown
; Region   : overlay
; Bytes    : file 0x029B84..0x029BBD  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029B84  55                    PUSH   bp ; STACK_PUSH
029B85  8B EC                 MOV    bp, sp ; MOV
029B87  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
029B8B  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
029B8F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
029B92  9A 74 0A 1F 18        LCALL  0x181f, 0xa74 ; THUNK -> 0x05EB:0x0F1C (thunk @file 0x01B064 type B) overlay @file 0x027F0C
029B97  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
029B9A  BA 01 00              MOV    dx, 1 ; MOV
029B9D  9A F8 08 1F 19        LCALL  0x191f, 0x8f8 ; THUNK -> 0x0B78:0x0000 (thunk @file 0x01BEE8 type B)
029BA2  C7 06 44 03 01 00     MOV    word ptr [0x344], 1 ; GLOBAL_LOAD
029BA8  C7 06 54 8D 06 00     MOV    word ptr [0x8d54], 6 ; GLOBAL_LOAD
029BAE  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
029BB1  A3 7C 8D              MOV    word ptr [0x8d7c], ax ; GLOBAL_LOAD
029BB4  A3 7E 8D              MOV    word ptr [0x8d7e], ax ; GLOBAL_LOAD
029BB7  0E                    PUSH   cs ; STACK_PUSH
029BB8  E8 BD 2E              CALL   0x2ca78 ; CALL_NEAR
029BBB  C9                    LEAVE ; EPILOGUE
029BBC  CB                    RETF ; RETURN
