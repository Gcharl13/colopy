; ============================================================================
; func_0124D6_coreleft_total
; Region   : load_image
; Bytes    : file 0x0124D6..0x012530  (90 bytes)
; Purpose  : C `coreleft()` (total free memory). Issues INT 21h AH=48h (Allocate Memory) with BX=0xFFFF to deliberately fail and learn the largest available block, then walks the DOS Memory Control Block (MCB) chain starting from the segment in DGROUP:0x27B2 (saved program-DS from cstart) to sum the total free memory across ALL MCBs (not just the largest single block). Returns the total in AX:DX (32-bit, AX=high, DX=low) suitable for `long coreleft(void)`.
; Args     : (none)
; Returns  : DX:AX = total free DOS memory in bytes (long).
; Callers  : TBD
; Callees  : INT 21h AH=48h (Allocate Memory)
; Verified : boundary identified — function continues past 0x0124F9; precise end TBD on continuing the annotation pass. 90-byte estimate is approximate.
; Source   : manually identified — INT 21h AH=48 BX=FFFF + MCB-chain walk is the canonical coreleft() implementation
; ============================================================================

0124D6  55                    PUSH   bp ; STACK_PUSH
0124D7  8B EC                 MOV    bp, sp ; MOV
0124D9  56                    PUSH   si ; STACK_PUSH
0124DA  57                    PUSH   di ; STACK_PUSH
0124DB  1E                    PUSH   ds ; STACK_PUSH
0124DC  1F                    POP    ds ; STACK_POP
0124DD  BB FF FF              MOV    bx, 0xffff ; CONST_LOAD
0124E0  B4 48                 MOV    ah, 0x48 ; CONST_LOAD
0124E2  CD 21                 INT    0x21 ; SYS
0124E4  3C 07                 CMP    al, 7 ; CMP
0124E6  74 42                 JE     0x1252a ; CJUMP
0124E8  8B 1E B2 27           MOV    bx, word ptr [0x27b2] ; GLOBAL_LOAD
0124EC  8B D3                 MOV    dx, bx ; MOV
0124EE  4B                    DEC    bx ; ARITH
0124EF  33 C9                 XOR    cx, cx ; LOGIC
0124F1  1E                    PUSH   ds ; STACK_PUSH
0124F2  8E DB                 MOV    ds, bx ; MOV
0124F4  A1 01 00              MOV    ax, word ptr [1] ; MOV
0124F7  3B C2                 CMP    ax, dx ; CMP
0124F9  74 06                 JE     0x12501 ; CJUMP
0124FB  0B C0                 OR     ax, ax ; LOGIC
0124FD  75 14                 JNE    0x12513 ; CJUMP
0124FF  8B CB                 MOV    cx, bx ; MOV
012501  43                    INC    bx ; ARITH
012502  03 1E 03 00           ADD    bx, word ptr [3] ; ARITH
012506  72 D4                 JB     0x124dc ; CJUMP
012508  A0 00 00              MOV    al, byte ptr [0] ; MOV
01250B  3C 4D                 CMP    al, 0x4d ; CMP
01250D  74 E3                 JE     0x124f2 ; CJUMP
01250F  3C 5A                 CMP    al, 0x5a ; CMP
012511  75 C9                 JNE    0x124dc ; CJUMP
012513  2B DA                 SUB    bx, dx ; ARITH
012515  1F                    POP    ds ; STACK_POP
012516  89 0E 08 2B           MOV    word ptr [0x2b08], cx ; GLOBAL_LOAD
01251A  80 3E B4 27 02        CMP    byte ptr [0x27b4], 2 ; CMP
01251F  77 0D                 JA     0x1252e ; CJUMP
012521  81 EB 81 02           SUB    bx, 0x281 ; ARITH
012525  73 07                 JAE    0x1252e ; CJUMP
012527  B8 08 00              MOV    ax, 8 ; MOV
01252A  F9                    STC ; FLAG
01252B  E9 B7 E5              JMP    0x10ae5 ; JUMP
01252E  53                    PUSH   bx ; STACK_PUSH
01252F  B8                    DB     0xB8 ; DATA_BYTE
