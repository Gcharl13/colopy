; ============================================================================
; func_002462_unknown
; Region   : load_image
; Bytes    : file 0x002462..0x00248F  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002462  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
002466  57                    PUSH   di ; STACK_PUSH
002467  56                    PUSH   si ; STACK_PUSH
002468  A1 42 2D              MOV    ax, word ptr [0x2d42] ; GLOBAL_LOAD
00246B  8B 16 44 2D           MOV    dx, word ptr [0x2d44] ; GLOBAL_LOAD
00246F  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
002472  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
002475  C4 7E FC              LES    di, ptr [bp - 4] ; MOV_FAR
002478  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
00247B  0B D2                 OR     dx, dx ; LOGIC
00247D  74 0C                 JE     0x248b ; CJUMP
00247F  32 C0                 XOR    al, al ; LOGIC
002481  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
002484  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
002486  75 03                 JNE    0x248b ; CJUMP
002488  4A                    DEC    dx ; ARITH
002489  75 F6                 JNE    0x2481 ; CJUMP
00248B  8C C2                 MOV    dx, es ; MOV
00248D  8B C7                 MOV    ax, di ; MOV
