; ============================================================================
; func_01298A_unknown
; Region   : load_image
; Bytes    : file 0x01298A..0x0129A4  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01298A  55                    PUSH   bp ; STACK_PUSH
01298B  8B EC                 MOV    bp, sp ; MOV
01298D  83 3E 3A 44 00        CMP    word ptr [0x443a], 0 ; CMP
012992  74 08                 JE     0x1299c ; CJUMP
012994  8B 16 3E 44           MOV    dx, word ptr [0x443e] ; GLOBAL_LOAD
012998  B4 45                 MOV    ah, 0x45 ; CONST_LOAD
01299A  CD 67                 INT    0x67 ; SYS
01299C  C7 06 3A 44 00 00     MOV    word ptr [0x443a], 0 ; GLOBAL_LOAD
0129A2  C9                    LEAVE ; EPILOGUE
0129A3  CB                    RETF ; RETURN
