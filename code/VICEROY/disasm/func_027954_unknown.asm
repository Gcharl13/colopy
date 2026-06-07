; ============================================================================
; func_027954_unknown
; Region   : overlay
; Bytes    : file 0x027954..0x02798C  (56 bytes)
; Purpose  : popup_finalizer (overlay 0x0B70:0x0002)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

027954  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
027958  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02795B  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
027960  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
027963  52                    PUSH   dx ; STACK_PUSH
027964  50                    PUSH   ax ; STACK_PUSH
027965  9A 14 01 1F 18        LCALL  0x181f, 0x114 ; THUNK -> 0x004B:0x0216 (thunk @file 0x01A704 type B) overlay @file 0x0605BE
02796A  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02796D  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
027971  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
027974  2A E4                 SUB    ah, ah ; ARITH
027976  48                    DEC    ax ; ARITH
027977  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
02797A  83 C1 06              ADD    cx, 6 ; ARITH
02797D  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
027980  89 0F                 MOV    word ptr [bx], cx ; MOV
027982  05 04 00              ADD    ax, 4 ; ARITH
027985  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
027988  89 07                 MOV    word ptr [bx], ax ; MOV
02798A  C9                    LEAVE ; EPILOGUE
02798B  CB                    RETF ; RETURN
