; ============================================================================
; func_06B02A_unknown
; Region   : overlay
; Bytes    : file 0x06B02A..0x06B0D4  (170 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B02A  C8 62 00 00           ENTER  0x62, 0 ; PROLOGUE
06B02E  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
06B032  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
06B036  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
06B03A  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
06B03E  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06B042  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06B046  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06B04A  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06B04E  68 B9 00              PUSH   0xb9 ; PUSH_CONST
06B051  2B C0                 SUB    ax, ax ; ARITH
06B053  BA 0F 00              MOV    dx, 0xf ; CONST_LOAD
06B056  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
06B059  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
06B05E  6B 06 AC A5 18        IMUL   ax, word ptr [0xa5ac], 0x18 ; ARITH
06B063  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
06B066  EB 37                 JMP    0x6b09f ; JUMP
06B068  A0 30 08              MOV    al, byte ptr [0x830] ; GLOBAL_LOAD
06B06B  2A E4                 SUB    ah, ah ; ARITH
06B06D  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
06B070  50                    PUSH   ax ; STACK_PUSH
06B071  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
06B074  8B 56 A0              MOV    dx, word ptr [bp - 0x60] ; LOCAL_LOAD
06B077  8B DA                 MOV    bx, dx ; MOV
06B079  9A F0 01 1F 18        LCALL  0x181f, 0x1f0 ; THUNK -> 0x0C28:0x000A (thunk @file 0x01A7E0 type B)
06B07E  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
06B082  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
06B086  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06B089  16                    PUSH   ss ; STACK_PUSH
06B08A  50                    PUSH   ax ; STACK_PUSH
06B08B  6A 00                 PUSH   0 ; STACK_PUSH
06B08D  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
06B091  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
06B094  8B 56 A6              MOV    dx, word ptr [bp - 0x5a] ; LOCAL_LOAD
06B097  9A FA 01 1F 18        LCALL  0x181f, 0x1fa ; THUNK -> 0x0C11:0x000C (thunk @file 0x01A7EA type B)
06B09C  FF 46 A8              INC    word ptr [bp - 0x58] ; ARITH
06B09F  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
06B0A2  39 06 AA A5           CMP    word ptr [0xa5aa], ax ; CMP
06B0A6  7F 03                 JG     0x6b0ab ; CJUMP
06B0A8  E9 D9 00              JMP    0x6b184 ; JUMP
06B0AB  8B 0E AC A5           MOV    cx, word ptr [0xa5ac] ; GLOBAL_LOAD
06B0AF  83 C1 03              ADD    cx, 3 ; ARITH
06B0B2  6B C9 18              IMUL   cx, cx, 0x18 ; ARITH
06B0B5  3B C8                 CMP    cx, ax ; CMP
06B0B7  7F 03                 JG     0x6b0bc ; CJUMP
06B0B9  E9 C8 00              JMP    0x6b184 ; JUMP
06B0BC  8D 4E AA              LEA    cx, [bp - 0x56] ; ADDR
06B0BF  51                    PUSH   cx ; STACK_PUSH
06B0C0  8D 4E AE              LEA    cx, [bp - 0x52] ; ADDR
06B0C3  51                    PUSH   cx ; STACK_PUSH
06B0C4  50                    PUSH   ax ; STACK_PUSH
06B0C5  0E                    PUSH   cs ; STACK_PUSH
06B0C6  E8 E2 05              CALL   0x6b6ab ; CALL_NEAR
06B0C9  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06B0CC  83 7E AE 00           CMP    word ptr [bp - 0x52], 0 ; CMP
06B0D0  7C CA                 JL     0x6b09c ; CJUMP
06B0D2  8D                    DB     0x8D ; DATA_BYTE
06B0D3  46                    DB     0x46 ; DATA_BYTE
