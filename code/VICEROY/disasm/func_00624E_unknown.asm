; ============================================================================
; func_00624E_unknown
; Region   : load_image
; Bytes    : file 0x00624E..0x006256  (8 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00624E  55                    PUSH   bp ; STACK_PUSH
00624F  8B EC                 MOV    bp, sp ; MOV
006251  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
006254  F6                    DB     0xF6 ; DATA_BYTE
006255  C3                    DB     0xC3 ; DATA_BYTE
