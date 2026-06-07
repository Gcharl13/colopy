; ============================================================================
; func_031BB0_unknown
; Region   : overlay
; Bytes    : file 0x031BB0..0x031BE6  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031BB0  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
031BB4  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
031BB7  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
031BBC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031BBF  52                    PUSH   dx ; STACK_PUSH
031BC0  50                    PUSH   ax ; STACK_PUSH
031BC1  9A 14 01 1F 18        LCALL  0x181f, 0x114 ; THUNK -> 0x004B:0x0216 (thunk @file 0x01A704 type B) overlay @file 0x0605BE
031BC6  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
031BC9  89 07                 MOV    word ptr [bx], ax ; MOV
031BCB  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
031BCF  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
031BD2  2A E4                 SUB    ah, ah ; ARITH
031BD4  48                    DEC    ax ; ARITH
031BD5  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
031BD8  C7 07 25 00           MOV    word ptr [bx], 0x25 ; CONST_LOAD
031BDC  05 04 00              ADD    ax, 4 ; ARITH
031BDF  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
031BE2  89 07                 MOV    word ptr [bx], ax ; MOV
031BE4  C9                    LEAVE ; EPILOGUE
031BE5  C3                    RET ; RETURN
