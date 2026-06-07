; ============================================================================
; func_062D84_unknown
; Region   : overlay
; Bytes    : file 0x062D84..0x062DD3  (79 bytes)
; Purpose  : Number-to-name converter (Five/Four/Seven/Three)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

062D84  C8 46 00 00           ENTER  0x46, 0 ; PROLOGUE
062D88  50                    PUSH   ax ; STACK_PUSH
062D89  56                    PUSH   si ; STACK_PUSH
062D8A  C7 46 E6 FF FF        MOV    word ptr [bp - 0x1a], 0xffff ; LOCAL_STORE
062D8F  C7 46 D0 00 00        MOV    word ptr [bp - 0x30], 0 ; LOCAL_STORE
062D94  F6 06 94 08 40        TEST   byte ptr [0x894], 0x40 ; LOGIC
062D99  74 1B                 JE     0x62db6 ; CJUMP
062D9B  83 3E A2 53 00        CMP    word ptr [0x53a2], 0 ; CMP
062DA0  75 0F                 JNE    0x62db1 ; CJUMP
062DA2  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
062DA5  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
062DA9  24 0F                 AND    al, 0xf ; LOGIC
062DAB  3A 06 96 53           CMP    al, byte ptr [0x5396] ; CMP
062DAF  75 05                 JNE    0x62db6 ; CJUMP
062DB1  C7 46 D0 01 00        MOV    word ptr [bp - 0x30], 1 ; LOCAL_STORE
062DB6  6B 5E B8 1C           IMUL   bx, word ptr [bp - 0x48], 0x1c ; ARITH
062DBA  8A 87 4D 31           MOV    al, byte ptr [bx + 0x314d] ; MOV
062DBE  2A E4                 SUB    ah, ah ; ARITH
062DC0  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
062DC3  8A 87 4E 31           MOV    al, byte ptr [bx + 0x314e] ; MOV
062DC7  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
062DCA  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
062DCE  89 46 CA              MOV    word ptr [bp - 0x36], ax ; LOCAL_STORE
062DD1  8A                    DB     0x8A ; DATA_BYTE
062DD2  87                    DB     0x87 ; DATA_BYTE
