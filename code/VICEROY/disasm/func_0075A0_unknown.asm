; ============================================================================
; func_0075A0_unknown
; Region   : load_image
; Bytes    : file 0x0075A0..0x0075D3  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0075A0  55                    PUSH   bp ; STACK_PUSH
0075A1  8B EC                 MOV    bp, sp ; MOV
0075A3  57                    PUSH   di ; STACK_PUSH
0075A4  56                    PUSH   si ; STACK_PUSH
0075A5  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0075A8  8B C7                 MOV    ax, di ; MOV
0075AA  0E                    PUSH   cs ; STACK_PUSH
0075AB  E8 C4 F0              CALL   0x6672 ; CALL_NEAR
0075AE  8B F8                 MOV    di, ax ; MOV
0075B0  0B FF                 OR     di, di ; LOGIC
0075B2  7C 1B                 JL     0x75cf ; CJUMP
0075B4  8B C7                 MOV    ax, di ; MOV
0075B6  0E                    PUSH   cs ; STACK_PUSH
0075B7  E8 00 F1              CALL   0x66ba ; CALL_NEAR
0075BA  8B F0                 MOV    si, ax ; MOV
0075BC  57                    PUSH   di ; STACK_PUSH
0075BD  0E                    PUSH   cs ; STACK_PUSH
0075BE  E8 D3 F8              CALL   0x6e94 ; CALL_NEAR
0075C1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0075C4  3B FE                 CMP    di, si ; CMP
0075C6  7D 01                 JGE    0x75c9 ; CJUMP
0075C8  4E                    DEC    si ; ARITH
0075C9  8B FE                 MOV    di, si ; MOV
0075CB  0B FF                 OR     di, di ; LOGIC
0075CD  7D E5                 JGE    0x75b4 ; CJUMP
0075CF  5E                    POP    si ; STACK_POP
0075D0  5F                    POP    di ; STACK_POP
0075D1  C9                    LEAVE ; EPILOGUE
0075D2  CB                    RETF ; RETURN
