; ============================================================================
; func_002D28_unknown
; Region   : load_image
; Bytes    : file 0x002D28..0x002D73  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002D28  55                    PUSH   bp ; STACK_PUSH
002D29  8B EC                 MOV    bp, sp ; MOV
002D2B  57                    PUSH   di ; STACK_PUSH
002D2C  56                    PUSH   si ; STACK_PUSH
002D2D  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
002D30  0B F6                 OR     si, si ; LOGIC
002D32  7C 0E                 JL     0x2d42 ; CJUMP
002D34  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
002D37  8B DE                 MOV    bx, si ; MOV
002D39  C1 E3 04              SHL    bx, 4 ; LOGIC
002D3C  FF B7 74 2F           PUSH   word ptr [bx + 0x2f74] ; PUSH_GLOBAL
002D40  EB 07                 JMP    0x2d49 ; JUMP
002D42  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
002D45  FF 36 0A 2E           PUSH   word ptr [0x2e0a] ; PUSH_GLOBAL
002D49  57                    PUSH   di ; STACK_PUSH
002D4A  0E                    PUSH   cs ; STACK_PUSH
002D4B  E8 44 FC              CALL   0x2992 ; CALL_NEAR
002D4E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
002D51  83 FE 08              CMP    si, 8 ; CMP
002D54  7C 19                 JL     0x2d6f ; CJUMP
002D56  83 FE 18              CMP    si, 0x18 ; CMP
002D59  7D 14                 JGE    0x2d6f ; CJUMP
002D5B  57                    PUSH   di ; STACK_PUSH
002D5C  0E                    PUSH   cs ; STACK_PUSH
002D5D  E8 50 FB              CALL   0x28b0 ; CALL_NEAR
002D60  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
002D63  FF 36 B0 2D           PUSH   word ptr [0x2db0] ; PUSH_GLOBAL
002D67  57                    PUSH   di ; STACK_PUSH
002D68  0E                    PUSH   cs ; STACK_PUSH
002D69  E8 26 FC              CALL   0x2992 ; CALL_NEAR
002D6C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
002D6F  5E                    POP    si ; STACK_POP
002D70  5F                    POP    di ; STACK_POP
002D71  C9                    LEAVE ; EPILOGUE
002D72  CB                    RETF ; RETURN
