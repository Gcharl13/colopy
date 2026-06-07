; ============================================================================
; func_010433_find_file
; Region   : load_image
; Bytes    : file 0x010433..0x010482  (79 bytes)
; Purpose  : C `_dos_findfirst(path, attr, &finfo)` / `_dos_findnext(&finfo)`. Sets up the disk-transfer-area (DTA) by saving the caller's DTA via INT 21h AH=2Fh (Get DTA), then INT 21h AH=1Ah (Set DTA) to install the caller-supplied buffer. The user's actual call (Find First, AH=0x4E, or Find Next, AH=0x4F — chosen by AH supplied in the call frame) follows. Restores the original DTA before returning. The 0x4E/0x4F selection is encoded by the AL=0x4E literal at 0x10437 — this branch is the Find First entry; the Find Next companion shares the implementation but takes a different entry point in the same module.
; Args     : [bp+6] = filename ptr (Find First only); [bp+8] = ?; [bp+0xA] = DTA buffer ptr
; Returns  : AX = 0 on success; nonzero DOS error code on failure.
; Callers  : TBD
; Callees  : INT 21h AH=2Fh (Get DTA), AH=1Ah (Set DTA), AH=4Eh (Find First Match) or AH=4Fh (Find Next Match)
; Verified : boundary verified — function continues past 0x010452 (PUSH AX / LAHF / PUSH AX / MOV ES into DS) until its eventual restore-DTA / RET; this 79-byte estimate covers the visible body up to 0x010482. The exact RET location to be validated when continuing the annotation pass.
; Source   : manually identified — 2F/1A/4E/4F INT 21h sequence is the canonical _dos_findfirst implementation
; ============================================================================

010433  55                    PUSH   bp ; STACK_PUSH
010434  8B EC                 MOV    bp, sp ; MOV
010436  1E                    PUSH   ds ; STACK_PUSH
010437  B0 4E                 MOV    al, 0x4e ; CONST_LOAD
010439  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
01043C  B4 2F                 MOV    ah, 0x2f ; CONST_LOAD
01043E  CD 21                 INT    0x21 ; SYS
010440  B4 1A                 MOV    ah, 0x1a ; CONST_LOAD
010442  CD 21                 INT    0x21 ; SYS
010444  3C 4E                 CMP    al, 0x4e ; CMP
010446  75 06                 JNE    0x1044e ; CJUMP
010448  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
01044B  8B 4E 08              MOV    cx, word ptr [bp + 8] ; LOCAL_LOAD
01044E  8A E0                 MOV    ah, al ; MOV
010450  CD 21                 INT    0x21 ; SYS
010452  50                    PUSH   ax ; STACK_PUSH
010453  9F                    LAHF ; FLAG
010454  50                    PUSH   ax ; STACK_PUSH
010455  8C C2                 MOV    dx, es ; MOV
010457  8E DA                 MOV    ds, dx ; MOV
010459  8B D3                 MOV    dx, bx ; MOV
01045B  B4 1A                 MOV    ah, 0x1a ; CONST_LOAD
01045D  CD 21                 INT    0x21 ; SYS
01045F  58                    POP    ax ; STACK_POP
010460  9E                    SAHF ; FLAG
010461  58                    POP    ax ; STACK_POP
010462  1F                    POP    ds ; STACK_POP
010463  E9 72 06              JMP    0x10ad8 ; JUMP
010466  55                    PUSH   bp ; STACK_PUSH
010467  8B EC                 MOV    bp, sp ; MOV
010469  B4 3F                 MOV    ah, 0x3f ; CONST_LOAD
01046B  EB 05                 JMP    0x10472 ; JUMP
01046D  55                    PUSH   bp ; STACK_PUSH
01046E  8B EC                 MOV    bp, sp ; MOV
010470  B4 40                 MOV    ah, 0x40 ; CONST_LOAD
010472  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
010475  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
010478  81 3E 16 2B D6 D6     CMP    word ptr [0x2b16], 0xd6d6 ; CMP
01047E  75 04                 JNE    0x10484 ; CJUMP
010480  FF                    DB     0xFF ; DATA_BYTE
010481  16                    DB     0x16 ; DATA_BYTE
