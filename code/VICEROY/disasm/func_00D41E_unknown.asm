; ============================================================================
; func_00D41E_unknown
; Region   : load_image
; Bytes    : file 0x00D41E..0x00D43B  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D41E  C8 0E 01 00           ENTER  0x10e, 0 ; PROLOGUE
00D422  53                    PUSH   bx ; STACK_PUSH
00D423  52                    PUSH   dx ; STACK_PUSH
00D424  50                    PUSH   ax ; STACK_PUSH
00D425  57                    PUSH   di ; STACK_PUSH
00D426  56                    PUSH   si ; STACK_PUSH
00D427  8B FB                 MOV    di, bx ; MOV
00D429  2B C0                 SUB    ax, ax ; ARITH
00D42B  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
00D42E  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
00D431  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00D434  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00D437  8B C2                 MOV    ax, dx ; MOV
00D439  0B                    DB     0x0B ; DATA_BYTE
00D43A  86                    DB     0x86 ; DATA_BYTE
