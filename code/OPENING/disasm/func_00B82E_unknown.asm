; ============================================================================
; func_00B82E_unknown
; Region   : load_image
; Bytes    : file 0x00B82E..0x00B848  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B82E  55                    PUSH   bp ; STACK_PUSH
00B82F  8B EC                 MOV    bp, sp ; MOV
00B831  83 3E 0A 42 00        CMP    word ptr [0x420a], 0 ; CMP
00B836  74 08                 JE     0xb840 ; CJUMP
00B838  8B 16 0E 42           MOV    dx, word ptr [0x420e] ; GLOBAL_LOAD
00B83C  B4 45                 MOV    ah, 0x45 ; CONST_LOAD
00B83E  CD 67                 INT    0x67 ; SYS
00B840  C7 06 0A 42 00 00     MOV    word ptr [0x420a], 0 ; GLOBAL_LOAD
00B846  C9                    LEAVE ; EPILOGUE
00B847  CB                    RETF ; RETURN
