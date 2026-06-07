; ============================================================================
; func_00D030_unknown
; Region   : load_image
; Bytes    : file 0x00D030..0x00D060  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D030  55                    PUSH   bp ; STACK_PUSH
00D031  8B EC                 MOV    bp, sp ; MOV
00D033  57                    PUSH   di ; STACK_PUSH
00D034  56                    PUSH   si ; STACK_PUSH
00D035  8B 36 16 07           MOV    si, word ptr [0x716] ; GLOBAL_LOAD
00D039  83 FE 78              CMP    si, 0x78 ; CMP
00D03C  75 22                 JNE    0xd060 ; CJUMP
00D03E  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00D041  99                    CDQ ; ARITH
00D042  52                    PUSH   dx ; STACK_PUSH
00D043  50                    PUSH   ax ; STACK_PUSH
00D044  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00D047  99                    CDQ ; ARITH
00D048  52                    PUSH   dx ; STACK_PUSH
00D049  50                    PUSH   ax ; STACK_PUSH
00D04A  B8 BC FF              MOV    ax, 0xffbc ; CONST_LOAD
00D04D  BA 02 00              MOV    dx, 2 ; MOV
00D050  BB 1C 00              MOV    bx, 0x1c ; CONST_LOAD
00D053  9A D6 03 D0 0E        LCALL  0xed0, 0x3d6 ; LCALL
00D058  2B C0                 SUB    ax, ax ; ARITH
00D05A  5E                    POP    si ; STACK_POP
00D05B  5F                    POP    di ; STACK_POP
00D05C  C9                    LEAVE ; EPILOGUE
00D05D  CA 08 00              RETF   8 ; RETURN
