; ============================================================================
; func_006E94_unknown
; Region   : load_image
; Bytes    : file 0x006E94..0x006F18  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006E94  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
006E98  57                    PUSH   di ; STACK_PUSH
006E99  56                    PUSH   si ; STACK_PUSH
006E9A  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
006E9D  0B FF                 OR     di, di ; LOGIC
006E9F  7D 03                 JGE    0x6ea4 ; CJUMP
006EA1  E9 B2 00              JMP    0x6f56 ; JUMP
006EA4  6B DF 1C              IMUL   bx, di, 0x1c ; ARITH
006EA7  89 5E F8              MOV    word ptr [bp - 8], bx ; LOCAL_STORE
006EAA  8A 9F 47 31           MOV    bl, byte ptr [bx + 0x3147] ; MOV
006EAE  83 E3 0F              AND    bx, 0xf ; LOGIC
006EB1  7C 10                 JL     0x6ec3 ; CJUMP
006EB3  83 FB 04              CMP    bx, 4 ; CMP
006EB6  7D 0B                 JGE    0x6ec3 ; CJUMP
006EB8  80 BF FC 8C 00        CMP    byte ptr [bx - 0x7304], 0 ; CMP
006EBD  74 04                 JE     0x6ec3 ; CJUMP
006EBF  FE 8F FC 8C           DEC    byte ptr [bx - 0x7304] ; ARITH
006EC3  83 FB 04              CMP    bx, 4 ; CMP
006EC6  7C 17                 JL     0x6edf ; CJUMP
006EC8  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
006ECB  80 BF 4A 31 00        CMP    byte ptr [bx + 0x314a], 0 ; CMP
006ED0  7C 0D                 JL     0x6edf ; CJUMP
006ED2  8A 87 4A 31           MOV    al, byte ptr [bx + 0x314a] ; MOV
006ED6  98                    CWDE ; ARITH
006ED7  6B D8 12              IMUL   bx, ax, 0x12 ; ARITH
006EDA  80 8F EF 54 01        OR     byte ptr [bx + 0x54ef], 1 ; LOGIC
006EDF  8B C7                 MOV    ax, di ; MOV
006EE1  0E                    PUSH   cs ; STACK_PUSH
006EE2  E8 C5 F9              CALL   0x68aa ; CALL_NEAR
006EE5  8B F7                 MOV    si, di ; MOV
006EE7  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
006EEA  48                    DEC    ax ; ARITH
006EEB  3B C7                 CMP    ax, di ; CMP
006EED  7E 30                 JLE    0x6f1f ; CJUMP
006EEF  6B C6 1C              IMUL   ax, si, 0x1c ; ARITH
006EF2  05 44 31              ADD    ax, 0x3144 ; ARITH
006EF5  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
006EF8  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
006EFB  2B C6                 SUB    ax, si ; ARITH
006EFD  48                    DEC    ax ; ARITH
006EFE  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
006F01  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
006F04  8B DA                 MOV    bx, dx ; MOV
006F06  8B FA                 MOV    di, dx ; MOV
006F08  8D 77 1C              LEA    si, [bx + 0x1c] ; ADDR
006F0B  8C D8                 MOV    ax, ds ; MOV
006F0D  8E C0                 MOV    es, ax ; MOV
006F0F  B9 0E 00              MOV    cx, 0xe ; CONST_LOAD
006F12  F3 A5                 REP MOVSW word ptr es:[di], word ptr [si] ; STR
006F14  83 C2 1C              ADD    dx, 0x1c ; ARITH
006F17  FF                    DB     0xFF ; DATA_BYTE
