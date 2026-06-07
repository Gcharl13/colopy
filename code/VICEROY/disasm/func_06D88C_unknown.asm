; ============================================================================
; func_06D88C_unknown
; Region   : overlay
; Bytes    : file 0x06D88C..0x06D8C7  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06D88C  55                    PUSH   bp ; STACK_PUSH
06D88D  8B EC                 MOV    bp, sp ; MOV
06D88F  56                    PUSH   si ; STACK_PUSH
06D890  83 3E 6A 1F 00        CMP    word ptr [0x1f6a], 0 ; CMP
06D895  74 0A                 JE     0x6d8a1 ; CJUMP
06D897  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06D89A  26 F6 47 0A 20        TEST   byte ptr es:[bx + 0xa], 0x20 ; LOGIC
06D89F  75 21                 JNE    0x6d8c2 ; CJUMP
06D8A1  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06D8A4  26 FF 77 1A           PUSH   word ptr es:[bx + 0x1a] ; PUSH_GLOBAL
06D8A8  26 FF 77 1C           PUSH   word ptr es:[bx + 0x1c] ; PUSH_GLOBAL
06D8AC  26 FF 77 1E           PUSH   word ptr es:[bx + 0x1e] ; PUSH_GLOBAL
06D8B0  26 8B 47 18           MOV    ax, word ptr es:[bx + 0x18] ; MOV
06D8B4  8B D8                 MOV    bx, ax ; MOV
06D8B6  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
06D8B9  26 8B 54 1A           MOV    dx, word ptr es:[si + 0x1a] ; MOV
06D8BD  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
06D8C2  5E                    POP    si ; STACK_POP
06D8C3  C9                    LEAVE ; EPILOGUE
06D8C4  C2 04 00              RET    4 ; RETURN
