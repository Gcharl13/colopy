; ============================================================================
; func_007936_unknown
; Region   : load_image
; Bytes    : file 0x007936..0x007966  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007936  55                    PUSH   bp ; STACK_PUSH
007937  8B EC                 MOV    bp, sp ; MOV
007939  57                    PUSH   di ; STACK_PUSH
00793A  56                    PUSH   si ; STACK_PUSH
00793B  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00793E  8B C6                 MOV    ax, si ; MOV
007940  0E                    PUSH   cs ; STACK_PUSH
007941  E8 2E ED              CALL   0x6672 ; CALL_NEAR
007944  8B F0                 MOV    si, ax ; MOV
007946  0B F6                 OR     si, si ; LOGIC
007948  7C 18                 JL     0x7962 ; CJUMP
00794A  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
00794D  8B C7                 MOV    ax, di ; MOV
00794F  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
007952  88 87 4C 31           MOV    byte ptr [bx + 0x314c], al ; MOV
007956  8B C6                 MOV    ax, si ; MOV
007958  0E                    PUSH   cs ; STACK_PUSH
007959  E8 5E ED              CALL   0x66ba ; CALL_NEAR
00795C  8B F0                 MOV    si, ax ; MOV
00795E  0B F6                 OR     si, si ; LOGIC
007960  7D EB                 JGE    0x794d ; CJUMP
007962  5E                    POP    si ; STACK_POP
007963  5F                    POP    di ; STACK_POP
007964  C9                    LEAVE ; EPILOGUE
007965  CB                    RETF ; RETURN
