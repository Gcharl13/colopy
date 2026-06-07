; ============================================================================
; func_00A548_unknown
; Region   : load_image
; Bytes    : file 0x00A548..0x00A593  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A548  55                    PUSH   bp ; STACK_PUSH
00A549  8B EC                 MOV    bp, sp ; MOV
00A54B  57                    PUSH   di ; STACK_PUSH
00A54C  56                    PUSH   si ; STACK_PUSH
00A54D  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
00A550  0B F6                 OR     si, si ; LOGIC
00A552  7C 0E                 JL     0xa562 ; CJUMP
00A554  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00A557  8B DE                 MOV    bx, si ; MOV
00A559  C1 E3 04              SHL    bx, 4 ; LOGIC
00A55C  FF B7 E6 4E           PUSH   word ptr [bx + 0x4ee6] ; PUSH_GLOBAL
00A560  EB 07                 JMP    0xa569 ; JUMP
00A562  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00A565  FF 36 8A 52           PUSH   word ptr [0x528a] ; PUSH_GLOBAL
00A569  57                    PUSH   di ; STACK_PUSH
00A56A  0E                    PUSH   cs ; STACK_PUSH
00A56B  E8 44 FC              CALL   0xa1b2 ; CALL_NEAR
00A56E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00A571  83 FE 08              CMP    si, 8 ; CMP
00A574  7C 19                 JL     0xa58f ; CJUMP
00A576  83 FE 18              CMP    si, 0x18 ; CMP
00A579  7D 14                 JGE    0xa58f ; CJUMP
00A57B  57                    PUSH   di ; STACK_PUSH
00A57C  0E                    PUSH   cs ; STACK_PUSH
00A57D  E8 50 FB              CALL   0xa0d0 ; CALL_NEAR
00A580  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00A583  FF 36 5A 4B           PUSH   word ptr [0x4b5a] ; PUSH_GLOBAL
00A587  57                    PUSH   di ; STACK_PUSH
00A588  0E                    PUSH   cs ; STACK_PUSH
00A589  E8 26 FC              CALL   0xa1b2 ; CALL_NEAR
00A58C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00A58F  5E                    POP    si ; STACK_POP
00A590  5F                    POP    di ; STACK_POP
00A591  C9                    LEAVE ; EPILOGUE
00A592  CB                    RETF ; RETURN
