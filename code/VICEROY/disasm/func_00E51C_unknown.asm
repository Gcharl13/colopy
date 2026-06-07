; ============================================================================
; func_00E51C_unknown
; Region   : load_image
; Bytes    : file 0x00E51C..0x00E534  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E51C  C8 66 00 00           ENTER  0x66, 0 ; PROLOGUE
00E520  52                    PUSH   dx ; STACK_PUSH
00E521  50                    PUSH   ax ; STACK_PUSH
00E522  53                    PUSH   bx ; STACK_PUSH
00E523  57                    PUSH   di ; STACK_PUSH
00E524  56                    PUSH   si ; STACK_PUSH
00E525  2B C0                 SUB    ax, ax ; ARITH
00E527  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
00E52A  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
00E52D  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
00E530  8B CA                 MOV    cx, dx ; MOV
00E532  A1                    DB     0xA1 ; DATA_BYTE
00E533  9E                    DB     0x9E ; DATA_BYTE
