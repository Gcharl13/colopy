; ============================================================================
; func_005296_unknown
; Region   : load_image
; Bytes    : file 0x005296..0x0052AC  (22 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005296  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00529A  57                    PUSH   di ; STACK_PUSH
00529B  56                    PUSH   si ; STACK_PUSH
00529C  C6 46 FE 02           MOV    byte ptr [bp - 2], 2 ; LOCAL_STORE
0052A0  C6 46 FC 07           MOV    byte ptr [bp - 4], 7 ; LOCAL_STORE
0052A4  51                    PUSH   cx ; STACK_PUSH
0052A5  52                    PUSH   dx ; STACK_PUSH
0052A6  8B D6                 MOV    dx, si ; MOV
0052A8  8A F2                 MOV    dh, dl ; MOV
0052AA  8B CF                 MOV    cx, di ; MOV
