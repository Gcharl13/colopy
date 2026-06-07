; ============================================================================
; func_057A3A_unknown
; Region   : overlay
; Bytes    : file 0x057A3A..0x057AA1  (103 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "GREAT"  (auto-named via string xrefs)
; ============================================================================

057A3A  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
057A3E  68 7E 18              PUSH   0x187e                       ; STRING: "GREAT"
057A41  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
057A44  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
057A47  50                    PUSH   ax ; STACK_PUSH
057A48  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
057A4D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057A50  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
057A53  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
057A56  50                    PUSH   ax ; STACK_PUSH
057A57  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
057A5C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057A5F  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
057A62  50                    PUSH   ax ; STACK_PUSH
057A63  68 7C 08              PUSH   0x87c ; PUSH_CONST
057A66  9A 28 09 1F 19        LCALL  0x191f, 0x928 ; THUNK -> 0x0000:0x001A (thunk @file 0x01BF18 type A) overlay @file 0x02591A
057A6B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
057A6E  0B C0                 OR     ax, ax ; LOGIC
057A70  75 19                 JNE    0x57a8b ; CJUMP
057A72  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
057A75  EB 0C                 JMP    0x57a83 ; JUMP
057A77  90                    NOP ; NOP
057A78  9A 1C 09 1F 19        LCALL  0x191f, 0x91c ; THUNK -> 0x0000:0x0106 (thunk @file 0x01BF0C type A) overlay @file 0x025A06
057A7D  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
057A80  FF 46 AE              INC    word ptr [bp - 0x52] ; ARITH
057A83  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
057A86  39 46 AE              CMP    word ptr [bp - 0x52], ax ; CMP
057A89  7E ED                 JLE    0x57a78 ; CJUMP
057A8B  1E                    PUSH   ds ; STACK_PUSH
057A8C  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
057A8F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
057A92  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
057A97  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
057A9A  9A B8 0F 1F 19        LCALL  0x191f, 0xfb8 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01C5A8 type A) overlay @file 0x025900
057A9F  C9                    LEAVE ; EPILOGUE
057AA0  CB                    RETF ; RETURN
