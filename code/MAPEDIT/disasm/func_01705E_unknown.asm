; ============================================================================
; func_01705E_unknown
; Region   : load_image
; Bytes    : file 0x01705E..0x017077  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01705E  55                    PUSH   bp ; STACK_PUSH
01705F  8B EC                 MOV    bp, sp ; MOV
017061  56                    PUSH   si ; STACK_PUSH
017062  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
017065  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
017068  50                    PUSH   ax ; STACK_PUSH
017069  9A F2 23 88 13        LCALL  0x1388, 0x23f2 ; LCALL
01706E  59                    POP    cx ; STACK_POP
01706F  8B DE                 MOV    bx, si ; MOV
017071  81 EB C6 46           SUB    bx, 0x46c6 ; ARITH
017075  81                    DB     0x81 ; DATA_BYTE
017076  C3                    DB     0xC3 ; DATA_BYTE
