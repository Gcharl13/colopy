; ============================================================================
; func_014293_rtlink_loader_shared
; Region   : load_image
; Bytes    : file 0x014293..0x01468D  (1018 bytes)
; Purpose  : Shared body of the RTLink overlay loader, reached from rtlink_loader_A (fall-through) and rtlink_loader_B (JMP). Implements the demand-paging mechanism for overlay segments: (1) sets the 'loader busy' flag at cs:[0x39E1] = 0xFF to prevent re-entry, (2) extracts the LCALL's saved CS:IP from the stack and saves it to globals cs:[0x397D]/cs:[0x397F], (3) saves SP, (4) re-pushes saved CS:IP for the eventual far-return, (5) saves all general-purpose registers (AX, BX, DX, SI, DS, ES, CX, DI, BP), (6) calls the segment-lookup helper at 0x164A2, (7) on success, branches between three patch paths: 'no patch needed', 'patch reloc' (rewrites the LJMP's segment word at [si-4]), or 'fault load from disk'. The function ends with IRET-like restoration of state and a final far-return that lands inside the overlay segment.
; Args     : (none — uses globals at cs:[0x397D..0x39F1] as control state)
; Returns  : Far-returns to the calling thunk's RETF, which then activates the patched LJMP.
; Callers  : rtlink_loader_A (0x1427B, fall-through), rtlink_loader_B (0x14261, JMP).
; Callees  : 0x164A2 (segment_lookup), 0x110D:0x1AC4 (fall-back path), 0x1414F (re-entry handler), and several internal branches at 0x142D8 / 0x142F1 / 0x1430F / 0x14322. Plus 0x1216 / 0x1251 / 0xE52 / 0xE93 / 0x147C / 0x149C / 0x1341 / 0x1369 referenced as patch-target IPs (NOT functions called directly — these are addresses written into the LJMP's segment word slot via MOV [si-4], ax).
; Verified : Boundary identified at 0x14293 with PUSHF / CLI; first RETF at 0x1466D giving size 1018 bytes. Per-line annotation pending; structurally complex with 6+ branches and multiple PUSHF/POPF/CLI/STI dances.
; Source   : manually identified by following the JMP from rtlink_loader_B and the fall-through from rtlink_loader_A.
; ============================================================================

014293  2E C6 06 E1 39 FF     MOV    byte ptr cs:[0x39e1], 0xff ; GLOBAL_LOAD
014299  9D                    POPF ; STACK_POP
01429A  2E 8F 06 7D 39        POP    word ptr cs:[0x397d] ; POP_GLOBAL
01429F  2E 8F 06 7F 39        POP    word ptr cs:[0x397f] ; POP_GLOBAL
0142A4  2E 89 26 83 39        MOV    word ptr cs:[0x3983], sp ; GLOBAL_LOAD
0142A9  2E FF 36 7F 39        PUSH   word ptr cs:[0x397f] ; PUSH_GLOBAL
0142AE  2E FF 36 7D 39        PUSH   word ptr cs:[0x397d] ; PUSH_GLOBAL
0142B3  9C                    PUSHF ; STACK_PUSH
0142B4  FC                    CLD ; FLAG
0142B5  FB                    STI ; FLAG
0142B6  50                    PUSH   ax ; STACK_PUSH
0142B7  53                    PUSH   bx ; STACK_PUSH
0142B8  52                    PUSH   dx ; STACK_PUSH
0142B9  56                    PUSH   si ; STACK_PUSH
0142BA  1E                    PUSH   ds ; STACK_PUSH
0142BB  06                    PUSH   es ; STACK_PUSH
0142BC  51                    PUSH   cx ; STACK_PUSH
0142BD  57                    PUSH   di ; STACK_PUSH
0142BE  55                    PUSH   bp ; STACK_PUSH
0142BF  2E C6 06 F0 39 00     MOV    byte ptr cs:[0x39f0], 0 ; GLOBAL_LOAD
0142C5  8B EC                 MOV    bp, sp ; MOV
0142C7  E8 D8 21              CALL   0x164a2 ; CALL_NEAR
0142CA  5D                    POP    bp ; STACK_POP
0142CB  5F                    POP    di ; STACK_POP
0142CC  59                    POP    cx ; STACK_POP
0142CD  8B DC                 MOV    bx, sp ; MOV
0142CF  72 3E                 JB     0x1430f ; CJUMP
0142D1  74 1E                 JE     0x142f1 ; CJUMP
0142D3  2E C5 36 7D 39        LDS    si, ptr cs:[0x397d] ; MOV_FAR
0142D8  B8 16 12              MOV    ax, 0x1216 ; CONST_LOAD
0142DB  BA 51 12              MOV    dx, 0x1251 ; CONST_LOAD
0142DE  2E F6 06 F1 39 FF     TEST   byte ptr cs:[0x39f1], 0xff ; LOGIC
0142E4  74 06                 JE     0x142ec ; CJUMP
0142E6  B8 7C 14              MOV    ax, 0x147c ; CONST_LOAD
0142E9  BA 9C 14              MOV    dx, 0x149c ; CONST_LOAD
0142EC  89 44 FC              MOV    word ptr [si - 4], ax ; MOV
0142EF  FF E2                 JMP    dx ; JUMP
0142F1  2E C5 36 7D 39        LDS    si, ptr cs:[0x397d] ; MOV_FAR
0142F6  B8 52 0E              MOV    ax, 0xe52 ; CONST_LOAD
0142F9  BA 93 0E              MOV    dx, 0xe93 ; CONST_LOAD
0142FC  2E F6 06 F1 39 FF     TEST   byte ptr cs:[0x39f1], 0xff ; LOGIC
014302  74 06                 JE     0x1430a ; CJUMP
014304  B8 41 13              MOV    ax, 0x1341 ; CONST_LOAD
014307  BA 69 13              MOV    dx, 0x1369 ; CONST_LOAD
01430A  89 44 FC              MOV    word ptr [si - 4], ax ; MOV
01430D  FF E2                 JMP    dx ; JUMP
01430F  8C C8                 MOV    ax, cs ; MOV
014311  8E D8                 MOV    ds, ax ; MOV
014313  BE CA 2F              MOV    si, 0x2fca ; CONST_LOAD
014316  EB C0                 JMP    0x142d8 ; JUMP
014318  9A C4 1A 0D 11        LCALL  0x110d, 0x1ac4 ; LCALL
01431D  EB 4C                 JMP    0x1436b ; JUMP
01431F  E9 2D FE              JMP    0x1414f ; JUMP
014322  9C                    PUSHF ; STACK_PUSH
014323  FA                    CLI ; FLAG
014324  2E F6 06 E1 39 FF     TEST   byte ptr cs:[0x39e1], 0xff ; LOGIC
01432A  75 F3                 JNE    0x1431f ; CJUMP
01432C  2E F6 06 DE 39 0C     TEST   byte ptr cs:[0x39de], 0xc ; LOGIC
014332  75 EB                 JNE    0x1431f ; CJUMP
014334  2E C6 06 E1 39 FF     MOV    byte ptr cs:[0x39e1], 0xff ; GLOBAL_LOAD
01433A  2E 89 26 83 39        MOV    word ptr cs:[0x3983], sp ; GLOBAL_LOAD
01433F  2E 83 06 83 39 06     ADD    word ptr cs:[0x3983], 6 ; ARITH
014345  FC                    CLD ; FLAG
014346  FB                    STI ; FLAG
014347  50                    PUSH   ax ; STACK_PUSH
014348  53                    PUSH   bx ; STACK_PUSH
014349  52                    PUSH   dx ; STACK_PUSH
01434A  56                    PUSH   si ; STACK_PUSH
01434B  1E                    PUSH   ds ; STACK_PUSH
01434C  06                    PUSH   es ; STACK_PUSH
01434D  8B DC                 MOV    bx, sp ; MOV
01434F  36 C4 5F 0E           LES    bx, ptr ss:[bx + 0xe] ; MOV_FAR
014353  2E 89 1E 7D 39        MOV    word ptr cs:[0x397d], bx ; GLOBAL_LOAD
014358  2E 8C 06 7F 39        MOV    word ptr cs:[0x397f], es ; GLOBAL_LOAD
01435D  2E C6 06 F0 39 00     MOV    byte ptr cs:[0x39f0], 0 ; GLOBAL_LOAD
014363  2E F6 06 E2 39 FF     TEST   byte ptr cs:[0x39e2], 0xff ; LOGIC
014369  75 AD                 JNE    0x14318 ; CJUMP
01436B  2E 80 0E DD 39 40     OR     byte ptr cs:[0x39dd], 0x40 ; LOGIC
014371  2E C6 06 E0 39 00     MOV    byte ptr cs:[0x39e0], 0 ; GLOBAL_LOAD
014377  2E 80 26 DF 39 FD     AND    byte ptr cs:[0x39df], 0xfd ; LOGIC
01437D  2E F6 06 DF 39 01     TEST   byte ptr cs:[0x39df], 1 ; LOGIC
014383  74 4B                 JE     0x143d0 ; CJUMP
014385  2E C5 36 7D 39        LDS    si, ptr cs:[0x397d] ; MOV_FAR
01438A  8B 44 05              MOV    ax, word ptr [si + 5] ; MOV
01438D  A9 00 40              TEST   ax, 0x4000 ; LOGIC
014390  74 41                 JE     0x143d3 ; CJUMP
014392  2E 80 0E DF 39 02     OR     byte ptr cs:[0x39df], 2 ; LOGIC
014398  25 FF 3F              AND    ax, 0x3fff ; LOGIC
01439B  48                    DEC    ax ; ARITH
01439C  D1 E0                 SHL    ax, 1 ; LOGIC
01439E  2E 03 06 9B 39        ADD    ax, word ptr cs:[0x399b] ; ARITH
0143A3  8E C0                 MOV    es, ax ; MOV
0143A5  26 F7 06 00 00 00 80  TEST   word ptr es:[0], 0x8000 ; LOGIC
0143AC  75 7C                 JNE    0x1442a ; CJUMP
0143AE  26 F7 06 00 00 20 38  TEST   word ptr es:[0], 0x3820 ; LOGIC
0143B5  75 1C                 JNE    0x143d3 ; CJUMP
0143B7  B8 D9 17              MOV    ax, 0x17d9 ; CONST_LOAD
0143BA  2E F6 06 DD 39 40     TEST   byte ptr cs:[0x39dd], 0x40 ; LOGIC
0143C0  75 03                 JNE    0x143c5 ; CJUMP
0143C2  B8 BC 18              MOV    ax, 0x18bc ; CONST_LOAD
0143C5  2E C5 36 7D 39        LDS    si, ptr cs:[0x397d] ; MOV_FAR
0143CA  89 44 FC              MOV    word ptr [si - 4], ax ; MOV
0143CD  E9 30 01              JMP    0x14500 ; JUMP
0143D0  E9 81 00              JMP    0x14454 ; JUMP
0143D3  2E F6 06 DD 39 40     TEST   byte ptr cs:[0x39dd], 0x40 ; LOGIC
0143D9  74 52                 JE     0x1442d ; CJUMP
0143DB  2E 8B 36 83 39        MOV    si, word ptr cs:[0x3983] ; GLOBAL_LOAD
0143E0  8B DD                 MOV    bx, bp ; MOV
0143E2  2E 8B 16 5C 39        MOV    dx, word ptr cs:[0x395c] ; GLOBAL_LOAD
0143E7  E8 ED 16              CALL   0x15ad7 ; CALL_NEAR
0143EA  0B F6                 OR     si, si ; LOGIC
0143EC  74 20                 JE     0x1440e ; CJUMP
0143EE  E8 39 17              CALL   0x15b2a ; CALL_NEAR
0143F1  2E C7 06 58 39 00 00  MOV    word ptr cs:[0x3958], 0 ; GLOBAL_LOAD
0143F8  2E 8B 36 83 39        MOV    si, word ptr cs:[0x3983] ; GLOBAL_LOAD
0143FD  2E 3B 36 5C 39        CMP    si, word ptr cs:[0x395c] ; CMP
014402  74 14                 JE     0x14418 ; CJUMP
014404  2E C5 36 52 39        LDS    si, ptr cs:[0x3952] ; MOV_FAR
014409  81 4C FA 00 40        OR     word ptr [si - 6], 0x4000 ; LOGIC
01440E  33 DB                 XOR    bx, bx ; LOGIC
014410  2E 8B 36 83 39        MOV    si, word ptr cs:[0x3983] ; GLOBAL_LOAD
014415  E8 3A 1A              CALL   0x15e52 ; CALL_NEAR
014418  2E F6 06 DF 39 02     TEST   byte ptr cs:[0x39df], 2 ; LOGIC
01441E  74 0A                 JE     0x1442a ; CJUMP
014420  2E C5 36 52 39        LDS    si, ptr cs:[0x3952] ; MOV_FAR
014425  81 4C FA 00 40        OR     word ptr [si - 6], 0x4000 ; LOGIC
01442A  E9 D3 00              JMP    0x14500 ; JUMP
01442D  33 F6                 XOR    si, si ; LOGIC
01442F  8B DD                 MOV    bx, bp ; MOV
014431  2E 8B 16 5C 39        MOV    dx, word ptr cs:[0x395c] ; GLOBAL_LOAD
014436  E8 9E 16              CALL   0x15ad7 ; CALL_NEAR
014439  0B F6                 OR     si, si ; LOGIC
01443B  74 0A                 JE     0x14447 ; CJUMP
01443D  E8 EA 16              CALL   0x15b2a ; CALL_NEAR
014440  2E C7 06 58 39 00 00  MOV    word ptr cs:[0x3958], 0 ; GLOBAL_LOAD
014447  2E C5 36 52 39        LDS    si, ptr cs:[0x3952] ; MOV_FAR
01444C  81 64 FA FF BF        AND    word ptr [si - 6], 0xbfff ; LOGIC
014451  E9 AC 00              JMP    0x14500 ; JUMP
014454  2E F7 06 58 39 FF FF  TEST   word ptr cs:[0x3958], 0xffff ; LOGIC
01445B  74 4A                 JE     0x144a7 ; CJUMP
01445D  2E 8E 06 5A 39        MOV    es, word ptr cs:[0x395a] ; GLOBAL_LOAD
014462  26 F7 06 00 00 20 00  TEST   word ptr es:[0], 0x20 ; LOGIC
014469  75 3C                 JNE    0x144a7 ; CJUMP
01446B  33 F6                 XOR    si, si ; LOGIC
01446D  2E 8B 16 5C 39        MOV    dx, word ptr cs:[0x395c] ; GLOBAL_LOAD
014472  2E F6 06 DD 39 40     TEST   byte ptr cs:[0x39dd], 0x40 ; LOGIC
014478  74 32                 JE     0x144ac ; CJUMP
01447A  2E 8B 36 83 39        MOV    si, word ptr cs:[0x3983] ; GLOBAL_LOAD
01447F  3B F2                 CMP    si, dx ; CMP
014481  74 55                 JE     0x144d8 ; CJUMP
014483  2E F6 06 DE 39 10     TEST   byte ptr cs:[0x39de], 0x10 ; LOGIC
014489  75 21                 JNE    0x144ac ; CJUMP
01448B  36 8B 44 02           MOV    ax, word ptr ss:[si + 2] ; MOV
01448F  26 2B 06 02 00        SUB    ax, word ptr es:[2] ; ARITH
014494  26 39 06 04 00        CMP    word ptr es:[4], ax ; CMP
014499  76 0F                 JBE    0x144aa ; CJUMP
01449B  B8 38 10              MOV    ax, 0x1038 ; CONST_LOAD
01449E  50                    PUSH   ax ; STACK_PUSH
01449F  2E 8B 1E 58 39        MOV    bx, word ptr cs:[0x3958] ; GLOBAL_LOAD
0144A4  E9 AB 19              JMP    0x15e52 ; JUMP
0144A7  E9 94 00              JMP    0x1453e ; JUMP
0144AA  33 F6                 XOR    si, si ; LOGIC
0144AC  8B DD                 MOV    bx, bp ; MOV
0144AE  E8 A3 16              CALL   0x15b54 ; CALL_NEAR
0144B1  72 38                 JB     0x144eb ; CJUMP
0144B3  0B F6                 OR     si, si ; LOGIC
0144B5  74 23                 JE     0x144da ; CJUMP
0144B7  2E 3B 36 83 39        CMP    si, word ptr cs:[0x3983] ; CMP
0144BC  74 3A                 JE     0x144f8 ; CJUMP
0144BE  2E F6 06 DD 39 40     TEST   byte ptr cs:[0x39dd], 0x40 ; LOGIC
0144C4  74 32                 JE     0x144f8 ; CJUMP
0144C6  2E 8B 1E 58 39        MOV    bx, word ptr cs:[0x3958] ; GLOBAL_LOAD
0144CB  E8 84 19              CALL   0x15e52 ; CALL_NEAR
0144CE  2E 8B 36 83 39        MOV    si, word ptr cs:[0x3983] ; GLOBAL_LOAD
0144D3  33 DB                 XOR    bx, bx ; LOGIC
0144D5  E8 7A 19              CALL   0x15e52 ; CALL_NEAR
0144D8  EB 26                 JMP    0x14500 ; JUMP
0144DA  2E C5 36 7D 39        LDS    si, ptr cs:[0x397d] ; MOV_FAR
0144DF  8B 44 05              MOV    ax, word ptr [si + 5] ; MOV
0144E2  2E 3B 06 58 39        CMP    ax, word ptr cs:[0x3958] ; CMP
0144E7  75 02                 JNE    0x144eb ; CJUMP
0144E9  EB 15                 JMP    0x14500 ; JUMP
0144EB  2E F6 06 DD 39 40     TEST   byte ptr cs:[0x39dd], 0x40 ; LOGIC
0144F1  75 02                 JNE    0x144f5 ; CJUMP
0144F3  EB 0B                 JMP    0x14500 ; JUMP
0144F5  E9 6D 06              JMP    0x14b65 ; JUMP
0144F8  2E 8B 1E 58 39        MOV    bx, word ptr cs:[0x3958] ; GLOBAL_LOAD
0144FD  E8 52 19              CALL   0x15e52 ; CALL_NEAR
014500  2E F6 06 DD 39 40     TEST   byte ptr cs:[0x39dd], 0x40 ; LOGIC
014506  74 55                 JE     0x1455d ; CJUMP
014508  2E C5 36 7D 39        LDS    si, ptr cs:[0x397d] ; MOV_FAR
01450D  8B 44 05              MOV    ax, word ptr [si + 5] ; MOV
014510  25 FF 3F              AND    ax, 0x3fff ; LOGIC
014513  48                    DEC    ax ; ARITH
014514  D1 E0                 SHL    ax, 1 ; LOGIC
014516  2E 03 06 9B 39        ADD    ax, word ptr cs:[0x399b] ; ARITH
01451B  8E C0                 MOV    es, ax ; MOV
01451D  2E 87 06 5A 39        XCHG   word ptr cs:[0x395a], ax ; MOV
014522  2E A3 87 39           MOV    word ptr cs:[0x3987], ax ; GLOBAL_LOAD
014526  26 A1 02 00           MOV    ax, word ptr es:[2] ; MOV
01452A  26 F7 06 00 00 01 00  TEST   word ptr es:[0], 1 ; LOGIC
014531  75 77                 JNE    0x145aa ; CJUMP
014533  8B 44 05              MOV    ax, word ptr [si + 5] ; MOV
014536  9A BD 1E 0D 11        LCALL  0x110d, 0x1ebd ; LCALL
01453B  E9 A3 00              JMP    0x145e1 ; JUMP
01453E  2E F6 06 DE 39 10     TEST   byte ptr cs:[0x39de], 0x10 ; LOGIC
014544  75 3E                 JNE    0x14584 ; CJUMP
014546  2E F6 06 DD 39 40     TEST   byte ptr cs:[0x39dd], 0x40 ; LOGIC
01454C  74 0D                 JE     0x1455b ; CJUMP
01454E  2E 8B 36 83 39        MOV    si, word ptr cs:[0x3983] ; GLOBAL_LOAD
014553  2E 8B 1E 58 39        MOV    bx, word ptr cs:[0x3958] ; GLOBAL_LOAD
014558  E8 F7 18              CALL   0x15e52 ; CALL_NEAR
01455B  EB A3                 JMP    0x14500 ; JUMP
01455D  2E F6 06 DF 39 01     TEST   byte ptr cs:[0x39df], 1 ; LOGIC
014563  75 A3                 JNE    0x14508 ; CJUMP
014565  2E F7 06 58 39 FF FF  TEST   word ptr cs:[0x3958], 0xffff ; LOGIC
01456C  74 9A                 JE     0x14508 ; CJUMP
01456E  2E 8E 06 5A 39        MOV    es, word ptr cs:[0x395a] ; GLOBAL_LOAD
014573  26 F7 06 00 00 00 80  TEST   word ptr es:[0], 0x8000 ; LOGIC
01457A  75 8C                 JNE    0x14508 ; CJUMP
01457C  E8 AB 1C              CALL   0x1622a ; CALL_NEAR
01457F  EB 87                 JMP    0x14508 ; JUMP
014581  E9 4C 01              JMP    0x146d0 ; JUMP
014584  33 F6                 XOR    si, si ; LOGIC
014586  8B DD                 MOV    bx, bp ; MOV
014588  2E 8B 16 5C 39        MOV    dx, word ptr cs:[0x395c] ; GLOBAL_LOAD
01458D  2E 8E 06 5A 39        MOV    es, word ptr cs:[0x395a] ; GLOBAL_LOAD
014592  E8 BF 15              CALL   0x15b54 ; CALL_NEAR
014595  0B F6                 OR     si, si ; LOGIC
014597  74 AD                 JE     0x14546 ; CJUMP
014599  2E 8B 1E 58 39        MOV    bx, word ptr cs:[0x3958] ; GLOBAL_LOAD
01459E  E8 B1 18              CALL   0x15e52 ; CALL_NEAR
0145A1  2E C7 06 58 39 00 00  MOV    word ptr cs:[0x3958], 0 ; GLOBAL_LOAD
0145A8  EB 9C                 JMP    0x14546 ; JUMP
0145AA  26 A1 02 00           MOV    ax, word ptr es:[2] ; MOV
0145AE  26 F7 06 00 00 20 00  TEST   word ptr es:[0], 0x20 ; LOGIC
0145B5  75 2A                 JNE    0x145e1 ; CJUMP
0145B7  8C C2                 MOV    dx, es ; MOV
0145B9  26 8B 1E 18 00        MOV    bx, word ptr es:[0x18] ; GLOBAL_LOAD
0145BE  4B                    DEC    bx ; ARITH
0145BF  8E C3                 MOV    es, bx ; MOV
0145C1  26 80 0E 00 00 08     OR     byte ptr es:[0], 8 ; LOGIC
0145C7  26 8B 1E 06 00        MOV    bx, word ptr es:[6] ; MOV
0145CC  43                    INC    bx ; ARITH
0145CD  74 B2                 JE     0x14581 ; CJUMP
0145CF  26 89 1E 06 00        MOV    word ptr es:[6], bx ; MOV
0145D4  8E C2                 MOV    es, dx ; MOV
0145D6  26 89 1E 06 00        MOV    word ptr es:[6], bx ; MOV
0145DB  2E C6 06 C7 5D FF     MOV    byte ptr cs:[0x5dc7], 0xff ; GLOBAL_LOAD
0145E1  26 F7 06 00 00 40 00  TEST   word ptr es:[0], 0x40 ; LOGIC
0145E8  74 03                 JE     0x145ed ; CJUMP
0145EA  03 44 07              ADD    ax, word ptr [si + 7] ; ARITH
0145ED  89 44 03              MOV    word ptr [si + 3], ax ; MOV
0145F0  2E A3 52 15           MOV    word ptr cs:[0x1552], ax ; GLOBAL_LOAD
0145F4  8B 44 01              MOV    ax, word ptr [si + 1] ; MOV
0145F7  2E A3 50 15           MOV    word ptr cs:[0x1550], ax ; GLOBAL_LOAD
0145FB  06                    PUSH   es ; STACK_PUSH
0145FC  2E F6 06 DF 39 01     TEST   byte ptr cs:[0x39df], 1 ; LOGIC
014602  74 3A                 JE     0x1463e ; CJUMP
014604  2E F6 06 E0 39 FF     TEST   byte ptr cs:[0x39e0], 0xff ; LOGIC
01460A  74 42                 JE     0x1464e ; CJUMP
01460C  2E 8B 36 83 39        MOV    si, word ptr cs:[0x3983] ; GLOBAL_LOAD
014611  2E 8B 16 5C 39        MOV    dx, word ptr cs:[0x395c] ; GLOBAL_LOAD
014616  8B DD                 MOV    bx, bp ; MOV
014618  3B F2                 CMP    si, dx ; CMP
01461A  74 22                 JE     0x1463e ; CJUMP
01461C  2E F6 06 DD 39 40     TEST   byte ptr cs:[0x39dd], 0x40 ; LOGIC
014622  75 02                 JNE    0x14626 ; CJUMP
014624  33 F6                 XOR    si, si ; LOGIC
014626  E8 37 14              CALL   0x15a60 ; CALL_NEAR
014629  0B C0                 OR     ax, ax ; LOGIC
01462B  74 11                 JE     0x1463e ; CJUMP
01462D  2E 87 06 58 39        XCHG   word ptr cs:[0x3958], ax ; MOV
014632  2E A3 85 39           MOV    word ptr cs:[0x3985], ax ; GLOBAL_LOAD
014636  2E 8C 06 5A 39        MOV    word ptr cs:[0x395a], es ; GLOBAL_LOAD
01463B  07                    POP    es ; STACK_POP
01463C  EB 19                 JMP    0x14657 ; JUMP
01463E  2E A1 5A 39           MOV    ax, word ptr cs:[0x395a] ; GLOBAL_LOAD
014642  8E C0                 MOV    es, ax ; MOV
014644  2E 2B 06 9B 39        SUB    ax, word ptr cs:[0x399b] ; ARITH
014649  D1 E8                 SHR    ax, 1 ; LOGIC
01464B  40                    INC    ax ; ARITH
01464C  EB DF                 JMP    0x1462d ; JUMP
01464E  2E A1 87 39           MOV    ax, word ptr cs:[0x3987] ; GLOBAL_LOAD
014652  2E A3 5A 39           MOV    word ptr cs:[0x395a], ax ; GLOBAL_LOAD
014656  07                    POP    es ; STACK_POP
014657  26 F7 06 00 00 20 00  TEST   word ptr es:[0], 0x20 ; LOGIC
01465E  75 0E                 JNE    0x1466e ; CJUMP
014660  07                    POP    es ; STACK_POP
014661  1F                    POP    ds ; STACK_POP
014662  5E                    POP    si ; STACK_POP
014663  5A                    POP    dx ; STACK_POP
014664  5B                    POP    bx ; STACK_POP
014665  58                    POP    ax ; STACK_POP
014666  9D                    POPF ; STACK_POP
014667  2E C6 06 E1 39 00     MOV    byte ptr cs:[0x39e1], 0 ; GLOBAL_LOAD
01466D  CB                    RETF ; RETURN
01466E  2E F6 06 DF 39 01     TEST   byte ptr cs:[0x39df], 1 ; LOGIC
014674  74 35                 JE     0x146ab ; CJUMP
014676  26 F7 06 00 00 00 80  TEST   word ptr es:[0], 0x8000 ; LOGIC
01467D  75 E1                 JNE    0x14660 ; CJUMP
01467F  2E FF 36 5A 39        PUSH   word ptr cs:[0x395a] ; PUSH_GLOBAL
014684  2E FF 36 58 39        PUSH   word ptr cs:[0x3958] ; PUSH_GLOBAL
014689  2E                    DB     0x2E ; DATA_BYTE
01468A  8C                    DB     0x8C ; DATA_BYTE
01468B  06                    DB     0x06 ; DATA_BYTE
01468C  5A                    DB     0x5A ; DATA_BYTE
