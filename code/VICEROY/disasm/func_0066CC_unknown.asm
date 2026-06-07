; ============================================================================
; func_0066CC_unknown
; Region   : load_image
; Bytes    : file 0x0066CC..0x006705  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0066CC  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0066D0  52                    PUSH   dx ; STACK_PUSH
0066D1  50                    PUSH   ax ; STACK_PUSH
0066D2  57                    PUSH   di ; STACK_PUSH
0066D3  56                    PUSH   si ; STACK_PUSH
0066D4  8B FA                 MOV    di, dx ; MOV
0066D6  8B F0                 MOV    si, ax ; MOV
0066D8  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
0066DD  57                    PUSH   di ; STACK_PUSH
0066DE  56                    PUSH   si ; STACK_PUSH
0066DF  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
0066E4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0066E7  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0066EA  0B C0                 OR     ax, ax ; LOGIC
0066EC  74 18                 JE     0x6706 ; CJUMP
0066EE  57                    PUSH   di ; STACK_PUSH
0066EF  56                    PUSH   si ; STACK_PUSH
0066F0  9A 14 03 7F 03        LCALL  0x37f, 0x314 ; LCALL
0066F5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0066F8  0B C0                 OR     ax, ax ; LOGIC
0066FA  7D 0A                 JGE    0x6706 ; CJUMP
0066FC  8B 7E FC              MOV    di, word ptr [bp - 4] ; LOCAL_LOAD
0066FF  8B C7                 MOV    ax, di ; MOV
006701  5E                    POP    si ; STACK_POP
006702  5F                    POP    di ; STACK_POP
006703  C9                    LEAVE ; EPILOGUE
006704  CB                    RETF ; RETURN
