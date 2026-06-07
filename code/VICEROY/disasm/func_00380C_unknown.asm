; ============================================================================
; func_00380C_unknown
; Region   : load_image
; Bytes    : file 0x00380C..0x003869  (93 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00380C  55                    PUSH   bp ; STACK_PUSH
00380D  8B EC                 MOV    bp, sp ; MOV
00380F  53                    PUSH   bx ; STACK_PUSH
003810  50                    PUSH   ax ; STACK_PUSH
003811  57                    PUSH   di ; STACK_PUSH
003812  56                    PUSH   si ; STACK_PUSH
003813  8B FA                 MOV    di, dx ; MOV
003815  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
003818  F7 C6 01 00           TEST   si, 1 ; LOGIC
00381C  74 25                 JE     0x3843 ; CJUMP
00381E  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
003822  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
003826  53                    PUSH   bx ; STACK_PUSH
003827  8B C6                 MOV    ax, si ; MOV
003829  25 04 00              AND    ax, 4 ; LOGIC
00382C  3D 01 00              CMP    ax, 1 ; CMP
00382F  F5                    CMC ; FLAG
003830  1A C0                 SBB    al, al ; ARITH
003832  24 5F                 AND    al, 0x5f ; LOGIC
003834  50                    PUSH   ax ; STACK_PUSH
003835  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
003838  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
00383C  8B D7                 MOV    dx, di ; MOV
00383E  9A 04 00 D8 0C        LCALL  0xcd8, 4 ; LCALL
003843  8B C6                 MOV    ax, si ; MOV
003845  A8 02                 TEST   al, 2 ; LOGIC
003847  74 1A                 JE     0x3863 ; CJUMP
003849  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
00384D  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
003851  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
003854  8D 55 02              LEA    dx, [di + 2] ; ADDR
003857  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00385A  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
00385E  9A 0A 00 36 0C        LCALL  0xc36, 0xa ; LCALL
003863  5E                    POP    si ; STACK_POP
003864  5F                    POP    di ; STACK_POP
003865  C9                    LEAVE ; EPILOGUE
003866  CA 02 00              RETF   2 ; RETURN
