; ============================================================================
; func_00679E_unknown
; Region   : load_image
; Bytes    : file 0x00679E..0x0067AE  (16 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00679E  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0067A2  52                    PUSH   dx ; STACK_PUSH
0067A3  57                    PUSH   di ; STACK_PUSH
0067A4  56                    PUSH   si ; STACK_PUSH
0067A5  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
0067A8  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
0067AB  0E                    PUSH   cs ; STACK_PUSH
0067AC  E8                    DB     0xE8 ; DATA_BYTE
0067AD  C3                    DB     0xC3 ; DATA_BYTE
