; ============================================================================
; func_043074_unknown
; Region   : overlay
; Bytes    : file 0x043074..0x0430C9  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043074  C8 C0 00 00           ENTER  0xc0, 0 ; PROLOGUE
043078  57                    PUSH   di ; STACK_PUSH
043079  56                    PUSH   si ; STACK_PUSH
04307A  0E                    PUSH   cs ; STACK_PUSH
04307B  E8 5B 13              CALL   0x443d9 ; CALL_NEAR
04307E  6A 00                 PUSH   0 ; STACK_PUSH
043080  A1 40 85              MOV    ax, word ptr [0x8540] ; GLOBAL_LOAD
043083  8B 16 3E 85           MOV    dx, word ptr [0x853e] ; GLOBAL_LOAD
043087  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
04308C  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
04308F  50                    PUSH   ax ; STACK_PUSH
043090  9A EA 07 1F 18        LCALL  0x181f, 0x7ea ; THUNK -> 0x0427:0x04D6 (thunk @file 0x01ADDA type B) overlay @file 0x0311EA
043095  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
043098  8B 46 98              MOV    ax, word ptr [bp - 0x68] ; LOCAL_LOAD
04309B  9A EE 02 1F 18        LCALL  0x181f, 0x2ee ; THUNK -> 0x0427:0x0002 (thunk @file 0x01A8DE type B) overlay @file 0x030D16
0430A0  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
0430A3  83 3E 96 53 04        CMP    word ptr [0x5396], 4 ; CMP
0430A8  7D 26                 JGE    0x430d0 ; CJUMP
0430AA  FF 36 3E 85           PUSH   word ptr [0x853e] ; PUSH_GLOBAL
0430AE  FF 36 40 85           PUSH   word ptr [0x8540] ; PUSH_GLOBAL
0430B2  9A 4A 07 1F 18        LCALL  0x181f, 0x74a ; THUNK -> 0x037F:0x02F8 (thunk @file 0x01AD3A type B) overlay @file 0x02EE34
0430B7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0430BA  2A E4                 SUB    ah, ah ; ARITH
0430BC  8A 0E 96 53           MOV    cl, byte ptr [0x5396] ; GLOBAL_LOAD
0430C0  BA 10 00              MOV    dx, 0x10 ; CONST_LOAD
0430C3  D3 E2                 SHL    dx, cl ; LOGIC
0430C5  85 C2                 TEST   dx, ax ; LOGIC
0430C7  75 07                 JNE    0x430d0 ; CJUMP
