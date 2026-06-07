; ============================================================================
; func_00D700_unknown
; Region   : load_image
; Bytes    : file 0x00D700..0x00D72E  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D700  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00D704  57                    PUSH   di ; STACK_PUSH
00D705  56                    PUSH   si ; STACK_PUSH
00D706  8B F3                 MOV    si, bx ; MOV
00D708  8B F8                 MOV    di, ax ; MOV
00D70A  57                    PUSH   di ; STACK_PUSH
00D70B  AC                    LODSB  al, byte ptr [si] ; STR
00D70C  98                    CWDE ; ARITH
00D70D  50                    PUSH   ax ; STACK_PUSH
00D70E  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00D711  9A 58 07 1D 0D        LCALL  0xd1d, 0x758 ; LCALL
00D716  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00D719  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
00D71D  75 EB                 JNE    0xd70a ; CJUMP
00D71F  57                    PUSH   di ; STACK_PUSH
00D720  6A 1A                 PUSH   0x1a ; PUSH_CONST
00D722  9A 58 07 1D 0D        LCALL  0xd1d, 0x758 ; LCALL
00D727  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00D72A  5E                    POP    si ; STACK_POP
00D72B  5F                    POP    di ; STACK_POP
00D72C  C9                    LEAVE ; EPILOGUE
00D72D  CB                    RETF ; RETURN
