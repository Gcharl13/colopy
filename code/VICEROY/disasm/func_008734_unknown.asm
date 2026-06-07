; ============================================================================
; func_008734_unknown
; Region   : load_image
; Bytes    : file 0x008734..0x008752  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008734  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
008738  0E                    PUSH   cs ; STACK_PUSH
008739  E8 E4 FF              CALL   0x8720 ; CALL_NEAR
00873C  48                    DEC    ax ; ARITH
00873D  74 09                 JE     0x8748 ; CJUMP
00873F  48                    DEC    ax ; ARITH
008740  74 10                 JE     0x8752 ; CJUMP
008742  48                    DEC    ax ; ARITH
008743  74 17                 JE     0x875c ; CJUMP
008745  EB 1F                 JMP    0x8766 ; JUMP
008747  90                    NOP ; NOP
008748  C7 46 FE 04 00        MOV    word ptr [bp - 2], 4 ; LOCAL_STORE
00874D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
008750  C9                    LEAVE ; EPILOGUE
008751  CB                    RETF ; RETURN
