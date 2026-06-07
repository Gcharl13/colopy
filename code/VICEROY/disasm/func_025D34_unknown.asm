; ============================================================================
; func_025D34_unknown
; Region   : overlay
; Bytes    : file 0x025D34..0x025D5A  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025D34  C8 38 00 00           ENTER  0x38, 0 ; PROLOGUE
025D38  57                    PUSH   di ; STACK_PUSH
025D39  56                    PUSH   si ; STACK_PUSH
025D3A  9A 62 0D 1F 18        LCALL  0x181f, 0xd62 ; THUNK -> 0x05EB:0x1476 (thunk @file 0x01B352 type B) overlay @file 0x028466
025D3F  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0 ; LOCAL_STORE
025D44  B0 FF                 MOV    al, 0xff ; CONST_LOAD
025D46  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
025D49  88 87 92 8E           MOV    byte ptr [bx - 0x716e], al ; MOV
025D4D  88 87 82 8E           MOV    byte ptr [bx - 0x717e], al ; MOV
025D51  8B F3                 MOV    si, bx ; MOV
025D53  D1 E6                 SHL    si, 1 ; LOGIC
025D55  C7 42 CA FF FF        MOV    word ptr [bp + si - 0x36], 0xffff ; LOCAL_STORE
