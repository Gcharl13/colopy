; ============================================================================
; func_03240C_unknown
; Region   : overlay
; Bytes    : file 0x03240C..0x03245C  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03240C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
032410  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
032413  0E                    PUSH   cs ; STACK_PUSH
032414  E8 79 44              CALL   0x36890 ; CALL_NEAR
032417  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03241A  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
03241D  83 F9 64              CMP    cx, 0x64 ; CMP
032420  7E 03                 JLE    0x32425 ; CJUMP
032422  B9 64 00              MOV    cx, 0x64 ; CONST_LOAD
032425  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
032428  F7 E9                 IMUL   cx ; ARITH
03242A  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03242D  99                    CDQ ; ARITH
03242E  52                    PUSH   dx ; STACK_PUSH
03242F  50                    PUSH   ax ; STACK_PUSH
032430  FF 36 12 9E           PUSH   word ptr [0x9e12] ; PUSH_GLOBAL
032434  9A F6 0A 1F 18        LCALL  0x181f, 0xaf6 ; THUNK -> 0x05EB:0x0596 (thunk @file 0x01B0E6 type B) overlay @file 0x027586
032439  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
03243C  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
03243F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
032442  0E                    PUSH   cs ; STACK_PUSH
032443  E8 3B 44              CALL   0x36881 ; CALL_NEAR
032446  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
032449  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
03244C  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
03244F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
032452  9A 58 0D 1F 18        LCALL  0x181f, 0xd58 ; THUNK -> 0x05EB:0x30B8 (thunk @file 0x01B348 type B) overlay @file 0x02A0A8
032457  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
03245A  C9                    LEAVE ; EPILOGUE
03245B  CB                    RETF ; RETURN
