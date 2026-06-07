; ============================================================================
; func_00A8F8_unknown
; Region   : load_image
; Bytes    : file 0x00A8F8..0x00A912  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A8F8  55                    PUSH   bp ; STACK_PUSH
00A8F9  8B EC                 MOV    bp, sp ; MOV
00A8FB  83 3E B4 3F 00        CMP    word ptr [0x3fb4], 0 ; CMP
00A900  74 08                 JE     0xa90a ; CJUMP
00A902  8B 16 B8 3F           MOV    dx, word ptr [0x3fb8] ; GLOBAL_LOAD
00A906  B4 45                 MOV    ah, 0x45 ; CONST_LOAD
00A908  CD 67                 INT    0x67 ; SYS
00A90A  C7 06 B4 3F 00 00     MOV    word ptr [0x3fb4], 0 ; GLOBAL_LOAD
00A910  C9                    LEAVE ; EPILOGUE
00A911  CB                    RETF ; RETURN
