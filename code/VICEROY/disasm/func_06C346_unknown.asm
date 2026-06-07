; ============================================================================
; func_06C346_unknown
; Region   : overlay
; Bytes    : file 0x06C346..0x06C387  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C346  55                    PUSH   bp ; STACK_PUSH
06C347  8B EC                 MOV    bp, sp ; MOV
06C349  0B C0                 OR     ax, ax ; LOGIC
06C34B  74 0D                 JE     0x6c35a ; CJUMP
06C34D  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06C350  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa] ; PUSH_GLOBAL
06C354  26 8B 57 04           MOV    dx, word ptr es:[bx + 4] ; MOV
06C358  EB 1D                 JMP    0x6c377 ; JUMP
06C35A  0B D2                 OR     dx, dx ; LOGIC
06C35C  74 0E                 JE     0x6c36c ; CJUMP
06C35E  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06C361  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa] ; PUSH_GLOBAL
06C365  26 8B 57 06           MOV    dx, word ptr es:[bx + 6] ; MOV
06C369  EB 0C                 JMP    0x6c377 ; JUMP
06C36B  90                    NOP ; NOP
06C36C  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06C36F  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa] ; PUSH_GLOBAL
06C373  26 8B 57 02           MOV    dx, word ptr es:[bx + 2] ; MOV
06C377  26 8B 5F 08           MOV    bx, word ptr es:[bx + 8] ; MOV
06C37B  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
06C37E  9A F0 01 1F 18        LCALL  0x181f, 0x1f0 ; THUNK -> 0x0C28:0x000A (thunk @file 0x01A7E0 type B)
06C383  C9                    LEAVE ; EPILOGUE
06C384  C2 04 00              RET    4 ; RETURN
