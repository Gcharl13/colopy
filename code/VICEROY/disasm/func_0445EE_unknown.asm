; ============================================================================
; func_0445EE_unknown
; Region   : overlay
; Bytes    : file 0x0445EE..0x044644  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0445EE  C8 50 00 00           ENTER  0x50, 0 ; PROLOGUE
0445F2  56                    PUSH   si ; STACK_PUSH
0445F3  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0445F6  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0445F9  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0445FC  16                    PUSH   ss ; STACK_PUSH
0445FD  50                    PUSH   ax ; STACK_PUSH
0445FE  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
044603  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
044606  6A 7E                 PUSH   0x7e ; PUSH_CONST
044608  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
04460B  50                    PUSH   ax ; STACK_PUSH
04460C  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
044611  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
044614  8B F0                 MOV    si, ax ; MOV
044616  0B F6                 OR     si, si ; LOGIC
044618  74 0F                 JE     0x44629 ; CJUMP
04461A  8D 44 01              LEA    ax, [si + 1] ; ADDR
04461D  1E                    PUSH   ds ; STACK_PUSH
04461E  50                    PUSH   ax ; STACK_PUSH
04461F  1E                    PUSH   ds ; STACK_PUSH
044620  56                    PUSH   si ; STACK_PUSH
044621  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
044626  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
044629  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
04462C  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa] ; PUSH_GLOBAL
044630  26 FF 77 08           PUSH   word ptr es:[bx + 8] ; STACK_PUSH
044634  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
044637  16                    PUSH   ss ; STACK_PUSH
044638  50                    PUSH   ax ; STACK_PUSH
044639  26 8B 07              MOV    ax, word ptr es:[bx] ; MOV
04463C  9A 04 02 1F 18        LCALL  0x181f, 0x204 ; THUNK -> 0x0C2A:0x0006 (thunk @file 0x01A7F4 type B)
044641  5E                    POP    si ; STACK_POP
044642  C9                    LEAVE ; EPILOGUE
044643  CB                    RETF ; RETURN
