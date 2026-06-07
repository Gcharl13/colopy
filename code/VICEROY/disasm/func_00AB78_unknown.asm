; ============================================================================
; func_00AB78_unknown
; Region   : load_image
; Bytes    : file 0x00AB78..0x00AB95  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00AB78  C8 42 00 00           ENTER  0x42, 0 ; PROLOGUE
00AB7C  56                    PUSH   si ; STACK_PUSH
00AB7D  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1 ; LOCAL_STORE
00AB82  2B C0                 SUB    ax, ax ; ARITH
00AB84  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
00AB87  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
00AB8A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00AB8E  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
00AB91  2A E4                 SUB    ah, ah ; ARITH
00AB93  89                    DB     0x89 ; DATA_BYTE
00AB94  46                    DB     0x46 ; DATA_BYTE
