; ============================================================================
; func_011C1A_unknown
; Region   : load_image
; Bytes    : file 0x011C1A..0x011C2E  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011C1A  55                    PUSH   bp ; STACK_PUSH
011C1B  8B EC                 MOV    bp, sp ; MOV
011C1D  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
011C20  B4 08                 MOV    ah, 8 ; MOV
011C22  EC                    IN     al, dx ; IO
011C23  22 C4                 AND    al, ah ; LOGIC
011C25  75 FB                 JNE    0x11c22 ; CJUMP
011C27  EC                    IN     al, dx ; IO
011C28  22 C4                 AND    al, ah ; LOGIC
011C2A  74 FB                 JE     0x11c27 ; CJUMP
011C2C  C9                    LEAVE ; EPILOGUE
011C2D  CB                    RETF ; RETURN
