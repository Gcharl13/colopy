; ============================================================================
; func_006A7C_unknown
; Region   : load_image
; Bytes    : file 0x006A7C..0x006AAE  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006A7C  55                    PUSH   bp ; STACK_PUSH
006A7D  8B EC                 MOV    bp, sp ; MOV
006A7F  57                    PUSH   di ; STACK_PUSH
006A80  56                    PUSH   si ; STACK_PUSH
006A81  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
006A84  0E                    PUSH   cs ; STACK_PUSH
006A85  E8 EA FB              CALL   0x6672 ; CALL_NEAR
006A88  8B F0                 MOV    si, ax ; MOV
006A8A  0B F6                 OR     si, si ; LOGIC
006A8C  7C 1C                 JL     0x6aaa ; CJUMP
006A8E  8B C6                 MOV    ax, si ; MOV
006A90  0E                    PUSH   cs ; STACK_PUSH
006A91  E8 26 FC              CALL   0x66ba ; CALL_NEAR
006A94  8B F8                 MOV    di, ax ; MOV
006A96  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
006A99  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
006A9C  56                    PUSH   si ; STACK_PUSH
006A9D  0E                    PUSH   cs ; STACK_PUSH
006A9E  E8 31 FF              CALL   0x69d2 ; CALL_NEAR
006AA1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
006AA4  8B F7                 MOV    si, di ; MOV
006AA6  0B F6                 OR     si, si ; LOGIC
006AA8  7D E4                 JGE    0x6a8e ; CJUMP
006AAA  5E                    POP    si ; STACK_POP
006AAB  5F                    POP    di ; STACK_POP
006AAC  C9                    LEAVE ; EPILOGUE
006AAD  CB                    RETF ; RETURN
