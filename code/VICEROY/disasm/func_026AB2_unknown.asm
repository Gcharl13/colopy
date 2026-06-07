; ============================================================================
; func_026AB2_unknown
; Region   : overlay
; Bytes    : file 0x026AB2..0x026B1F  (109 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026AB2  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
026AB6  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
026ABB  C7 46 F4 03 00        MOV    word ptr [bp - 0xc], 3 ; LOCAL_STORE
026AC0  8D 46 06              LEA    ax, [bp + 6] ; ADDR
026AC3  50                    PUSH   ax ; STACK_PUSH
026AC4  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
026AC7  A0 4B 02              MOV    al, byte ptr [0x24b] ; GLOBAL_LOAD
026ACA  98                    CWDE ; ARITH
026ACB  50                    PUSH   ax ; STACK_PUSH
026ACC  50                    PUSH   ax ; STACK_PUSH
026ACD  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
026AD0  50                    PUSH   ax ; STACK_PUSH
026AD1  8D 46 F0              LEA    ax, [bp - 0x10] ; ADDR
026AD4  50                    PUSH   ax ; STACK_PUSH
026AD5  6A 02                 PUSH   2 ; STACK_PUSH
026AD7  B8 67 00              MOV    ax, 0x67 ; CONST_LOAD
026ADA  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
026ADD  8B DA                 MOV    bx, dx ; MOV
026ADF  9A 40 02 1F 18        LCALL  0x181f, 0x240 ; THUNK -> 0x0097:0x0004 (thunk @file 0x01A830 type B) overlay @file 0x0270D0
026AE4  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
026AE7  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
026AEB  8A 07                 MOV    al, byte ptr [bx] ; MOV
026AED  2A E4                 SUB    ah, ah ; ARITH
026AEF  8A 57 01              MOV    dl, byte ptr [bx + 1] ; MOV
026AF2  2A F6                 SUB    dh, dh ; ARITH
026AF4  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
026AF9  EB 60                 JMP    0x26b5b ; JUMP
026AFB  90                    NOP ; NOP
026AFC  A1 7C 8D              MOV    ax, word ptr [0x8d7c] ; GLOBAL_LOAD
026AFF  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
026B02  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
026B05  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
026B08  75 43                 JNE    0x26b4d ; CJUMP
026B0A  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
026B0E  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
026B12  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
026B16  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
026B1A  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
026B1D  8B C3                 MOV    ax, bx ; MOV
