; ============================================================================
; func_0775EC_unknown
; Region   : overlay
; Bytes    : file 0x0775EC..0x077609  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0775EC  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
0775F0  53                    PUSH   bx ; STACK_PUSH
0775F1  52                    PUSH   dx ; STACK_PUSH
0775F2  50                    PUSH   ax ; STACK_PUSH
0775F3  57                    PUSH   di ; STACK_PUSH
0775F4  56                    PUSH   si ; STACK_PUSH
0775F5  8B FB                 MOV    di, bx ; MOV
0775F7  2B C0                 SUB    ax, ax ; ARITH
0775F9  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
0775FC  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
0775FF  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
077602  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
077605  8B C2                 MOV    ax, dx ; MOV
077607  0B                    DB     0x0B ; DATA_BYTE
077608  46                    DB     0x46 ; DATA_BYTE
