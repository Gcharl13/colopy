; ============================================================================
; func_00F9C4_fclose_or_remove
; Region   : load_image
; Bytes    : file 0x00F9C4..0x00FA7E  (186 bytes)
; Purpose  : C runtime fclose() variant. Validates the FILE struct's flag byte at offset +6 (must have bit 0x83 set, must NOT have bit 0x40 set). Calls a library helper (LCALL 0xD1D:0x1896) and the buffer flush (CALL 0x10CA0), then translates the FILE* to its parallel-table entry at DGROUP:0x29B2[fd], reads a stored handle from there and calls the close-handle library (LCALL 0xD1D:0x1E7A). For temp files (entry 0x27E8 sentinel), calls an additional path that includes the unlink helper. Branches into the unlink wrapper at 0x01041A for the temp-file removal case.
; Args     : [bp+6] = FILE* (16-bit pointer to a stdio FILE struct in DGROUP)
; Returns  : AX = 0 on success; -1 on error.
; Callers  : TBD
; Callees  : 0xD1D:0x1896 (library helper), 0x10CA0 (buffer flush), 0xD1D:0x1E7A (low-level close), unlink at 0x1041A (for temp-file path), 0xD1D:0x07E4 (string copy/format helper)
; Verified : boundary verified by capstone scan: PUSH BP/MOV BP,SP at 0xF9C4; full body 186 bytes including the temp-file branch.
; Source   : manually identified — discovered as the unique caller of unlink in callgraph.json
; ============================================================================

00F9C4  55                    PUSH   bp ; STACK_PUSH
00F9C5  8B EC                 MOV    bp, sp ; MOV
00F9C7  83 EC 0E              SUB    sp, 0xe ; STACK_ALLOC
00F9CA  57                    PUSH   di ; STACK_PUSH
00F9CB  56                    PUSH   si ; STACK_PUSH
00F9CC  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
00F9CF  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00F9D2  F6 44 06 40           TEST   byte ptr [si + 6], 0x40 ; LOGIC
00F9D6  74 03                 JE     0xf9db ; CJUMP
00F9D8  E9 97 00              JMP    0xfa72 ; JUMP
00F9DB  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
00F9DF  75 03                 JNE    0xf9e4 ; CJUMP
00F9E1  E9 8E 00              JMP    0xfa72 ; JUMP
00F9E4  56                    PUSH   si ; STACK_PUSH
00F9E5  9A 96 18 1D 0D        LCALL  0xd1d, 0x1896 ; LCALL
00F9EA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00F9ED  8B F8                 MOV    di, ax ; MOV
00F9EF  8B DE                 MOV    bx, si ; MOV
00F9F1  81 EB 0E 29           SUB    bx, 0x290e ; ARITH
00F9F5  8B 87 B2 29           MOV    ax, word ptr [bx + 0x29b2] ; MOV
00F9F9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00F9FC  56                    PUSH   si ; STACK_PUSH
00F9FD  E8 A0 12              CALL   0x10ca0 ; CALL_NEAR
00FA00  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00FA03  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
00FA06  2A E4                 SUB    ah, ah ; ARITH
00FA08  50                    PUSH   ax ; STACK_PUSH
00FA09  9A 7A 1E 1D 0D        LCALL  0xd1d, 0x1e7a ; LCALL
00FA0E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00FA11  0B C0                 OR     ax, ax ; LOGIC
00FA13  7C 5A                 JL     0xfa6f ; CJUMP
00FA15  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
00FA19  74 57                 JE     0xfa72 ; CJUMP
00FA1B  B8 E8 27              MOV    ax, 0x27e8 ; CONST_LOAD
00FA1E  50                    PUSH   ax ; STACK_PUSH
00FA1F  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
00FA22  50                    PUSH   ax ; STACK_PUSH
00FA23  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
00FA28  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00FA2B  8D 46 F4              LEA    ax, [bp - 0xc] ; ADDR
00FA2E  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00FA31  80 7E F2 5C           CMP    byte ptr [bp - 0xe], 0x5c ; CMP
00FA35  74 13                 JE     0xfa4a ; CJUMP
00FA37  B8 EA 27              MOV    ax, 0x27ea ; CONST_LOAD
00FA3A  50                    PUSH   ax ; STACK_PUSH
00FA3B  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
00FA3E  50                    PUSH   ax ; STACK_PUSH
00FA3F  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
00FA44  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00FA47  EB 04                 JMP    0xfa4d ; JUMP
00FA49  90                    NOP ; NOP
00FA4A  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
00FA4D  B8 0A 00              MOV    ax, 0xa ; CONST_LOAD
00FA50  50                    PUSH   ax ; STACK_PUSH
00FA51  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00FA54  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00FA57  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
00FA5C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00FA5F  8D 46 F2              LEA    ax, [bp - 0xe] ; ADDR
00FA62  50                    PUSH   ax ; STACK_PUSH
00FA63  9A 4A 0E 1D 0D        LCALL  0xd1d, 0xe4a ; LCALL
00FA68  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00FA6B  0B C0                 OR     ax, ax ; LOGIC
00FA6D  74 03                 JE     0xfa72 ; CJUMP
00FA6F  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
00FA72  C6 44 06 00           MOV    byte ptr [si + 6], 0 ; MOV
00FA76  8B C7                 MOV    ax, di ; MOV
00FA78  5E                    POP    si ; STACK_POP
00FA79  5F                    POP    di ; STACK_POP
00FA7A  8B E5                 MOV    sp, bp ; MOV
00FA7C  5D                    POP    bp ; STACK_POP
00FA7D  CB                    RETF ; RETURN
